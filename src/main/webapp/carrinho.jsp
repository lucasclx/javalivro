<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;500;600&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <header class="navbar no-print">
        <div class="container navbar-container">
            <!-- Logo e Nome -->
            <div class="navbar-brand-section">
                <a href="${pageContext.request.contextPath}/livros?action=listar" class="navbar-brand">
                    Livraria Mil Páginas
                </a>
            </div>

            <!-- Busca Rápida (Desktop) -->
            <div class="navbar-search d-none d-md-block">
                <form action="${pageContext.request.contextPath}/livros" method="GET" class="search-form">
                    <input type="hidden" name="action" value="buscar">
                    <div class="search-input-group">
                        <input type="text" 
                               name="q" 
                               id="busca-rapida"
                               class="search-input" 
                               placeholder="Buscar livros ou autores..."
                               autocomplete="off">
                        <button type="submit" class="search-btn">
                            🔍
                        </button>
                    </div>
                    <!-- Container para resultados da busca AJAX -->
                    <div id="resultados-busca" class="busca-resultados hidden"></div>
                </form>
            </div>

            <!-- Navegação Principal -->
            <nav class="navbar-nav">
                <a class="nav-link" href="${pageContext.request.contextPath}/livros">
                    🏠 Home
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/livros?action=destaques">
                    ⭐ Destaques
                </a>
                <a class="nav-link carrinho-link" href="${pageContext.request.contextPath}/carrinho">
                    🛒 Carrinho
                    <c:if test="${not empty sessionScope.carrinho && not empty sessionScope.carrinho.itens}">
                        <span class="carrinho-contador">${sessionScope.carrinho.quantidadeTotalItens}</span>
                    </c:if>
                </a>

                <!-- Menu do Usuário -->
                <div class="user-menu">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogado}">
                            <div class="user-dropdown">
                                <button class="user-toggle" onclick="toggleUserMenu()">
                                    👤 ${sessionScope.usuarioLogado.nome}
                                    <span class="dropdown-arrow">▼</span>
                                </button>
                                <div class="user-menu-dropdown" id="userMenuDropdown">
                                    <a href="${pageContext.request.contextPath}/pedidos" class="dropdown-item">
                                        📋 Meus Pedidos
                                    </a>
                                    
                                    <c:if test="${sessionScope.usuarioLogado.admin}">
                                        <div class="dropdown-divider"></div>
                                        <a href="${pageContext.request.contextPath}/livros?action=adminDashboard" class="dropdown-item admin-item">
                                            ⚙️ Painel Admin
                                        </a>
                                        <a href="${pageContext.request.contextPath}/pedidos?action=admin" class="dropdown-item admin-item">
                                            📊 Gestão Pedidos
                                        </a>
                                    </c:if>
                                    
                                    <div class="dropdown-divider"></div>
                                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="dropdown-item logout-item">
                                        🚪 Sair
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth?action=loginPage">
                                🔐 Entrar
                            </a>
                            <a class="btn btn-gold btn-sm" href="${pageContext.request.contextPath}/auth?action=cadastroPage">
                                📝 Cadastrar
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>

            <!-- Botão de Menu Mobile -->
            <button class="mobile-menu-toggle d-md-none" onclick="toggleMobileMenu()">
                ☰
            </button>
        </div>

        <!-- Menu Mobile -->
        <div class="mobile-menu d-md-none" id="mobileMenu">
            <!-- Busca Mobile -->
            <div class="mobile-search">
                <form action="${pageContext.request.contextPath}/livros" method="GET" class="search-form">
                    <input type="hidden" name="action" value="buscar">
                    <div class="search-input-group">
                        <input type="text" 
                               name="q" 
                               class="search-input" 
                               placeholder="Buscar livros..."
                               autocomplete="off">
                        <button type="submit" class="search-btn">🔍</button>
                    </div>
                </form>
            </div>

            <!-- Links Mobile -->
            <div class="mobile-nav-links">
                <a class="mobile-nav-link" href="${pageContext.request.contextPath}/livros">
                    🏠 Home
                </a>
                <a class="mobile-nav-link" href="${pageContext.request.contextPath}/livros?action=destaques">
                    ⭐ Destaques
                </a>
                <a class="mobile-nav-link" href="${pageContext.request.contextPath}/carrinho">
                    🛒 Carrinho
                    <c:if test="${not empty sessionScope.carrinho && not empty sessionScope.carrinho.itens}">
                        <span class="carrinho-contador">${sessionScope.carrinho.quantidadeTotalItens}</span>
                    </c:if>
                </a>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogado}">
                        <a class="mobile-nav-link" href="${pageContext.request.contextPath}/pedidos">
                            📋 Meus Pedidos
                        </a>
                        
                        <c:if test="${sessionScope.usuarioLogado.admin}">
                            <a class="mobile-nav-link admin-item" href="${pageContext.request.contextPath}/livros?action=adminDashboard">
                                ⚙️ Painel Admin
                            </a>
                        </c:if>
                        
                        <a class="mobile-nav-link logout-item" href="${pageContext.request.contextPath}/auth?action=logout">
                            🚪 Sair
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="mobile-nav-link" href="${pageContext.request.contextPath}/auth?action=loginPage">
                            🔐 Entrar
                        </a>
                        <a class="mobile-nav-link" href="${pageContext.request.contextPath}/auth?action=cadastroPage">
                            📝 Cadastrar
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <main class="container py-5">

