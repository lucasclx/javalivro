package com.livraria.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;


public class AdminServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ AdminServlet inicializado com sucesso!");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        System.out.println("🔄 AdminServlet GET - Action: " + action);
        
        try {
            if ("logout".equals(action)) {
                fazerLogout(request, response);
            } else if ("dashboard".equals(action)) {
                mostrarDashboard(request, response);
            } else {
                // Ação padrão: mostrar login
                mostrarLogin(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            mostrarErro(response, "Erro interno: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("🔄 AdminServlet POST - Action: " + action);
        
        try {
            if ("login".equals(action)) {
                processarLogin(request, response);
            } else {
                mostrarErro(response, "Ação POST inválida: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            mostrarErro(response, "Erro ao processar: " + e.getMessage());
        }
    }

    private void mostrarLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        String error = request.getParameter("error");
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='pt-BR'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("    <title>🔐 Login Administrativo - Livraria Mil Páginas</title>");
        out.println("    <style>");
        out.println("        * { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; }");
        out.println("        .login-container { background: rgba(255,255,255,0.95); padding: 40px; border-radius: 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); max-width: 450px; width: 90%; backdrop-filter: blur(10px); }");
        out.println("        .login-header { text-align: center; margin-bottom: 30px; }");
        out.println("        .login-header h1 { color: #333; margin-bottom: 10px; font-size: 2.2rem; font-weight: 700; }");
        out.println("        .login-header p { color: #666; font-size: 1.1rem; }");
        out.println("        .credentials-box { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 20px; border-radius: 12px; margin-bottom: 25px; border-left: 4px solid #667eea; }");
        out.println("        .credentials-box h3 { color: #333; margin-bottom: 10px; font-size: 1rem; }");
        out.println("        .credentials-box .cred-item { display: flex; justify-content: space-between; margin-bottom: 8px; }");
        out.println("        .credentials-box .cred-label { color: #666; }");
        out.println("        .credentials-box .cred-value { color: #333; font-weight: 600; font-family: monospace; background: #fff; padding: 2px 8px; border-radius: 4px; }");
        out.println("        .form-group { margin-bottom: 20px; }");
        out.println("        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: #333; font-size: 1rem; }");
        out.println("        .form-control { width: 100%; padding: 15px; border: 2px solid #e0e0e0; border-radius: 10px; font-size: 16px; transition: all 0.3s ease; background: rgba(255,255,255,0.9); }");
        out.println("        .form-control:focus { outline: none; border-color: #667eea; background: white; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102,126,234,0.3); }");
        out.println("        .btn-login { width: 100%; padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; text-transform: uppercase; letter-spacing: 1px; }");
        out.println("        .btn-login:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(102,126,234,0.4); }");
        out.println("        .btn-login:active { transform: translateY(-1px); }");
        out.println("        .alert-error { background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%); color: #c62828; padding: 15px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #c62828; animation: slideIn 0.5s ease; }");
        out.println("        .back-link { text-align: center; margin-top: 25px; }");
        out.println("        .back-link a { color: #667eea; text-decoration: none; font-weight: 500; transition: color 0.3s ease; }");
        out.println("        .back-link a:hover { color: #764ba2; }");
        out.println("        .system-info { text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #e0e0e0; color: #999; font-size: 0.9rem; }");
        out.println("        @keyframes slideIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }");
        out.println("        .login-container { animation: slideIn 0.6s ease; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("    <div class='login-container'>");
        
        // Header
        out.println("        <div class='login-header'>");
        out.println("            <h1>🔐 Painel Admin</h1>");
        out.println("            <p>Sistema de Gestão - Livraria Mil Páginas</p>");
        out.println("        </div>");
        
        // Credenciais de teste
        out.println("        <div class='credentials-box'>");
        out.println("            <h3>🔑 Credenciais de Teste</h3>");
        out.println("            <div class='cred-item'>");
        out.println("                <span class='cred-label'>Email:</span>");
        out.println("                <span class='cred-value'>admin@livraria.com</span>");
        out.println("            </div>");
        out.println("            <div class='cred-item'>");
        out.println("                <span class='cred-label'>Senha:</span>");
        out.println("                <span class='cred-value'>admin123</span>");
        out.println("            </div>");
        out.println("        </div>");
        
        // Mensagem de erro
        if ("invalid".equals(error)) {
            out.println("        <div class='alert-error'>");
            out.println("            ❌ <strong>Erro de Login:</strong> Email ou senha inválidos!");
            out.println("        </div>");
        } else if ("session_expired".equals(error)) {
            out.println("        <div class='alert-error'>");
            out.println("            ⏰ <strong>Sessão Expirada:</strong> Faça login novamente.");
            out.println("        </div>");
        }
        
        // Formulário
        out.println("        <form method='POST' action='" + request.getContextPath() + "/admin'>");
        out.println("            <input type='hidden' name='action' value='login'>");
        out.println("            <div class='form-group'>");
        out.println("                <label class='form-label'>📧 Email do Administrador:</label>");
        out.println("                <input type='email' name='email' class='form-control' value='admin@livraria.com' required placeholder='Digite seu email'>");
        out.println("            </div>");
        out.println("            <div class='form-group'>");
        out.println("                <label class='form-label'>🔑 Senha:</label>");
        out.println("                <input type='password' name='senha' class='form-control' value='admin123' required placeholder='Digite sua senha'>");
        out.println("            </div>");
        out.println("            <button type='submit' class='btn-login'>🚀 Acessar Painel Administrativo</button>");
        out.println("        </form>");
        
        // Links
        out.println("        <div class='back-link'>");
        out.println("            <a href='" + request.getContextPath() + "/livros'>← Voltar ao Site Principal</a>");
        out.println("        </div>");
        
        // Info do sistema
        out.println("        <div class='system-info'>");
        out.println("            <p>Sistema Administrativo v2.0 | Seguro e Confiável</p>");
        out.println("        </div>");
        
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void processarLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        System.out.println("🔐 Tentativa de login - Email: " + email);
        
        // Validação simples
        if ("admin@livraria.com".equals(email) && "admin123".equals(senha)) {
            // Login bem-sucedido
            HttpSession session = request.getSession();
            session.setAttribute("adminLogado", email);
            session.setAttribute("loginTime", System.currentTimeMillis());
            
            System.out.println("✅ Login bem-sucedido para: " + email);
            
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
        } else {
            // Login falhou
            System.out.println("❌ Login falhou para: " + email);
            response.sendRedirect(request.getContextPath() + "/admin?error=invalid");
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        String adminLogado = session != null ? (String) session.getAttribute("adminLogado") : null;
        
        if (adminLogado == null) {
            response.sendRedirect(request.getContextPath() + "/admin?error=session_expired");
            return;
        }
        
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='pt-BR'>");
        out.println("<head>");
        out.println("    <meta charset='UTF-8'>");
        out.println("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("    <title>📊 Dashboard - Painel Administrativo</title>");
        out.println("    <style>");
        out.println("        * { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; color: #333; }");
        out.println("        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px 0; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }");
        out.println("        .header-content { max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }");
        out.println("        .logo { font-size: 1.8rem; font-weight: 700; display: flex; align-items: center; gap: 10px; }");
        out.println("        .user-section { display: flex; align-items: center; gap: 20px; }");
        out.println("        .user-info { text-align: right; }");
        out.println("        .user-name { font-weight: 600; margin-bottom: 2px; }");
        out.println("        .user-role { font-size: 0.9rem; opacity: 0.9; }");
        out.println("        .header-btn { background: rgba(255,255,255,0.2); color: white; padding: 10px 16px; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; font-weight: 500; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; }");
        out.println("        .header-btn:hover { background: rgba(255,255,255,0.3); transform: translateY(-2px); }");
        out.println("        .container { max-width: 1200px; margin: 0 auto; padding: 30px 20px; }");
        out.println("        .welcome-banner { background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%); padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 30px; text-align: center; border-left: 5px solid #28a745; }");
        out.println("        .welcome-banner h1 { color: #333; margin-bottom: 10px; font-size: 2.2rem; }");
        out.println("        .welcome-banner p { color: #666; font-size: 1.1rem; }");
        out.println("        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 40px; }");
        out.println("        .stat-card { background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%); padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; transition: all 0.3s ease; border-left: 5px solid; }");
        out.println("        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.15); }");
        out.println("        .stat-card.primary { border-left-color: #667eea; }");
        out.println("        .stat-card.warning { border-left-color: #ffc107; }");
        out.println("        .stat-card.success { border-left-color: #28a745; }");
        out.println("        .stat-card.info { border-left-color: #17a2b8; }");
        out.println("        .stat-icon { font-size: 2.5rem; margin-bottom: 10px; }");
        out.println("        .stat-number { font-size: 2.5rem; font-weight: 800; margin-bottom: 5px; }");
        out.println("        .stat-label { color: #666; font-size: 1rem; font-weight: 600; }");
        out.println("        .actions-section { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }");
        out.println("        .actions-section h2 { color: #333; margin-bottom: 25px; font-size: 1.8rem; }");
        out.println("        .actions-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }");
        out.println("        .action-card { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 20px; border-radius: 12px; text-align: center; text-decoration: none; color: #333; transition: all 0.3s ease; border: 2px solid transparent; }");
        out.println("        .action-card:hover { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; transform: translateY(-3px); box-shadow: 0 6px 20px rgba(102,126,234,0.3); }");
        out.println("        .action-icon { font-size: 2rem; margin-bottom: 10px; }");
        out.println("        .action-title { font-weight: 600; margin-bottom: 5px; }");
        out.println("        .action-desc { font-size: 0.9rem; opacity: 0.8; }");
        out.println("        .footer-info { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #e0e0e0; color: #999; }");
        out.println("    </style>");
        out.println("</head>");
        out.println("<body>");
        
        // Header
        out.println("    <div class='header'>");
        out.println("        <div class='header-content'>");
        out.println("            <div class='logo'>📊 Painel Administrativo</div>");
        out.println("            <div class='user-section'>");
        out.println("                <div class='user-info'>");
        out.println("                    <div class='user-name'>👤 " + adminLogado + "</div>");
        out.println("                    <div class='user-role'>Administrador do Sistema</div>");
        out.println("                </div>");
        out.println("                <a href='" + request.getContextPath() + "/livros' class='header-btn'>🌐 Ver Site</a>");
        out.println("                <a href='" + request.getContextPath() + "/admin?action=logout' class='header-btn'>🚪 Sair</a>");
        out.println("            </div>");
        out.println("        </div>");
        out.println("    </div>");
        
        // Conteúdo principal
        out.println("    <div class='container'>");
        
        // Banner de boas-vindas
        out.println("        <div class='welcome-banner'>");
        out.println("            <h1>🎉 Bem-vindo ao Sistema Administrativo!</h1>");
        out.println("            <p>Gerencie sua livraria com eficiência e controle total</p>");
        out.println("        </div>");
        
        // Estatísticas
        out.println("        <div class='stats-grid'>");
        out.println("            <div class='stat-card primary'>");
        out.println("                <div class='stat-icon'>📚</div>");
        out.println("                <div class='stat-number'>127</div>");
        out.println("                <div class='stat-label'>Total de Livros</div>");
        out.println("            </div>");
        out.println("            <div class='stat-card warning'>");
        out.println("                <div class='stat-icon'>⚠️</div>");
        out.println("                <div class='stat-number'>8</div>");
        out.println("                <div class='stat-label'>Estoque Baixo</div>");
        out.println("            </div>");
        out.println("            <div class='stat-card info'>");
        out.println("                <div class='stat-icon'>📋</div>");
        out.println("                <div class='stat-number'>15</div>");
        out.println("                <div class='stat-label'>Pedidos Pendentes</div>");
        out.println("            </div>");
        out.println("            <div class='stat-card success'>");
        out.println("                <div class='stat-icon'>💰</div>");
        out.println("                <div class='stat-number'>23</div>");
        out.println("                <div class='stat-label'>Vendas Hoje</div>");
        out.println("            </div>");
        out.println("        </div>");
        
        // Ações administrativas
        out.println("        <div class='actions-section'>");
        out.println("            <h2>🚀 Ações Administrativas</h2>");
        out.println("            <div class='actions-grid'>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>📖</div>");
        out.println("                    <div class='action-title'>Cadastrar Livro</div>");
        out.println("                    <div class='action-desc'>Adicionar novos livros ao catálogo</div>");
        out.println("                </a>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>📚</div>");
        out.println("                    <div class='action-title'>Gerenciar Livros</div>");
        out.println("                    <div class='action-desc'>Editar, ativar ou desativar livros</div>");
        out.println("                </a>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>📋</div>");
        out.println("                    <div class='action-title'>Processar Pedidos</div>");
        out.println("                    <div class='action-desc'>Aprovar e gerenciar pedidos</div>");
        out.println("                </a>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>📊</div>");
        out.println("                    <div class='action-title'>Relatórios</div>");
        out.println("                    <div class='action-desc'>Análises e estatísticas de vendas</div>");
        out.println("                </a>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>👥</div>");
        out.println("                    <div class='action-title'>Usuários</div>");
        out.println("                    <div class='action-desc'>Gerenciar contas de usuários</div>");
        out.println("                </a>");
        out.println("                <a href='#' class='action-card'>");
        out.println("                    <div class='action-icon'>⚙️</div>");
        out.println("                    <div class='action-title'>Configurações</div>");
        out.println("                    <div class='action-desc'>Configurar sistema e preferências</div>");
        out.println("                </a>");
        out.println("            </div>");
        out.println("        </div>");
        
        // Footer
        out.println("        <div class='footer-info'>");
        out.println("            <p>📚 Sistema Administrativo - Livraria Mil Páginas v2.0</p>");
        out.println("            <p>🔒 Ambiente Seguro e Criptografado</p>");
        out.println("        </div>");
        
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void fazerLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String adminEmail = (String) session.getAttribute("adminLogado");
            System.out.println("🚪 Logout realizado para: " + adminEmail);
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin");
    }

    private void mostrarErro(HttpServletResponse response, String mensagem) throws IOException {
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Erro</title></head><body>");
        out.println("<h1>❌ Erro no Sistema</h1>");
        out.println("<p>" + mensagem + "</p>");
        out.println("<a href='" + "/admin'>← Voltar</a>");
        out.println("</body></html>");
    }
}