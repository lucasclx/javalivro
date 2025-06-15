package com.livraria.util;

import com.livraria.model.Livro;
import java.util.List;

/**
 * Classe utilitária para converter objetos Java em strings JSON manualmente.
 */
public class JsonConverter {

    /**
     * Converte uma lista de objetos Livro para uma string no formato JSON.
     * @param livros A lista de livros a ser convertida.
     * @return Uma string representando um array de objetos JSON.
     */
    public static String toJson(List<Livro> livros) {
        StringBuilder jsonArray = new StringBuilder("[");

        for (int i = 0; i < livros.size(); i++) {
            Livro livro = livros.get(i);
            jsonArray.append("{");
            jsonArray.append("\"id\":").append(livro.getId()).append(",");
            jsonArray.append("\"titulo\":\"").append(escapeJson(livro.getTitulo())).append("\",");
            jsonArray.append("\"autor\":\"").append(escapeJson(livro.getAutor())).append("\",");
            jsonArray.append("\"preco\":").append(livro.getPreco()).append(",");
            jsonArray.append("\"imagemUrl\":\"").append(escapeJson(livro.getImagemUrl())).append("\"");
            jsonArray.append("}");

            if (i < livros.size() - 1) {
                jsonArray.append(",");
            }
        }

        jsonArray.append("]");
        return jsonArray.toString();
    }

    /**
     * Escapa caracteres especiais em uma string para que ela seja um valor JSON válido.
     * @param str A string a ser escapada.
     * @return A string com caracteres especiais escapados.
     */
    private static String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}