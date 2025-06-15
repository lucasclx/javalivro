package com.livraria.filter;

import com.livraria.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*") // Intercepta tudo que estiver dentro de /admin/
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Não cria uma nova sessão

        boolean isLoggedIn = (session != null && session.getAttribute("usuarioLogado") != null);
        boolean isAdmin = false;

        if (isLoggedIn) {
            Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
            isAdmin = usuario.isAdmin();
        }

        // Se o utilizador é admin, permite que o pedido continue
        if (isAdmin) {
            chain.doFilter(request, response);
        } else {
            // Se não, redireciona para a página de login com uma mensagem de erro
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth?action=loginPage&error=acesso_negado");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Método de inicialização do filtro (pode ser deixado em branco)
    }

    @Override
    public void destroy() {
        // Método de destruição do filtro (pode ser deixado em branco)
    }
}