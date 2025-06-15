package com.livraria.filter;

import com.livraria.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Filtro de autenticação para área administrativa
 * Protege rotas administrativas e controla acesso baseado em permissões
 */
@WebFilter("/admin/*")
public class AuthenticationFilter implements Filter {

    // URLs que não precisam de autenticação
    private static final Set<String> PUBLIC_URLS = new HashSet<>(Arrays.asList(
        "/admin",
        "/admin/",
        "/admin/login.jsp"
    ));

    // Parâmetros que permitem acesso público
    private static final Set<String> PUBLIC_ACTIONS = new HashSet<>(Arrays.asList(
        "loginPage",
        "login"
    ));

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("🔐 Filtro de Autenticação Administrativa Inicializado");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Obter informações da requisição
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String action = httpRequest.getParameter("action");
        
        // Remover context path da URI
        String path = requestURI.substring(contextPath.length());
        
        // Log da requisição (apenas em desenvolvimento)
        logRequest(httpRequest, path, action);
        
        // Verificar se é uma URL pública
        if (isPublicAccess(path, action)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Verificar autenticação
        HttpSession session = httpRequest.getSession(false);
        Usuario admin = getAuthenticatedAdmin(session);
        
        if (admin != null && admin.isAdmin()) {
            // Usuário autenticado e é admin
            
            // Atualizar último acesso
            session.setAttribute("lastAccess", System.currentTimeMillis());
            
            // Adicionar informações de contexto
            httpRequest.setAttribute("currentAdmin", admin);
            httpRequest.setAttribute("adminPermissions", getAdminPermissions(admin));
            
            // Prosseguir com a requisição
            chain.doFilter(request, response);
            
        } else {
            // Não autenticado ou não é admin
            handleUnauthorizedAccess(httpRequest, httpResponse, admin);
        }
    }

    @Override
    public void destroy() {
        System.out.println("🔐 Filtro de Autenticação Administrativa Finalizado");
    }

    /**
     * Verifica se a URL ou ação permite acesso público
     */
    private boolean isPublicAccess(String path, String action) {
        // Verificar URLs públicas
        if (PUBLIC_URLS.contains(path)) {
            return true;
        }
        
        // Verificar ações públicas
        if (action != null && PUBLIC_ACTIONS.contains(action)) {
            return true;
        }
        
        // Verificar se é apenas /admin sem parâmetros (redireciona para login)
        if ("/admin".equals(path) && action == null) {
            return true;
        }
        
        return false;
    }

    /**
     * Obtém o administrador autenticado da sessão
     */
    private Usuario getAuthenticatedAdmin(HttpSession session) {
        if (session == null) {
            return null;
        }
        
        // Verificar se a sessão expirou
        if (isSessionExpired(session)) {
            session.invalidate();
            return null;
        }
        
        return (Usuario) session.getAttribute("adminLogado");
    }

    /**
     * Verifica se a sessão expirou
     */
    private boolean isSessionExpired(HttpSession session) {
        Long lastAccess = (Long) session.getAttribute("lastAccess");
        if (lastAccess == null) {
            return false; // Primeira vez
        }
        
        long now = System.currentTimeMillis();
        long maxInactive = session.getMaxInactiveInterval() * 1000L; // Converter para ms
        
        return (now - lastAccess) > maxInactive;
    }

    /**
     * Trata acesso não autorizado
     */
    private void handleUnauthorizedAccess(HttpServletRequest request, HttpServletResponse response, Usuario user) 
            throws IOException {
        
        String contextPath = request.getContextPath();
        String errorParam;
        
        if (user != null && !user.isAdmin()) {
            // Usuário logado mas não é admin
            errorParam = "access_denied";
            System.out.println("⚠️ Tentativa de acesso admin por usuário comum: " + user.getEmail());
        } else {
            // Não autenticado
            errorParam = "session_expired";
            System.out.println("⚠️ Tentativa de acesso admin não autenticado de IP: " + getClientIP(request));
        }
        
        // Redirecionar para página de login com erro
        String redirectURL = contextPath + "/admin?action=loginPage&error=" + errorParam;
        response.sendRedirect(redirectURL);
    }

    /**
     * Obtém as permissões do administrador
     */
    private Set<String> getAdminPermissions(Usuario admin) {
        Set<String> permissions = new HashSet<>();
        
        if (admin != null && admin.isAdmin()) {
            // Por enquanto, todos os admins têm todas as permissões
            // Em um sistema mais complexo, isso seria baseado em roles
            permissions.add("MANAGE_BOOKS");
            permissions.add("MANAGE_ORDERS");
            permissions.add("VIEW_REPORTS");
            permissions.add("MANAGE_USERS");
            permissions.add("SYSTEM_ADMIN");
        }
        
        return permissions;
    }

    /**
     * Obtém o IP do cliente
     */
    private String getClientIP(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP;
        }
        
        return request.getRemoteAddr();
    }

    /**
     * Log de requisições (apenas em desenvolvimento)
     */
    private void logRequest(HttpServletRequest request, String path, String action) {
        // Apenas em desenvolvimento - remover em produção
        String method = request.getMethod();
        String userAgent = request.getHeader("User-Agent");
        String ip = getClientIP(request);
        
        System.out.printf("🌐 Admin Request: %s %s | Action: %s | IP: %s%n", 
            method, path, action != null ? action : "none", ip);
        
        // Log adicional para debugging
        if ("POST".equals(method)) {
            System.out.printf("📝 POST Parameters: %s%n", request.getParameterMap().keySet());
        }
    }

    /**
     * Verifica se a requisição é AJAX
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(xRequestedWith);
    }

    /**
     * Verifica rate limiting (prevenção de ataques)
     */
    private boolean isRateLimited(HttpServletRequest request) {
        // Implementar rate limiting se necessário
        // Por exemplo, máximo 10 tentativas de login por IP por minuto
        return false;
    }

    /**
     * Sanitiza parâmetros de entrada
     */
    private String sanitizeParameter(String param) {
        if (param == null) {
            return null;
        }
        
        // Remover caracteres perigosos
        return param.replaceAll("[<>\"'&]", "").trim();
    }
}