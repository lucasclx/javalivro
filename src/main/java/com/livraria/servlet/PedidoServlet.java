package com.livraria.servlet;

import com.livraria.dao.PedidoDAO;
import com.livraria.dao.ItemPedidoDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/pedidos")
public class PedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO;
    private ItemPedidoDAO itemPedidoDAO;
    private LivroDAO livroDAO;

    @Override
    public void init() throws ServletException {
        pedidoDAO = new PedidoDAO();
        itemPedidoDAO = new ItemPedidoDAO();
        livroDAO = new LivroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "listar") {
                case "listar":
                    listarPedidos(request, response);
                    break;
                case "detalhes":
                    mostrarDetalhes(request, response);
                    break;
                case "meusPedidos":
                    listarMeusPedidos(request, response);
                    break;
                case "checkout":
                    mostrarCheckout(request, response);
                    break;
                case "confirmarPedido":
                    confirmarPedido(request, response);
                    break;
                case "admin":
                    listarTodosPedidos(request, response);
                    break;
                case "atualizarStatus":
                    atualizarStatusPedido(request, response);
                    break;
                default:
                    listarPedidos(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao acessar o banco de dados", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "finalizar":
                    finalizarPedido(request, response);
                    break;
                case "cancelar":
                    cancelarPedido(request, response);
                    break;
                case "atualizarStatus":
                    atualizarStatusPedido(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao processar pedido", e);
        }
    }

    /**
     * Lista pedidos do usuário logado
     */
    private void listarPedidos(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        List<Pedido> pedidos = pedidoDAO.listarPorUsuario(usuario.getId());
        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("/pages/meus-pedidos.jsp").forward(request, response);
    }

    /**
     * Mostra detalhes de um pedido específico
     */
    private void mostrarDetalhes(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        try {
            int pedidoId = Integer.parseInt(request.getParameter("id"));
            Pedido pedido = pedidoDAO.buscarPorId(pedidoId);
            
            if (pedido != null && (pedido.getUsuarioId() == usuario.getId() || usuario.isAdmin())) {
                request.setAttribute("pedido", pedido);
                request.getRequestDispatcher("/pages/pedido-detalhes.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de pedido inválido");
        }
    }

    /**
     * Lista pedidos do usuário (alias para listarPedidos)
     */
    private void listarMeusPedidos(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        listarPedidos(request, response);
    }

    /**
     * Mostra página de checkout
     */
    private void mostrarCheckout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        if (carrinho == null || carrinho.isEmpty()) {
            session.setAttribute("mensagemErro", "Seu carrinho está vazio.");
            response.sendRedirect(request.getContextPath() + "/carrinho");
            return;
        }
        
        request.setAttribute("carrinho", carrinho);
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }

    /**
     * Finaliza um pedido
     */
    private void finalizarPedido(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        if (carrinho == null || carrinho.isEmpty()) {
            session.setAttribute("mensagemErro", "Carrinho vazio.");
            response.sendRedirect(request.getContextPath() + "/carrinho");
            return;
        }
        
        String enderecoEntrega = request.getParameter("enderecoEntrega");
        String observacoes = request.getParameter("observacoes");
        
        if (enderecoEntrega == null || enderecoEntrega.trim().isEmpty()) {
            session.setAttribute("mensagemErro", "Endereço de entrega é obrigatório.");
            response.sendRedirect(request.getContextPath() + "/pedidos?action=checkout");
            return;
        }
        
        try {
            // Verifica estoque disponível antes de criar o pedido
            for (ItemCarrinho item : carrinho.getItens()) {
                Livro livro = livroDAO.buscarPorId(item.getLivro().getId());
                if (livro == null || !livro.isAtivo() || livro.getEstoque() < item.getQuantidade()) {
                    session.setAttribute("mensagemErro", 
                        "Livro '" + item.getLivro().getTitulo() + "' não tem estoque suficiente.");
                    response.sendRedirect(request.getContextPath() + "/carrinho");
                    return;
                }
            }
            
            // Cria o pedido
            Pedido pedido = new Pedido();
            pedido.setUsuarioId(usuario.getId());
            pedido.setValorTotal(carrinho.getValorTotal());
            pedido.setEnderecoEntrega(enderecoEntrega.trim());
            pedido.setObservacoes(observacoes);
            pedido.setStatusPedido(Pedido.StatusPedido.PENDENTE);
            
            // Insere o pedido no banco
            int pedidoId = pedidoDAO.inserir(pedido);
            
            if (pedidoId > 0) {
                // Cria os itens do pedido
                List<ItemPedido> itens = new ArrayList<>();
                for (ItemCarrinho itemCarrinho : carrinho.getItens()) {
                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.setPedidoId(pedidoId);
                    itemPedido.setLivroId(itemCarrinho.getLivro().getId());
                    itemPedido.setQuantidade(itemCarrinho.getQuantidade());
                    itemPedido.setPrecoUnitario(itemCarrinho.getLivro().getPreco());
                    itemPedido.setSubtotal(itemCarrinho.getPrecoTotal());
                    itens.add(itemPedido);
                }
                
                // Insere os itens do pedido
                if (itemPedidoDAO.inserirLote(itens)) {
                    // Atualiza estoque dos livros
                    for (ItemCarrinho item : carrinho.getItens()) {
                        Livro livro = livroDAO.buscarPorId(item.getLivro().getId());
                        livro.setEstoque(livro.getEstoque() - item.getQuantidade());
                        livroDAO.atualizar(livro);
                    }
                    
                    // Limpa o carrinho
                    session.removeAttribute("carrinho");
                    
                    session.setAttribute("mensagemSucesso", "Pedido realizado com sucesso! Número: " + pedidoId);
                    response.sendRedirect(request.getContextPath() + "/pedidos?action=detalhes&id=" + pedidoId);
                } else {
                    session.setAttribute("mensagemErro", "Erro ao processar itens do pedido.");
                    response.sendRedirect(request.getContextPath() + "/pedidos?action=checkout");
                }
            } else {
                session.setAttribute("mensagemErro", "Erro ao criar pedido.");
                response.sendRedirect(request.getContextPath() + "/pedidos?action=checkout");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensagemErro", "Erro interno do servidor.");
            response.sendRedirect(request.getContextPath() + "/pedidos?action=checkout");
        }
    }

    /**
     * Cancela um pedido
     */
    private void cancelarPedido(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        try {
            int pedidoId = Integer.parseInt(request.getParameter("id"));
            Pedido pedido = pedidoDAO.buscarPorId(pedidoId);
            
            if (pedido != null && (pedido.getUsuarioId() == usuario.getId() || usuario.isAdmin())) {
                if (pedido.podeSerCancelado()) {
                    if (pedidoDAO.cancelar(pedidoId)) {
                        // Restaura estoque dos livros
                        for (ItemPedido item : pedido.getItens()) {
                            Livro livro = livroDAO.buscarPorId(item.getLivroId());
                            if (livro != null) {
                                livro.setEstoque(livro.getEstoque() + item.getQuantidade());
                                livroDAO.atualizar(livro);
                            }
                        }
                        
                        session.setAttribute("mensagemSucesso", "Pedido cancelado com sucesso.");
                    } else {
                        session.setAttribute("mensagemErro", "Erro ao cancelar pedido.");
                    }
                } else {
                    session.setAttribute("mensagemErro", "Pedido não pode ser cancelado.");
                }
            } else {
                session.setAttribute("mensagemErro", "Pedido não encontrado.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "ID de pedido inválido.");
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos");
    }

    /**
     * Lista todos os pedidos (área administrativa)
     */
    private void listarTodosPedidos(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null || !usuario.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        String statusParam = request.getParameter("status");
        List<Pedido> pedidos;
        
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            try {
                Pedido.StatusPedido status = Pedido.StatusPedido.valueOf(statusParam.toUpperCase());
                pedidos = pedidoDAO.listarPorStatus(status);
                request.setAttribute("statusFiltro", status);
            } catch (IllegalArgumentException e) {
                pedidos = pedidoDAO.listarTodos();
            }
        } else {
            pedidos = pedidoDAO.listarTodos();
        }
        
        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("/admin/pedidos.jsp").forward(request, response);
    }

    /**
     * Atualiza status de um pedido (área administrativa)
     */
    private void atualizarStatusPedido(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null || !usuario.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        try {
            int pedidoId = Integer.parseInt(request.getParameter("id"));
            String novoStatusStr = request.getParameter("status");
            
            Pedido.StatusPedido novoStatus = Pedido.StatusPedido.valueOf(novoStatusStr.toUpperCase());
            
            if (pedidoDAO.atualizarStatus(pedidoId, novoStatus)) {
                session.setAttribute("mensagemSucesso", "Status do pedido atualizado.");
            } else {
                session.setAttribute("mensagemErro", "Erro ao atualizar status.");
            }
        } catch (NumberFormatException | IllegalArgumentException e) {
            session.setAttribute("mensagemErro", "Dados inválidos.");
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos?action=admin");
    }

    /**
     * Confirma um pedido (área administrativa)
     */
    private void confirmarPedido(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null || !usuario.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        try {
            int pedidoId = Integer.parseInt(request.getParameter("id"));
            
            if (pedidoDAO.atualizarStatus(pedidoId, Pedido.StatusPedido.CONFIRMADO)) {
                session.setAttribute("mensagemSucesso", "Pedido confirmado com sucesso.");
            } else {
                session.setAttribute("mensagemErro", "Erro ao confirmar pedido.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "ID de pedido inválido.");
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos?action=admin");
    }
}