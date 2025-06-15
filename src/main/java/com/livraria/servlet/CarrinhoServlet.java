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
        String action = request.getParameter("action");

        if ("adicionar".equals(action)) {
            adicionarAoCarrinho(request, response);
        } else {
            // Outras ações POST (ex: atualizar quantidade) podem ser adicionadas aqui
            response.sendRedirect(request.getContextPath() + "/carrinho");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simplesmente exibe a página do carrinho
        request.getRequestDispatcher("/carrinho.jsp").forward(request, response);
    }

    private void adicionarAoCarrinho(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();

        // Pega o carrinho da sessão, ou cria um novo se não existir
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new Carrinho();
            session.setAttribute("carrinho", carrinho);
        }

        try {
            // Pega o ID do livro a ser adicionado
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            Livro livro = livroDAO.buscarPorId(livroId);

            if (livro != null) {
                carrinho.adicionarItem(livro);
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            // Lidar com erro (opcional, por simplicidade estamos a ignorar)
        }

        // Redireciona para a página do carrinho para o utilizador ver o item adicionado
        response.sendRedirect(request.getContextPath() + "/carrinho");
    }
}