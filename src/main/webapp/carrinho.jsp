<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Seu Carrinho de Compras" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<h1 class="page-title">Carrinho de Compras</h1>

<div class="cart-container p-4">
    <c:choose>
        <%-- Caso o carrinho esteja vazio ou não exista --%>
        <c:when test="${empty sessionScope.carrinho or empty sessionScope.carrinho.itens}">
            <div class="alert alert-info text-center">
                <h3>Seu carrinho está vazio.</h3>
                <p>Adicione livros ao seu carrinho para vê-los aqui.</p>
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary mt-3">Continuar a Comprar</a>
            </div>
        </c:when>

        <%-- Caso o carrinho tenha itens --%>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table table-modern align-middle">
                    <thead>
                        <tr>
                            <th style="width: 50%;">Produto</th>
                            <th class="text-center">Preço Unit.</th>
                            <th class="text-center">Quantidade</th>
                            <th class="text-end">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${sessionScope.carrinho.itens}">
                            <tr class="cart-item">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" class="cart-item-img me-3">
                                        <div>
                                            <h6 class="mb-0">${item.livro.titulo}</h6>
                                            <small class="text-muted">${item.livro.autor}</small>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <fmt:formatNumber value="${item.livro.preco}" type="currency"/>
                                </td>
                                <td class="text-center">
                                    ${item.quantidade}
                                    <%-- Aqui podemos adicionar botões para alterar a quantidade no futuro --%>
                                </td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${item.precoTotal}" type="currency"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="row mt-4">
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-outline-elegant">
                        Continuar a Comprar
                    </a>
                </div>
                <div class="col-md-6 text-end">
                    <div class="cart-summary p-4">
                        <h3>Resumo do Pedido</h3>
                        <div class="d-flex justify-content-between">
                            <span>Total</span>
                            <span class="fw-bold fs-4 text-primary">
                                <fmt:formatNumber value="${sessionScope.carrinho.valorTotal}" type="currency"/>
                            </span>
                        </div>
                        <a href="#" class="btn btn-gold w-100 mt-3">Finalizar Compra</a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
.cart-item-img {
    width: 60px;
    height: 90px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
}
.me-3 { margin-right: 1rem !important; }
</style>

<%@ include file="/WEB-INF/tags/footer.jsp" %>