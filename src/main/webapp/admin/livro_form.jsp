<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="isEditing" value="${not empty livro}" />
<c:set var="pageTitle" value="${isEditing ? 'Editar Livro' : 'Adicionar Livro'}" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<h1 class="page-title">${isEditing ? 'Editar Livro' : 'Adicionar Novo Livro'}</h1>
<div class="form-card p-5" style="max-width: 900px; margin: auto;">
    <form action="${pageContext.request.contextPath}/livros" method="POST">
        
        <c:choose>
            <c:when test="${isEditing}">
                <input type="hidden" name="action" value="atualizar">
                <input type="hidden" name="id" value="${livro.id}">
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="inserir">
            </c:otherwise>
        </c:choose>

        <div class="row">
            <div class="col-md-8 mb-3">
                <label for="titulo" class="form-label">Título</label>
                <input type="text" class="form-control" id="titulo" name="titulo" value="${livro.titulo}" required>
            </div>
            <div class="col-md-4 mb-3">
                <label for="autor" class="form-label">Autor</label>
                <input type="text" class="form-control" id="autor" name="autor" value="${livro.autor}" required>
            </div>
        </div>
        
        <div class="mb-3">
            <label for="descricao" class="form-label">Descrição</label>
            <textarea class="form-control" id="descricao" name="descricao" rows="4" required>${livro.descricao}</textarea>
        </div>
        
        <div class="row">
            <div class="col-md-4 mb-3">
                <label for="preco" class="form-label">Preço (ex: 45.90)</label>
                <input type="number" step="0.01" class="form-control" id="preco" name="preco" value="${livro.preco}" required>
            </div>
            <div class="col-md-2 mb-3">
                <label for="estoque" class="form-label">Estoque</label>
                <input type="number" class="form-control" id="estoque" name="estoque" value="${livro.estoque}" required>
            </div>
            <div class="col-md-6 mb-3">
                <label for="categoriaId" class="form-label">Categoria</label>
                <select class="form-select" id="categoriaId" name="categoriaId" required>
                    <option value="">Selecione uma categoria...</option>
                    <c:forEach var="cat" items="${categorias}">
                        <option value="${cat.id}" ${livro.categoriaId == cat.id ? 'selected' : ''}>${cat.nome}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label for="imagemUrl" class="form-label">URL da Imagem da Capa</label>
            <input type="url" class="form-control" id="imagemUrl" name="imagemUrl" value="${livro.imagemUrl}" required>
        </div>
        
        <div class="row">
            <div class="col-md-4 mb-3">
                <label class="form-label">Opções</label>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="destaque" id="destaque" value="true" ${livro.destaque ? 'checked' : ''}>
                    <label class="form-check-label" for="destaque">Marcar como Destaque</label>
                </div>
                 <c:if test="${isEditing}">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="ativo" id="ativo" value="true" ${livro.ativo ? 'checked' : ''}>
                        <label class="form-check-label" for="ativo">Livro Ativo</label>
                    </div>
                 </c:if>
                 <c:if test="${!isEditing}">
                    <input type="hidden" name="ativo" value="true">
                 </c:if>
            </div>
            
            <div class="col-md-8 mb-3">
                <div class="row">
                    <div class="col-md-6">
                        <label for="isbn" class="form-label">ISBN</label>
                        <input type="text" class="form-control" id="isbn" name="isbn" value="${livro.isbn}">
                    </div>
                    <div class="col-md-3">
                        <label for="anoPublicacao" class="form-label">Ano</label>
                        <input type="number" class="form-control" id="anoPublicacao" name="anoPublicacao" value="${livro.anoPublicacao}">
                    </div>
                    <div class="col-md-3">
                        <label for="numeroPaginas" class="form-label">Páginas</label>
                        <input type="number" class="form-control" id="numeroPaginas" name="numeroPaginas" value="${livro.numeroPaginas}">
                    </div>
                     <div class="col-md-3">
                        <label for="editora" class="form-label">Editora</label>
                        <input type="text" class="form-control" id="editora" name="editora" value="${livro.editora}">
                    </div>
                </div>
            </div>
        </div>
        
        <hr class="my-4">
        
        <button type="submit" class="btn btn-primary">${isEditing ? 'Salvar Alterações' : 'Adicionar Livro'}</button>
        <a href="${pageContext.request.contextPath}/livros?action=adminDashboard" class="btn btn-outline-elegant">Cancelar</a>
    </form>
</div>
<%@ include file="/WEB-INF/tags/footer.jsp" %>