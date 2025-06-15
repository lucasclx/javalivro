<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Bem-vindo à Livraria Mil Páginas" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="row">
    <div class="col-lg-3">
        <div class="filter-card p-4">
            <h4 class="mb-3">Categorias</h4>
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/livros?action=listar" class="list-group-item list-group-item-action ${empty param.categoria ? 'active' : ''}">
                    Todas
                </a>
                <c:forEach var="cat" items="${categorias}">
                    <a href="${pageContext.request.contextPath}/livros?action=categoria&categoria=${cat.id}" 
                       class="list-group-item list-group-item-action ${param.categoria == cat.id ? 'active' : ''}">
                        ${cat.nome}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="col-lg-9">
        <h1 class="page-title">
            <c:choose>
                <c:when test="${not empty categoriaSelecionada}">${categoriaSelecionada.nome}</c:when>
                <c:when test="${isDestaques}">Livros em Destaque</c:when>
                <c:when test="${not empty termoBusca}">Busca por: "${termoBusca}"</c:when>
                <c:otherwise>Nossos Livros</c:otherwise>
            </c:choose>
        </h1>
        
        <c:if test="${empty livros}">
            <div class="alert alert-info">Nenhum livro encontrado.</div>
        </c:if>

        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:forEach var="livro" items="${livros}">
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="${not empty livro.imagemUrl ? livro.imagemUrl : 'https://via.placeholder.com/300x450.png?text=Capa+Indisponível'}" class="card-img-top book-cover" alt="Capa do livro ${livro.titulo}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title fw-semibold">${livro.titulo}</h5>
                            <p class="card-text text-muted small mb-2">${livro.autor}</p>
                            <div class="mt-auto">
                                <p class="price mb-2">R$ ${livro.preco}</p>
                                <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" class="btn btn-primary w-100">
                                    Ver Detalhes
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/tags/footer.jsp" %>