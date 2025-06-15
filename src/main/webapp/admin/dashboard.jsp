<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Painel Administrativo" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="page-title" style="width: auto; margin-bottom: 0;">Gestão de Livros</h1>
    <a href="${pageContext.request.contextPath}/livros?action=adminForm" class="btn btn-primary">Adicionar Novo Livro</a>
</div>

<div class="table-responsive">
    <table class="table table-modern">
        <thead>
            <tr>
                <th>ID</th>
                <th>Capa</th>
                <th>Título</th>
                <th>Estoque</th>
                <th>Preço</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="livro" items="${livros}">
                <tr>
                    <td>${livro.id}</td>
                    <td><img src="${not empty livro.imagemUrl ? livro.imagemUrl : 'https://via.placeholder.com/80x120.png?text=Sem+Capa'}" alt="Capa" style="width: 40px; height: 60px; object-fit: cover;"></td>
                    <td>${livro.titulo}</td>
                    <td>${livro.estoque}</td>
                    <td><fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$"/></td>
                    <td>
                        <c:if test="${livro.ativo}">
                            <span class="badge badge-stock-ok">Ativo</span>
                        </c:if>
                        <c:if test="${not livro.ativo}">
                            <span class="badge badge-stock-out">Inativo</span>
                        </c:if>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/livros?action=adminForm&id=${livro.id}" class="btn btn-warning btn-sm">Editar</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/tags/footer.jsp" %>