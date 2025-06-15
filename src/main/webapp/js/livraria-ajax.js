/**
 * Sistema de Busca AJAX para Livraria Mil Páginas
 * Funcionalidades: busca em tempo real, filtros por categoria, adição ao carrinho
 */

class LivrariaAjax {
    constructor() {
        this.contextPath = this.getContextPath();
        this.debounceTimer = null;
        this.init();
    }

    getContextPath() {
        // Obtém o context path da aplicação
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }

    init() {
        this.setupBuscaRapida();
        this.setupFiltroCategoria();
        this.setupAdicionarCarrinho();
        this.setupNotificacoes();
    }

    /**
     * Configura busca rápida em tempo real
     */
    setupBuscaRapida() {
        const searchInput = document.getElementById('busca-rapida');
        const resultadosDiv = document.getElementById('resultados-busca');
        
        if (!searchInput) return;

        // Cria o container de resultados se não existir
        if (!resultadosDiv) {
            const container = document.createElement('div');
            container.id = 'resultados-busca';
            container.className = 'busca-resultados hidden';
            searchInput.parentNode.appendChild(container);
        }

        searchInput.addEventListener('input', (e) => {
            const termo = e.target.value.trim();
            
            // Cancela busca anterior
            if (this.debounceTimer) {
                clearTimeout(this.debounceTimer);
            }

            // Agenda nova busca após 300ms
            this.debounceTimer = setTimeout(() => {
                if (termo.length >= 2) {
                    this.buscarLivros(termo);
                } else {
                    this.ocultarResultados();
                }
            }, 300);
        });

        // Oculta resultados quando clica fora
        document.addEventListener('click', (e) => {
            if (!searchInput.contains(e.target) && !resultadosDiv?.contains(e.target)) {
                this.ocultarResultados();
            }
        });
    }

    /**
     * Realiza busca via AJAX
     */
    async buscarLivros(termo) {
        try {
            const response = await fetch(`${this.contextPath}/livros?action=ajax&tipo=busca&q=${encodeURIComponent(termo)}`);
            
            if (!response.ok) {
                throw new Error('Erro na busca');
            }

            const livros = await response.json();
            this.exibirResultados(livros, termo);
        } catch (error) {
            console.error('Erro na busca:', error);
            this.exibirErro('Erro ao buscar livros');
        }
    }

    /**
     * Exibe resultados da busca
     */
    exibirResultados(livros, termo) {
        const container = document.getElementById('resultados-busca');
        if (!container) return;

        if (livros.length === 0) {
            container.innerHTML = `
                <div class="busca-vazia">
                    <p>Nenhum livro encontrado para "${termo}"</p>
                </div>
            `;
        } else {
            const html = livros.map(livro => `
                <div class="resultado-item" data-id="${livro.id}">
                    <img src="${livro.imagemUrl || 'https://via.placeholder.com/60x90.png?text=Sem+Capa'}" 
                         alt="${livro.titulo}" class="resultado-img">
                    <div class="resultado-info">
                        <h6 class="resultado-titulo">${livro.titulo}</h6>
                        <p class="resultado-autor">${livro.autor}</p>
                        <p class="resultado-preco">R$ ${this.formatarPreco(livro.preco)}</p>
                    </div>
                    <div class="resultado-acoes">
                        <button class="btn btn-sm btn-primary btn-add-carrinho" data-id="${livro.id}">
                            🛒 Adicionar
                        </button>
                        <a href="${this.contextPath}/livros?action=detalhes&id=${livro.id}" 
                           class="btn btn-sm btn-outline-primary">Ver</a>
                    </div>
                </div>
            `).join('');

            container.innerHTML = html;
        }

        container.classList.remove('hidden');
        this.setupBotoesCarrinho();
    }

    /**
     * Oculta resultados da busca
     */
    ocultarResultados() {
        const container = document.getElementById('resultados-busca');
        if (container) {
            container.classList.add('hidden');
        }
    }

