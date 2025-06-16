<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Pedido #${pedido.id} - Detalhes" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="pedido-detalhes-container">
    <div class="pedido-header-section">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="page-title">📋 Pedido #${pedido.id}</h1>
                <div class="pedido-meta">
                    <span class="pedido-data">
                        📅 Realizado em <fmt:formatDate value="${pedido.dataPedido}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                    </span>
                    <c:if test="${pedido.dataAtualizacao != null && pedido.dataAtualizacao != pedido.dataPedido}">
                        <span class="pedido-atualizacao">
                            🔄 Atualizado em <fmt:formatDate value="${pedido.dataAtualizacao}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                        </span>
                    </c:if>
                </div>
            </div>
            <div class="col-md-4 text-end">
                <span class="status-badge status-${pedido.statusPedido.toString().toLowerCase()}">
                    ${pedido.statusFormatado}
                </span>
            </div>
        </div>
    </div>

    <!-- Progress Bar do Status -->
    <div class="status-progress">
        <div class="progress-step ${pedido.statusPedido == 'PENDENTE' or pedido.statusPedido == 'CONFIRMADO' or pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}">
            <div class="step-icon">📝</div>
            <div class="step-label">Pendente</div>
        </div>
        <div class="progress-line ${pedido.statusPedido == 'CONFIRMADO' or pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}"></div>
        <div class="progress-step ${pedido.statusPedido == 'CONFIRMADO' or pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}">
            <div class="step-icon">✅</div>
            <div class="step-label">Confirmado</div>
        </div>
        <div class="progress-line ${pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}"></div>
        <div class="progress-step ${pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}">
            <div class="step-icon">🚚</div>
            <div class="step-label">Enviado</div>
        </div>
        <div class="progress-line ${pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}"></div>
        <div class="progress-step ${pedido.statusPedido == 'ENTREGUE' ? 'completed' : ''}">
            <div class="step-icon">📦</div>
            <div class="step-label">Entregue</div>
        </div>
    </div>

    <div class="row">
        <!-- Detalhes Principais -->
        <div class="col-lg-8">
            <!-- Itens do Pedido -->
            <div class="section-card">
                <div class="section-header">
                    <h3>📚 Itens do Pedido</h3>
                    <span class="item-count">${pedido.itens.size()} itens</span>
                </div>
                
                <div class="itens-pedido">
                    <c:forEach var="item" items="${pedido.itens}">
                        <div class="item-pedido">
                            <div class="item-imagem">
                                <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" class="book-thumbnail">
                            </div>
                            <div class="item-info">
                                <h5 class="item-titulo">
                                    <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${item.livro.id}">
                                        ${item.livro.titulo}
                                    </a>
                                </h5>
                                <p class="item-autor">por ${item.livro.autor}</p>
                                <div class="item-specs">
                                    <span>Quantidade: ${item.quantidade}</span>
                                    <span>Preço unitário: <fmt:formatNumber value="${item.precoUnitario}" type="currency"/></span>
                                </div>
                            </div>
                            <div class="item-subtotal">
                                <fmt:formatNumber value="${item.subtotal}" type="currency"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Histórico do Pedido -->
            <div class="section-card">
                <div class="section-header">
                    <h3>📋 Histórico do Pedido</h3>
                </div>
                <div class="historico-timeline">
                    <div class="timeline-item">
                        <div class="timeline-icon">📝</div>
                        <div class="timeline-content">
                            <h6>Pedido Criado</h6>
                            <p>Seu pedido foi criado e está aguardando confirmação.</p>
                            <small class="text-muted">
                                <fmt:formatDate value="${pedido.dataPedido}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                            </small>
                        </div>
                    </div>
                    
                    <c:if test="${pedido.statusPedido == 'CONFIRMADO' or pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE'}">
                        <div class="timeline-item">
                            <div class="timeline-icon">✅</div>
                            <div class="timeline-content">
                                <h6>Pedido Confirmado</h6>
                                <p>Pagamento processado e pedido confirmado. Preparando para envio.</p>
                                <small class="text-muted">
                                    <fmt:formatDate value="${pedido.dataAtualizacao}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${pedido.statusPedido == 'ENVIADO' or pedido.statusPedido == 'ENTREGUE'}">
                        <div class="timeline-item">
                            <div class="timeline-icon">🚚</div>
                            <div class="timeline-content">
                                <h6>Pedido Enviado</h6>
                                <p>Seu pedido saiu para entrega. Código de rastreamento: BR123456789BR</p>
                                <small class="text-muted">
                                    <fmt:formatDate value="${pedido.dataAtualizacao}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${pedido.statusPedido == 'ENTREGUE'}">
                        <div class="timeline-item">
                            <div class="timeline-icon">📦</div>
                            <div class="timeline-content">
                                <h6>Pedido Entregue</h6>
                                <p>Pedido entregue com sucesso. Obrigado pela preferência!</p>
                                <small class="text-muted">
                                    <fmt:formatDate value="${pedido.dataAtualizacao}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${pedido.statusPedido == 'CANCELADO'}">
                        <div class="timeline-item cancelled">
                            <div class="timeline-icon">❌</div>
                            <div class="timeline-content">
                                <h6>Pedido Cancelado</h6>
                                <p>Este pedido foi cancelado. O estorno será processado em até 5 dias úteis.</p>
                                <small class="text-muted">
                                    <fmt:formatDate value="${pedido.dataAtualizacao}" pattern="dd/MM/yyyy 'às' HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Sidebar com Informações -->
        <div class="col-lg-4">
            <!-- Resumo Financeiro -->
            <div class="sidebar-card">
                <h4>💰 Resumo Financeiro</h4>
                <div class="resumo-financeiro">
                    <div class="resumo-linha">
                        <span>Subtotal:</span>
                        <span><fmt:formatNumber value="${pedido.valorTotal}" type="currency"/></span>
                    </div>
                    <div class="resumo-linha">
                        <span>Frete:</span>
                        <span class="frete-gratis">GRÁTIS</span>
                    </div>
                    <div class="resumo-linha desconto" style="display: none;">
                        <span>Desconto:</span>
                        <span class="text-success">- R$ 0,00</span>
                    </div>
                    <hr>
                    <div class="resumo-total">
                        <span>Total:</span>
                        <span class="valor-total">
                            <fmt:formatNumber value="${pedido.valorTotal}" type="currency"/>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Informações de Entrega -->
            <div class="sidebar-card">
                <h4>🏠 Entrega</h4>
                <div class="entrega-info">
                    <div class="endereco-entrega">
                        <h6>Endereço de Entrega:</h6>
                        <p>${pedido.enderecoEntrega}</p>
                    </div>
                    
                    <c:if test="${not empty pedido.observacoes}">
                        <div class="observacoes-entrega">
                            <h6>Observações:</h6>
                            <p>${pedido.observacoes}</p>
                        </div>
                    </c:if>
                    
                    <div class="prazo-entrega">
                        <h6>Prazo de Entrega:</h6>
                        <p>
                            <c:choose>
                                <c:when test="${pedido.statusPedido == 'ENTREGUE'}">
                                    ✅ Entregue
                                </c:when>
                                <c:when test="${pedido.statusPedido == 'ENVIADO'}">
                                    📦 Em trânsito - Previsão: 2-5 dias úteis
                                </c:when>
                                <c:when test="${pedido.statusPedido == 'CONFIRMADO'}">
                                    📋 Preparando envio - 1-2 dias úteis
                                </c:when>
                                <c:when test="${pedido.statusPedido == 'PENDENTE'}">
                                    ⏳ Aguardando confirmação
                                </c:when>
                                <c:otherwise>
                                    ❌ Cancelado
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Informações de Pagamento -->
            <div class="sidebar-card">
                <h4>💳 Pagamento</h4>
                <div class="pagamento-info">
                    <div class="metodo-pagamento">
                        <h6>Método de Pagamento:</h6>
                        <p>💰 Pagamento na Entrega</p>
                        <small class="text-muted">
                            Você pode pagar em dinheiro, cartão de débito ou crédito no momento da entrega.
                        </small>
                    </div>
                </div>
            </div>

            <!-- Ações do Pedido -->
            <div class="sidebar-card">
                <h4>⚙️ Ações</h4>
                <div class="acoes-pedido">
                    <c:if test="${pedido.podeSerCancelado()}">
                        <form action="${pageContext.request.contextPath}/pedidos" method="POST" 
                              onsubmit="return confirm('Tem certeza que deseja cancelar este pedido?')">
                            <input type="hidden" name="action" value="cancelar">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="id" value="${pedido.id}">
                            <button type="submit" class="btn btn-outline-danger w-100 mb-2">
                                ❌ Cancelar Pedido
                            </button>
                        </form>
                    </c:if>
                    
                    <button class="btn btn-outline-primary w-100 mb-2" onclick="imprimirPedido()">
                        🖨️ Imprimir Comprovante
                    </button>
                    
                    <c:if test="${pedido.statusPedido == 'ENVIADO'}">
                        <button class="btn btn-outline-info w-100 mb-2" onclick="rastrearPedido()">
                            📍 Rastrear Pedido
                        </button>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary w-100">
                        ← Voltar aos Pedidos
                    </a>
                </div>
            </div>

            <!-- Suporte -->
            <div class="sidebar-card">
                <h4>🆘 Precisa de Ajuda?</h4>
                <div class="suporte-info">
                    <p>Entre em contato conosco:</p>
                    <ul class="contato-lista">
                        <li>📞 (11) 1234-5678</li>
                        <li>✉️ suporte@livrarmiamilpaginas.com</li>
                        <li>💬 Chat online: 8h às 18h</li>
                    </ul>
                    <button class="btn btn-success w-100 mt-2" onclick="abrirChat()">
                        💬 Chat com Suporte
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.pedido-detalhes-container {
    max-width: 1200px;
    margin: 0 auto;
}

