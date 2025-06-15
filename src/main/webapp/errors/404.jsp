<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Página Não Encontrada - 404" scope="request" />
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;500;600&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="error-container">
        <div class="error-content">
            <div class="error-icon">📚❓</div>
            <h1 class="error-title">404</h1>
            <h2 class="error-subtitle">Página Não Encontrada</h2>
            <p class="error-message">
                Oops! Parece que a página que você está procurando não existe em nossa biblioteca digital.
                Talvez ela tenha sido movida, removida ou você digitou o endereço incorretamente.
            </p>
            
            <div class="error-suggestions">
                <h3>🔍 O que você pode fazer:</h3>
                <ul>
                    <li>Verificar se o endereço foi digitado corretamente</li>
                    <li>Voltar à página anterior usando o botão "Voltar" do seu navegador</li>
                    <li>Ir para nossa página inicial e navegar a partir dela</li>
                    <li>Usar nossa busca para encontrar o que procura</li>
                </ul>
            </div>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                    🏠 Ir para Home
                </a>
                <button onclick="history.back()" class="btn btn-outline-elegant">
                    ← Voltar
                </button>
            </div>

            <!-- Busca rápida na página de erro -->
            <div class="error-search">
                <h4>🔎 Buscar livros:</h4>
                <form action="${pageContext.request.contextPath}/livros" method="GET" class="search-form">
                    <input type="hidden" name="action" value="buscar">
                    <div class="search-input-group">
                        <input type="text" 
                               name="q" 
                               class="search-input" 
                               placeholder="Digite título, autor ou categoria..."
                               autocomplete="off">
                        <button type="submit" class="search-btn">Buscar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <style>
        body {
            background: var(--gradient-light);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: var(--font-body);
        }

        .error-container {
            max-width: 600px;
            padding: var(--spacing-xl);
            text-align: center;
        }

        .error-content {
            background: rgba(253, 246, 227, 0.9);
            border-radius: var(--border-radius-large);
            padding: var(--spacing-xxl);
            box-shadow: var(--shadow-extra-large);
            backdrop-filter: blur(10px);
        }

        .error-icon {
            font-size: 4rem;
            margin-bottom: var(--spacing-md);
        }

        .error-title {
            font-family: var(--font-serif);
            font-size: 4rem;
            color: var(--primary-brown);
            margin: 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        .error-subtitle {
            font-family: var(--font-serif);
            color: var(--dark-brown);
            margin: var(--spacing-sm) 0 var(--spacing-lg) 0;
        }

        .error-message {
            color: var(--ink);
            line-height: 1.6;
            margin-bottom: var(--spacing-xl);
            font-size: 1.1rem;
        }

        .error-suggestions {
            background: rgba(245, 245, 220, 0.8);
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-lg);
            margin: var(--spacing-xl) 0;
            text-align: left;
        }

        .error-suggestions h3 {
            color: var(--primary-brown);
            margin-top: 0;
            margin-bottom: var(--spacing-md);
        }

        .error-suggestions ul {
            margin: 0;
            padding-left: var(--spacing-lg);
        }

        .error-suggestions li {
            margin-bottom: var(--spacing-sm);
            color: var(--ink);
        }

        .error-actions {
            display: flex;
            gap: var(--spacing-md);
            justify-content: center;
            margin: var(--spacing-xl) 0;
            flex-wrap: wrap;
        }

        .error-search {
            margin-top: var(--spacing-xl);
            padding-top: var(--spacing-xl);
            border-top: 2px dashed rgba(139, 69, 19, 0.2);
        }

        .error-search h4 {
            color: var(--dark-brown);
            margin-bottom: var(--spacing-md);
        }

        .search-input-group {
            display: flex;
            background: white;
            border-radius: var(--border-radius-pill);
            overflow: hidden;
            box-shadow: var(--shadow-medium);
            max-width: 400px;
            margin: 0 auto;
        }

        .search-input {
            flex: 1;
            border: none;
            padding: 0.8rem 1.2rem;
            font-size: 1rem;
        }

        .search-input:focus {
            outline: none;
        }

        .search-btn {
            background: var(--gradient-primary);
            border: none;
            color: white;
            padding: 0.8rem 1.5rem;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition-normal);
        }

        .search-btn:hover {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
        }

        @media (max-width: 768px) {
            .error-container {
                padding: var(--spacing-md);
            }
            
            .error-content {
                padding: var(--spacing-lg);
            }
            
            .error-title {
                font-size: 3rem;
            }
            
            .error-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .error-actions .btn {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</body>
</html>