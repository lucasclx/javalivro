package com.livraria.util;

import com.google.gson.Gson;
import com.livraria.model.Livro;
import java.util.List;

/**
 * Classe utilitária para converter objetos Java em strings JSON usando Gson.
 */
public class JsonConverter {

    /** Instância única de Gson para reutilização. */
    private static final Gson gson = new Gson();

    /**
     * Converte uma lista de objetos Livro para JSON.
     *
     * @param livros A lista de livros a ser convertida.
     * @return JSON representando a lista de livros.
     */
    public static String toJson(List<Livro> livros) {
        return gson.toJson(livros);
    }
}