<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Login" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="form-container">
    <div class="form-card p-5">
        <h1 class="page-title">Login</h1>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/auth" method="POST">
            <input type="hidden" name="action" value="login">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="senha" class="form-label">Senha</label>
                <input type="password" class="form-control" id="senha" name="senha" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Entrar</button>
        </form>
        <div class="text-center mt-3">
            <p>Não tem uma conta? <a href="${pageContext.request.contextPath}/auth?action=cadastroPage">Registe-se</a></p>
        </div>
    </div>
</div>
<style>.form-container { max-width: 500px; margin: auto; }</style>
<%@ include file="/WEB-INF/tags/footer.jsp" %>