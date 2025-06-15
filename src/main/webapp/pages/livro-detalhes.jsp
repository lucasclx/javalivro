<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Define o título da página usando o título do livro --%>
<c:set var="pageTitle" value="${livro.titulo}" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="book-details-container">
    <%-- Verifica se o objeto 'livro' existe. Se não, mostra uma mensagem de erro. --%>
    <c:if test="${empty livro}">
        <div class="alert alert-danger">
            <h2>Livro não encontrado</h2>
            <p>O livro que você está a tentar ver não foi encontrado. <a href="${pageContext.request.contextPath}/livros">Voltar para a página inicial</a>.</p>
        </div>
    </c:if>

    <c:if test="${not empty livro}">
        <div class="row">
            <div class="col-md-4 text-center">
                <img src="${not empty livro.imagemUrl ? livro.imagemUrl : 'https://via.placeholder.com/300x450.png?text=Capa'}" 
                     alt="Capa do livro ${livro.titulo}" class="book-detail-cover shadow-lg">
            </div>

            <div class="col-md-8">
                <h1 class="book-title">${livro.titulo}</h1>
                <h2 class="book-author">por ${livro.autor}</h2>
                
                <div class="price-box my-4">
                    <span class="price">
                        <fmt:setLocale value="pt_BR"/>
                        <fmt:formatNumber value="${livro.preco}" type="currency"/>
                    </span>
                </div>

                <p class="book-description">${livro.descricao}</p>

                <%-- Ação de Adicionar ao Carrinho (funcionalidade futura) --%>
                <div class="call-to-action my-4">
                    <form action="${pageContext.request.contextPath}/carrinho" method="POST">
                        <input type="hidden" name="action" value="adicionar">
                        <input type="hidden" name="livroId" value="${livro.id}">
                        <button type="submit" class="btn btn-gold btn-lg">
                            <i class="fas fa-shopping-cart"></i> Adicionar ao Carrinho
                        </button>
                    </form>
                </div>
                
                <div class="technical-details mt-5">
                    <h4 class="details-title">Detalhes do Produto</h4>
                    <ul class="details-list">
                        <li><strong>Editora:</strong> ${livro.editora}</li>
                        <li><strong>Ano de Publicação:</strong> ${livro.anoPublicacao}</li>
                        <li><strong>Número de Páginas:</strong> ${livro.numeroPaginas}</li>
                        <li><strong>ISBN:</strong> ${livro.isbn}</li>
                    </ul>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%-- Adicione este pequeno script e estilo para melhorar a apresentação --%>
<style>
    .book-detail-cover {
        max-width: 100%;
        height: auto;
        border-radius: var(--border-radius-medium);
        border: 5px solid white;
    }
    .book-title {
        font-size: 2.8rem;
        color: var(--dark-brown);
        margin-bottom: var(--spacing-xs);
    }
    .book-author {
        font-size: 1.5rem;
        color: var(--secondary-color);
        font-family: var(--font-body);
        font-weight: 400;
        margin-bottom: var(--spacing-lg);
    }
    .price-box {
        background: rgba(255, 255, 255, 0.7);
        padding: var(--spacing-md);
        border-radius: var(--border-radius-small);
        display: inline-block;
    }
    .book-description {
        font-size: 1.1rem;
        line-height: 1.7;
    }
    .technical-details {
        background: var(--aged-paper);
        padding: var(--spacing-lg);
        border-radius: var(--border-radius-medium);
        border: 1px solid rgba(139, 69, 19, 0.1);
    }
    .details-title {
        color: var(--primary-brown);
        border-bottom: 2px solid var(--light-brown);
        padding-bottom: var(--spacing-sm);
        margin-bottom: var(--spacing-md);
    }
    .details-list {
        list-style: none;
        padding: 0;
    }
    .details-list li {
        padding: var(--spacing-sm) 0;
        border-bottom: 1px dashed rgba(139, 69, 19, 0.1);
    }
    .details-list li:last-child {
        border-bottom: none;
    }
</style>
<%-- Inclui o FontAwesome para o ícone do carrinho --%>
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

<%@ include file="/WEB-INF/tags/footer.jsp" %>