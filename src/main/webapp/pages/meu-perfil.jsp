<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Meu Perfil - ${sessionScope.usuarioLogado.nome}" scope="request" />
<%@ include file="/WEB-INF/tags/header.jsp" %>

<div class="perfil-container">
    <!-- Header do Perfil -->
    <div class="perfil-header">
        <div class="usuario-avatar-grande">
            ${sessionScope.usuarioLogado.nome.substring(0,1).toUpperCase()}
        </div>
        <div class="usuario-info-header">
            <h1>Olá, ${sessionScope.usuarioLogado.nome}!</h1>
            <p class="usuario-email">${sessionScope.usuarioLogado.email}</p>
            <div class="usuario-badges">
                <c:if test="${sessionScope.usuarioLogado.admin}">
                    <span class="badge badge-admin">👑 Administrador</span>
                </c:if>
                <span class="badge badge-membro">📚 Membro desde ${dataRegistro}</span>
            </div>
        </div>
        <div class="perfil-acoes">
            <button class="btn btn-outline-primary" onclick="editarPerfil()">
                ✏️ Editar Perfil
            </button>
            <button class="btn btn-outline-secondary" onclick="configuracoes()">
                ⚙️ Configurações
            </button>
        </div>
    </div>

    <!-- Estatísticas do Usuário -->
    <div class="estatisticas-usuario">
        <div class="stat-card">
            <div class="stat-icon">📖</div>
            <div class="stat-content">
                <h3>${totalLivrosAvaliados}</h3>
                <p>Livros Avaliados</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🛒</div>
            <div class="stat-content">
                <h3>${totalPedidos}</h3>
                <p>Pedidos Realizados</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">💰</div>
            <div class="stat-content">
                <h3><fmt:formatNumber value="${valorTotalGasto}" type="currency"/></h3>
                <p>Total Investido</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">⭐</div>
            <div class="stat-content">
                <h3>${String.format("%.1f", mediaAvaliacoesUsuario)}</h3>
                <p>Nota Média Dada</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">👍</div>
            <div class="stat-content">
                <h3>${totalCurtidasRecebidas}</h3>
                <p>Curtidas Recebidas</p>
            </div>
        </div>
    </div>

    <!-- Navegação de Abas -->
    <div class="perfil-tabs">
        <button class="tab-btn active" onclick="mostrarAba('atividades')" id="tab-atividades">
            📊 Atividades Recentes
        </button>
        <button class="tab-btn" onclick="mostrarAba('avaliacoes')" id="tab-avaliacoes">
            ⭐ Minhas Avaliações
        </button>
        <button class="tab-btn" onclick="mostrarAba('pedidos')" id="tab-pedidos">
            🛒 Meus Pedidos
        </button>
        <button class="tab-btn" onclick="mostrarAba('favoritos')" id="tab-favoritos">
            ❤️ Lista de Desejos
        </button>
        <button class="tab-btn" onclick="mostrarAba('recomendacoes')" id="tab-recomendacoes">
            🎯 Recomendações
        </button>
    </div>

    <!-- Conteúdo das Abas -->
    <div class="tabs-content">
        
        <!-- Aba: Atividades Recentes -->
        <div id="atividades" class="tab-content active">
            <div class="section-header">
                <h3>📊 Atividades Recentes</h3>
                <p>Suas últimas interações na livraria</p>
            </div>

            <div class="atividades-timeline">
                <c:choose>
                    <c:when test="${empty atividadesRecentes}">
                        <div class="empty-state">
                            <div class="empty-icon">📊</div>
                            <h4>Nenhuma atividade recente</h4>
                            <p>Comece explorando nossos livros para ver suas atividades aqui!</p>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                                📚 Explorar Livros
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="atividade" items="${atividadesRecentes}">
                            <div class="atividade-item">
                                <div class="atividade-icon">
                                    <c:choose>
                                        <c:when test="${atividade.tipo == 'PEDIDO'}">🛒</c:when>
                                        <c:when test="${atividade.tipo == 'AVALIACAO'}">⭐</c:when>
                                        <c:when test="${atividade.tipo == 'FAVORITO'}">❤️</c:when>
                                        <c:otherwise>📖</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="atividade-content">
                                    <div class="atividade-titulo">${atividade.descricao}</div>
                                    <div class="atividade-detalhes">${atividade.detalhes}</div>
                                    <div class="atividade-data">${atividade.dataFormatada}</div>
                                </div>
                                <c:if test="${not empty atividade.linkAcao}">
                                    <div class="atividade-acao">
                                        <a href="${atividade.linkAcao}" class="btn btn-sm btn-outline-primary">
                                            Ver
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                        
                        <div class="carregar-mais">
                            <button class="btn btn-outline-secondary" onclick="carregarMaisAtividades()">
                                Carregar mais atividades
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Aba: Minhas Avaliações -->
        <div id="avaliacoes" class="tab-content">
            <div class="section-header">
                <h3>⭐ Minhas Avaliações</h3>
                <p>Livros que você já avaliou</p>
            </div>

            <div class="filtros-avaliacoes">
                <select id="filtroNotaUsuario" onchange="filtrarAvaliacoesUsuario()">
                    <option value="">Todas as notas</option>
                    <option value="5">5 estrelas</option>
                    <option value="4">4 estrelas</option>
                    <option value="3">3 estrelas</option>
                    <option value="2">2 estrelas</option>
                    <option value="1">1 estrela</option>
                </select>
                <select id="ordenarAvaliacoesUsuario" onchange="ordenarAvaliacoesUsuario()">
                    <option value="data-desc">Mais recentes</option>
                    <option value="data-asc">Mais antigas</option>
                    <option value="nota-desc">Maior nota</option>
                    <option value="nota-asc">Menor nota</option>
                    <option value="curtidas-desc">Mais curtidas</option>
                </select>
            </div>

            <div class="avaliacoes-usuario-grid">
                <c:choose>
                    <c:when test="${empty minhasAvaliacoes}">
                        <div class="empty-state">
                            <div class="empty-icon">⭐</div>
                            <h4>Você ainda não avaliou nenhum livro</h4>
                            <p>Compartilhe suas opiniões e ajude outros leitores!</p>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                                📚 Encontrar Livros para Avaliar
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="avaliacao" items="${minhasAvaliacoes}">
                            <div class="avaliacao-card" data-nota="${avaliacao.nota}" data-data="${avaliacao.dataAvaliacao}">
                                <div class="avaliacao-livro">
                                    <img src="${avaliacao.livroImagemUrl}" alt="${avaliacao.livroTitulo}" 
                                         class="livro-capa-pequena">
                                    <div class="livro-info">
                                        <h5>${avaliacao.livroTitulo}</h5>
                                        <p>${avaliacao.livroAutor}</p>
                                    </div>
                                </div>
                                
                                <div class="avaliacao-detalhes">
                                    <div class="nota-estrelas">
                                        <c:forEach var="i" begin="1" end="5">
                                            <span class="estrela ${i <= avaliacao.nota ? 'preenchida' : 'vazia'}">★</span>
                                        </c:forEach>
                                        <span class="nota-texto">${avaliacao.descricaoNota}</span>
                                    </div>
                                    
                                    <c:if test="${avaliacao.temComentario()}">
                                        <div class="comentario-preview">
                                            "${avaliacao.getComentarioPrevia(150)}"
                                        </div>
                                    </c:if>
                                    
                                    <div class="avaliacao-meta">
                                        <span class="data-avaliacao">${avaliacao.dataRelativa}</span>
                                        <span class="curtidas">👍 ${avaliacao.curtidas}</span>
                                        <c:if test="${avaliacao.foiEditada()}">
                                            <span class="editada-badge">Editada</span>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="avaliacao-acoes">
                                    <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${avaliacao.livroId}" 
                                       class="btn btn-sm btn-outline-primary">Ver Livro</a>
                                    <c:if test="${avaliacao.podeSerEditada(sessionScope.usuarioLogado.id)}">
                                        <button class="btn btn-sm btn-outline-secondary" 
                                                onclick="editarAvaliacao(${avaliacao.id})">
                                            Editar
                                        </button>
                                    </c:if>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="excluirAvaliacao(${avaliacao.id})">
                                        Excluir
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Aba: Meus Pedidos -->
        <div id="pedidos" class="tab-content">
            <div class="section-header">
                <h3>🛒 Meus Pedidos</h3>
                <p>Histórico de compras e status dos pedidos</p>
            </div>

            <div class="filtros-pedidos">
                <select id="filtroPedidoStatus" onchange="filtrarPedidos()">
                    <option value="">Todos os status</option>
                    <option value="PENDENTE">Pendentes</option>
                    <option value="CONFIRMADO">Confirmados</option>
                    <option value="ENVIADO">Enviados</option>
                    <option value="ENTREGUE">Entregues</option>
                    <option value="CANCELADO">Cancelados</option>
                </select>
                <input type="date" id="filtroDataInicio" onchange="filtrarPedidos()" placeholder="Data início">
                <input type="date" id="filtroDataFim" onchange="filtrarPedidos()" placeholder="Data fim">
            </div>

            <div class="pedidos-resumo">
                <c:choose>
                    <c:when test="${empty meusPedidos}">
                        <div class="empty-state">
                            <div class="empty-icon">🛒</div>
                            <h4>Você ainda não fez nenhum pedido</h4>
                            <p>Que tal começar adicionando alguns livros ao carrinho?</p>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                                📚 Explorar Livros
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="pedido" items="${meusPedidos}" varStatus="status">
                            <div class="pedido-resumo-card" data-status="${pedido.statusPedido}">
                                <div class="pedido-header">
                                    <div class="pedido-numero">Pedido #${pedido.id}</div>
                                    <div class="pedido-status">
                                        <span class="status-badge status-${pedido.statusPedido.toString().toLowerCase()}">
                                            ${pedido.statusFormatado}
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="pedido-content">
                                    <div class="pedido-info">
                                        <div class="pedido-data">
                                            📅 <fmt:formatDate value="${pedido.dataPedido}" pattern="dd/MM/yyyy"/>
                                        </div>
                                        <div class="pedido-valor">
                                            💰 <fmt:formatNumber value="${pedido.valorTotal}" type="currency"/>
                                        </div>
                                        <div class="pedido-itens">
                                            📦 ${pedido.itens.size()} itens
                                        </div>
                                    </div>
                                    
                                    <div class="pedido-livros-preview">
                                        <c:forEach var="item" items="${pedido.itens}" end="2">
                                            <img src="${item.livro.imagemUrl}" alt="${item.livro.titulo}" 
                                                 class="livro-thumb-mini" title="${item.livro.titulo}">
                                        </c:forEach>
                                        <c:if test="${pedido.itens.size() > 3}">
                                            <div class="mais-livros">+${pedido.itens.size() - 3}</div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="pedido-acoes">
                                    <a href="${pageContext.request.contextPath}/pedidos?action=detalhes&id=${pedido.id}" 
                                       class="btn btn-sm btn-primary">Ver Detalhes</a>
                                    <c:if test="${pedido.statusPedido == 'ENVIADO'}">
                                        <button class="btn btn-sm btn-outline-info" onclick="rastrearPedido(${pedido.id})">
                                            📍 Rastrear
                                        </button>
                                    </c:if>
                                    <c:if test="${pedido.podeSerCancelado()}">
                                        <button class="btn btn-sm btn-outline-danger" 
                                                onclick="cancelarPedido(${pedido.id})">
                                            Cancelar
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="ver-todos-pedidos">
                            <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-outline-primary">
                                Ver Todos os Pedidos
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Aba: Lista de Desejos -->
        <div id="favoritos" class="tab-content">
            <div class="section-header">
                <h3>❤️ Lista de Desejos</h3>
                <p>Livros que você quer ler ou comprar</p>
            </div>

            <div class="favoritos-grid">
                <c:choose>
                    <c:when test="${empty livrosFavoritos}">
                        <div class="empty-state">
                            <div class="empty-icon">❤️</div>
                            <h4>Sua lista de desejos está vazia</h4>
                            <p>Adicione livros que despertam seu interesse!</p>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                                📚 Descobrir Livros
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="livro" items="${livrosFavoritos}">
                            <div class="favorito-card">
                                <div class="favorito-image">
                                    <img src="${livro.imagemUrl}" alt="${livro.titulo}" class="livro-capa">
                                    <button class="btn-remover-favorito" onclick="removerFavorito(${livro.id})" 
                                            title="Remover da lista">❌</button>
                                </div>
                                <div class="favorito-info">
                                    <h5>${livro.titulo}</h5>
                                    <p>${livro.autor}</p>
                                    <div class="favorito-preco">
                                        <fmt:formatNumber value="${livro.preco}" type="currency"/>
                                    </div>
                                    <div class="favorito-acoes">
                                        <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                           class="btn btn-sm btn-outline-primary">Ver Detalhes</a>
                                        <form action="${pageContext.request.contextPath}/carrinho" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="adicionar">
                                            <input type="hidden" name="livroId" value="${livro.id}">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                🛒 Adicionar ao Carrinho
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="compartilhar-lista">
                            <button class="btn btn-outline-secondary" onclick="compartilharLista()">
                                📤 Compartilhar Lista
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Aba: Recomendações -->
        <div id="recomendacoes" class="tab-content">
            <div class="section-header">
                <h3>🎯 Recomendações Personalizadas</h3>
                <p>Livros selecionados especialmente para você</p>
            </div>

            <div class="recomendacoes-sections">
                <!-- Baseado em suas avaliações -->
                <div class="recomendacao-section">
                    <h4>📊 Baseado em suas avaliações</h4>
                    <div class="livros-recomendados">
                        <c:forEach var="livro" items="${recomendacoesPorAvaliacoes}" end="3">
                            <div class="recomendacao-card">
                                <img src="${livro.imagemUrl}" alt="${livro.titulo}" class="livro-capa">
                                <div class="recomendacao-info">
                                    <h6>${livro.titulo}</h6>
                                    <p>${livro.autor}</p>
                                    <div class="compatibilidade">
                                        <span class="match-percentage">95% compatível</span>
                                    </div>
                                    <div class="recomendacao-acoes">
                                        <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                           class="btn btn-sm btn-primary">Ver</a>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="adicionarFavorito(${livro.id})">
                                            ❤️
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Outros leitores também compraram -->
                <div class="recomendacao-section">
                    <h4>👥 Outros leitores também compraram</h4>
                    <div class="livros-recomendados">
                        <c:forEach var="livro" items="${recomendacoesPorCompras}" end="3">
                            <div class="recomendacao-card">
                                <img src="${livro.imagemUrl}" alt="${livro.titulo}" class="livro-capa">
                                <div class="recomendacao-info">
                                    <h6>${livro.titulo}</h6>
                                    <p>${livro.autor}</p>
                                    <div class="social-proof">
                                        <span>🔥 Tendência entre leitores similares</span>
                                    </div>
                                    <div class="recomendacao-acoes">
                                        <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                           class="btn btn-sm btn-primary">Ver</a>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="adicionarFavorito(${livro.id})">
                                            ❤️
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Novidades que podem interessar -->
                <div class="recomendacao-section">
                    <h4>✨ Novidades que podem interessar</h4>
                    <div class="livros-recomendados">
                        <c:forEach var="livro" items="${novidades}" end="3">
                            <div class="recomendacao-card">
                                <img src="${livro.imagemUrl}" alt="${livro.titulo}" class="livro-capa">
                                <div class="recomendacao-info">
                                    <h6>${livro.titulo}</h6>
                                    <p>${livro.autor}</p>
                                    <div class="novidade-badge">
                                        <span>🆕 Lançamento</span>
                                    </div>
                                    <div class="recomendacao-acoes">
                                        <a href="${pageContext.request.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                           class="btn btn-sm btn-primary">Ver</a>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="adicionarFavorito(${livro.id})">
                                            ❤️
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="configurar-recomendacoes">
                <button class="btn btn-outline-primary" onclick="configurarRecomendacoes()">
                    ⚙️ Configurar Preferências
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal para Edição de Perfil -->
<div id="modalEditarPerfil" class="modal-overlay" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h4>✏️ Editar Perfil</h4>
            <button class="modal-close" onclick="fecharModalEditarPerfil()">&times;</button>
        </div>
        <form id="formEditarPerfil" onsubmit="salvarPerfil(event)">
            <div class="modal-body">
                <div class="form-group">
                    <label for="editNome">Nome Completo:</label>
                    <input type="text" id="editNome" name="nome" class="form-control" 
                           value="${sessionScope.usuarioLogado.nome}" required>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">Email:</label>
                    <input type="email" id="editEmail" name="email" class="form-control" 
                           value="${sessionScope.usuarioLogado.email}" required>
                </div>
                
                <div class="form-group">
                    <label for="editSenhaAtual">Senha Atual (para confirmar):</label>
                    <input type="password" id="editSenhaAtual" name="senhaAtual" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="editNovaSenha">Nova Senha (deixe em branco para manter):</label>
                    <input type="password" id="editNovaSenha" name="novaSenha" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="editConfirmarSenha">Confirmar Nova Senha:</label>
                    <input type="password" id="editConfirmarSenha" name="confirmarSenha" class="form-control">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="fecharModalEditarPerfil()">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    💾 Salvar Alterações
                </button>
            </div>
        </form>
    </div>
