<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Carrinho de Compras" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="carrinho-container">
    <h1 class="page-title">🛒 Meu Carrinho</h1>
    
    <!-- Mensagens de sucesso/erro -->
    <c:if test="${not empty sessionScope.mensagemSucesso}">
        <div class="alert alert-success alert-dismissible">
            <span class="alert-icon">✅</span>
            ${sessionScope.mensagemSucesso}
            <button type="button" class="alert-close" onclick="this.parentElement.style.display='none'">×</button>
        </div>
        <c:remove var="mensagemSucesso" scope="session" />
    </c:if>
    
    <c:if test="${not empty sessionScope.mensagemErro}">
        <div class="alert alert-danger alert-dismissible">
            <span class="alert-icon">❌</span>
            ${sessionScope.mensagemErro}
            <button type="button" class="alert-close" onclick="this.parentElement.style.display='none'">×</button>
        </div>
        <c:remove var="mensagemErro" scope="session" />
    </c:if>

    <c:choose>
        <c:when test="${empty sessionScope.carrinho or empty sessionScope.carrinho.itens}">
            <!-- Carrinho Vazio -->
            <div class="carrinho-vazio">
                <div class="empty-cart-icon">🛒</div>
                <h3>Seu carrinho está vazio</h3>
                <p>Parece que você ainda não adicionou nenhum livro ao seu carrinho.</p>
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary btn-lg">
                    📚 Explorar Livros
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Carrinho com Itens -->
            <div class="row">
                <!-- Lista de Itens -->
                <div class="col-lg-8">
                    <div class="carrinho-itens">
                        <div class="carrinho-header">
                            <h4>Itens no Carrinho (${sessionScope.carrinho.quantidadeTotalLivros})</h4>
                            <form action="${pageContext.request.contextPath}/carrinho" method="POST" style="display: inline;">
                                <input type="hidden" name="action" value="limpar">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <button type="submit" class="btn btn-outline-danger btn-sm" 
                                        onclick="return confirm('Deseja realmente limpar todo o carrinho?')">
                                    🗑️ Limpar Carrinho
                                </button>
                            </form>
                        </div>

                        <c:forEach var="item" items="${sessionScope.carrinho.itens}">
                            <div class="carrinho-item" data-livro-id="${item.livro.id}">
                                <div class="item-imagem">
                                    <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" class="book-thumbnail">
                                </div>
                                
                                <div class="item-detalhes">
                                    <h5 class="item-titulo">
                                        <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${item.livro.id}">
                                            ${item.livro.titulo}
                                        </a>
                                    </h5>
                                    <p class="item-autor">por ${item.livro.autor}</p>
                                    <div class="item-disponibilidade">
                                        <c:choose>
                                            <c:when test="${item.livro.estoque >= item.quantidade}">
                                                <span class="disponivel">✅ Em estoque</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="indisponivel">⚠️ Estoque limitado (${item.livro.estoque} disponíveis)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="item-preco">
                                    <div class="preco-unitario">
                                        <fmt:formatNumber value="${item.livro.preco}" type="currency"/>
                                    </div>
                                    <small class="text-muted">preço unitário</small>
                                </div>
                                
                                <div class="item-quantidade">
                                    <label for="qty-${item.livro.id}" class="sr-only">Quantidade</label>
                                    <div class="quantidade-controls">
                                        <button type="button" class="qty-btn qty-minus" 
                                                onclick="alterarQuantidade(${item.livro.id}, ${item.quantidade - 1})">-</button>
                                        <input type="number" 
                                               id="qty-${item.livro.id}"
                                               class="quantidade-input" 
                                               value="${item.quantidade}" 
                                               min="1" 
                                               max="${item.livro.estoque}"
                                               onchange="alterarQuantidade(${item.livro.id}, this.value)">
                                        <button type="button" class="qty-btn qty-plus" 
                                                onclick="alterarQuantidade(${item.livro.id}, ${item.quantidade + 1})">+</button>
                                    </div>
                                </div>
                                
                                <div class="item-subtotal">
                                    <div class="subtotal-valor">
                                        <fmt:formatNumber value="${item.precoTotal}" type="currency"/>
                                    </div>
                                    <small class="text-muted">subtotal</small>
                                </div>
                                
                                <div class="item-acoes">
                                    <button type="button" class="btn-remover" 
                                            onclick="removerItem(${item.livro.id})"
                                            title="Remover item">
                                        🗑️
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Continuar Comprando -->
                    <div class="continuar-comprando">
                        <a href="${pageContext.request.contextPath}/livros" class="btn btn-outline-primary">
                            ← Continuar Comprando
                        </a>
                    </div>
                </div>

                <!-- Resumo do Pedido -->
                <div class="col-lg-4">
                    <div class="carrinho-resumo">
                        <h4>📋 Resumo do Pedido</h4>
                        
                        <div class="resumo-linha">
                            <span>Subtotal (${sessionScope.carrinho.quantidadeTotalLivros} itens):</span>
                            <span class="valor">
                                <fmt:formatNumber value="${sessionScope.carrinho.valorTotal}" type="currency"/>
                            </span>
                        </div>
                        
                        <div class="resumo-linha">
                            <span>Frete:</span>
                            <span class="valor frete-gratis">GRÁTIS</span>
                        </div>
                        
                        <div class="cupom-desconto">
                            <h6>💰 Cupom de Desconto</h6>
                            <div class="cupom-form">
                                <input type="text" id="cupomDesconto" class="form-control" placeholder="Digite seu cupom">
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="aplicarCupom()">
                                    Aplicar
                                </button>
                            </div>
                            <div id="cupom-resultado" class="cupom-resultado"></div>
                        </div>
                        
                        <hr class="resumo-divider">
                        
                        <div class="resumo-total">
                            <span class="total-label">Total:</span>
                            <span class="total-valor">
                                <fmt:formatNumber value="${sessionScope.carrinho.valorTotal}" type="currency"/>
                            </span>
                        </div>

                        <div class="acoes-checkout">
                            <c:choose>
                                <c:when test="${not empty sessionScope.usuarioLogado}">
                                    <a href="${pageContext.request.contextPath}/pedidos?action=checkout" 
                                       class="btn btn-success btn-lg w-100">
                                        🚀 Finalizar Compra
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="login-necessario">
                                        <p class="text-muted">Para finalizar a compra, você precisa estar logado.</p>
                                        <a href="${pageContext.request.contextPath}/auth?action=loginPage" 
                                           class="btn btn-primary btn-lg w-100">
                                            🔐 Fazer Login
                                        </a>
                                        <div class="text-center mt-2">
                                            <small>
                                                Não tem conta? 
                                                <a href="${pageContext.request.contextPath}/auth?action=cadastroPage">
                                                    Cadastre-se
                                                </a>
                                            </small>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Informações de Segurança -->
                        <div class="seguranca-info">
                            <h6>🔒 Compra Segura</h6>
                            <ul class="seguranca-lista">
                                <li>✓ Pagamento seguro</li>
                                <li>✓ Entrega garantida</li>
                                <li>✓ Dados protegidos</li>
                                <li>✓ Suporte especializado</li>
                            </ul>
                        </div>

                        <!-- Formas de Pagamento -->
                        <div class="formas-pagamento">
                            <h6>💳 Formas de Pagamento</h6>
                            <div class="pagamento-icons">
                                <span class="pagamento-icon">💳</span>
                                <span class="pagamento-icon">💰</span>
                                <span class="pagamento-icon">📱</span>
                                <span class="pagamento-icon">🏦</span>
                            </div>
                            <small class="text-muted">Cartão, Dinheiro, PIX ou Boleto</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
