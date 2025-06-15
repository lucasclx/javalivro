package com.livraria.model;

import java.math.BigDecimal;

public class ItemCarrinho {

    private Livro livro;
    private int quantidade;

    public ItemCarrinho(Livro livro) {
        this.livro = livro;
        this.quantidade = 1; // Começa com 1 unidade ao ser adicionado
    }

    public Livro getLivro() {
        return livro;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void incrementarQuantidade() {
        this.quantidade++;
    }

    // Futuramente, podemos adicionar métodos para decrementar ou definir a quantidade

    public BigDecimal getPrecoTotal() {
        return livro.getPreco().multiply(new BigDecimal(this.quantidade));
    }
}