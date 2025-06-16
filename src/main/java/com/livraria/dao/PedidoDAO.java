package com.livraria.dao;

import com.livraria.model.Pedido;
import com.livraria.model.ItemPedido;
import com.livraria.model.Usuario;
import com.livraria.model.Livro;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PedidoDAO {

    private ItemPedidoDAO itemPedidoDAO;
    private UsuarioDAO usuarioDAO;
    private LivroDAO livroDAO;

    public PedidoDAO() {
        this.itemPedidoDAO = new ItemPedidoDAO();
        this.usuarioDAO = new UsuarioDAO();
        this.livroDAO = new LivroDAO();
    }

    /**
     * Insere um novo pedido no banco de dados
     */
    public int inserir(Pedido pedido) throws SQLException {
        String sql = "INSERT INTO pedidos (usuario_id, valor_total, status, endereco_entrega, observacoes) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, pedido.getUsuarioId());
            stmt.setBigDecimal(2, pedido.getValorTotal());
            stmt.setString(3, pedido.getStatusPedido().name());
            stmt.setString(4, pedido.getEnderecoEntrega());
            stmt.setString(5, pedido.getObservacoes());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    /**
     * Busca um pedido por ID
     */
    public Pedido buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM pedidos WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Pedido pedido = mapResultSetToPedido(rs);
                    
                    // Carrega os itens do pedido
                    List<ItemPedido> itens = itemPedidoDAO.buscarPorPedidoId(id);
                    pedido.setItens(itens);
                    
                    return pedido;
                }
            }
        }
        return null;
    }

    /**
     * Lista todos os pedidos de um usuário
     */
    public List<Pedido> listarPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM pedidos WHERE usuario_id = ? ORDER BY data_pedido DESC";
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapResultSetToPedido(rs);
                    
                    // Carrega os itens do pedido
                    List<ItemPedido> itens = itemPedidoDAO.buscarPorPedidoId(pedido.getId());
                    pedido.setItens(itens);
                    
                    pedidos.add(pedido);
                }
            }
        }
        return pedidos;
    }

    /**
     * Lista todos os pedidos (para administradores)
     */
    public List<Pedido> listarTodos() throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM pedidos p " +
                    "INNER JOIN usuarios u ON p.usuario_id = u.id " +
                    "ORDER BY p.data_pedido DESC";
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Pedido pedido = mapResultSetToPedido(rs);
                
                // Adiciona informações do usuário
                Usuario usuario = new Usuario();
                usuario.setId(pedido.getUsuarioId());
                usuario.setNome(rs.getString("usuario_nome"));
                usuario.setEmail(rs.getString("usuario_email"));
                pedido.setUsuario(usuario);
                
                // Carrega os itens do pedido
                List<ItemPedido> itens = itemPedidoDAO.buscarPorPedidoId(pedido.getId());
                pedido.setItens(itens);
                
                pedidos.add(pedido);
            }
        }
        return pedidos;
    }

    /**
     * Lista pedidos por status
     */
    public List<Pedido> listarPorStatus(Pedido.StatusPedido status) throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM pedidos p " +
                    "INNER JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.status = ? " +
                    "ORDER BY p.data_pedido DESC";
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapResultSetToPedido(rs);
                    
                    // Adiciona informações do usuário
                    Usuario usuario = new Usuario();
                    usuario.setId(pedido.getUsuarioId());
                    usuario.setNome(rs.getString("usuario_nome"));
                    usuario.setEmail(rs.getString("usuario_email"));
                    pedido.setUsuario(usuario);
                    
                    // Carrega os itens do pedido
                    List<ItemPedido> itens = itemPedidoDAO.buscarPorPedidoId(pedido.getId());
                    pedido.setItens(itens);
                    
                    pedidos.add(pedido);
                }
            }
        }
        return pedidos;
    }

    /**
     * Atualiza o status de um pedido
     */
    public boolean atualizarStatus(int pedidoId, Pedido.StatusPedido novoStatus) throws SQLException {
        String sql = "UPDATE pedidos SET status = ?, data_atualizacao = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus.name());
            stmt.setInt(2, pedidoId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Atualiza um pedido completo
     */
    public boolean atualizar(Pedido pedido) throws SQLException {
        String sql = "UPDATE pedidos SET valor_total = ?, status = ?, endereco_entrega = ?, " +
                    "observacoes = ?, data_atualizacao = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBigDecimal(1, pedido.getValorTotal());
            stmt.setString(2, pedido.getStatusPedido().name());
            stmt.setString(3, pedido.getEnderecoEntrega());
            stmt.setString(4, pedido.getObservacoes());
            stmt.setInt(5, pedido.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Cancela um pedido (se permitido)
     */
    public boolean cancelar(int pedidoId) throws SQLException {
        // Primeiro verifica se o pedido pode ser cancelado
        Pedido pedido = buscarPorId(pedidoId);
        if (pedido == null || !pedido.podeSerCancelado()) {
            return false;
        }
        
        return atualizarStatus(pedidoId, Pedido.StatusPedido.CANCELADO);
    }

    /**
     * Busca pedidos por período
     */
    public List<Pedido> buscarPorPeriodo(LocalDateTime dataInicio, LocalDateTime dataFim) throws SQLException {
        String sql = "SELECT p.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM pedidos p " +
                    "INNER JOIN usuarios u ON p.usuario_id = u.id " +
                    "WHERE p.data_pedido BETWEEN ? AND ? " +
                    "ORDER BY p.data_pedido DESC";
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(dataInicio));
            stmt.setTimestamp(2, Timestamp.valueOf(dataFim));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapResultSetToPedido(rs);
                    
                    // Adiciona informações do usuário
                    Usuario usuario = new Usuario();
                    usuario.setId(pedido.getUsuarioId());
                    usuario.setNome(rs.getString("usuario_nome"));
                    usuario.setEmail(rs.getString("usuario_email"));
                    pedido.setUsuario(usuario);
                    
                    pedidos.add(pedido);
                }
            }
        }
        return pedidos;
    }

    /**
     * Calcula estatísticas de vendas
     */
    public BigDecimal calcularTotalVendas() throws SQLException {
        String sql = "SELECT SUM(valor_total) as total FROM pedidos WHERE status IN ('CONFIRMADO', 'ENVIADO', 'ENTREGUE')";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Conta total de pedidos por status
     */
    public int contarPorStatus(Pedido.StatusPedido status) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM pedidos WHERE status = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

    // MÉTODO AUXILIAR PRIVADO
    
    private Pedido mapResultSetToPedido(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        
        pedido.setId(rs.getInt("id"));
        pedido.setUsuarioId(rs.getInt("usuario_id"));
        pedido.setValorTotal(rs.getBigDecimal("valor_total"));
        pedido.setStatusPedido(Pedido.StatusPedido.valueOf(rs.getString("status")));
        pedido.setEnderecoEntrega(rs.getString("endereco_entrega"));
        pedido.setObservacoes(rs.getString("observacoes"));
        
        // Converte Timestamp para LocalDateTime
        Timestamp dataTimestamp = rs.getTimestamp("data_pedido");
        if (dataTimestamp != null) {
            pedido.setDataPedido(dataTimestamp.toLocalDateTime());
        }
        
        Timestamp dataAtualizacaoTimestamp = rs.getTimestamp("data_atualizacao");
        if (dataAtualizacaoTimestamp != null) {
            pedido.setDataAtualizacao(dataAtualizacaoTimestamp.toLocalDateTime());
        }
        
        return pedido;
    }
}