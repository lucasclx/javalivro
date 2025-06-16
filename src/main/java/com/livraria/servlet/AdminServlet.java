package com.livraria.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controlador da área administrativa. Somente realiza o fluxo de
 * controle e delega a renderização para JSPs.
 */
public class AdminServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ AdminServlet inicializado com sucesso!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            fazerLogout(request, response);
        } else if ("dashboard".equals(action)) {
            mostrarDashboard(request, response);
        } else {
            // action == null ou loginPage
            mostrarLogin(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            processarLogin(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void mostrarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    private void processarLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if ("admin@livraria.com".equals(email) && "admin123".equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("adminLogado", email);
            session.setAttribute("loginTime", System.currentTimeMillis());

            response.sendRedirect(request.getContextPath()
                    + "/admin?action=dashboard&success=login");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/admin?action=loginPage&error=invalid");
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String adminLogado = session != null ? (String) session.getAttribute("adminLogado") : null;

        if (adminLogado == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin?action=loginPage&error=session_expired");
            return;
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void fazerLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/admin?action=loginPage");
    }
}