    /**
     * Exibe mensagem de erro
     */
    exibirErro(mensagem) {
        const container = document.getElementById('resultados-busca');
        if (container) {
            container.innerHTML = `
                <div class="busca-erro">
                    <p class="text-danger">${mensagem}</p>
                </div>
            `;
            container.classList.remove('hidden');
        }
    }

    /**
     * Configura filtro por categoria
     */
    setupFiltroCategoria() {
        const filtroSelect = document.getElementById('filtro-categoria');
        if (!filtroSelect) return;

        filtroSelect.addEventListener('change', async (e) => {
            const categoriaId = e.target.value;
            
            if (categoriaId) {
                try {
                    const response = await fetch(`${this.contextPath}/livros?action=ajax&tipo=categoria&categoria=${categoriaId}`);
                    const livros = await response.json();
                    this.atualizarListaLivros(livros);
                } catch (error) {
                    console.error('Erro ao filtrar por categoria:', error);
                }
            }
        });
    }

    /**
     * Atualiza a lista de livros na página
     */
    atualizarListaLivros(livros) {
        const container = document.getElementById('lista-livros');
        if (!container) return;

        if (livros.length === 0) {
            container.innerHTML = '<div class="alert alert-info">Nenhum livro encontrado nesta categoria.</div>';
            return;
        }

        const html = livros.map(livro => `
            <div class="col">
                <div class="card book-card h-100">
                    <img src="${livro.imagemUrl || 'https://via.placeholder.com/300x450.png?text=Capa+Indisponível'}" 
                         class="card-img-top book-cover" alt="Capa do livro ${livro.titulo}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-semibold">${livro.titulo}</h5>
                        <p class="card-text text-muted small mb-2">${livro.autor}</p>
                        <div class="mt-auto">
                            <p class="price mb-2">R$ ${this.formatarPreco(livro.preco)}</p>
                            <div class="book-actions">
                                <a href="${this.contextPath}/livros?action=detalhes&id=${livro.id}" 
                                   class="btn btn-outline-primary btn-sm">Ver Detalhes</a>
                                <button class="btn btn-primary btn-sm btn-add-carrinho-card" data-id="${livro.id}">
                                    🛒 Adicionar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

        container.innerHTML = html;
        this.setupBotoesCarrinho();
    }

    /**
     * Configura botões de adicionar ao carrinho
     */
    setupAdicionarCarrinho() {
        this.setupBotoesCarrinho();
    }

    setupBotoesCarrinho() {
        // Botões na busca rápida
        document.querySelectorAll('.btn-add-carrinho').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const livroId = btn.dataset.id;
                this.adicionarAoCarrinho(livroId, btn);
            });
        });

        // Botões nos cards de livros
        document.querySelectorAll('.btn-add-carrinho-card').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const livroId = btn.dataset.id;
                this.adicionarAoCarrinho(livroId, btn);
            });
        });
    }

    /**
     * Adiciona livro ao carrinho via AJAX
     */
    async adicionarAoCarrinho(livroId, botao) {
        const botaoOriginal = botao.innerHTML;
        botao.disabled = true;
        botao.innerHTML = '⏳ Adicionando...';

        try {
            const formData = new FormData();
            formData.append('action', 'adicionar');
            formData.append('livroId', livroId);

            const response = await fetch(`${this.contextPath}/carrinho`, {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                this.mostrarNotificacao('Livro adicionado ao carrinho!', 'success');
                this.atualizarContadorCarrinho();
                botao.innerHTML = '✅ Adicionado';
                
                setTimeout(() => {
                    botao.innerHTML = botaoOriginal;
                    botao.disabled = false;
                }, 2000);
            } else {
                throw new Error('Erro ao adicionar ao carrinho');
            }
        } catch (error) {
            console.error('Erro:', error);
            this.mostrarNotificacao('Erro ao adicionar ao carrinho', 'error');
            botao.innerHTML = botaoOriginal;
            botao.disabled = false;
        }
    }

    /**
     * Atualiza contador do carrinho no header
     */
    async atualizarContadorCarrinho() {
        // Esta função seria implementada se houvesse um contador visual no header
        // Por enquanto, podemos deixar vazia ou implementar uma versão simples
        console.log('Carrinho atualizado');
    }

    /**
     * Sistema de notificações
     */
    setupNotificacoes() {
        // Cria container de notificações se não existir
        if (!document.getElementById('notificacoes-container')) {
            const container = document.createElement('div');
            container.id = 'notificacoes-container';
            container.className = 'notificacoes-container';
            document.body.appendChild(container);
        }
    }

    /**
     * Mostra notificação na tela
     */
    mostrarNotificacao(mensagem, tipo = 'info') {
        const container = document.getElementById('notificacoes-container');
        if (!container) return;

        const notificacao = document.createElement('div');
        notificacao.className = `notificacao notificacao-${tipo}`;
        notificacao.innerHTML = `
            <div class="notificacao-content">
                <span class="notificacao-icon">${this.getIconeNotificacao(tipo)}</span>
                <span class="notificacao-texto">${mensagem}</span>
                <button class="notificacao-fechar" onclick="this.parentElement.parentElement.remove()">×</button>
            </div>
        `;

        container.appendChild(notificacao);

        // Remove automaticamente após 5 segundos
        setTimeout(() => {
            if (notificacao.parentNode) {
                notificacao.remove();
            }
        }, 5000);

        // Animação de entrada
        setTimeout(() => {
            notificacao.classList.add('notificacao-show');
        }, 100);
    }

    /**
     * Retorna ícone para o tipo de notificação
     */
    getIconeNotificacao(tipo) {
        const icones = {
            'success': '✅',
            'error': '❌',
            'warning': '⚠️',
            'info': 'ℹ️'
        };
        return icones[tipo] || icones.info;
    }

    /**
     * Formata preço para exibição
     */
    formatarPreco(preco) {
        return parseFloat(preco).toFixed(2).replace('.', ',');
    }

    /**
     * Carrega destaques via AJAX
     */
    async carregarDestaques() {
        try {
            const response = await fetch(`${this.contextPath}/livros?action=ajax&tipo=destaques`);
            const livros = await response.json();
            this.exibirDestaques(livros);
        } catch (error) {
            console.error('Erro ao carregar destaques:', error);
        }
    }

    /**
     * Exibe seção de destaques
     */
    exibirDestaques(livros) {
        const container = document.getElementById('destaques-container');
        if (!container || livros.length === 0) return;

        const html = `
            <div class="destaques-section">
                <h3>📚 Livros em Destaque</h3>
                <div class="destaques-grid">
                    ${livros.map(livro => `
                        <div class="destaque-item">
                            <img src="${livro.imagemUrl}" alt="${livro.titulo}" class="destaque-img">
                            <div class="destaque-info">
                                <h6>${livro.titulo}</h6>
                                <p class="destaque-autor">${livro.autor}</p>
                                <p class="destaque-preco">R$ ${this.formatarPreco(livro.preco)}</p>
                                <button class="btn btn-primary btn-sm btn-add-carrinho-destaque" data-id="${livro.id}">
                                    Adicionar ao Carrinho
                                </button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;

        container.innerHTML = html;
        this.setupBotoesCarrinho();
    }
}

// CSS para os componentes AJAX
const ajaxStyles = `
<style>
/* Resultados de Busca */
.busca-resultados {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border: 1px solid rgba(139, 69, 19, 0.2);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-large);
    max-height: 400px;
    overflow-y: auto;
    z-index: 1000;
}

.busca-resultados.hidden {
    display: none;
}

.resultado-item {
    display: flex;
    align-items: center;
    padding: var(--spacing-md);
    border-bottom: 1px solid rgba(139, 69, 19, 0.1);
    transition: var(--transition-normal);
}

.resultado-item:hover {
    background: rgba(245, 245, 220, 0.5);
}

.resultado-item:last-child {
    border-bottom: none;
}

.resultado-img {
    width: 50px;
    height: 75px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
    margin-right: var(--spacing-md);
}

.resultado-info {
    flex: 1;
    margin-right: var(--spacing-md);
}

.resultado-titulo {
    margin: 0 0 var(--spacing-xs) 0;
    font-size: 0.9rem;
    font-weight: 600;
    color: var(--dark-brown);
}

.resultado-autor {
    margin: 0 0 var(--spacing-xs) 0;
    font-size: 0.8rem;
    color: var(--secondary-color);
}

.resultado-preco {
    margin: 0;
    font-size: 0.9rem;
    font-weight: 600;
    color: var(--forest-green);
}

.resultado-acoes {
    display: flex;
    flex-direction: column;
    gap: var(--spacing-xs);
}

.busca-vazia, .busca-erro {
    padding: var(--spacing-lg);
    text-align: center;
    color: var(--secondary-color);
}

/* Notificações */
.notificacoes-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    max-width: 400px;
}

.notificacao {
    margin-bottom: var(--spacing-sm);
    border-radius: var(--border-radius-medium);
    box-shadow: var(--shadow-large);
    transform: translateX(100%);
    transition: transform var(--transition-normal);
}

.notificacao-show {
    transform: translateX(0);
}

.notificacao-content {
    display: flex;
    align-items: center;
    padding: var(--spacing-md);
    background: white;
    border-radius: var(--border-radius-medium);
}

.notificacao-success .notificacao-content {
    border-left: 4px solid var(--success-color);
}

.notificacao-error .notificacao-content {
    border-left: 4px solid var(--danger-color);
}

.notificacao-warning .notificacao-content {
    border-left: 4px solid var(--warning-color);
}

.notificacao-info .notificacao-content {
    border-left: 4px solid var(--info-color);
}

.notificacao-icon {
    margin-right: var(--spacing-sm);
    font-size: 1.2rem;
}

.notificacao-texto {
    flex: 1;
    font-weight: 500;
}

.notificacao-fechar {
    background: none;
    border: none;
    font-size: 1.5rem;
    color: var(--secondary-color);
    cursor: pointer;
    padding: 0;
    margin-left: var(--spacing-sm);
}

.notificacao-fechar:hover {
    color: var(--danger-color);
}

/* Actions nos cards de livros */
.book-actions {
    display: flex;
    gap: var(--spacing-xs);
    flex-wrap: wrap;
}

.book-actions .btn {
    flex: 1;
    min-width: 0;
}

/* Destaques */
.destaques-section {
    margin: var(--spacing-xl) 0;
}

.destaques-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: var(--spacing-md);
    margin-top: var(--spacing-md);
}

.destaque-item {
    background: rgba(253, 246, 227, 0.8);
    border-radius: var(--border-radius-medium);
    padding: var(--spacing-md);
    text-align: center;
    transition: var(--transition-normal);
}

.destaque-item:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-large);
}

