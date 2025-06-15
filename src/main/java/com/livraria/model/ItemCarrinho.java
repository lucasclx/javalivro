package com.livraria.model;

import java.math.BigDecimal;

public class ItemCarrinho {

    private Livro livro;
    private int quantidade;

    public ItemCarrinho(Livro livro) {
        if (livro == null) {
            throw new IllegalArgumentException("Livro não pode ser null");
        }
        this.livro = livro;
        this.quantidade = 1; // Começa com 1 unidade ao ser adicionado
    }

    public ItemCarrinho(Livro livro, int quantidade) {
        if (livro == null) {
            throw new IllegalArgumentException("Livro não pode ser null");
        }
        if (quantidade <= 0) {
            throw new IllegalArgumentException("Quantidade deve ser maior que zero");
        }
        this.livro = livro;
        this.quantidade = quantidade;
    }

    // Getters
    public Livro getLivro() {
        return livro;
    }

    public int getLivroId() {
        return livro != null ? livro.getId() : 0;
    }

    public int getQuantidade() {
        return quantidade;
    }

    // Setters
    public void setLivro(Livro livro) {
        if (livro == null) {
            throw new IllegalArgumentException("Livro não pode ser null");
        }
        this.livro = livro;
    }

    public void setQuantidade(int quantidade) {
        if (quantidade <= 0) {
            throw new IllegalArgumentException("Quantidade deve ser maior que zero");
        }
        this.quantidade = quantidade;
    }

    // Métodos de manipulação de quantidade
    public void incrementarQuantidade() {
        this.quantidade++;
    }

    public void incrementarQuantidade(int incremento) {
        if (incremento <= 0) {
            throw new IllegalArgumentException("Incremento deve ser maior que zero");
        }
        this.quantidade += incremento;
    }

    public void decrementarQuantidade() {
        if (this.quantidade > 1) {
            this.quantidade--;
        }
    }

    public void decrementarQuantidade(int decremento) {
        if (decremento <= 0) {
            throw new IllegalArgumentException("Decremento deve ser maior que zero");
        }
        this.quantidade = Math.max(1, this.quantidade - decremento);
    }

    // Métodos de cálculo
    public BigDecimal getPrecoTotal() {
        return livro.getPreco().multiply(new BigDecimal(this.quantidade));
    }

    public BigDecimal getSubtotal() {
        return getPrecoTotal(); // Alias para compatibilidade
    }

    // Métodos de validação
    public boolean isQuantidadeValida() {
        return quantidade > 0;
    }

    public boolean isEstoqueSuficiente() {
        return livro != null && livro.getEstoque() >= quantidade;
    }

    // Métodos utilitários
    @Override
    public String toString() {
        return "ItemCarrinho{" +
                "livro=" + (livro != null ? livro.getTitulo() : "null") +
                ", quantidade=" + quantidade +
                ", precoTotal=" + getPrecoTotal() +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ItemCarrinho that = (ItemCarrinho) obj;
        return livro != null && livro.getId() == that.livro.getId();
    }

    @Override
    public int hashCode() {
        return livro != null ? livro.getId() : 0;
    }