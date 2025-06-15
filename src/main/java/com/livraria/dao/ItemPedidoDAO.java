package com.livraria.dao;

import com.livraria.model.ItemPedido;
import com.livraria.model.Livro;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ItemPedidoDAO {

    /**
     * Insere um item de pedido no banco de dados
     */
    public boolean inserir(ItemPedido item) throws SQLException {
        String sql = "INSERT INTO itens_pedido (pedido_id, livro_id, quantidade, preco_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, item.getPedidoId());
            stmt.setInt(2, item.getLivroId());
            stmt.setInt(3, item.getQuantidade());
            stmt.setBigDecimal(4, item.getPrecoUnitario());
            stmt.setBigDecimal(5, item.getSubtotal());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Insere múltiplos itens de uma vez (mais eficiente para pedidos)
     */
    public boolean inserirLote(List<ItemPedido> itens) throws SQLException {
        String sql = "INSERT INTO itens_pedido (pedido_id, livro_id, quantidade, preco_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false); // Inicia transação
            
            for (ItemPedido item : itens) {
                stmt.setInt(1, item.getPedidoId());
                stmt.setInt(2, item.getLivroId());
                stmt.setInt(3, item.getQuantidade());
                stmt.setBigDecimal(4, item.getPrecoUnitario());
                stmt.setBigDecimal(5, item.getSubtotal());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            conn.commit();
            
            // Verifica se todos os itens foram inseridos
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
            
        } catch (SQLException e) {
            // Em caso de erro, faz rollback
            try (Connection conn = DatabaseConnection.getConnection()) {
                conn.rollback();
            }
            throw e;
        }
    }

    /**
     * Busca todos os itens de um pedido específico
     */
    public List<ItemPedido> buscarPorPedidoId(int pedidoId) throws SQLException {
        String sql = "SELECT ip.*, l.titulo, l.autor, l.preco as preco_atual, l.imagem_url " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN livros l ON ip.livro_id = l.id " +
                    "WHERE ip.pedido_id = ? " +
                    "ORDER BY ip.id";
        
        List<ItemPedido> itens = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pedidoId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ItemPedido item = mapResultSetToItemPedido(rs);
                    itens.add(item);
                }
            }
        }
        return itens;
    }

    /**
     * Busca um item específico por ID
     */
    public ItemPedido buscarPorId(int id) throws SQLException {
        String sql = "SELECT ip.*, l.titulo, l.autor, l.preco as preco_atual, l.imagem_url " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN livros l ON ip.livro_id = l.id " +
                    "WHERE ip.id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToItemPedido(rs);
                }
            }
        }
        return null;
    }

    /**
     * Atualiza um item de pedido
     */
    public boolean atualizar(ItemPedido item) throws SQLException {
        String sql = "UPDATE itens_pedido SET quantidade = ?, preco_unitario = ?, subtotal = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, item.getQuantidade());
            stmt.setBigDecimal(2, item.getPrecoUnitario());
            stmt.setBigDecimal(3, item.getSubtotal());
            stmt.setInt(4, item.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove um item de pedido
     */
    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM itens_pedido WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove todos os itens de um pedido
     */
    public boolean deletarPorPedidoId(int pedidoId) throws SQLException {
        String sql = "DELETE FROM itens_pedido WHERE pedido_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pedidoId);
            return stmt.executeUpdate() >= 0; // Pode ser 0 se o pedido não tinha itens
        }
    }

    /**
     * Busca itens de pedido por livro (para estatísticas)
     */
    public List<ItemPedido> buscarPorLivroId(int livroId) throws SQLException {
        String sql = "SELECT ip.*, l.titulo, l.autor, l.preco as preco_atual, l.imagem_url " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN livros l ON ip.livro_id = l.id " +
                    "INNER JOIN pedidos p ON ip.pedido_id = p.id " +
                    "WHERE ip.livro_id = ? AND p.status IN ('CONFIRMADO', 'ENVIADO', 'ENTREGUE') " +
                    "ORDER BY p.data_pedido DESC";
        
        List<ItemPedido> itens = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ItemPedido item = mapResultSetToItemPedido(rs);
                    itens.add(item);
                }
            }
        }
        return itens;
    }

    /**
     * Calcula a quantidade total vendida de um livro
     */
    public int calcularQuantidadeVendidaLivro(int livroId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(ip.quantidade), 0) as total " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN pedidos p ON ip.pedido_id = p.id " +
                    "WHERE ip.livro_id = ? AND p.status IN ('CONFIRMADO', 'ENVIADO', 'ENTREGUE')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    /**
     * Busca os livros mais vendidos
     */
    public List<Object[]> buscarLivrosMaisVendidos(int limite) throws SQLException {
        String sql = "SELECT l.id, l.titulo, l.autor, SUM(ip.quantidade) as total_vendido " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN livros l ON ip.livro_id = l.id " +
                    "INNER JOIN pedidos p ON ip.pedido_id = p.id " +
                    "WHERE p.status IN ('CONFIRMADO', 'ENVIADO', 'ENTREGUE') " +
                    "GROUP BY l.id, l.titulo, l.autor " +
                    "ORDER BY total_vendido DESC " +
                    "LIMIT ?";
        
        List<Object[]> resultado = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limite);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] linha = new Object[4];
                    linha[0] = rs.getInt("id");
                    linha[1] = rs.getString("titulo");
                    linha[2] = rs.getString("autor");
                    linha[3] = rs.getInt("total_vendido");
                    resultado.add(linha);
                }
            }
        }
        return resultado;
    }

    /**
     * Calcula o valor total de itens vendidos
     */
    public BigDecimal calcularValorTotalVendas() throws SQLException {
        String sql = "SELECT COALESCE(SUM(ip.subtotal), 0.00) as total " +
                    "FROM itens_pedido ip " +
                    "INNER JOIN pedidos p ON ip.pedido_id = p.id " +
                    "WHERE p.status IN ('CONFIRMADO', 'ENVIADO', 'ENTREGUE')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    // MÉTODO AUXILIAR PRIVADO
    
    private ItemPedido mapResultSetToItemPedido(ResultSet rs) throws SQLException {
        ItemPedido item = new ItemPedido();
        
        item.setId(rs.getInt("id"));
        item.setPedidoId(rs.getInt("pedido_id"));
        item.setLivroId(rs.getInt("livro_id"));
        item.setQuantidade(rs.getInt("quantidade"));
        item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        
        // Cria objeto Livro com informações básicas
        Livro livro = new Livro();
        livro.setId(rs.getInt("livro_id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setImagemUrl(rs.getString("imagem_url"));
        livro.setPreco(rs.getBigDecimal("preco_atual")); // Preço atual, não o do pedido
        
        item.setLivro(livro);
        
        return item;
    }
}