.destaque-img {
    width: 100%;
    max-width: 120px;
    height: 180px;
    object-fit: cover;
    border-radius: var(--border-radius-small);
    margin-bottom: var(--spacing-sm);
}

.destaque-info h6 {
    font-size: 0.9rem;
    margin-bottom: var(--spacing-xs);
}

.destaque-autor {
    font-size: 0.8rem;
    color: var(--secondary-color);
    margin-bottom: var(--spacing-xs);
}

.destaque-preco {
    font-weight: 600;
    color: var(--forest-green);
    margin-bottom: var(--spacing-sm);
}

/* Responsividade */
@media (max-width: 768px) {
    .notificacoes-container {
        left: 10px;
        right: 10px;
        max-width: none;
    }
    
    .resultado-item {
        flex-direction: column;
        text-align: center;
        gap: var(--spacing-sm);
    }
    
    .resultado-acoes {
        flex-direction: row;
        justify-content: center;
    }
}
</style>
`;

// Adiciona os estilos ao documento
document.head.insertAdjacentHTML('beforeend', ajaxStyles);

// Inicializa o sistema quando o DOM estiver carregado
document.addEventListener('DOMContentLoaded', () => {
    new LivrariaAjax();
});

// Exporta a classe para uso global se necessário
window.LivrariaAjax = LivrariaAjax;