.carrinho-container {
    max-width: 1200px;
    margin: 0 auto;
}

/* Carrinho Vazio */
.carrinho-vazio {
    text-align: center;
    padding: var(--spacing-xxl);
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-medium);
}

.empty-cart-icon {
    font-size: 4rem;
    margin-bottom: var(--spacing-md);
    opacity: 0.6;
}

/* Layout Principal */
.row {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
}

.col-lg-8, .col-lg-4 {
    padding: 0 15px;
}

@media (min-width: 992px) {
    .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
    .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
}

/* Carrinho Itens */
.carrinho-itens {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-medium);
    overflow: hidden;
}

.carrinho-header {
    background: var(--gradient-primary);
    color: white;
    padding: var(--spacing-md) var(--spacing-lg);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.carrinho-header h4 {
    margin: 0;
    color: white;
}

.carrinho-item {
    display: grid;
    grid-template-columns: 80px 1fr auto auto auto auto;
    gap: var(--spacing-md);
    padding: var(--spacing-lg);
    border-bottom: 1px solid rgba(139, 69, 19, 0.1);
    align-items: center;
    transition: var(--transition-normal);
}

.carrinho-item:hover {
    background: rgba(245, 245, 220, 0.5);
}

.carrinho-item:last-child {
    border-bottom: none;
}

.book-thumbnail {
    width: 60px;
    height: 90px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
    box-shadow: var(--shadow-small);
}

.item-detalhes {
    min-width: 200px;
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

.disponivel {
    color: var(--success-color);
    font-size: 0.8rem;
    font-weight: 500;
}

.indisponivel {
    color: var(--warning-color);
    font-size: 0.8rem;
    font-weight: 500;
}

.item-preco, .item-subtotal {
    text-align: center;
    min-width: 100px;
}

.preco-unitario, .subtotal-valor {
    font-weight: 600;
    color: var(--forest-green);
    font-size: 1rem;
}

/* Controles de Quantidade */
.quantidade-controls {
    display: flex;
    align-items: center;
    border: 2px solid rgba(139, 69, 19, 0.2);
    border-radius: var(--border-radius-small);
    overflow: hidden;
    width: 120px;
}

.qty-btn {
    background: var(--light-brown);
    border: none;
    width: 30px;
    height: 35px;
    cursor: pointer;
    font-weight: bold;
    transition: var(--transition-normal);
    color: var(--dark-brown);
}

.qty-btn:hover {
    background: var(--primary-brown);
    color: white;
}

.quantidade-input {
    border: none;
    width: 60px;
    height: 35px;
    text-align: center;
    font-weight: 600;
    background: white;
}

.quantidade-input:focus {
    outline: none;
}

.btn-remover {
    background: none;
    border: none;
    font-size: 1.2rem;
    cursor: pointer;
    padding: var(--spacing-xs);
    border-radius: var(--border-radius-small);
    transition: var(--transition-normal);
}

.btn-remover:hover {
    background: rgba(220, 53, 69, 0.1);
    transform: scale(1.1);
}

/* Resumo do Carrinho */
.carrinho-resumo {
    background: rgba(245, 245, 220, 0.9);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    box-shadow: var(--shadow-medium);
    position: sticky;
    top: 20px;
}

.carrinho-resumo h4 {
    color: var(--dark-brown);
    margin-bottom: var(--spacing-lg);
    text-align: center;
}

.resumo-linha {
    display: flex;
    justify-content: space-between;
    margin-bottom: var(--spacing-md);
    padding: var(--spacing-xs) 0;
}

.valor {
    font-weight: 600;
    color: var(--forest-green);
}

.frete-gratis {
    color: var(--success-color);
    font-weight: 700;
}

.cupom-desconto {
    margin: var(--spacing-lg) 0;
    padding: var(--spacing-md);
    background: rgba(255, 255, 255, 0.7);
    border-radius: var(--border-radius-small);
}

.cupom-form {
    display: flex;
    gap: var(--spacing-xs);
    margin-top: var(--spacing-sm);
}

.cupom-form input {
    flex: 1;
    border: 1px solid rgba(139, 69, 19, 0.3);
    border-radius: var(--border-radius-small);
    padding: var(--spacing-sm);
}

.cupom-resultado {
    margin-top: var(--spacing-sm);
    font-size: 0.9rem;
}

.resumo-divider {
    border: none;
    height: 2px;
    background: var(--gradient-gold);
    margin: var(--spacing-lg) 0;
}

.resumo-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 1.2rem;
    font-weight: 700;
    margin-bottom: var(--spacing-lg);
    padding: var(--spacing-md);
    background: rgba(255, 255, 255, 0.8);
    border-radius: var(--border-radius-small);
}

.total-valor {
    color: var(--forest-green);
    font-size: 1.4rem;
}

.acoes-checkout {
    margin-bottom: var(--spacing-lg);
}

.login-necessario {
    text-align: center;
}

.seguranca-info, .formas-pagamento {
    margin-top: var(--spacing-lg);
    padding: var(--spacing-md);
    background: rgba(255, 255, 255, 0.6);
    border-radius: var(--border-radius-small);
}

.seguranca-lista {
    list-style: none;
    padding: 0;
    margin: var(--spacing-sm) 0 0 0;
}

.seguranca-lista li {
    padding: var(--spacing-xs) 0;
    font-size: 0.9rem;
    color: var(--forest-green);
}

.pagamento-icons {
    display: flex;
    gap: var(--spacing-sm);
    margin: var(--spacing-sm) 0;
    justify-content: center;
}

.pagamento-icon {
    font-size: 1.5rem;
    padding: var(--spacing-xs);
    background: white;
    border-radius: var(--border-radius-small);
    box-shadow: var(--shadow-small);
}

.continuar-comprando {
    margin-top: var(--spacing-lg);
}

/* Alertas */
.alert-dismissible {
    position: relative;
    padding-right: 4rem;
}

.alert-close {
    position: absolute;
    top: 0;
    right: 0;
    padding: 0.75rem 1rem;
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    color: inherit;
}

/* Responsividade */
@media (max-width: 992px) {
    .carrinho-item {
        grid-template-columns: 1fr;
        gap: var(--spacing-sm);
        text-align: center;
    }
    
    .item-detalhes {
        order: 1;
    }
    
    .item-imagem {
        order: 0;
        justify-self: center;
    }
    
    .item-preco, .item-quantidade, .item-subtotal {
        order: 2;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .item-acoes {
        order: 3;
        justify-self: center;
    }
}

@media (max-width: 768px) {
    .carrinho-header {
        flex-direction: column;
        gap: var(--spacing-sm);
        text-align: center;
    }
    
    .quantidade-controls {
        width: 100px;
    }
    
    .cupom-form {
        flex-direction: column;
    }
}

/* Utilitários */
.sr-only {
    position: absolute !important;
    width: 1px !important;
    height: 1px !important;
    padding: 0 !important;
    margin: -1px !important;
    overflow: hidden !important;
    clip: rect(0,0,0,0) !important;
    white-space: nowrap !important;
    border: 0 !important;
}

.w-100 { width: 100% !important; }
.text-center { text-align: center !important; }
.text-muted { color: var(--secondary-color) !important; }
.mt-2 { margin-top: 0.5rem !important; }
</style>

<script>
// Funções JavaScript para carrinho
function alterarQuantidade(livroId, novaQuantidade) {
    novaQuantidade = parseInt(novaQuantidade);
    
    if (novaQuantidade < 1) {
        if (confirm('Deseja remover este item do carrinho?')) {
            removerItem(livroId);
        }
        return;
    }
    
    // Atualiza via AJAX
    const formData = new FormData();
    formData.append('action', 'atualizar');
    formData.append('livroId', livroId);
    formData.append('quantidade', novaQuantidade);
    
    fetch('${pageContext.request.contextPath}/carrinho', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            location.reload(); // Recarrega para atualizar valores
        } else {
            alert('Erro ao atualizar quantidade');
        }
    })
    .catch(error => {
        console.error('Erro:', error);
        alert('Erro ao atualizar quantidade');
    });
}

function removerItem(livroId) {
    if (confirm('Deseja realmente remover este item do carrinho?')) {
        window.location.href = '${pageContext.request.contextPath}/carrinho?action=remover&livroId=' + livroId;
    }
}

function aplicarCupom() {
    const cupom = document.getElementById('cupomDesconto').value.trim();
    const resultado = document.getElementById('cupom-resultado');
    
    if (!cupom) {
        resultado.innerHTML = '<span class="text-danger">Digite um cupom válido</span>';
        return;
    }
    
    // Simula verificação de cupom (implementar no backend)
    const cuponsValidos = ['PRIMEIRA15', 'LIVROS10', 'ESTUDANTE20'];
    
    if (cuponsValidos.includes(cupom.toUpperCase())) {
        resultado.innerHTML = '<span class="text-success">✅ Cupom aplicado com sucesso!</span>';
    } else {
        resultado.innerHTML = '<span class="text-danger">❌ Cupom inválido</span>';
    }
}

// Auto-ajusta altura do textarea de observações
document.addEventListener('DOMContentLoaded', function() {
    // Adiciona animações de entrada
    const items = document.querySelectorAll('.carrinho-item');
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