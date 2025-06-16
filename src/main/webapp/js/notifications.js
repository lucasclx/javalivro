export default class Notifications {
    constructor() {
        this.setup();
        this.injectStyles();
    }

    setup() {
        if (!document.getElementById('notificacoes-container')) {
            const container = document.createElement('div');
            container.id = 'notificacoes-container';
            container.className = 'notificacoes-container';
            document.body.appendChild(container);
        }
    }

    show(mensagem, tipo = 'info') {
        const container = document.getElementById('notificacoes-container');
        if (!container) return;

        const notificacao = document.createElement('div');
        notificacao.className = `notificacao notificacao-${tipo}`;
        notificacao.innerHTML = `
            <div class="notificacao-content">
                <span class="notificacao-icon">${this.getIcon(tipo)}</span>
                <span class="notificacao-texto">${mensagem}</span>
                <button class="notificacao-fechar" onclick="this.parentElement.parentElement.remove()">×</button>
            </div>
        `;

        container.appendChild(notificacao);

        setTimeout(() => {
            if (notificacao.parentNode) {
                notificacao.remove();
            }
        }, 5000);

        setTimeout(() => {
            notificacao.classList.add('notificacao-show');
        }, 100);
    }

    getIcon(tipo) {
        const icones = {
            'success': '✅',
            'error': '❌',
            'warning': '⚠️',
            'info': 'ℹ️'
        };
        return icones[tipo] || icones.info;
    }

    injectStyles() {
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
        document.head.insertAdjacentHTML('beforeend', ajaxStyles);
    }
}
