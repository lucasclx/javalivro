export default class CartActions {
    constructor(notifications) {
        this.notifications = notifications;
        this.contextPath = this.getContextPath();
        this.setupButtons();
    }

    getContextPath() {
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }

    setupButtons() {
        document.querySelectorAll('.btn-add-carrinho, .btn-add-carrinho-card, .btn-add-carrinho-destaque')
            .forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    const livroId = btn.dataset.id;
                    this.addToCart(livroId, btn);
                });
            });
    }

    async addToCart(livroId, botao) {
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
                this.notifications.show('Livro adicionado ao carrinho!', 'success');
                this.updateCartCounter();
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
            this.notifications.show('Erro ao adicionar ao carrinho', 'error');
            botao.innerHTML = botaoOriginal;
            botao.disabled = false;
        }
    }

    async updateCartCounter() {
        console.log('Carrinho atualizado');
    }
}