</div>

<style>
.perfil-container {
    max-width: 1200px;
    margin: 0 auto;
}

/* Header do Perfil */
.perfil-header {
    background: var(--gradient-light);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-xl);
    margin-bottom: var(--spacing-xl);
    display: flex;
    align-items: center;
    gap: var(--spacing-xl);
    box-shadow: var(--shadow-medium);
}

.usuario-avatar-grande {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: var(--gradient-primary);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3rem;
    font-weight: 700;
    box-shadow: var(--shadow-medium);
}

.usuario-info-header {
    flex: 1;
}

.usuario-info-header h1 {
    margin: 0 0 var(--spacing-sm) 0;
    color: var(--dark-brown);
}

.usuario-email {
    color: var(--secondary-color);
    margin: 0 0 var(--spacing-md) 0;
    font-size: 1.1rem;
}

.usuario-badges {
    display: flex;
    gap: var(--spacing-sm);
    flex-wrap: wrap;
}

.badge {
    padding: var(--spacing-xs) var(--spacing-sm);
    border-radius: var(--border-radius-pill);
    font-size: 0.8rem;
    font-weight: 600;
}

.badge-admin {
    background: rgba(220, 53, 69, 0.1);
    color: #c82333;
}

.badge-membro {
    background: rgba(52, 152, 219, 0.1);
    color: #2980b9;
}

.perfil-acoes {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-sm);
}

/* Estatísticas */
.estatisticas-usuario {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: var(--spacing-md);
    margin-bottom: var(--spacing-xl);
}

.stat-card {
    background: white;
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-lg);
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    box-shadow: var(--shadow-medium);
    transition: var(--transition-normal);
}

.stat-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-large);
}

.stat-icon {
    font-size: 2.5rem;
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center