<style>
/* Header atualizado */
.navbar-container {
    display: grid;
    grid-template-columns: auto 1fr auto;
    align-items: center;
    gap: var(--spacing-md);
    position: relative;
}

/* Busca no Header */
.navbar-search {
    max-width: 400px;
    margin: 0 auto;
    position: relative;
}

.search-form {
    position: relative;
}

.search-input-group {
    display: flex;
    background: rgba(255, 255, 255, 0.9);
    border-radius: var(--border-radius-pill);
    overflow: hidden;
    box-shadow: var(--shadow-small);
    transition: var(--transition-normal);
}

.search-input-group:focus-within {
    box-shadow: var(--shadow-medium);
    transform: translateY(-1px);
}

.search-input {
    flex: 1;
    border: none;
    padding: 0.6rem 1rem;
    font-size: 0.9rem;
    background: transparent;
    color: var(--ink);
}

.search-input:focus {
    outline: none;
}

.search-input::placeholder {
    color: var(--secondary-color);
}

.search-btn {
    background: var(--gradient-gold);
    border: none;
    padding: 0.6rem 1rem;
    color: white;
    cursor: pointer;
    font-size: 1rem;
    transition: var(--transition-normal);
}

.search-btn:hover {
    background: linear-gradient(135deg, var(--dark-gold) 0%, var(--gold) 100%);
}

/* Navegação */
.navbar-nav {
    display: flex;
    align-items: center;
    gap: var(--spacing-sm);
    flex-wrap: wrap;
}

.nav-link {
    white-space: nowrap;
    display: flex;
    align-items: center;
    gap: 0.3rem;
}

/* Carrinho com contador */
.carrinho-link {
    position: relative;
}

.carrinho-contador {
    position: absolute;
    top: -8px;
    right: -8px;
    background: var(--danger-color);
    color: white;
    border-radius: 50%;
    width: 20px;
    height: 20px;
    font-size: 0.7rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
}

/* Menu do usuário */
.user-menu {
    position: relative;
}

.user-dropdown {
    position: relative;
}

.user-toggle {
    background: rgba(218, 165, 32, 0.1);
    border: 1px solid rgba(218, 165, 32, 0.3);
    color: var(--cream);
    padding: 0.5rem 1rem;
    border-radius: var(--border-radius-pill);
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: var(--transition-normal);
    font-size: 0.9rem;
}

.user-toggle:hover {
    background: rgba(218, 165, 32, 0.2);
    transform: translateY(-1px);
}

.dropdown-arrow {
    transition: transform var(--transition-normal);
    font-size: 0.7rem;
}

