package com.livraria.model;

import java.math.BigDecimal;

public class ItemPedido {
    private int id;
    private int pedidoId;
    private int livroId;
    private Livro livro;
    private int quantidade;
    private BigDecimal precoUnitario;
    private BigDecimal subtotal;

    // Construtores
    public ItemPedido() {}

    public ItemPedido(int pedidoId, int livroId, int quantidade, BigDecimal precoUnitario) {
        this.pedidoId = pedidoId;
        this.livroId = livroId;
        this.quantidade = quantidade;
        this.precoUnitario = precoUnitario;
        this.subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }

    public ItemPedido(ItemCarrinho itemCarrinho) {
        this.livroId = itemCarrinho.getLivroId();
        this.livro = itemCarrinho.getLivro();
        this.quantidade = itemCarrinho.getQuantidade();
        this.precoUnitario = itemCarrinho.getLivro().getPreco();
        this.subtotal = itemCarrinho.getSubtotal();
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPedidoId() { return pedidoId; }
    public void setPedidoId(int pedidoId) { this.pedidoId = pedidoId; }

    public int getLivroId() { return livroId; }
    public void setLivroId(int livroId) { this.livroId = livroId; }

    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }

    public BigDecimal getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(BigDecimal precoUnitario) { this.precoUnitario = precoUnitario; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    @Override
    public String toString() {
        return "ItemPedido{" +
                "id=" + id +
                ", pedidoId=" + pedidoId +
                ", livroId=" + livroId +
                ", quantidade=" + quantidade +
                ", precoUnitario=" + precoUnitario +
                ", subtotal=" + subtotal +
                '}';
    }
}