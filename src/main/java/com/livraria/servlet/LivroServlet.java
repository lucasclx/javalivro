package com.livraria.servlet;

import com.livraria.dao.CategoriaDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.model.Categoria;
import com.livraria.model.Livro;
import com.livraria.model.Usuario;
import com.livraria.util.JsonConverter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/livros")
public class LivroServlet extends HttpServlet {
    
    private LivroDAO livroDAO;
    private CategoriaDAO categoriaDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "listar") {
                case "listar":
                    listarLivros(request, response);
                    break;
                case "detalhes":
                    mostrarDetalhes(request, response);
                    break;
                case "categoria":
                    listarPorCategoria(request, response);
                    break;
                case "destaques":
                    listarDestaques(request, response);
                    break;
                case "buscar":
                    buscarLivros(request, response);
                    break;
                case "ajax":
                    handleAjaxRequest(request, response);
                    break;
                case "adminDashboard":
                    mostrarDashboardAdmin(request, response);
                    break;
                case "adminForm":
                    mostrarFormularioAdmin(request, response);
                    break;
                default:
                    listarLivros(request, response);
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
        HttpSession session = request.getSession(false);
        
        // Verificação de usuário admin
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;
        if (usuario == null || !usuario.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado. Requer privilégios de administrador.");
            return;
        }
        
        try {
            switch (action != null ? action : "") {
                case "inserir":
                    inserirLivro(request, response);
                    break;
                case "atualizar":
                    atualizarLivro(request, response);
                    break;
                case "deletar":
                    deletarLivro(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida para POST.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao processar dados no banco", e);
        }
    }

    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String tipo = request.getParameter("tipo");
        String jsonResponse = "[]";

        switch (tipo != null ? tipo : "") {
            case "destaques":
                List<Livro> destaques = livroDAO.listarDestaques();
                jsonResponse = JsonConverter.toJson(destaques);
                break;
            case "categoria":
                int categoriaId = Integer.parseInt(request.getParameter("categoria"));
                List<Livro> livrosPorCategoria = livroDAO.listarPorCategoria(categoriaId);
                jsonResponse = JsonConverter.toJson(livrosPorCategoria);
                break;
            case "busca":
                String termo = request.getParameter("q");
                if (termo != null && !termo.trim().isEmpty()) {
                    List<Livro> resultadoBusca = livroDAO.buscarPorTermo(termo);
                    jsonResponse = JsonConverter.toJson(resultadoBusca);
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo de requisição AJAX inválido");
                return;
        }
        
        response.getWriter().write(jsonResponse);
    }
    
    // MÉTODOS DE AÇÃO IMPLEMENTADOS
    
    private void listarLivros(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        List<Livro> livros = livroDAO.listarTodos();
        List<Categoria> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("livros", livros);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    private void mostrarDetalhes(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Livro livro = livroDAO.buscarPorId(id);
            
            if (livro != null) {
                request.setAttribute("livro", livro);
                request.getRequestDispatcher("/pages/livro-detalhes.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    }
    
    private void listarPorCategoria(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        try {
            int categoriaId = Integer.parseInt(request.getParameter("categoria"));
            
            List<Livro> livros = livroDAO.listarPorCategoria(categoriaId);
            List<Categoria> categorias = categoriaDAO.listarTodas();
            Categoria categoriaSelecionada = categoriaDAO.buscarPorId(categoriaId);
            
            request.setAttribute("livros", livros);
            request.setAttribute("categorias", categorias);
            request.setAttribute("categoriaSelecionada", categoriaSelecionada);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/livros");
        }
    }
    
    private void listarDestaques(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        List<Livro> livros = livroDAO.listarDestaques();
        List<Categoria> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("livros", livros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("isDestaques", true);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    private void buscarLivros(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        String termo = request.getParameter("q");
        List<Categoria> categorias = categoriaDAO.listarTodas();
        
        if (termo != null && !termo.trim().isEmpty()) {
            List<Livro> livros = livroDAO.buscarPorTermo(termo.trim());
            request.setAttribute("livros", livros);
            request.setAttribute("termoBusca", termo);
        } else {
            // Se não há termo de busca, redireciona para listar todos
            response.sendRedirect(request.getContextPath() + "/livros");
            return;
        }
        
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    private void mostrarDashboardAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        List<Livro> livros = livroDAO.listarTodosAdmin(); // Mostra todos, incluindo inativos
        request.setAttribute("livros", livros);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
    
    private void mostrarFormularioAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        List<Categoria> categorias = categoriaDAO.listarTodas();
        request.setAttribute("categorias", categorias);
        
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Livro livro = livroDAO.buscarPorId(id);
                if (livro != null) {
                    request.setAttribute("livro", livro);
                }
            } catch (NumberFormatException e) {
                // ID inválido, ignora e mostra formulário vazio
            }
        }
        
        request.getRequestDispatcher("/admin/livro_form.jsp").forward(request, response);
    }
    
    private void inserirLivro(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        try {
            Livro livro = criarLivroFromRequest(request);
            
            if (livroDAO.inserir(livro)) {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&success=inserido");
            } else {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminForm&error=erro_inserir");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/livros?action=adminForm&error=dados_invalidos");
        }
    }
    
    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        try {
            Livro livro = criarLivroFromRequest(request);
            int id = Integer.parseInt(request.getParameter("id"));
            livro.setId(id);
            
            if (livroDAO.atualizar(livro)) {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&success=atualizado");
            } else {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminForm&id=" + id + "&error=erro_atualizar");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&error=dados_invalidos");
        }
    }
    
    private void deletarLivro(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            if (livroDAO.deletar(id)) {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&success=deletado");
            } else {
                response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&error=erro_deletar");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/livros?action=adminDashboard&error=id_invalido");
        }
    }
    
    // MÉTODO AUXILIAR
    
    private Livro criarLivroFromRequest(HttpServletRequest request) {
        Livro livro = new Livro();
        
        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setEditora(request.getParameter("editora"));
        livro.setIsbn(request.getParameter("isbn"));
        livro.setDescricao(request.getParameter("descricao"));
        livro.setImagemUrl(request.getParameter("imagemUrl"));
        
        // Conversões numéricas
        try {
            livro.setAnoPublicacao(Integer.parseInt(request.getParameter("anoPublicacao")));
        } catch (NumberFormatException e) {
            livro.setAnoPublicacao(0);
        }
        
        try {
            livro.setNumeroPaginas(Integer.parseInt(request.getParameter("numeroPaginas")));
        } catch (NumberFormatException e) {
            livro.setNumeroPaginas(0);
        }
        
        try {
            livro.setEstoque(Integer.parseInt(request.getParameter("estoque")));
        } catch (NumberFormatException e) {
            livro.setEstoque(0);
        }
        
        try {
            livro.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
        } catch (NumberFormatException e) {
            livro.setCategoriaId(1); // categoria padrão
        }
        
        try {
            String precoStr = request.getParameter("preco");
            livro.setPreco(new BigDecimal(precoStr));
        } catch (NumberFormatException e) {
            livro.setPreco(BigDecimal.ZERO);
        }
        
        // Checkboxes
        livro.setDestaque("true".equals(request.getParameter("destaque")));
        livro.setAtivo("true".equals(request.getParameter("ativo")));
        
        return livro;
    }
}