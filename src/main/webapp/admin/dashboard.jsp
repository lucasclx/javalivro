<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administrativo - Livraria Mil Páginas</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;500;600&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-body">

    <!-- Header Administrativo -->
    <header class="admin-header">
        <div class="admin-header-content">
            <div class="admin-brand">
                <span class="admin-logo">👨‍💼</span>
                <div class="brand-text">
                    <h1>Painel Administrativo</h1>
                    <span class="brand-subtitle">Livraria Mil Páginas</span>
                </div>
            </div>

            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-item active">
                    <span class="nav-icon">📊</span>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=livros" class="nav-item">
                    <span class="nav-icon">📚</span>
                    Livros
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=pedidos" class="nav-item">
                    <span class="nav-icon">📋</span>
                    Pedidos
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=relatorios" class="nav-item">
                    <span class="nav-icon">📈</span>
                    Relatórios
                </a>
            </nav>

            <div class="admin-user">
                <div class="user-info">
                    <span class="user-name">Olá, ${sessionScope.adminLogado}</span>
                    <span class="user-role">Administrador</span>
                </div>
                <div class="user-actions">
                    <a href="${pageContext.request.contextPath}/livros" class="user-action" title="Ver Site">
                        🌐
                    </a>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" class="user-action logout" title="Sair">
                        🚪
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <main class="admin-main">
        <div class="admin-container">
            
            <!-- Mensagens de Sucesso/Erro -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <span class="alert-icon">✅</span>
                    <c:choose>
                        <c:when test="${param.success == 'login'}">
                            Bem-vindo ao painel administrativo!
                        </c:when>
                        <c:otherwise>
                            ${param.success}
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <span class="alert-icon">❌</span>
                    ${param.error}
                </div>
            </c:if>

            <!-- Título da Página -->
            <div class="page-header">
                <h2 class="page-title">📊 Dashboard Geral</h2>
                <p class="page-subtitle">Visão geral do sistema e estatísticas principais</p>
            </div>

            <!-- Cards de Estatísticas -->
            <div class="stats-grid">
                <!-- Total de Livros -->
                <div class="stat-card stat-primary">
                    <div class="stat-icon">📚</div>
                    <div class="stat-content">
                        <h3 class="stat-number">${totalLivros}</h3>
                        <p class="stat-label">Total de Livros</p>
                        <div class="stat-extra">
                            <span class="stat-detail">${livrosAtivos} ativos</span>
                        </div>
                    </div>
                    <div class="stat-action">
                        <a href="${pageContext.request.contextPath}/admin?action=novoLivro" class="btn-quick-action">
                            ➕ Novo Livro
                        </a>
                    </div>
                </div>

                <!-- Estoque Baixo -->
                <div class="stat-card stat-warning">
                    <div class="stat-icon">⚠️</div>
                    <div class="stat-content">
                        <h3 class="stat-number">${livrosEstoqueBaixo}</h3>
                        <p class="stat-label">Estoque Baixo</p>
                        <div class="stat-extra">
                            <span class="stat-detail">Menos de 5 unidades</span>
                        </div>
                    </div>
                    <div class="stat-action">
                        <a href="${pageContext.request.contextPath}/admin?action=livros&status=estoque_baixo" class="btn-quick-action">
                            👁️ Ver Lista
                        </a>
                    </div>
                </div>

                <!-- Pedidos Pendentes -->
                <div class="stat-card stat-info">
                    <div class="stat-icon">📋</div>
                    <div class="stat-content">
                        <h3 class="stat-number">${pedidosPendentes}</h3>
                        <p class="stat-label">Pedidos Pendentes</p>
                        <div class="stat-extra">
                            <span class="stat-detail">Aguardando aprovação</span>
                        </div>
                    </div>
                    <div class="stat-action">
                        <a href="${pageContext.request.contextPath}/admin?action=pedidos&status=pendente" class="btn-quick-action">
                            🔍 Processar
                        </a>
                    </div>
                </div>

                <!-- Vendas Hoje -->
                <div class="stat-card stat-success">
                    <div class="stat-icon">💰</div>
                    <div class="stat-content">
                        <h3 class="stat-number">${pedidosHoje}</h3>
                        <p class="stat-label">Vendas Hoje</p>
                        <div class="stat-extra">
                            <span class="stat-detail">Últimas 24 horas</span>
                        </div>
                    </div>
                    <div class="stat-action">
                        <a href="${pageContext.request.contextPath}/admin?action=relatorios" class="btn-quick-action">
                            📈 Relatórios
                        </a>
                    </div>
                </div>
            </div>

            <!-- Seções de Conteúdo -->
            <div class="content-grid">
                
                <!-- Ações Rápidas -->
                <div class="content-section">
                    <div class="section-header">
                        <h3>🚀 Ações Rápidas</h3>
                    </div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/admin?action=novoLivro" class="quick-action-card">
                            <div class="action-icon">📖</div>
                            <div class="action-content">
                                <h4>Cadastrar Livro</h4>
                                <p>Adicionar novo livro ao catálogo</p>
                            </div>
                            <div class="action-arrow">→</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin?action=pedidos&status=pendente" class="quick-action-card">
                            <div class="action-icon">✅</div>
                            <div class="action-content">
                                <h4>Processar Pedidos</h4>
                                <p>Aprovar pedidos pendentes</p>
                            </div>
                            <div class="action-arrow">→</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin?action=livros&status=inativo" class="quick-action-card">
                            <div class="action-icon">🔄</div>
                            <div class="action-content">
                                <h4>Reativar Livros</h4>
                                <p>Gerenciar livros inativos</p>
                            </div>
                            <div class="action-arrow">→</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin?action=relatorios" class="quick-action-card">
                            <div class="action-icon">📊</div>
                            <div class="action-content">
                                <h4>Ver Relatórios</h4>
                                <p>Analisar vendas e performance</p>
                            </div>
                            <div class="action-arrow">→</div>
                        </a>
                    </div>
                </div>

                <!-- Livros Mais Vendidos -->
                <div class="content-section">
                    <div class="section-header">
                        <h3>🏆 Livros Mais Vendidos</h3>
                        <a href="${pageContext.request.contextPath}/admin?action=relatorios" class="section-link">Ver todos</a>
                    </div>
                    <div class="bestsellers-list">
                        <c:choose>
                            <c:when test="${not empty livrosMaisVendidos}">
                                <c:forEach var="item" items="${livrosMaisVendidos}" varStatus="status">
                                    <div class="bestseller-item">
                                        <div class="bestseller-rank">#${status.index + 1}</div>
                                        <div class="bestseller-info">
                                            <h4 class="bestseller-title">${item[1]}</h4>
                                            <p class="bestseller-author">${item[2]}</p>
                                            <span class="bestseller-sales">${item[3]} vendas</span>
                                        </div>
                                        <div class="bestseller-actions">
                                            <a href="${pageContext.request.contextPath}/admin?action=editarLivro&id=${item[0]}" 
                                               class="btn-mini" title="Editar">✏️</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>📊 Dados não disponíveis</p>
                                    <small>Vendas serão exibidas após os primeiros pedidos</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Atividade Recente -->
                <div class="content-section">
                    <div class="section-header">
                        <h3>📅 Livros Recentes</h3>
                        <a href="${pageContext.request.contextPath}/admin?action=livros" class="section-link">Ver todos</a>
                    </div>
                    <div class="recent-activity">
                        <c:choose>
                            <c:when test="${not empty livrosRecentes}">
                                <c:forEach var="livro" items="${livrosRecentes}" end="4">
                                    <div class="activity-item">
                                        <div class="activity-icon">📚</div>
                                        <div class="activity-content">
                                            <h4 class="activity-title">${livro.titulo}</h4>
                                            <p class="activity-details">por ${livro.autor}</p>
                                            <span class="activity-meta">
                                                Estoque: ${livro.estoque} | 
                                                <fmt:formatNumber value="${livro.preco}" type="currency"/>
                                            </span>
                                        </div>
                                        <div class="activity-status">
                                            <span class="status-badge ${livro.ativo ? 'status-active' : 'status-inactive'}">
                                                ${livro.ativo ? 'Ativo' : 'Inativo'}
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>📚 Nenhum livro cadastrado</p>
                                    <a href="${pageContext.request.contextPath}/admin?action=novoLivro" class="btn-primary">
                                        Cadastrar Primeiro Livro
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Sistema Info -->
                <div class="content-section">
                    <div class="section-header">
                        <h3>ℹ️ Informações do Sistema</h3>
                    </div>
                    <div class="system-info">
                        <div class="info-item">
                            <span class="info-label">Versão do Sistema:</span>
                            <span class="info-value">2.0.0</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Último Login:</span>
                            <span class="info-value">Agora</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Status do Banco:</span>
                            <span class="info-value status-online">🟢 Online</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Backup:</span>
                            <span class="info-value">🔄 Automático</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Estilos específicos do dashboard -->
    <style>
        .admin-body {
            background: #f8f9fa;
            font-family: var(--font-sans);
        }

        .admin-header {
            background: var(--gradient-primary);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .admin-header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .admin-brand {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .admin-logo {
            font-size: 2rem;
        }

        .brand-text h1 {
            margin: 0;
            font-size: 1.5rem;
            color: white;
        }

        .brand-subtitle {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .admin-nav {
            display: flex;
            gap: 0.5rem;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .nav-item:hover,
        .nav-item.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }

        .admin-user {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-info {
            text-align: right;
        }

        .user-name {
            display: block;
            font-weight: 600;
        }

        .user-role {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .user-actions {
            display: flex;
            gap: 0.5rem;
        }

        .user-action {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            color: white;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .user-action:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.1);
        }

        .admin-main {
            min-height: calc(100vh - 100px);
            padding: 2rem 0;
        }

        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 2rem;
            margin: 0 0 0.5rem 0;
            color: var(--dark-brown);
        }

        .page-subtitle {
            color: var(--secondary-color);
            margin: 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 4px solid;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .stat-primary { border-left-color: var(--primary-brown); }
        .stat-warning { border-left-color: #f39c12; }
        .stat-info { border-left-color: #3498db; }
        .stat-success { border-left-color: #27ae60; }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 50px;
            height: 50px;
            opacity: 0.1;
            border-radius: 0 15px 0 50px;
        }

        .stat-primary::before { background: var(--primary-brown); }
        .stat-warning::before { background: #f39c12; }
        .stat-info::before { background: #3498db; }
        .stat-success::before { background: #27ae60; }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
            color: var(--dark-brown);
        }

        .stat-label {
            font-size: 1rem;
            margin: 0 0 0.5rem 0;
            color: var(--secondary-color);
        }

        .stat-detail {
            font-size: 0.85rem;
            color: var(--secondary-color);
        }

        .stat-action {
            margin-top: 1rem;
        }

        .btn-quick-action {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: rgba(139, 69, 19, 0.1);
            color: var(--primary-brown);
            text-decoration: none;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-quick-action:hover {
            background: var(--primary-brown);
            color: white;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
        }

        .content-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f8f9fa;
        }

        .section-header h3 {
            margin: 0;
            color: var(--dark-brown);
            font-size: 1.3rem;
        }

        .section-link {
            color: var(--primary-brown);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .section-link:hover {
            text-decoration: underline;
        }

        .quick-actions {
            display: grid;
            gap: 1rem;
        }

        .quick-action-card {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
        }

        .quick-action-card:hover {
            background: rgba(139, 69, 19, 0.1);
            transform: translateX(5px);
        }

        .action-icon {
            font-size: 2rem;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .action-content h4 {
            margin: 0 0 0.25rem 0;
            color: var(--dark-brown);
        }

        .action-content p {
            margin: 0;
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .action-arrow {
            margin-left: auto;
            font-size: 1.5rem;
            color: var(--primary-brown);
        }

        .bestsellers-list,
        .recent-activity {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .bestseller-item,
        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .bestseller-item:hover,
        .activity-item:hover {
            background: rgba(139, 69, 19, 0.05);
        }

        .bestseller-rank {
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-brown);
            color: white;
            border-radius: 50%;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .bestseller-info,
        .activity-content {
            flex: 1;
        }

        .bestseller-title,
        .activity-title {
            margin: 0 0 0.25rem 0;
            font-size: 1rem;
            font-weight: 600;
            color: var(--dark-brown);
        }

        .bestseller-author,
        .activity-details {
            margin: 0 0 0.25rem 0;
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .bestseller-sales,
        .activity-meta {
            font-size: 0.8rem;
            color: var(--primary-brown);
            font-weight: 500;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 50%;
            font-size: 1.2rem;
        }

        .activity-status {
            margin-left: auto;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-active {
            background: rgba(39, 174, 96, 0.2);
            color: #27ae60;
        }

        .status-inactive {
            background: rgba(231, 76, 60, 0.2);
            color: #e74c3c;
        }

        .btn-mini {
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-brown);
            color: white;
            text-decoration: none;
            border-radius: 50%;
            font-size: 0.8rem;
            transition: all 0.3s ease;
        }

        .btn-mini:hover {
            transform: scale(1.1);
            background: var(--dark-brown);
        }

        .system-info {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .info-label {
            font-weight: 500;
            color: var(--dark-brown);
        }

        .info-value {
            color: var(--secondary-color);
        }

        .status-online {
            color: #27ae60 !important;
        }

        .empty-state {
            text-align: center;
            padding: 2rem;
            color: var(--secondary-color);
        }

        .empty-state p {
            margin: 0 0 1rem 0;
            font-size: 1.1rem;
        }

        .empty-state small {
            display: block;
            margin-bottom: 1rem;
        }

        /* Alerts */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background: rgba(39, 174, 96, 0.1);
            border-left: 4px solid #27ae60;
            color: #1e8449;
        }

        .alert-danger {
            background: rgba(231, 76, 60, 0.1);
            border-left: 4px solid #e74c3c;
            color: #c0392b;
        }

        .alert-icon {
            font-size: 1.2rem;
        }

        /* Responsividade */
        @media (max-width: 1200px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .admin-header-content {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .admin-nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .admin-container {
                padding: 0 1rem;
            }

            .quick-action-card {
                flex-direction: column;
                text-align: center;
            }

            .action-arrow {
                margin: 0;
            }
        }
    </style>

    <!-- JavaScript para funcionalidades do dashboard -->
    <script>
        // Auto-refresh para dados em tempo real (opcional)
        function refreshStats() {
            // Implementar se necessário refresh automático
            console.log('Stats refreshed at:', new Date().toLocaleTimeString());
        }

        // Atualiza stats a cada 5 minutos
        // setInterval(refreshStats, 5 * 60 * 1000);

        // Animações de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.stat-card, .content-section');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Função para mostrar alertas temporários
        function showAlert(message, type = 'success') {
            const alertsContainer = document.querySelector('.admin-container');
            const alert = document.createElement('div');
            alert.className = `alert alert-${type}`;
            alert.innerHTML = `
                <span class="alert-icon">${type === 'success' ? '✅' : '❌'}</span>
                ${message}
            `;
            
            alertsContainer.insertBefore(alert, alertsContainer.firstChild);
            
            setTimeout(() => {
                alert.remove();
            }, 5000);
        }
    </script>
</body>
</html>