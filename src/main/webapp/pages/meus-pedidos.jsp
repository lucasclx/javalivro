<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Meus Pedidos" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="pedidos-container">
    <h1 class="page-title">📋 Meus Pedidos</h1>
    
    <c:if test="${not empty sessionScope.mensagemSucesso}">
        <div class="alert alert-success">
            ${sessionScope.mensagemSucesso}
        </div>
        <c:remove var="mensagemSucesso" scope="session" />
    </c:if>
    
    <c:if test="${not empty sessionScope.mensagemErro}">
        <div class="alert alert-danger">
            ${sessionScope.mensagemErro}
        </div>
        <c:remove var="mensagemErro" scope="session" />
    </c:if>

    <c:choose>
        <c:when test="${empty pedidos}">
            <div class="empty-state">
                <div class="empty-icon">📦</div>
                <h3>Nenhum pedido encontrado</h3>
                <p>Você ainda não fez nenhum pedido. Que tal começar a explorar nossos livros?</p>
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                    Explorar Livros
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="pedidos-list">
                <c:forEach var="pedido" items="${pedidos}">
                    <div class="pedido-card">
                        <div class="pedido-header">
                            <div class="pedido-info">
                                <h4>Pedido #${pedido.id}</h4>
                                <div class="pedido-data">
                                    <fmt:formatDate value="${pedido.dataPedido}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </div>
                            </div>
                            <div class="pedido-status">
                                <span class="status-badge status-${pedido.statusPedido.toString().toLowerCase()}">
                                    ${pedido.statusFormatado}
                                </span>
                            </div>
                        </div>

                        <div class="pedido-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <h6>Itens do Pedido:</h6>
                                    <div class="itens-resumo">
                                        <c:forEach var="item" items="${pedido.itens}" varStatus="status">
                                            <div class="item-linha">
                                                <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" class="item-img">
                                                <div class="item-info">
                                                    <div class="item-titulo">${item.livro.titulo}</div>
                                                    <div class="item-detalhes">
                                                        ${item.quantidade}x <fmt:formatNumber value="${item.precoUnitario}" type="currency"/>
                                                    </div>
                                                </div>
                                                <div class="item-subtotal">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency"/>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                
                                <div class="col-md-4">
                                    <div class="pedido-resumo">
                                        <div class="resumo-linha">
                                            <span>Total:</span>
                                            <span class="valor-total">
                                                <fmt:formatNumber value="${pedido.valorTotal}" type="currency"/>
                                            </span>
                                        </div>
                                        
                                        <div class="resumo-linha">
                                            <span>Endereço:</span>
                                        </div>
                                        <div class="endereco-entrega">
                                            ${pedido.enderecoEntrega}
                                        </div>
                                        
                                        <c:if test="${not empty pedido.observacoes}">
                                            <div class="resumo-linha mt-2">
                                                <span>Observações:</span>
                                            </div>
                                            <div class="observacoes">
                                                ${pedido.observacoes}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="pedido-actions">
                            <a href="${pageContext.request.contextPath}/pedidos?action=detalhes&id=${pedido.id}" 
                               class="btn btn-outline-primary btn-sm">
                                Ver Detalhes
                            </a>
                            
                            <c:if test="${pedido.podeSerCancelado()}">
                                <form action="${pageContext.request.contextPath}/pedidos" method="POST" 
                                      style="display: inline;" onsubmit="return confirm('Tem certeza que deseja cancelar este pedido?')">
                                    <input type="hidden" name="action" value="cancelar">
                                    <input type="hidden" name="id" value="${pedido.id}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        Cancelar Pedido
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
.pedidos-container {
    max-width: 1200px;
    margin: 0 auto;
}

.empty-state {
    text-align: center;
    padding: var(--spacing-xxl);
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-medium);
}

.empty-icon {
    font-size: 4rem;
    margin-bottom: var(--spacing-md);
}

.pedidos-list {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-lg);
}

.pedido-card {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-medium);
    overflow: hidden;
    transition: var(--transition-normal);
}

.pedido-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-large);
}

.pedido-header {
    background: var(--gradient-primary);
    color: white;
    padding: var(--spacing-md) var(--spacing-lg);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.pedido-info h4 {
    margin: 0;
    color: white;
}

.pedido-data {
    font-size: 0.9rem;
    opacity: 0.9;
}

.status-badge {
    padding: var(--spacing-xs) var(--spacing-sm);
    border-radius: var(--border-radius-pill);
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
}

.status-pendente {
    background: #ffc107;
    color: #000;
}

.status-confirmado {
    background: #17a2b8;
    color: white;
}

.status-enviado {
    background: #28a745;
    color: white;
}

.status-entregue {
    background: #218838;
    color: white;
}

.status-cancelado {
    background: #dc3545;
    color: white;
}

.pedido-body {
    padding: var(--spacing-lg);
}

.itens-resumo {
    max-height: 300px;
    overflow-y: auto;
}

.item-linha {
    display: flex;
    align-items: center;
    padding: var(--spacing-sm) 0;
    border-bottom: 1px solid rgba(139, 69, 19, 0.1);
}

.item-linha:last-child {
    border-bottom: none;
}

.item-img {
    width: 40px;
    height: 60px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
    margin-right: var(--spacing-sm);
}

.item-info {
    flex: 1;
    margin-right: var(--spacing-sm);
}

.item-titulo {
    font-weight: 600;
    color: var(--dark-brown);
}

.item-detalhes {
    font-size: 0.9rem;
    color: var(--secondary-color);
}

.item-subtotal {
    font-weight: 600;
    color: var(--forest-green);
}

.pedido-resumo {
    background: rgba(245, 245, 220, 0.7);
    border-radius: var(--border-radius-small);
    padding: var(--spacing-md);
}

.resumo-linha {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-xs);
}

.valor-total {
    font-weight: 700;
    font-size: 1.1rem;
    color: var(--forest-green);
}

.endereco-entrega, .observacoes {
    background: white;
    padding: var(--spacing-sm);
    border-radius: var(--border-radius-small);
    font-size: 0.9rem;
    margin-top: var(--spacing-xs);
    line-height: 1.4;
}

.pedido-actions {
    background: rgba(245, 245, 220, 0.5);
    padding: var(--spacing-md) var(--spacing-lg);
    display: flex;
    gap: var(--spacing-sm);
    justify-content: flex-end;
    border-top: 1px solid rgba(139, 69, 19, 0.1);
}

.row {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
}

.col-md-4, .col-md-8 {
    padding: 0 15px;
}

@media (min-width: 768px) {
    .col-md-4 {
        flex: 0 0 33.333333%;
        max-width: 33.333333%;
    }
    .col-md-8 {
        flex: 0 0 66.666667%;
        max-width: 66.666667%;
    }
}

@media (max-width: 768px) {
    .pedido-header {
        flex-direction: column;
        align-items: flex-start;
        gap: var(--spacing-sm);
    }
    
    .pedido-actions {
        flex-direction: column;
    }
    
    .item-linha {
        flex-wrap: wrap;
    }
    
    .item-img {
        margin-bottom: var(--spacing-xs);
    }
}

.mt-2 { margin-top: 0.5rem !important; }
</style>

<%@ include file="/WEB-INF/tags/footer.jsp" %>