import CartActions from './cart.js';
import Notifications from './notifications.js';

export default class Search {
    constructor(cart, notifications) {
        this.cart = cart;
        this.notifications = notifications;
        this.contextPath = this.getContextPath();
        this.debounceTimer = null;
        this.init();
    }

    getContextPath() {
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }

    init() {
        this.setupBuscaRapida();
        this.setupFiltroCategoria();
        this.carregarDestaques();
    }

    setupBuscaRapida() {
        const searchInput = document.getElementById('busca-rapida');
        const resultadosDiv = document.getElementById('resultados-busca');
        if (!searchInput) return;

        if (!resultadosDiv) {
            const container = document.createElement('div');
            container.id = 'resultados-busca';
            container.className = 'busca-resultados hidden';
            searchInput.parentNode.appendChild(container);
        }

        searchInput.addEventListener('input', (e) => {
            const termo = e.target.value.trim();
            if (this.debounceTimer) clearTimeout(this.debounceTimer);
            this.debounceTimer = setTimeout(() => {
                if (termo.length >= 2) {
                    this.buscarLivros(termo);
                } else {
                    this.ocultarResultados();
                }
            }, 300);
        });

        document.addEventListener('click', (e) => {
            if (!searchInput.contains(e.target) && !resultadosDiv?.contains(e.target)) {
                this.ocultarResultados();
            }
        });
    }

    async buscarLivros(termo) {
        try {
            const response = await fetch(`${this.contextPath}/livros?action=ajax&tipo=busca&q=${encodeURIComponent(termo)}`);
            if (!response.ok) throw new Error('Erro na busca');
            const livros = await response.json();
            this.exibirResultados(livros, termo);
        } catch (error) {
            console.error('Erro na busca:', error);
            this.exibirErro('Erro ao buscar livros');
        }
    }

    exibirResultados(livros, termo) {
        const container = document.getElementById('resultados-busca');
        if (!container) return;
        if (livros.length === 0) {
            container.innerHTML = `
                <div class="busca-vazia">
                    <p>Nenhum livro encontrado para "${termo}"</p>
                </div>`;
        } else {
            const html = livros.map(livro => `
                <div class="resultado-item" data-id="${livro.id}">
                    <img src="${livro.imagemUrl || 'https://via.placeholder.com/60x90.png?text=Sem+Capa'}" alt="${livro.titulo}" class="resultado-img">
                    <div class="resultado-info">
                        <h6 class="resultado-titulo">${livro.titulo}</h6>
                        <p class="resultado-autor">${livro.autor}</p>
                        <p class="resultado-preco">R$ ${this.formatarPreco(livro.preco)}</p>
                    </div>
                    <div class="resultado-acoes">
                        <button class="btn btn-sm btn-primary btn-add-carrinho" data-id="${livro.id}">
                            🛒 Adicionar
                        </button>
                        <a href="${this.contextPath}/livros?action=detalhes&id=${livro.id}" class="btn btn-sm btn-outline-primary">Ver</a>
                    </div>
                </div>`).join('');
            container.innerHTML = html;
        }
        container.classList.remove('hidden');
        this.cart.setupButtons();
    }

    ocultarResultados() {
        const container = document.getElementById('resultados-busca');
        if (container) container.classList.add('hidden');
    }

    exibirErro(mensagem) {
        const container = document.getElementById('resultados-busca');
        if (container) {
            container.innerHTML = `<div class="busca-erro"><p class="text-danger">${mensagem}</p></div>`;
            container.classList.remove('hidden');
        }
    }

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
                    <img src="${livro.imagemUrl || 'https://via.placeholder.com/300x450.png?text=Capa+Indisponível'}" class="card-img-top book-cover" alt="Capa do livro ${livro.titulo}">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-semibold">${livro.titulo}</h5>
                        <p class="card-text text-muted small mb-2">${livro.autor}</p>
                        <div class="mt-auto">
                            <p class="price mb-2">R$ ${this.formatarPreco(livro.preco)}</p>
                            <div class="book-actions">
                                <a href="${this.contextPath}/livros?action=detalhes&id=${livro.id}" class="btn btn-outline-primary btn-sm">Ver Detalhes</a>
                                <button class="btn btn-primary btn-sm btn-add-carrinho-card" data-id="${livro.id}">🛒 Adicionar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>`).join('');
        container.innerHTML = html;
        this.cart.setupButtons();
    }

    formatarPreco(preco) {
        return parseFloat(preco).toFixed(2).replace('.', ',');
    }

    async carregarDestaques() {
        try {
            const response = await fetch(`${this.contextPath}/livros?action=ajax&tipo=destaques`);
            const livros = await response.json();
            this.exibirDestaques(livros);
        } catch (error) {
            console.error('Erro ao carregar destaques:', error);
        }
    }

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
                                <button class="btn btn-primary btn-sm btn-add-carrinho-destaque" data-id="${livro.id}">Adicionar ao Carrinho</button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>`;
        container.innerHTML = html;
        this.cart.setupButtons();
    }
}