.pedido-header-section {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    margin-bottom: var(--spacing-lg);
    box-shadow: var(--shadow-medium);
}

.pedido-meta {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-xs);
    margin-top: var(--spacing-sm);
}

.pedido-data, .pedido-atualizacao {
    font-size: 0.9rem;
    color: var(--secondary-color);
}

/* Status Progress Bar */
.status-progress {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: var(--spacing-xl) 0;
    padding: var(--spacing-lg);
    background: rgba(245, 245, 220, 0.8);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-medium);
}

.progress-step {
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
}

.step-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: #e9ecef;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    margin-bottom: var(--spacing-sm);
    transition: all 0.3s ease;
    border: 3px solid #e9ecef;
}

.progress-step.completed .step-icon {
    background: var(--success-color);
    border-color: var(--success-color);
    color: white;
}

.step-label {
    font-size: 0.8rem;
    font-weight: 600;
    color: var(--secondary-color);
    text-align: center;
}

.progress-step.completed .step-label {
    color: var(--success-color);
}

.progress-line {
    flex: 1;
    height: 3px;
    background: #e9ecef;
    margin: 0 1rem;
    max-width: 100px;
    transition: all 0.3s ease;
}

.progress-line.completed {
    background: var(--success-color);
}

/* Cards */
.section-card, .sidebar-card {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    margin-bottom: var(--spacing-lg);
    box-shadow: var(--shadow-medium);
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--spacing-lg);
    padding-bottom: var(--spacing-md);
    border-bottom: 2px solid rgba(139, 69, 19, 0.1);
}

