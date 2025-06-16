<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="isEditing" value="${not empty livro}" />
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEditing ? 'Editar' : 'Cadastrar'} Livro - Painel Administrativo</title>
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
                <a href="${pageContext.request.contextPath}/admin?action=livros">Livros</a>
                <span class="breadcrumb-separator">→</span>
                <span class="breadcrumb-current">${isEditing ? 'Editar' : 'Cadastrar'} Livro</span>
            </nav>

            <!-- Título da Página -->
            <div class="page-header">
                <h2 class="page-title">
                    ${isEditing ? '✏️ Editar Livro' : '📖 Cadastrar Novo Livro'}
                </h2>
                <p class="page-subtitle">
                    ${isEditing ? 'Altere as informações do livro abaixo' : 'Preencha as informações do novo livro'}
                </p>
            </div>

            <!-- Formulário -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin" method="POST" class="book-form" id="bookForm">
                    <input type="hidden" name="action" value="salvarLivro">
                    <c:if test="${isEditing}">
                        <input type="hidden" name="id" value="${livro.id}">
                    </c:if>

                    <div class="form-grid">
                        <!-- Seção: Informações Básicas -->
                        <div class="form-section">
                            <div class="section-header">
                                <h3>📝 Informações Básicas</h3>
                                <p>Dados principais do livro</p>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="titulo" class="form-label required">
                                        <span class="label-icon">📚</span>
                                        Título do Livro
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="titulo" 
                                           name="titulo" 
                                           value="${livro.titulo}"
                                           placeholder="Ex: O Senhor dos Anéis"
                                           required 
                                           maxlength="200">
                                    <div class="form-feedback"></div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-8">
                                    <label for="autor" class="form-label required">
                                        <span class="label-icon">✍️</span>
                                        Autor
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="autor" 
                                           name="autor" 
                                           value="${livro.autor}"
                                           placeholder="Ex: J.R.R. Tolkien"
                                           required 
                                           maxlength="150">
                                </div>
                                <div class="form-group col-4">
                                    <label for="categoriaId" class="form-label required">
                                        <span class="label-icon">🏷️</span>
                                        Categoria
                                    </label>
                                    <select class="form-control" id="categoriaId" name="categoriaId" required>
                                        <option value="">Selecionar...</option>
                                        <c:forEach var="cat" items="${categorias}">
                                            <option value="${cat.id}" ${livro.categoriaId == cat.id ? 'selected' : ''}>
                                                ${cat.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="editora" class="form-label">
                                        <span class="label-icon">🏢</span>
                                        Editora
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="editora" 
                                           name="editora" 
                                           value="${livro.editora}"
                                           placeholder="Ex: Martins Fontes"
                                           maxlength="100">
                                </div>
                                <div class="form-group col-6">
                                    <label for="isbn" class="form-label">
                                        <span class="label-icon">🔢</span>
                                        ISBN
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="isbn" 
                                           name="isbn" 
                                           value="${livro.isbn}"
                                           placeholder="Ex: 978-85-578-2748-6"
                                           maxlength="20">
                                </div>
                            </div>
                        </div>

                        <!-- Seção: Detalhes -->
                        <div class="form-section">
                            <div class="section-header">
                                <h3>📋 Detalhes da Publicação</h3>
                                <p>Informações técnicas e comerciais</p>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-4">
                                    <label for="anoPublicacao" class="form-label">
                                        <span class="label-icon">📅</span>
                                        Ano de Publicação
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="anoPublicacao" 
                                           name="anoPublicacao" 
                                           value="${livro.anoPublicacao > 0 ? livro.anoPublicacao : ''}"
                                           placeholder="Ex: 2023"
                                           min="1900" 
                                           max="2030">
                                </div>
                                <div class="form-group col-4">
                                    <label for="numeroPaginas" class="form-label">
                                        <span class="label-icon">📄</span>
                                        Número de Páginas
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="numeroPaginas" 
                                           name="numeroPaginas" 
                                           value="${livro.numeroPaginas > 0 ? livro.numeroPaginas : ''}"
                                           placeholder="Ex: 350"
                                           min="1" 
                                           max="10000">
                                </div>
                                <div class="form-group col-4">
                                    <label for="preco" class="form-label required">
                                        <span class="label-icon">💰</span>
                                        Preço (R$)
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="preco" 
                                           name="preco" 
                                           value="${livro.preco}"
                                           placeholder="Ex: 29,90"
                                           step="0.01" 
                                           min="0"
                                           required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-4">
                                    <label for="estoque" class="form-label required">
                                        <span class="label-icon">📦</span>
                                        Estoque
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="estoque" 
                                           name="estoque" 
                                           value="${livro.estoque}"
                                           placeholder="Ex: 50"
                                           min="0"
                                           required>
                                    <small class="form-hint">Quantidade disponível para venda</small>
                                </div>
                                <div class="form-group col-8">
                                    <label for="imagemUrl" class="form-label required">
                                        <span class="label-icon">🖼️</span>
                                        URL da Imagem da Capa
                                    </label>
                                    <input type="url" 
                                           class="form-control" 
                                           id="imagemUrl" 
                                           name="imagemUrl" 
                                           value="${livro.imagemUrl}"
                                           placeholder="https://exemplo.com/capa-livro.jpg"
                                           required>
                                    <small class="form-hint">Link direto para a imagem da capa</small>
                                </div>
                            </div>
                        </div>

                        <!-- Seção: Descrição -->
                        <div class="form-section full-width">
                            <div class="section-header">
                                <h3>📖 Descrição</h3>
                                <p>Sinopse e detalhes do livro</p>
                            </div>

                            <div class="form-group">
                                <label for="descricao" class="form-label required">
                                    <span class="label-icon">📝</span>
                                    Sinopse do Livro
                                </label>
                                <textarea class="form-control" 
                                         id="descricao" 
                                         name="descricao" 
                                         rows="5" 
                                         placeholder="Descreva o enredo, personagens principais e pontos interessantes do livro..."
                                         required 
                                         maxlength="2000">${livro.descricao}</textarea>
                                <div class="char-counter">
                                    <span id="charCount">0</span>/2000 caracteres
                                </div>
                            </div>
                        </div>

                        <!-- Seção: Configurações -->
                        <div class="form-section full-width">
                            <div class="section-header">
                                <h3>⚙️ Configurações</h3>
                                <p>Status e visibilidade do livro</p>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-6">
                                    <div class="checkbox-group">
                                        <label class="checkbox-container">
                                            <input type="checkbox" 
                                                   name="destaque" 
                                                   id="destaque" 
                                                   ${livro.destaque ? 'checked' : ''}>
                                            <span class="checkbox-checkmark"></span>
                                            <div class="checkbox-content">
                                                <span class="checkbox-title">⭐ Livro em Destaque</span>
                                                <span class="checkbox-description">Aparecerá na seção de destaques da homepage</span>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="form-group col-6">
                                    <div class="checkbox-group">
                                        <label class="checkbox-container">
                                            <input type="checkbox" 
                                                   name="ativo" 
                                                   id="ativo" 
                                                   ${isEditing ? (livro.ativo ? 'checked' : '') : 'checked'}>
                                            <span class="checkbox-checkmark"></span>
                                            <div class="checkbox-content">
                                                <span class="checkbox-title">✅ Livro Ativo</span>
                                                <span class="checkbox-description">Disponível para compra no site</span>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Prévia da Capa -->
                    <div class="image-preview" id="imagePreview">
                        <h4>👁️ Prévia da Capa</h4>
                        <div class="preview-container">
                            <img id="previewImg" 
                                 src="${not empty livro.imagemUrl ? livro.imagemUrl : 'https://via.placeholder.com/200x300?text=Capa+do+Livro'}" 
                                 alt="Prévia da capa"
                                 onerror="this.src='https://via.placeholder.com/200x300?text=Imagem+Indisponível'">
                            <div class="preview-info">
                                <p><strong>Dica:</strong> Use imagens com proporção 2:3 (largura:altura)</p>
                                <p><strong>Tamanho ideal:</strong> 400x600 pixels</p>
                                <p><strong>Formato:</strong> JPG, PNG ou WebP</p>
                            </div>
                        </div>
                    </div>

                    <!-- Botões de Ação -->
                    <div class="form-actions">
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/admin?action=livros" 
                               class="btn btn-secondary">
                                <span class="btn-icon">← </span>
                                Cancelar
                            </a>
                            
                            <button type="button" class="btn btn-outline" onclick="previewBook()">
                                <span class="btn-icon">👁️</span>
                                Visualizar
                            </button>
                            
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <span class="btn-icon">${isEditing ? '💾' : '➕'}</span>
                                <span class="btn-text">${isEditing ? 'Salvar Alterações' : 'Cadastrar Livro'}</span>
                            </button>
                        </div>
                        
                        <div class="form-status" id="formStatus