<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Finalizar Compra" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="checkout-container">
    <h1 class="page-title">Finalizar Compra</h1>
    
    <c:if test="${not empty sessionScope.mensagemErro}">
        <div class="alert alert-danger">
            ${sessionScope.mensagemErro}
        </div>
        <c:remove var="mensagemErro" scope="session" />
    </c:if>

    <div class="row">
        <!-- Resumo do Pedido -->
        <div class="col-md-8">
            <div class="checkout-section">
                <h3>📦 Resumo do Pedido</h3>
                <div class="order-summary">
                    <c:forEach var="item" items="${carrinho.itens}">
                        <div class="order-item d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center">
                                <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" class="order-item-img">
                                <div class="ms-3">
                                    <h6 class="mb-1">${item.livro.titulo}</h6>
                                    <small class="text-muted">${item.livro.autor}</small>
                                    <div class="text-muted">Qtd: ${item.quantidade}</div>
                                </div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold">
                                    <fmt:formatNumber value="${item.precoTotal}" type="currency"/>
                                </div>
                                <small class="text-muted">
                                    <fmt:formatNumber value="${item.livro.preco}" type="currency"/> cada
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Formulário de Entrega -->
            <div class="checkout-section">
                <h3>🏠 Dados de Entrega</h3>
                <form action="${pageContext.request.contextPath}/pedidos" method="POST" id="checkoutForm">
                    <input type="hidden" name="action" value="finalizar">
                    
                    <div class="mb-3">
                        <label for="enderecoEntrega" class="form-label">Endereço Completo de Entrega *</label>
                        <textarea class="form-control" id="enderecoEntrega" name="enderecoEntrega" 
                                rows="4" required placeholder="Rua, número, complemento, bairro, cidade, estado, CEP"></textarea>
                        <div class="form-text">Informe o endereço completo para entrega</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="observacoes" class="form-label">Observações (opcional)</label>
                        <textarea class="form-control" id="observacoes" name="observacoes" 
                                rows="3" placeholder="Instruções especiais para entrega, ponto de referência, etc."></textarea>
                    </div>

                    <div class="checkout-actions">
                        <a href="${pageContext.request.contextPath}/carrinho" class="btn btn-outline-elegant">
                            ← Voltar ao Carrinho
                        </a>
                        <button type="submit" class="btn btn-success btn-lg" id="btnFinalizar">
                            🛒 Finalizar Pedido
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Resumo Financeiro -->
        <div class="col-md-4">
            <div class="checkout-summary">
                <h4>💰 Resumo Financeiro</h4>
                
                <div class="summary-line">
                    <span>Subtotal:</span>
                    <span><fmt:formatNumber value="${carrinho.valorTotal}" type="currency"/></span>
                </div>
                
                <div class="summary-line">
                    <span>Frete:</span>
                    <span class="text-success">GRÁTIS</span>
                </div>
                
                <hr>
                
                <div class="summary-total">
                    <span class="fw-bold fs-5">Total:</span>
                    <span class="fw-bold fs-4 text-primary">
                        <fmt:formatNumber value="${carrinho.valorTotal}" type="currency"/>
                    </span>
                </div>

                <div class="payment-info mt-4">
                    <h5>💳 Forma de Pagamento</h5>
                    <div class="alert alert-info">
                        <small>
                            <strong>Pagamento na Entrega</strong><br>
                            Você pode pagar em dinheiro, cartão de débito ou crédito na hora da entrega.
                        </small>
                    </div>
                </div>

                <div class="security-info mt-3">
                    <h6>🔒 Compra Segura</h6>
                    <ul class="security-list">
                        <li>✓ Dados protegidos</li>
                        <li>✓ Entrega garantida</li>
                        <li>✓ Suporte 24/7</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.checkout-container {
    max-width: 1200px;
    margin: 0 auto;
}

.checkout-section {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    margin-bottom: var(--spacing-lg);
    box-shadow: var(--shadow-medium);
}

.order-summary {
    max-height: 400px;
    overflow-y: auto;
}

.order-item {
    padding: var(--spacing-md) 0;
    border-bottom: 1px solid rgba(139, 69, 19, 0.1);
}

.order-item:last-child {
    border-bottom: none;
}

.order-item-img {
    width: 60px;
    height: 90px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
}

.checkout-summary {
    background: rgba(245, 245, 220, 0.9);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    box-shadow: var(--shadow-medium);
    position: sticky;
    top: 20px;
}

.summary-line {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-sm);
}

.summary-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: var(--spacing-md);
}

.security-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.security-list li {
    padding: var(--spacing-xs) 0;
    font-size: 0.9rem;
    color: var(--forest-green);
}

.checkout-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: var(--spacing-xl);
}

.ms-3 { margin-left: 1rem !important; }
.text-end { text-align: right !important; }

@media (max-width: 768px) {
    .checkout-actions {
        flex-direction: column;
        gap: var(--spacing-md);
    }
    
    .checkout-actions .btn {
        width: 100%;
    }
}
</style>

<script>
document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    const btn = document.getElementById('btnFinalizar');
    btn.disabled = true;
    btn.innerHTML = '⏳ Processando...';
});
</script>

<%@ include file="/WEB-INF/tags/footer.jsp" %>