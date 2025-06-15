package com.livraria.servlet;

// Import removido: com.google.gson.Gson;
import com.livraria.dao.CategoriaDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.model.Categoria;
import com.livraria.model.Livro;
import com.livraria.model.Usuario;
import com.livraria.util.JsonConverter; // Import da nossa nova classe

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
    // private Gson gson; // Removido

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
        // gson = new Gson(); // Removido
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); // Garante o encoding correto para parâmetros
        String action = request.getParameter("action");
        
        try {
            // Lógica do switch permanece a mesma, mas agora chama os métodos que implementamos
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
        HttpSession session = request.getSession(false); // Não cria uma nova sessão se não existir
        
        // A verificação de usuário e admin agora funciona como esperado
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
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
        String jsonResponse = "[]"; // Resposta padrão é um array JSON vazio

        switch (tipo != null ? tipo : "") {
            case "destaques":
                List<Livro> destaques = livroDAO.listarDestaques();
                // Substituído gson.toJson por nossa classe
                jsonResponse = JsonConverter.toJson(destaques);
                break;
            case "categoria":
                int categoriaId = Integer.parseInt(request.getParameter("categoria"));
                List<Livro> livrosPorCategoria = livroDAO.listarPorCategoria(categoriaId);
                // Substituído gson.toJson por nossa classe
                jsonResponse = JsonConverter.toJson(livrosPorCategoria);
                break;
            case "busca":
                String termo = request.getParameter("q");
                if (termo != null && !termo.trim().isEmpty()) {
                    List<Livro> resultadoBusca = livroDAO.buscarPorTermo(termo);
                    // Substituído gson.toJson por nossa classe
                    jsonResponse = JsonConverter.toJson(resultadoBusca);
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo de requisição AJAX inválido");
                return;
        }
        
        response.getWriter().write(jsonResponse);
    }
    
    // --- MÉTODOS DE AÇÃO (sem alterações na lógica interna) ---
    // Os métodos abaixo já estavam corretos, pois chamavam os DAOs.
    // Agora eles funcionarão, pois os DAOs foram implementados.

    private void listarLivros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException { /* ...código original... */ }
    private void mostrarDetalhes(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException { /* ...código original... */ }
    private void listarPorCategoria(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException { /* ...código original... */ }
    private void listarDestaques(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException { /* ...código original... */ }
    private void buscarLivros(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException { /* ...código original... */ }
    private void inserirLivro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException { /* ...código original... */ }
    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException { /* ...código original... */ }
    private void deletarLivro(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException { /* ...código original... */ }
}