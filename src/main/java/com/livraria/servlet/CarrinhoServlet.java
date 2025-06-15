package com.livraria.servlet;

import com.livraria.dao.LivroDAO;
import com.livraria.model.Carrinho;
import com.livraria.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {

    private LivroDAO livroDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "adicionar") {
                case "adicionar":
                    adicionarAoCarrinho(request, response);
                    break;
                case "remover":
                    removerDoCarrinho(request, response);
                    break;
                case "atualizar":
                    atualizarQuantidade(request, response);
                    break;
                case "limpar":
                    limparCarrinho(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/carrinho");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/carrinho?error=erro_banco");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("remover".equals(action)) {
            try {
                removerDoCarrinho(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/carrinho?error=erro_banco");
            }
        } else {
            // Exibe a página do carrinho
            exibirCarrinho(request, response);
        }
    }

    /**
     * Adiciona um livro ao carrinho
     */
    private void adicionarAoCarrinho(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Carrinho carrinho = obterOuCriarCarrinho(session);

        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            Livro livro = livroDAO.buscarPorId(livroId);

            if (livro != null && livro.isAtivo() && livro.getEstoque() > 0) {
                carrinho.adicionarItem(livro);
                
                // Define mensagem de sucesso
                session.setAttribute("mensagemSucesso", "Livro adicionado ao carrinho com sucesso!");
                
                // Redireciona para o carrinho ou para a página de origem
                String origem = request.getParameter("origem");
                if ("detalhes".equals(origem)) {
                    response.sendRedirect(request.getContextPath() + "/livros?action=detalhes&id=" + livroId + "&added=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/carrinho");
                }
            } else {
                session.setAttribute("mensagemErro", "Livro não encontrado ou fora de estoque.");
                response.sendRedirect(request.getContextPath() + "/carrinho");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "ID do livro inválido.");
            response.sendRedirect(request.getContextPath() + "/carrinho");
        }
    }

    /**
     * Remove um livro do carrinho
     */
    private void removerDoCarrinho(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Carrinho carrinho = obterOuCriarCarrinho(session);

        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            carrinho.removerItem(livroId);
            
            session.setAttribute("mensagemSucesso", "Item removido do carrinho.");
        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "ID do livro inválido.");
        }

        response.sendRedirect(request.getContextPath() + "/carrinho");
    }

    /**
     * Atualiza a quantidade de um item no carrinho
     */
    private void atualizarQuantidade(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        HttpSession session = request.getSession();
        Carrinho carrinho = obterOuCriarCarrinho(session);

        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            int novaQuantidade = Integer.parseInt(request.getParameter("quantidade"));

            if (novaQuantidade <= 0) {
                carrinho.removerItem(livroId);
                session.setAttribute("mensagemSucesso", "Item removido do carrinho.");
            } else {
                // Verifica se há estoque suficiente
                Livro livro = livroDAO.buscarPorId(livroId);
                if (livro != null && livro.getEstoque() >= novaQuantidade) {
                    carrinho.atualizarQuantidade(livroId, novaQuantidade);
                    session.setAttribute("mensagemSucesso", "Quantidade atualizada.");
                } else {
                    session.setAttribute("mensagemErro", 
                        "Estoque insuficiente. Disponível: " + (livro != null ? livro.getEstoque() : 0));
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "Dados inválidos.");
        }

        response.sendRedirect(request.getContextPath() + "/carrinho");
    }

    /**
     * Limpa todo o carrinho
     */
    private void limparCarrinho(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        session.removeAttribute("carrinho");
        session.setAttribute("mensagemSucesso", "Carrinho limpo com sucesso.");
        
        response.sendRedirect(request.getContextPath() + "/carrinho");
    }

    /**
     * Exibe a página do carrinho
     */
    private void exibirCarrinho(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Adiciona informações úteis para a página
        HttpSession session = request.getSession();
        Carrinho carrinho = obterOuCriarCarrinho(session);
        
        // Calcula informações do carrinho
        request.setAttribute("totalItens", carrinho.getQuantidadeTotalItens());
        request.setAttribute("valorTotal", carrinho.getValorTotal());
        
        // Forward para a página JSP
        request.getRequestDispatcher("/carrinho.jsp").forward(request, response);
    }

    /**
     * Obtém o carrinho da sessão ou cria um novo se não existir
     */
    private Carrinho obterOuCriarCarrinho(HttpSession session) {
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new Carrinho();
            session.setAttribute("carrinho", carrinho);
        }
        return carrinho;
    }
}