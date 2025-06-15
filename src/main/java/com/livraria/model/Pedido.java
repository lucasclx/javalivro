package com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Pedido {
    private int id;
    private int usuarioId;
    private Usuario usuario;
    private BigDecimal valorTotal;
    private StatusPedido statusPedido;
    private String enderecoEntrega;
    private LocalDateTime dataPedido;
    private LocalDateTime dataAtualizacao;
    private List<ItemPedido> itens;

    public enum StatusPedido {
        PENDENTE, CONFIRMADO, ENVIADO, ENTREGUE, CANCELADO
    }

    // Construtores
    public Pedido() {}

    public Pedido(int usuarioId, BigDecimal valorTotal, String enderecoEntrega) {
        this.usuarioId = usuarioId;
        this.valorTotal = valorTotal;
        this.enderecoEntrega = enderecoEntrega;
        this.statusPedido = StatusPedido.PENDENTE;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public BigDecimal getValorTotal() { return valorTotal; }
    public void setValorTotal(BigDecimal valorTotal) { this.valorTotal = valorTotal; }

    public StatusPedido getStatusPedido() { return statusPedido; }
    public void setStatusPedido(StatusPedido statusPedido) { this.statusPedido = statusPedido; }

    public String getEnderecoEntrega() { return enderecoEntrega; }
    public void setEnderecoEntrega(String enderecoEntrega) { this.enderecoEntrega = enderecoEntrega; }

    public LocalDateTime getDataPedido() { return dataPedido; }
    public void setDataPedido(LocalDateTime dataPedido) { this.dataPedido = dataPedido; }

    public LocalDateTime getDataAtualizacao() { return dataAtualizacao; }
    public void setDataAtualizacao(LocalDateTime dataAtualizacao) { this.dataAtualizacao = dataAtualizacao; }

    public List<ItemPedido> getItens() { return itens; }
    public void setItens(List<ItemPedido> itens) { this.itens = itens; }

    // Métodos úteis
    public boolean podeSerCancelado() {
        return statusPedido == StatusPedido.PENDENTE || statusPedido == StatusPedido.CONFIRMADO;
    }

    public String getStatusFormatado() {
        switch (statusPedido) {
            case PENDENTE: return "Pendente";
            case CONFIRMADO: return "Confirmado";
            case ENVIADO: return "Enviado";
            case ENTREGUE: return "Entregue";
            case CANCELADO: return "Cancelado";
            default: return statusPedido.toString();
        }
    }

    @Override
    public String toString() {
        return "Pedido{" +
                "id=" + id +
                ", usuarioId=" + usuarioId +
                ", valorTotal=" + valorTotal +
                ", statusPedido=" + statusPedido +
                ", dataPedido=" + dataPedido +
                '}';
    }
}