.section-header h3 {
    margin: 0;
    color: var(--dark-brown);
}

.item-count {
    background: var(--primary-brown);
    color: white;
    padding: var(--spacing-xs) var(--spacing-sm);
    border-radius: var(--border-radius-pill);
    font-size: 0.8rem;
    font-weight: 600;
}

/* Itens do Pedido */
.itens-pedido {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-md);
}

.item-pedido {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    padding: var(--spacing-md);
    background: rgba(255, 255, 255, 0.7);
    border-radius: var(--border-radius-small);
    border: 1px solid rgba(139, 69, 19, 0.1);
    transition: var(--transition-normal);
}

.item-pedido:hover {
    background: rgba(255, 255, 255, 0.9);
    transform: translateX(5px);
}

.book-thumbnail {
    width: 60px;
    height: 90px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
    box-shadow: var(--shadow-small);
}

.item-info {
    flex: 1;
}

.item-titulo {
    margin: 0 0 var(--spacing-xs) 0;
    font-size: 1rem;
}

.item-titulo a {
    color: var(--dark-brown);
    text-decoration: none;
    transition: var(--transition-normal);
}

.item-titulo a:hover {
    color: var(--primary-brown);
    text-decoration: underline;
}

.item-autor {
    margin: 0 0 var(--spacing-xs) 0;
    color: var(--secondary-color);
    font-size: 0.9rem;
}

.item-specs {
    display: flex;
    gap: var(--spacing-md);
    font-size: 0.8rem;
    color: var(--secondary-color);
}

.item-subtotal {
    font-weight: 700;
    font-size: 1.1rem;
    color: var(--forest-green);
    text-align: right;
}

/* Timeline */
.historico-timeline {
    position: relative;
}

.timeline-item {
    display: flex;
    gap: var(--spacing-md);
    margin-bottom: var(--spacing-lg);
    position: relative;
}

.timeline-item:not(:last-child)::after {
    content: '';
    position: absolute;
    left: 20px;
    top: 50px;
    width: 2px;
    height: calc(100% + var(--spacing-lg));
    background: #e9ecef;
}

.timeline-item.cancelled::after {
    background: var(--danger-color);
}

.timeline-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: var(--light-brown);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    flex-shrink: 0;
    border: 3px solid white;
    box-shadow: var(--shadow-small);
}

.timeline-content h6 {
    margin: 0 0 var(--spacing-xs) 0;
    color: var(--dark-brown);
    font-weight: 600;
}

.timeline-content p {
    margin: 0 0 var(--spacing-xs) 0;
    color: var(--ink);
    line-height: 1.4;
}

