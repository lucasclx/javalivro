package com.livraria.model;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Carrinho {

    // Usamos um Map para acesso rápido aos itens pelo ID do livro
    private Map<Integer, ItemCarrinho> itens = new HashMap<>();

    public void adicionarItem(Livro livro) {
        // Se o livro já existe no carrinho, apenas incrementa a quantidade
        if (itens.containsKey(livro.getId())) {
            itens.get(livro.getId()).incrementarQuantidade();
        } else {
            // Se não, adiciona um novo item
            itens.put(livro.getId(), new ItemCarrinho(livro));
        }
    }

    public void removerItem(int livroId) {
        itens.remove(livroId);
    }

    public Collection<ItemCarrinho> getItens() {
        return itens.values();
    }

    public BigDecimal getValorTotal() {
        BigDecimal total = BigDecimal.ZERO;
        for (ItemCarrinho item : itens.values()) {
            total = total.add(item.getPrecoTotal());
        }
        return total;
    }

    public int getQuantidadeTotalItens() {
        return itens.size();
    }
}