package com.livraria.dao;

import com.livraria.model.Livro;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LivroDAO {

    public List<Livro> listarTodos() throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros WHERE ativo = true";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                livros.add(mapResultSetToLivro(rs));
            }
        }
        return livros;
    }

    public Livro buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLivro(rs);
                }
            }
        }
        return null;
    }
    
    public List<Livro> listarPorCategoria(int categoriaId) throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros WHERE categoria_id = ? AND ativo = true";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoriaId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    livros.add(mapResultSetToLivro(rs));
                }
            }
        }
        return livros;
    }

    public List<Livro> listarDestaques() throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros WHERE destaque = true AND ativo = true LIMIT 5";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                livros.add(mapResultSetToLivro(rs));
            }
        }
        return livros;
    }
    
    public List<Livro> buscarPorTermo(String termo) throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros WHERE (titulo LIKE ? OR autor LIKE ?) AND ativo = true";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + termo + "%");
            stmt.setString(2, "%" + termo + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    livros.add(mapResultSetToLivro(rs));
                }
            }
        }
        return livros;
    }

    public boolean inserir(Livro livro) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, editora, isbn, ano_publicacao, numero_paginas, descricao, preco, estoque, categoria_id, imagem_url, destaque, ativo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            setStatementParameters(stmt, livro);
            stmt.setBoolean(13, true); // Ativo por padrão
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean atualizar(Livro livro) throws SQLException {
        String sql = "UPDATE livros SET titulo = ?, autor = ?, editora = ?, isbn = ?, ano_publicacao = ?, numero_paginas = ?, descricao = ?, preco = ?, estoque = ?, categoria_id = ?, imagem_url = ?, destaque = ?, ativo = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            setStatementParameters(stmt, livro);
            stmt.setBoolean(13, livro.isAtivo());
            stmt.setInt(14, livro.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deletar(int id) throws SQLException {
        // Soft delete: apenas marca como inativo
        String sql = "UPDATE livros SET ativo = false WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // MÉTODO ADICIONADO
    public List<Livro> listarTodosAdmin() throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros ORDER BY id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                livros.add(mapResultSetToLivro(rs));
            }
        }
        return livros;
    }

    private Livro mapResultSetToLivro(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        livro.setId(rs.getInt("id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setEditora(rs.getString("editora"));
        livro.setIsbn(rs.getString("isbn"));
        livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
        livro.setNumeroPaginas(rs.getInt("numero_paginas"));
        livro.setDescricao(rs.getString("descricao"));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setEstoque(rs.getInt("estoque"));
        livro.setCategoriaId(rs.getInt("categoria_id"));
        livro.setImagemUrl(rs.getString("imagem_url"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setAtivo(rs.getBoolean("ativo"));
        return livro;
    }

    private void setStatementParameters(PreparedStatement stmt, Livro livro) throws SQLException {
        stmt.setString(1, livro.getTitulo());
        stmt.setString(2, livro.getAutor());
        stmt.setString(3, livro.getEditora());
        stmt.setString(4, livro.getIsbn());
        stmt.setInt(5, livro.getAnoPublicacao());
        stmt.setInt(6, livro.getNumeroPaginas());
        stmt.setString(7, livro.getDescricao());
        stmt.setBigDecimal(8, livro.getPreco());
        stmt.setInt(9, livro.getEstoque());
        stmt.setInt(10, livro.getCategoriaId());
        stmt.setString(11, livro.getImagemUrl());
        stmt.setBoolean(12, livro.isDestaque());
    }
}