/* Sidebar */
.sidebar-card h4 {
    color: var(--dark-brown);
    margin: 0 0 var(--spacing-md) 0;
    text-align: center;
    padding-bottom: var(--spacing-sm);
    border-bottom: 2px solid rgba(139, 69, 19, 0.1);
}

.resumo-financeiro {
    background: rgba(255, 255, 255, 0.7);
    border-radius: var(--border-radius-small);
    padding: var(--spacing-md);
}

.resumo-linha {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-sm);
    padding: var(--spacing-xs) 0;
}

.resumo-total {
    font-weight: 700;
    font-size: 1.1rem;
}

.valor-total {
    color: var(--forest-green);
    font-size: 1.3rem;
}

.frete-gratis {
    color: var(--success-color);
    font-weight: 600;
}

.entrega-info, .pagamento-info {
    background: rgba(255, 255, 255, 0.7);
    border-radius: var(--border-radius-small);
    padding: var(--spacing-md);
}

.entrega-info h6, .pagamento-info h6 {
    color: var(--primary-brown);
    font-size: 0.9rem;
    margin: 0 0 var(--spacing-xs) 0;
    font-weight: 600;
}

.endereco-entrega p, .observacoes-entrega p {
    background: white;
    padding: var(--spacing-sm);
    border-radius: var(--border-radius-small);
    border: 1px solid rgba(139, 69, 19, 0.1);
    margin: var(--spacing-xs) 0 var(--spacing-md) 0;
    line-height: 1.4;
    font-size: 0.9rem;
}

.prazo-entrega p {
    font-weight: 600;
    color: var(--primary-brown);
}

.acoes-pedido .btn {
    margin-bottom: var(--spacing-sm);
}

.contato-lista {
    list-style: none;
    padding: 0;
    margin: var(--spacing-sm) 0;
}

.contato-lista li {
    padding: var(--spacing-xs) 0;
    font-size: 0.9rem;
}

/* Status Badges */
.status-badge {
    padding: var(--spacing-xs) var(--spacing-md);
    border-radius: var(--border-radius-pill);
    font-size: 0.9rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
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

/* Layout */
.row {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
}

.col-lg-8, .col-lg-4, .col-md-8, .col-md-4 {
    padding: 0 15px;
}

@media (min-width: 992px) {
    .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
    .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
}

@media (min-width: 768px) {
    .col-md-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
    .col-md-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
}

/* Responsividade */
@media (max-width: 992px) {
    .status-progress {
        flex-direction: column;
        gap: var(--spacing-md);
    }
    
    .progress-line {
        width: 3px;
        height: 30px;
        margin: 0;
    }
    
    .item-pedido {
        flex-direction: column;
        text-align: center;
    }
}

@media (max-width: 768px) {
    .pedido-header-section .row {
        flex-direction: column;
        gap: var(--spacing-md);
    }
    
    .text-end {
        text-align: center !important;
    }
    
    .item-specs {
        flex-direction: column;
        gap: var(--spacing-xs);
    }
    
    .timeline-item {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
    
    .timeline-item::after {
        left: 50%;
        transform: translateX(-50%);
    }
}

/* Utilitários */
.w-100 { width: 100% !important; }
.mb-2 { margin-bottom: 0.5rem !important; }
.mt-2 { margin-top: 0.5rem !important; }
.text-end { text-align: right !important; }
.text-muted { color: var(--secondary-color) !important; }
.text-success { color: var(--success-color) !important; }
.align-items-center { align-items: center !important; }

/* Print Styles */
@media print {
    .sidebar-card:last-child,
    .acoes-pedido {
        display: none !important;
    }
    
    .pedido-detalhes-container {
        max-width: none;
    }
    
    .section-card, .sidebar-card {
        box-shadow: none;
        border: 1px solid #ddd;
    }
}
</style>

<script>
function imprimirPedido() {
    window.print();
}

function rastrearPedido() {
    alert('Redirecionando para o sistema de rastreamento...\nCódigo: BR123456789BR');
    // Aqui seria implementada a integração com o sistema dos Correios
}

function abrirChat() {
    alert('Funcionalidade de chat em desenvolvimento.\nPor enquanto, entre em contato pelo telefone ou email.');
    // Aqui seria implementado o sistema de chat
}

// Animações de entrada
document.addEventListener('DOMContentLoaded', function() {
    const items = document.querySelectorAll('.item-pedido, .timeline-item, .sidebar-card');
    items.forEach((item, index) => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            item.style.transition = 'all 0.6s ease';
            item.style.opacity = '1';
            item.style.transform = 'translateY(0)';
        }, index * 100);
    });
});
</script>

<%@ include file="/WEB-INF/tags/footer.jsp" %>