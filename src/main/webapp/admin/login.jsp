<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Administrativo - Livraria Mil Páginas</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;500;600&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-login-body">
    <div class="admin-login-container">
        <div class="admin-login-card">
            <!-- Logo e Título -->
            <div class="admin-header">
                <div class="admin-logo">
                    <span class="admin-icon">👨‍💼</span>
                    <h1>Painel Administrativo</h1>
                </div>
                <p class="admin-subtitle">Livraria Mil Páginas - Sistema de Gestão</p>
            </div>

            <!-- Formulário de Login -->
            <form action="${pageContext.request.contextPath}/admin" method="POST" class="admin-login-form" id="adminLoginForm">
                <input type="hidden" name="action" value="login">
                
                <!-- Mensagens de Erro/Sucesso -->
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger">
                        <span class="alert-icon">⚠️</span>
                        <c:choose>
                            <c:when test="${param.error == 'invalid'}">
                                Credenciais inválidas. Verifique email e senha.
                            </c:when>
                            <c:when test="${param.error == 'access_denied'}">
                                Acesso negado. Apenas administradores podem acessar.
                            </c:when>
                            <c:when test="${param.error == 'session_expired'}">
                                Sessão expirada. Faça login novamente.
                            </c:when>
                            <c:otherwise>
                                Erro no login. Tente novamente.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success">
                        <span class="alert-icon">✅</span>
                        Login realizado com sucesso!
                    </div>
                </c:if>

                <!-- Campo Email -->
                <div class="form-group">
                    <label for="email" class="form-label">
                        <span class="label-icon">📧</span>
                        Email do Administrador
                    </label>
                    <input type="email" 
                           class="form-control admin-input" 
                           id="email" 
                           name="email" 
                           placeholder="admin@livraria.com"
                           value="${param.email}"
                           required 
                           autocomplete="username">
                    <div class="input-focus-line"></div>
                </div>

                <!-- Campo Senha -->
                <div class="form-group">
                    <label for="senha" class="form-label">
                        <span class="label-icon">🔐</span>
                        Senha
                    </label>
                    <div class="password-container">
                        <input type="password" 
                               class="form-control admin-input" 
                               id="senha" 
                               name="senha" 
                               placeholder="••••••••"
                               required 
                               autocomplete="current-password">
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <span id="passwordIcon">👁️</span>
                        </button>
                    </div>
                    <div class="input-focus-line"></div>
                </div>

                <!-- Checkbox Lembrar -->
                <div class="form-group">
                    <label class="checkbox-container">
                        <input type="checkbox" name="remember" id="remember">
                        <span class="checkbox-checkmark"></span>
                        <span class="checkbox-text">Manter-me conectado</span>
                    </label>
                </div>

                <!-- Botão de Login -->
                <button type="submit" class="btn-admin-primary" id="loginBtn">
                    <span class="btn-content">
                        <span class="btn-icon">🚀</span>
                        <span class="btn-text">Acessar Painel</span>
                    </span>
                    <div class="btn-loading hidden">
                        <span class="loading-spinner"></span>
                        Validando...
                    </div>
                </button>
            </form>

            <!-- Links Auxiliares -->
            <div class="admin-footer">
                <div class="admin-links">
                    <a href="${pageContext.request.contextPath}/livros" class="admin-link">
                        🏠 Voltar ao Site
                    </a>
                    <a href="#" class="admin-link" onclick="showHelp()">
                        ❓ Ajuda
                    </a>
                </div>
                
                <div class="admin-info">
                    <p>📚 Sistema de Gestão v2.0</p>
                    <p>🔒 Acesso Seguro e Criptografado</p>
                </div>
            </div>
        </div>

        <!-- Painel de Ajuda -->
        <div class="help-panel hidden" id="helpPanel">
            <div class="help-content">
                <h3>🆘 Precisa de Ajuda?</h3>
                <div class="help-section">
                    <h4>👤 Credenciais Padrão:</h4>
                    <p><strong>Email:</strong> admin@livraria.com</p>
                    <p><strong>Senha:</strong> admin123</p>
                </div>
                <div class="help-section">
                    <h4>🔧 Problemas Comuns:</h4>
                    <ul>
                        <li>Verifique se o email está correto</li>
                        <li>Certifique-se de que sua conta tem privilégios administrativos</li>
                        <li>Limpe o cache do navegador se necessário</li>
                    </ul>
                </div>
                <button class="btn-close-help" onclick="hideHelp()">Fechar</button>
            </div>
        </div>
    </div>

    <!-- Background Animado -->
    <div class="admin-background">
        <div class="floating-shape shape-1"></div>
        <div class="floating-shape shape-2"></div>
        <div class="floating-shape shape-3"></div>
        <div class="floating-shape shape-4"></div>
    </div>

    <style>
        /* Estilos específicos para o login administrativo */
        .admin-login-body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .admin-login-container {
            width: 100%;
            max-width: 450px;
            padding: 2rem;
            position: relative;
            z-index: 10;
        }

        .admin-login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideIn 0.8s ease-out;
        }

        .admin-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .admin-logo {
            margin-bottom: 1rem;
        }

        .admin-icon {
            font-size: 3rem;
            display: block;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }

        .admin-header h1 {
            color: var(--dark-brown);
            margin: 0;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .admin-subtitle {
            color: var(--secondary-color);
            margin: 0.5rem 0 0 0;
            font-size: 0.9rem;
        }

        .admin-login-form {
            space-y: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--dark-brown);
        }

        .label-icon {
            font-size: 1.1rem;
        }

        .admin-input {
            width: 100%;
            padding: 1rem;
            border: 2px solid rgba(139, 69, 19, 0.2);
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .admin-input:focus {
            outline: none;
            border-color: var(--primary-brown);
            background: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.2);
        }

        .input-focus-line {
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: var(--gradient-gold);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .admin-input:focus + .input-focus-line {
            width: 100%;
        }

        .password-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
            color: var(--secondary-color);
        }

        .checkbox-container {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            cursor: pointer;
            user-select: none;
        }

        .checkbox-container input[type="checkbox"] {
            display: none;
        }

        .checkbox-checkmark {
            width: 20px;
            height: 20px;
            border: 2px solid var(--primary-brown);
            border-radius: 4px;
            position: relative;
            transition: all 0.3s ease;
        }

        .checkbox-container input[type="checkbox"]:checked + .checkbox-checkmark {
            background: var(--primary-brown);
        }

        .checkbox-container input[type="checkbox"]:checked + .checkbox-checkmark::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-weight: bold;
            font-size: 12px;
        }

        .checkbox-text {
            color: var(--dark-brown);
            font-size: 0.9rem;
        }

        .btn-admin-primary {
            width: 100%;
            padding: 1rem;
            background: var(--gradient-primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-admin-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(139, 69, 19, 0.3);
        }

        .btn-admin-primary:active {
            transform: translateY(-1px);
        }

        .btn-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-loading {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .loading-spinner {
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        .admin-footer {
            margin-top: 2rem;
            text-align: center;
        }

        .admin-links {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-bottom: 1rem;
        }

        .admin-link {
            color: var(--primary-brown);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .admin-link:hover {
            color: var(--dark-brown);
            transform: translateY(-1px);
        }

        .admin-info {
            color: var(--secondary-color);
            font-size: 0.8rem;
        }

        .admin-info p {
            margin: 0.25rem 0;
        }

        /* Background animado */
        .admin-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        }

        .floating-shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .shape-1 {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape-2 {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 15%;
            animation-delay: 2s;
        }

        .shape-3 {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: 4s;
        }

        .shape-4 {
            width: 100px;
            height: 100px;
            top: 30%;
            right: 30%;
            animation-delay: 1s;
        }

        /* Painel de ajuda */
        .help-panel {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .help-content {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            max-width: 400px;
            margin: 1rem;
        }

        .help-section {
            margin: 1rem 0;
        }

        .help-section h4 {
            color: var(--primary-brown);
            margin-bottom: 0.5rem;
        }

        .btn-close-help {
            background: var(--primary-brown);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 1rem;
        }

        /* Animações */
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(180deg);
            }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Utilitários */
        .hidden {
            display: none !important;
        }

        /* Responsividade */
        @media (max-width: 480px) {
            .admin-login-container {
                padding: 1rem;
            }
            
            .admin-login-card {
                padding: 2rem;
            }
            
            .admin-links {
                flex-direction: column;
                gap: 0.5rem;
            }
        }
    </style>

    <script>
        // Toggle senha
        function togglePassword() {
            const senhaInput = document.getElementById('senha');
            const icon = document.getElementById('passwordIcon');
            
            if (senhaInput.type === 'password') {
                senhaInput.type = 'text';
                icon.textContent = '🙈';
            } else {
                senhaInput.type = 'password';
                icon.textContent = '👁️';
            }
        }

        // Mostrar/ocultar ajuda
        function showHelp() {
            document.getElementById('helpPanel').classList.remove('hidden');
        }

        function hideHelp() {
            document.getElementById('helpPanel').classList.add('hidden');
        }

        // Loading no formulário
        document.getElementById('adminLoginForm').addEventListener('submit', function() {
            const btn = document.getElementById('loginBtn');
            const content = btn.querySelector('.btn-content');
            const loading = btn.querySelector('.btn-loading');
            
            content.classList.add('hidden');
            loading.classList.remove('hidden');
            btn.disabled = true;
        });

        // Auto-foco no campo email
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('email').focus();
        });
    </script>
</body>
</html>