<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Livros - Painel Administrativo</title>
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
                    <span class="brand-subtitle">Gestão de Livros</span>
                </div>
            </div>

            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="nav-item">
                    <span class="nav-icon">📊</span>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin?action=livros" class="nav-item active">
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
                    <span class="user-name">${sessionScope.adminLogado}</span>
                    <span class="user-role">Administrador</span>
                </div>
                <div class="user-actions">
                    <a href="${pageContext.request.contextPath}/livros" class="user-action" title="Ver Site">🌐</a>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" class="user-action logout" title="Sair">🚪</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Conteúdo Principal -->
    <main class="admin-main">
        <div class="admin-container">
            
            <!-- Breadcrumb -->
            <nav class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin?action=dashboard">Dashboard</a>
                <span class="breadcrumb-separator">→</span>
                <span class="breadcrumb-current">Gestão de Livros</span>
            </nav>

            <!-- Alertas -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <span class="alert-icon">✅</span>
                    <c:choose>
                        <c:when test="${param.success == 'inserido'}">Livro cadastrado com sucesso!</c:when>
                        <c:when test="${param.success == 'atualizado'}">Livro atualizado com sucesso!</c:when>
                        <c:when test="${param.success == 'deletado'}">Livro removido com sucesso!</c:when>
                        <c:otherwise>${param.success}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <span class="alert-icon">❌</span>
                    <c:choose>
                        <c:when test="${param.error == 'erro_inserir'}">Erro ao cadastrar livro.</c:when>
                        <c:when test="${param.error == 'erro_atualizar'}">Erro ao atualizar livro.</c:when>
                        <c:when test="${param.error == 'erro_deletar'}">Erro ao remover livro.</c:when>
                        <c:when test="${param.error == 'dados_invalidos'}">Dados inválidos fornecidos.</c:when>
                        <c:otherwise>${param.error}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Cabeçalho da Página -->
            <div class="page-header">
                <div class="header-content">
                    <div class="header-info">
                        <h2 class="page-title">📚 Gestão de Livros</h2>
                        <p class="page-subtitle">Gerencie o catálogo de livros da livraria</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn btn-secondary" onclick="exportarDados()">
                            📄 Exportar
                        </button>
                        <a href="${pageContext.request.contextPath}/admin?action=novoLivro" class="btn btn-primary">
                            ➕ Novo Livro
                        </a>
                    </div>
                </div>
            </div>

            <!-- Estatísticas Rápidas -->
            <div class="stats-overview">
                <div class="stat-item">
                    <div class="stat-icon">📚</div>
                    <div class="stat-content">
                        <h4>${totalLivros}</h4>
                        <p>Total de Livros</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon">✅</div>
                    <div class="stat-content">
                        <h4>${livrosAtivos}</h4>
                        <p>Livros Ativos</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon">⚠️</div>
                    <div class="stat-content">
                        <h4>${livrosEstoqueBaixo}</h4>
                        <p>Estoque Baixo</p>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon">⭐</div>
                    <div class="stat-content">
                        <h4>${livrosDestaque}</h4>
                        <p>Em Destaque</p>
                    </div>
                </div>
            </div>

            <!-- Filtros e Busca -->
            <div class="filters-section">
                <div class="filters-header">
                    <h3>🔍 Filtros e Busca</h3>
                    <button class="btn btn-outline-secondary btn-sm" onclick="limparFiltros()">
                        Limpar Filtros
                    </button>
                </div>
                
                <div class="filters-content">
                    <div class="filter-group">
                        <label for="searchInput">Buscar Livros:</label>
                        <input type="text" id="searchInput" class="form-control" 
                               placeholder="Digite título, autor ou ISBN..." 
                               onkeyup="filtrarLivros()">
                    </div>
                    
                    <div class="filter-group">
                        <label for="statusFilter">Status:</label>
                        <select id="statusFilter" class="form-control" onchange="filtrarLivros()">
                            <option value="">Todos</option>
                            <option value="ativo">Ativos</option>
                            <option value="inativo">Inativos</option>
                            <option value="destaque">Em Destaque</option>
                            <option value="estoque-baixo">Estoque Baixo</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="categoriaFilter">Categoria:</label>
                        <select id="categoriaFilter" class="form-control" onchange="filtrarLivros()">
                            <option value="">Todas</option>
                            <c:forEach var="categoria" items="${categorias}">
                                <option value="${categoria.id}">${categoria.nome}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="orderBy">Ordenar por:</label>
                        <select id="orderBy" class="form-control" onchange="ordenarLivros()">
                            <option value="id-desc">Mais Recentes</option>
                            <option value="titulo-asc">Título A-Z</option>
                            <option value="titulo-desc">Título Z-A</option>
                            <option value="preco-asc">Menor Preço</option>
                            <option value="preco-desc">Maior Preço</option>
                            <option value="estoque-asc">Menor Estoque</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Tabela de Livros -->
            <div class="livros-table-section">
                <div class="table-header">
                    <div class="table-info">
                        <span id="resultadosInfo">Mostrando todos os livros</span>
                    </div>
                    <div class="table-actions">
                        <button class="btn btn-outline-primary btn-sm" onclick="toggleView()">
                            <span id="viewToggleText">👁️ Visualização</span>
                        </button>
                        <div class="items-per-page">
                            <label for="itemsPerPage">Itens por página:</label>
                            <select id="itemsPerPage" onchange="changeItemsPerPage()">
                                <option value="10">10</option>
                                <option value="25" selected>25</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Visualização em Tabela -->
                <div id="tableView" class="table-responsive">
                    <table class="livros-table">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                </th>
                                <th onclick="sortTable('imagem')">Capa</th>
                                <th onclick="sortTable('titulo')">Título <span class="sort-icon">↕️</span></th>
                                <th onclick="sortTable('autor')">Autor <span class="sort-icon">↕️</span></th>
                                <th onclick="sortTable('categoria')">Categoria</th>
                                <th onclick="sortTable('preco')">Preço <span class="sort-icon">↕️</span></th>
                                <th onclick="sortTable('estoque')">Estoque <span class="sort-icon">↕️</span></th>
                                <th>Status</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody id="livrosTableBody">
                            <c:forEach var="livro" items="${livros}">
                                <tr class="livro-row" data-id="${livro.id}" 
                                    data-titulo="${livro.titulo}" 
                                    data-autor="${livro.autor}"
                                    data-categoria="${livro.categoriaId}"
                                    data-preco="${livro.preco}"
                                    data-estoque="${livro.estoque}"
                                    data-ativo="${livro.ativo}"
                                    data-destaque="${livro.destaque}">
                                    <td>
                                        <input type="checkbox" class="row-select" value="${livro.id}">
                                    </td>
                                    <td class="livro-capa">
                                        <img src="${livro.imagemUrl}" alt="${livro.titulo}" 
                                             class="book-cover-mini" 
                                             onerror="this.src='https://via.placeholder.com/60x90?text=Sem+Capa'">
                                    </td>
                                    <td class="livro-titulo">
                                        <div class="titulo-info">
                                            <strong>${livro.titulo}</strong>
                                            <c:if test="${not empty livro.isbn}">
                                                <small class="isbn">ISBN: ${livro.isbn}</small>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="livro-autor">${livro.autor}</td>
                                    <td class="livro-categoria">
                                        <c:forEach var="cat" items="${categorias}">
                                            <c:if test="${cat.id == livro.categoriaId}">
                                                <span class="categoria-badge">${cat.nome}</span>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="livro-preco">
                                        <fmt:formatNumber value="${livro.preco}" type="currency"/>
                                    </td>
                                    <td class="livro-estoque">
                                        <span class="estoque-badge ${livro.estoque <= 5 ? 'estoque-baixo' : ''}">
                                            ${livro.estoque}
                                        </span>
                                    </td>
                                    <td class="livro-status">
                                        <div class="status-badges">
                                            <span class="status-badge ${livro.ativo ? 'status-ativo' : 'status-inativo'}">
                                                ${livro.ativo ? 'Ativo' : 'Inativo'}
                                            </span>
                                            <c:if test="${livro.destaque}">
                                                <span class="status-badge status-destaque">Destaque</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="livro-acoes">
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                               class="btn-action btn-view" title="Visualizar" target="_blank">
                                                👁️
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin?action=editarLivro&id=${livro.id}" 
                                               class="btn-action btn-edit" title="Editar">
                                                ✏️
                                            </a>
                                            <button onclick="confirmarDelecao(${livro.id}, '${livro.titulo}')" 
                                                    class="btn-action btn-delete" title="Excluir">
                                                🗑️
                                            </button>
                                            <button onclick="toggleStatus(${livro.id}, ${livro.ativo})" 
                                                    class="btn-action btn-toggle" 
                                                    title="${livro.ativo ? 'Desativar' : 'Ativar'}">
                                                ${livro.ativo ? '🔴' : '🟢'}
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Visualização em Cards (alternativa) -->
                <div id="cardView" class="cards-view" style="display: none;">
                    <div class="livros-grid" id="livrosGrid">
                        <!-- Cards serão gerados via JavaScript -->
                    </div>
                </div>

                <!-- Ações em Lote -->
                <div class="bulk-actions" id="bulkActions" style="display: none;">
                    <div class="bulk-info">
                        <span id="selectedCount">0</span> itens selecionados
                    </div>
                    <div class="bulk-buttons">
                        <button class="btn btn-outline-success btn-sm" onclick="bulkAction('ativar')">
                            ✅ Ativar Selecionados
                        </button>
                        <button class="btn btn-outline-warning btn-sm" onclick="bulkAction('desativar')">
                            ⏸️ Desativar Selecionados
                        </button>
                        <button class="btn btn-outline-primary btn-sm" onclick="bulkAction('destaque')">
                            ⭐ Marcar como Destaque
                        </button>
                        <button class="btn btn-outline-danger btn-sm" onclick="bulkAction('deletar')">
                            🗑️ Excluir Selecionados
                        </button>
                    </div>
                </div>

                <!-- Paginação -->
                <div class="pagination-section">
                    <div class="pagination-info">
                        Página <span id="currentPage">1</span> de <span id="totalPages">1</span>
                        (<span id="totalItems">0</span> itens no total)
                    </div>
                    <div class="pagination-controls">
                        <button class="btn btn-outline-secondary btn-sm" onclick="previousPage()">← Anterior</button>
                        <div class="page-numbers" id="pageNumbers"></div>
                        <button class="btn btn-outline-secondary btn-sm" onclick="nextPage()">Próxima →</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Modal de Confirmação -->
    <div id="confirmModal" class="modal-overlay" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h4>Confirmar Ação</h4>
                <button class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p id="confirmMessage">Tem certeza que deseja realizar esta ação?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancelar</button>
                <button class="btn btn-danger" id="confirmButton" onclick="executeAction()">Confirmar</button>
            </div>
        </div>
    </div>

    <style>
        /* Estilos específicos da página de gestão de livros */
        .breadcrumb {
            background: rgba(245, 245, 220, 0.8);
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-small);
            margin-bottom: var(--spacing-lg);
            font-size: 0.9rem;
        }

        .breadcrumb a {
            color: var(--primary-brown);
            text-decoration: none;
        }

        .breadcrumb-separator {
            margin: 0 var(--spacing-sm);
            color: var(--secondary-color);
        }

        .breadcrumb-current {
            color: var(--dark-brown);
            font-weight: 600;
        }

        .page-header {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            box-shadow: var(--shadow-medium);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-actions {
            display: flex;
            gap: var(--spacing-sm);
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-lg);
        }

        .stat-item {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-md);
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
            box-shadow: var(--shadow-medium);
            transition: var(--transition-normal);
        }

        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-large);
        }

        .stat-icon {
            font-size: 2rem;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--gradient-primary);
            color: white;
            border-radius: 50%;
        }

        .stat-content h4 {
            margin: 0;
            font-size: 1.8rem;
            color: var(--dark-brown);
        }

        .stat-content p {
            margin: 0;
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .filters-section {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            box-shadow: var(--shadow-medium);
        }

        .filters-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-md);
            padding-bottom: var(--spacing-sm);
            border-bottom: 2px solid #f8f9fa;
        }

        .filters-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-md);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-xs);
        }

        .filter-group label {
            font-weight: 600;
            color: var(--dark-brown);
            font-size: 0.9rem;
        }

        .form-control {
            padding: var(--spacing-sm);
            border: 2px solid rgba(139, 69, 19, 0.2);
            border-radius: var(--border-radius-small);
            transition: var(--transition-normal);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-brown);
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        .livros-table-section {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-medium);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-lg);
            padding-bottom: var(--spacing-sm);
            border-bottom: 2px solid #f8f9fa;
        }

        .table-actions {
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
        }

        .items-per-page {
            display: flex;
            align-items: center;
            gap: var(--spacing-xs);
            font-size: 0.9rem;
        }

        .items-per-page select {
            padding: var(--spacing-xs) var(--spacing-sm);
            border: 1px solid #ddd;
            border-radius: var(--border-radius-small);
        }

        .table-responsive {
            overflow-x: auto;
        }

        .livros-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .livros-table th {
            background: var(--gradient-primary);
            color: white;
            padding: var(--spacing-md);
            text-align: left;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition-normal);
            white-space: nowrap;
        }

        .livros-table th:hover {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
        }

        .sort-icon {
            float: right;
            opacity: 0.6;
        }

        .livros-table td {
            padding: var(--spacing-md);
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        .livro-row {
            transition: var(--transition-normal);
        }

        .livro-row:hover {
            background: rgba(245, 245, 220, 0.5);
        }

        .book-cover-mini {
            width: 40px;
            height: 60px;
            object-fit: cover;
            border-radius: var(--border-radius-small);
            box-shadow: var(--shadow-small);
        }

        .titulo-info {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-xs);
        }

        .isbn {
            color: var(--secondary-color);
            font-size: 0.8rem;
        }

        .categoria-badge {
            background: rgba(52, 152, 219, 0.1);
            color: #2980b9;
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--border-radius-pill);
            font-size: 0.8rem;
            font-weight: 500;
        }

        .estoque-badge {
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--border-radius-pill);
            font-weight: 600;
            background: #d4edda;
            color: #155724;
        }

        .estoque-badge.estoque-baixo {
            background: #f8d7da;
            color: #721c24;
        }

        .status-badges {
            display: flex;
            flex-direction: column;
            gap: var(--spacing-xs);
        }

        .status-badge {
            padding: var(--spacing-xs) var(--spacing-sm);
            border-radius: var(--border-radius-pill);
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            text-align: center;
        }

        .status-ativo {
            background: #d4edda;
            color: #155724;
        }

        .status-inativo {
            background: #f8d7da;
            color: #721c24;
        }

        .status-destaque {
            background: #fff3cd;
            color: #856404;
        }

        .action-buttons {
            display: flex;
            gap: var(--spacing-xs);
        }

        .btn-action {
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            transition: var(--transition-normal);
            font-size: 0.9rem;
            text-decoration: none;
        }

        .btn-view {
            background: rgba(52, 152, 219, 0.1);
            color: #2980b9;
        }

        .btn-edit {
            background: rgba(243, 156, 18, 0.1);
            color: #d68910;
        }

        .btn-delete {
            background: rgba(231, 76, 60, 0.1);
            color: #c0392b;
        }

        .btn-toggle {
            background: rgba(46, 204, 113, 0.1);
            color: #27ae60;
        }

        .btn-action:hover {
            transform: scale(1.1);
            box-shadow: var(--shadow-small);
        }

        .bulk-actions {
            background: var(--gradient-light);
            border-radius: var(--border-radius-small);
            padding: var(--spacing-md);
            margin-top: var(--spacing-lg);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .bulk-info {
            font-weight: 600;
            color: var(--dark-brown);
        }

        .bulk-buttons {
            display: flex;
            gap: var(--spacing-sm);
        }

        .pagination-section {
            margin-top: var(--spacing-lg);
            padding-top: var(--spacing-lg);
            border-top: 2px solid #f8f9fa;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .pagination-controls {
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }

        .page-numbers {
            display: flex;
            gap: var(--spacing-xs);
        }

        .page-number {
            padding: var(--spacing-xs) var(--spacing-sm);
            border: 1px solid #ddd;
            border-radius: var(--border-radius-small);
            cursor: pointer;
            transition: var(--transition-normal);
        }

        .page-number.active {
            background: var(--primary-brown);
            color: white;
            border-color: var(--primary-brown);
        }

        .page-number:hover:not(.active) {
            background: rgba(139, 69, 19, 0.1);
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .modal-content {
            background: white;
            border-radius: var(--border-radius-medium);
            max-width: 500px;
            width: 90%;
            box-shadow: var(--shadow-extra-large);
        }

        .modal-header {
            padding: var(--spacing-md) var(--spacing-lg);
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--secondary-color);
        }

        .modal-body {
            padding: var(--spacing-lg);
        }

        .modal-footer {
            padding: var(--spacing-md) var(--spacing-lg);
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: var(--spacing-sm);
        }

        /* Cards View */
        .livros-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: var(--spacing-md);
        }

        .livro-card {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: var(--spacing-md);
            box-shadow: var(--shadow-small);
            transition: var(--transition-normal);
        }

        .livro-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-large);
        }

        /* Responsividade */
        @media (max-width: 1200px) {
            .stats-overview {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .filters-content {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: var(--spacing-md);
                text-align: center;
            }
            
            .stats-overview {
                grid-template-columns: 1fr;
            }
            
            .filters-content {
                grid-template-columns: 1fr;
            }
            
            .table-header {
                flex-direction: column;
                gap: var(--spacing-md);
            }
            
            .pagination-section {
                flex-direction: column;
                gap: var(--spacing-md);
            }
            
            .bulk-actions {
                flex-direction: column;
                gap: var(--spacing-sm);
                text-align: center;
            }
        }
    </style>

    <script>
        // Variáveis globais
        let currentPage = 1;
        let itemsPerPage = 25;
        let totalItems = 0;
        let filteredLivros = [];
        let allLivros = [];
        let currentView = 'table';
        let currentAction = null;
        let selectedIds = [];

        // Inicialização
        document.addEventListener('DOMContentLoaded', function() {
            initializePage();
            loadLivrosData();
        });

        function initializePage() {
            // Carregar dados dos livros da tabela HTML
            const rows = document.querySelectorAll('.livro-row');
            allLivros = Array.from(rows).map(row => ({
                id: row.dataset.id,
                titulo: row.dataset.titulo,
                autor: row.dataset.autor,
                categoria: row.dataset.categoria,
                preco: parseFloat(row.dataset.preco),
                estoque: parseInt(row.dataset.estoque),
                ativo: row.dataset.ativo === 'true',
                destaque: row.dataset.destaque === 'true',
                element: row
            }));
            
            filteredLivros = [...allLivros];
            updatePagination();
            updateResultsInfo();
        }

        function loadLivrosData() {
            // Simula carregamento de dados via AJAX
            totalItems = allLivros.length;
            updatePagination();
        }

        function filtrarLivros() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const categoriaFilter = document.getElementById('categoriaFilter').value;

            filteredLivros = allLivros.filter(livro => {
                // Filtro de busca
                const matchesSearch = searchTerm === '' || 
                    livro.titulo.toLowerCase().includes(searchTerm) ||
                    livro.autor.toLowerCase().includes(searchTerm);

                // Filtro de status
                let matchesStatus = true;
                if (statusFilter === 'ativo') matchesStatus = livro.ativo;
                else if (statusFilter === 'inativo') matchesStatus = !livro.ativo;
                else if (statusFilter === 'destaque') matchesStatus = livro.destaque;
                else if (statusFilter === 'estoque-baixo') matchesStatus = livro.estoque <= 5;

                // Filtro de categoria
                const matchesCategoria = categoriaFilter === '' || livro.categoria === categoriaFilter;

                return matchesSearch && matchesStatus && matchesCategoria;
            });

            // Ocultar/mostrar linhas
            allLivros.forEach(livro => {
                const isVisible = filteredLivros.includes(livro);
                livro.element.style.display = isVisible ? '' : 'none';
            });

            currentPage = 1;
            updatePagination();
            updateResultsInfo();
        }

        function ordenarLivros() {
            const orderBy = document.getElementById('orderBy').value;
            const [field, direction] = orderBy.split('-');

            filteredLivros.sort((a, b) => {
                let valueA = a[field];
                let valueB = b[field];

                if (typeof valueA === 'string') {
                    valueA = valueA.toLowerCase();
                    valueB = valueB.toLowerCase();
                }

                if (direction === 'asc') {
                    return valueA < valueB ? -1 : valueA > valueB ? 1 : 0;
                } else {
                    return valueA > valueB ? -1 : valueA < valueB ? 1 : 0;
                }
            });

            // Reordenar elementos na tabela
            const tbody = document.getElementById('livrosTableBody');
            filteredLivros.forEach(livro => {
                tbody.appendChild(livro.element);
            });
        }

        function limparFiltros() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('categoriaFilter').value = '';
            document.getElementById('orderBy').value = 'id-desc';
            filtrarLivros();
        }

        function toggleView() {
            const tableView = document.getElementById('tableView');
            const cardView = document.getElementById('cardView');
            const toggleText = document.getElementById('viewToggleText');

            if (currentView === 'table') {
                tableView.style.display = 'none';
                cardView.style.display = 'block';
                toggleText.textContent = '📋 Tabela';
                currentView = 'card';
                generateCardView();
            } else {
                tableView.style.display = 'block';
                cardView.style.display = 'none';
                toggleText.textContent = '👁️ Visualização';
                currentView = 'table';
            }
        }

        function generateCardView() {
            const grid = document.getElementById('livrosGrid');
            grid.innerHTML = '';

            filteredLivros.forEach(livro => {
                const card = document.createElement('div');
                card.className = 'livro-card';
                card.innerHTML = `
                    <div class="card-header">
                        <input type="checkbox" class="row-select" value="${livro.id}">
                        <div class="status-badges">
                            <span class="status-badge ${livro.ativo ? 'status-ativo' : 'status-inativo'}">
                                ${livro.ativo ? 'Ativo' : 'Inativo'}
                            </span>
                            ${livro.destaque ? '<span class="status-badge status-destaque">Destaque</span>' : ''}
                        </div>
                    </div>
                    <div class="card-image">
                        <img src="${livro.element.querySelector('.book-cover-mini').src}" alt="${livro.titulo}">
                    </div>
                    <div class="card-content">
                        <h4>${livro.titulo}</h4>
                        <p>${livro.autor}</p>
                        <div class="card-stats">
                            <span>Preço: R$ ${livro.preco.toFixed(2)}</span>
                            <span>Estoque: ${livro.estoque}</span>
                        </div>
                    </div>
                    <div class="card-actions">
                        ${livro.element.querySelector('.action-buttons').innerHTML}
                    </div>
                `;
                grid.appendChild(card);
            });
        }

        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.row-select');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
            
            updateBulkActions();
        }

        function updateBulkActions() {
            const selectedCheckboxes = document.querySelectorAll('.row-select:checked');
            const bulkActions = document.getElementById('bulkActions');
            const selectedCount = document.getElementById('selectedCount');
            
            selectedIds = Array.from(selectedCheckboxes).map(cb => cb.value);
            
            if (selectedIds.length > 0) {
                bulkActions.style.display = 'flex';
                selectedCount.textContent = selectedIds.length;
            } else {
                bulkActions.style.display = 'none';
            }
        }

        // Event listeners para checkboxes
        document.addEventListener('change', function(e) {
            if (e.target.classList.contains('row-select')) {
                updateBulkActions();
            }
        });

        function bulkAction(action) {
            if (selectedIds.length === 0) return;
            
            let message = '';
            switch (action) {
                case 'ativar':
                    message = `Ativar ${selectedIds.length} livros selecionados?`;
                    break;
                case 'desativar':
                    message = `Desativar ${selectedIds.length} livros selecionados?`;
                    break;
                case 'destaque':
                    message = `Marcar ${selectedIds.length} livros como destaque?`;
                    break;
                case 'deletar':
                    message = `EXCLUIR ${selectedIds.length} livros selecionados? Esta ação não pode ser desfeita!`;
                    break;
            }
            
            showConfirmModal(message, action);
        }

        function confirmarDelecao(id, titulo) {
            selectedIds = [id];
            const message = `Excluir o livro "${titulo}"? Esta ação não pode ser desfeita!`;
            showConfirmModal(message, 'deletar');
        }

        function toggleStatus(id, currentStatus) {
            selectedIds = [id];
            const action = currentStatus ? 'desativar' : 'ativar';
            const message = `${currentStatus ? 'Desativar' : 'Ativar'} este livro?`;
            showConfirmModal(message, action);
        }

        function showConfirmModal(message, action) {
            currentAction = action;
            document.getElementById('confirmMessage').textContent = message;
            document.getElementById('confirmModal').style.display = 'flex';
            
            const confirmButton = document.getElementById('confirmButton');
            confirmButton.className = action === 'deletar' ? 'btn btn-danger' : 'btn btn-primary';
            confirmButton.textContent = action === 'deletar' ? 'Excluir' : 'Confirmar';
        }

        function closeModal() {
            document.getElementById('confirmModal').style.display = 'none';
            currentAction = null;
            selectedIds = [];
        }

        function executeAction() {
            if (!currentAction || selectedIds.length === 0) return;
            
            // Aqui seria feita a requisição AJAX para o servidor
            console.log(`Executando ação: ${currentAction} para IDs:`, selectedIds);
            
            // Simular sucesso
            switch (currentAction) {
                case 'deletar':
                    alert(`${selectedIds.length} livros foram excluídos com sucesso!`);
                    // Remover da interface
                    selectedIds.forEach(id => {
                        const row = document.querySelector(`[data-id="${id}"]`);
                        if (row) row.remove();
                    });
                    break;
                case 'ativar':
                case 'desativar':
                    alert(`Status alterado para ${selectedIds.length} livros!`);
                    // Atualizar status na interface
                    break;
                case 'destaque':
                    alert(`${selectedIds.length} livros marcados como destaque!`);
                    break;
            }
            
            closeModal();
            updateBulkActions();
            filtrarLivros();
        }

        function updatePagination() {
            totalItems = filteredLivros.length;
            const totalPages = Math.ceil(totalItems / itemsPerPage);
            
            document.getElementById('currentPage').textContent = currentPage;
            document.getElementById('totalPages').textContent = totalPages;
            document.getElementById('totalItems').textContent = totalItems;
            
            // Gerar números das páginas
            const pageNumbers = document.getElementById('pageNumbers');
            pageNumbers.innerHTML = '';
            
            for (let i = 1; i <= Math.min(5, totalPages); i++) {
                const pageBtn = document.createElement('span');
                pageBtn.className = `page-number ${i === currentPage ? 'active' : ''}`;
                pageBtn.textContent = i;
                pageBtn.onclick = () => goToPage(i);
                pageNumbers.appendChild(pageBtn);
            }
        }

        function updateResultsInfo() {
            const info = document.getElementById('resultadosInfo');
            info.textContent = `Mostrando ${filteredLivros.length} de ${allLivros.length} livros`;
        }

        function goToPage(page) {
            currentPage = page;
            updatePagination();
        }

        function previousPage() {
            if (currentPage > 1) {
                currentPage--;
                updatePagination();
            }
        }

        function nextPage() {
            const totalPages = Math.ceil(totalItems / itemsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                updatePagination();
            }
        }

        function changeItemsPerPage() {
            itemsPerPage = parseInt(document.getElementById('itemsPerPage').value);
            currentPage = 1;
            updatePagination();
        }

        function exportarDados() {
            // Simular exportação
            alert('Funcionalidade de exportação será implementada em breve!');
        }

        function sortTable(column) {
            // Implementar ordenação por coluna
            console.log('Ordenando por:', column);
        }
    </script>
</body>
</html>