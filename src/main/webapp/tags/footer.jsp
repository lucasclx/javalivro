</main>

    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5 class="text-gold">Livraria Mil Páginas</h5>
                    <p>Sua livraria online com os melhores livros e preços.</p>
                    <div class="social-links">
                        <a href="#" class="social-link">📧</a>
                        <a href="#" class="social-link">📘</a>
                        <a href="#" class="social-link">📸</a>
                        <a href="#" class="social-link">🐦</a>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <h5 class="text-gold">Links Úteis</h5>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/livros">Catálogo</a></li>
                        <li><a href="${pageContext.request.contextPath}/livros?action=destaques">Destaques</a></li>
                        <li><a href="${pageContext.request.contextPath}/carrinho">Carrinho</a></li>
                        <li><a href="${pageContext.request.contextPath}/auth?action=loginPage">Minha Conta</a></li>
                    </ul>
                </div>
                
                <div class="col-md-4">
                    <h5 class="text-gold">Contato</h5>
                    <ul class="footer-contact">
                        <li>📍 Rua das Letras, 123 - Centro</li>
                        <li>📞 (11) 1234-5678</li>
                        <li>✉️ contato@livrarmiamilpaginas.com</li>
                        <li>🕒 Seg-Sex: 8h às 18h</li>
                    </ul>
                </div>
            </div>
            
            <hr class="footer-divider">
            
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0">&copy; 2025 Livraria Mil Páginas. Todos os direitos reservados.</p>
                </div>
                <div class="col-md-6 text-end">
                    <p class="mb-0">Desenvolvido para projeto acadêmico</p>
                </div>
            </div>
        </div>
    </footer>

    <style>
        .text-gold { color: var(--gold); }
        .footer-links, .footer-contact {
            list-style: none;
            padding: 0;
        }
        .footer-links li, .footer-contact li {
            margin-bottom: 0.5rem;
        }
        .footer-links a {
            color: var(--cream);
            text-decoration: none;
            transition: var(--transition-normal);
        }
        .footer-links a:hover {
            color: var(--gold);
            padding-left: 5px;
        }
        .social-links {
            margin-top: 1rem;
        }
        .social-link {
            display: inline-block;
            margin-right: 1rem;
            font-size: 1.5rem;
            text-decoration: none;
            transition: var(--transition-normal);
        }
        .social-link:hover {
            transform: scale(1.2);
        }
        .footer-divider {
            border-color: rgba(218, 165, 32, 0.3);
            margin: 2rem 0 1rem 0;
        }
        .col-md-4, .col-md-6 {
            padding: 0 15px;
        }
        .row {
            margin: 0 -15px;
        }
        @media (max-width: 768px) {
            .col-md-4, .col-md-6 {
                margin-bottom: 2rem;
            }
            .text-end {
                text-align: left !important;
            }
        }
    </style>

</body>
</html>