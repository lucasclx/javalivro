package com.livraria.model;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Carrinho {

    // Usamos um Map para acesso rápido aos itens pelo ID do livro
    private Map<Integer, ItemCarrinho> itens = new HashMap<>();

    /**
     * Adiciona um livro ao carrinho.
     * Se já existe, incrementa a quantidade.
     */
    public void adicionarItem(Livro livro) {
        if (livro == null) {
            throw new IllegalArgumentException("Livro não pode ser null");
        }
        
        // Se o livro já existe no carrinho, apenas incrementa a quantidade
        if (itens.containsKey(livro.getId())) {
            itens.get(livro.getId()).incrementarQuantidade();
        } else {
            // Se não, adiciona um novo item
            itens.put(livro.getId(), new ItemCarrinho(livro));
        }
    }

    /**
     * Remove um item completamente do carrinho
     */
    public void removerItem(int livroId) {
        itens.remove(livroId);
    }

    /**
     * Atualiza a quantidade de um item específico
     */
    public void atualizarQuantidade(int livroId, int novaQuantidade) {
        if (novaQuantidade <= 0) {
            removerItem(livroId);
        } else if (itens.containsKey(livroId)) {
            itens.get(livroId).setQuantidade(novaQuantidade);
        }
    }

    /**
     * Obtém um item específico do carrinho
     */
    public ItemCarrinho obterItem(int livroId) {
        return itens.get(livroId);
    }

    /**
     * Verifica se um livro está no carrinho
     */
    public boolean contemItem(int livroId) {
        return itens.containsKey(livroId);
    }

    /**
     * Retorna todos os itens do carrinho
     */
    public Collection<ItemCarrinho> getItens() {
        return itens.values();
    }

    /**
     * Calcula o valor total do carrinho
     */
    public BigDecimal getValorTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (ItemCarrinho item : itens.values()) {
            total = total.add(item.getPrecoTotal());
        }
        return total;
    }

    /**
     * Retorna a quantidade total de tipos de itens diferentes no carrinho
     */
    public int getQuantidadeTotalItens() {
        return itens.size();
    }

    /**
     * Retorna a quantidade total de livros (somando as quantidades de todos os itens)
     */
    public int getQuantidadeTotalLivros() {
        int total = 0;
        for (ItemCarrinho item : itens.values()) {
            total += item.getQuantidade();
        }
        return total;
    }

    /**
     * Verifica se o carrinho está vazio
     */
    public boolean isEmpty() {
        return itens.isEmpty();
    }

    /**
     * Limpa todos os itens do carrinho
     */
    public void limpar() {
        itens.clear();
    }

    /**
     * Retorna uma representação textual do carrinho
     */
    @Override
    public String toString() {
        return "Carrinho{" +
                "totalItens=" + getQuantidadeTotalItens() +
                ", totalLivros=" + getQuantidadeTotalLivros() +
                ", valorTotal=" + getValorTotal() +
                '}';
    }
}