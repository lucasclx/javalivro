package com.livraria.servlet;

import com.livraria.dao.UsuarioDAO;
import com.livraria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/livros");
        } else if ("loginPage".equals(action)) {
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        } else if ("cadastroPage".equals(action)) {
            request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/livros");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "login":
                    handleLogin(request, response);
                    break;
                case "cadastrar":
                    handleCadastro(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (SQLException e) {
            throw new ServletException("Erro de base de dados", e);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        Usuario usuario = usuarioDAO.validarLogin(email, senha);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuario);
            response.sendRedirect(request.getContextPath() + "/livros");
        } else {
            request.setAttribute("errorMessage", "Email ou senha inválidos.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    private void handleCadastro(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (usuarioDAO.buscarPorEmail(email) != null) {
            request.setAttribute("errorMessage", "Este email já está em uso.");
            request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
            return;
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(nome);
        novoUsuario.setEmail(email);
        novoUsuario.setSenha(senha);
        novoUsuario.setAdmin(false); // Novos utilizadores nunca são admins

        usuarioDAO.inserir(novoUsuario);

        // Obtém o utilizador já persistido (com a senha "hasheada")
        Usuario usuarioPersistido = usuarioDAO.buscarPorEmail(email);

        // Após o registo, faz login automaticamente
        HttpSession session = request.getSession();
        session.setAttribute("usuarioLogado", usuarioPersistido);
        response.sendRedirect(request.getContextPath() + "/livros");
    }
}