.user-toggle.active .dropdown-arrow {
    transform: rotate(180deg);
}

.user-menu-dropdown {
    position: absolute;
    top: 100%;
    right: 0;
    background: white;
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-large);
    min-width: 200px;
    overflow: hidden;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: var(--transition-normal);
    z-index: 1000;
    margin-top: 0.5rem;
}

.user-menu-dropdown.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-item {
    display: block;
    padding: 0.75rem 1rem;
    color: var(--ink);
    text-decoration: none;
    transition: var(--transition-normal);
    border-bottom: 1px solid rgba(139, 69, 19, 0.1);
}

.dropdown-item:hover {
    background: rgba(245, 245, 220, 0.8);
    color: var(--dark-brown);
}

.dropdown-item:last-child {
    border-bottom: none;
}

.admin-item {
    background: rgba(23, 162, 184, 0.1);
}

.logout-item {
    background: rgba(220, 53, 69, 0.1);
}

.dropdown-divider {
    height: 1px;
    background: rgba(139, 69, 19, 0.2);
    margin: 0.5rem 0;
}

/* Menu Mobile */
.mobile-menu-toggle {
    background: rgba(218, 165, 32, 0.1);
    border: 1px solid rgba(218, 165, 32, 0.3);
    color: var(--cream);
    padding: 0.5rem;
    border-radius: var(--border-radius-small);
    font-size: 1.2rem;
    cursor: pointer;
}

.mobile-menu {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: var(--gradient-header);
    border-top: 1px solid rgba(218, 165, 32, 0.3);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: var(--transition-normal);
    z-index: 999;
}

.mobile-menu.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.mobile-search {
    padding: var(--spacing-md);
    border-bottom: 1px solid rgba(218, 165, 32, 0.2);
}

.mobile-nav-links {
    padding: var(--spacing-md) 0;
}

.mobile-nav-link {
    display: block;
    padding: 0.75rem var(--spacing-md);
    color: var(--cream);
    text-decoration: none;
    transition: var(--transition-normal);
    border-bottom: 1px solid rgba(218, 165, 32, 0.1);
}

.mobile-nav-link:hover {
    background: rgba(218, 165, 32, 0.1);
    color: var(--gold);
}

/* Responsividade */
.d-none { display: none !important; }
.d-md-block { display: block !important; }
.d-md-none { display: none !important; }

@media (min-width: 768px) {
    .d-md-block { display: block !important; }
    .d-md-none { display: none !important; }
    
    .navbar-container {
        grid-template-columns: auto 1fr auto;
    }
}

@media (max-width: 767px) {
    .navbar-container {
        grid-template-columns: auto 1fr auto;
    }
    
    .navbar-nav {
        display: none;
    }
    
    .navbar-search {
        display: none;
    }
}
</style>

<script>
// Funções para o menu do usuário e mobile
function toggleUserMenu() {
    const dropdown = document.getElementById('userMenuDropdown');
    const toggle = document.querySelector('.user-toggle');
    
    dropdown.classList.toggle('show');
    toggle.classList.toggle('active');
}

function toggleMobileMenu() {
    const menu = document.getElementById('mobileMenu');
    menu.classList.toggle('show');
}

// Fecha menus quando clica fora
document.addEventListener('click', function(e) {
    // Fecha menu do usuário
    if (!e.target.closest('.user-dropdown')) {
        const dropdown = document.getElementById('userMenuDropdown');
        const toggle = document.querySelector('.user-toggle');
        if (dropdown) {
            dropdown.classList.remove('show');
            toggle?.classList.remove('active');
        }
    }
    
    // Fecha menu mobile
    if (!e.target.closest('.mobile-menu-toggle') && !e.target.closest('.mobile-menu')) {
        const menu = document.getElementById('mobileMenu');
        if (menu) {
            menu.classList.remove('show');
        }
    }
});
</script>

<!-- Script AJAX -->
<script src="${pageContext.request.contextPath}/js/livraria-ajax.js"></script>