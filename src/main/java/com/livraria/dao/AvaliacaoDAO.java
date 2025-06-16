package com.livraria.dao;

import com.livraria.model.Avaliacao;
import com.livraria.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class AvaliacaoDAO {

    /**
     * Insere uma nova avaliação no banco de dados
     */
    public boolean inserir(Avaliacao avaliacao) throws SQLException {
        String sql = "INSERT INTO avaliacoes (usuario_id, livro_id, nota, comentario, data_avaliacao) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, avaliacao.getUsuarioId());
            stmt.setInt(2, avaliacao.getLivroId());
            stmt.setInt(3, avaliacao.getNota());
            stmt.setString(4, avaliacao.getComentario());
            stmt.setTimestamp(5, Timestamp.valueOf(avaliacao.getDataAvaliacao()));
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        avaliacao.setId(rs.getInt(1));
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * Lista todas as avaliações de um livro específico
     */
    public List<Avaliacao> listarPorLivro(int livroId) throws SQLException {
        String sql = "SELECT a.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM avaliacoes a " +
                    "INNER JOIN usuarios u ON a.usuario_id = u.id " +
                    "WHERE a.livro_id = ? AND a.aprovado = true " +
                    "ORDER BY a.data_avaliacao DESC";
        
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao avaliacao = mapResultSetToAvaliacao(rs);
                    
                    // Adicionar informações do usuário
                    Usuario usuario = new Usuario();
                    usuario.setId(avaliacao.getUsuarioId());
                    usuario.setNome(rs.getString("usuario_nome"));
                    usuario.setEmail(rs.getString("usuario_email"));
                    avaliacao.setUsuario(usuario);
                    
                    avaliacoes.add(avaliacao);
                }
            }
        }
        return avaliacoes;
    }

    /**
     * Lista avaliações de um usuário específico
     */
    public List<Avaliacao> listarPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT a.*, l.titulo as livro_titulo, l.autor as livro_autor, l.imagem_url " +
                    "FROM avaliacoes a " +
                    "INNER JOIN livros l ON a.livro_id = l.id " +
                    "WHERE a.usuario_id = ? " +
                    "ORDER BY a.data_avaliacao DESC";
        
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao avaliacao = mapResultSetToAvaliacao(rs);
                    avaliacao.setLivroTitulo(rs.getString("livro_titulo"));
                    avaliacao.setLivroAutor(rs.getString("livro_autor"));
                    avaliacao.setLivroImagemUrl(rs.getString("imagem_url"));
                    avaliacoes.add(avaliacao);
                }
            }
        }
        return avaliacoes;
    }

    /**
     * Verifica se um usuário já avaliou um livro específico
     */
    public boolean usuarioJaAvaliou(int usuarioId, int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM avaliacoes WHERE usuario_id = ? AND livro_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Calcula a média de avaliações de um livro
     */
    public double calcularMediaAvaliacoes(int livroId) throws SQLException {
        String sql = "SELECT AVG(CAST(nota AS DECIMAL(3,2))) as media " +
                    "FROM avaliacoes " +
                    "WHERE livro_id = ? AND aprovado = true";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("media");
                }
            }
        }
        return 0.0;
    }

    /**
     * Conta o total de avaliações de um livro
     */
    public int contarAvaliacoes(int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM avaliacoes WHERE livro_id = ? AND aprovado = true";
        
        try (Connection conn = DataSourceFactory.getConnection();
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
     * Conta avaliações por nota (para gráfico de distribuição)
     */
    public int[] contarPorNota(int livroId) throws SQLException {
        String sql = "SELECT nota, COUNT(*) as quantidade " +
                    "FROM avaliacoes " +
                    "WHERE livro_id = ? AND aprovado = true " +
                    "GROUP BY nota " +
                    "ORDER BY nota";
        
        int[] distribuicao = new int[6]; // índice 0 não usado, 1-5 para as notas
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int nota = rs.getInt("nota");
                    int quantidade = rs.getInt("quantidade");
                    if (nota >= 1 && nota <= 5) {
                        distribuicao[nota] = quantidade;
                    }
                }
            }
        }
        return distribuicao;
    }

    /**
     * Busca avaliação específica por ID
     */
    public Avaliacao buscarPorId(int id) throws SQLException {
        String sql = "SELECT a.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM avaliacoes a " +
                    "INNER JOIN usuarios u ON a.usuario_id = u.id " +
                    "WHERE a.id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Avaliacao avaliacao = mapResultSetToAvaliacao(rs);
                    
                    Usuario usuario = new Usuario();
                    usuario.setId(avaliacao.getUsuarioId());
                    usuario.setNome(rs.getString("usuario_nome"));
                    usuario.setEmail(rs.getString("usuario_email"));
                    avaliacao.setUsuario(usuario);
                    
                    return avaliacao;
                }
            }
        }
        return null;
    }

    /**
     * Atualiza uma avaliação existente
     */
    public boolean atualizar(Avaliacao avaliacao) throws SQLException {
        String sql = "UPDATE avaliacoes SET nota = ?, comentario = ?, data_atualizacao = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getNota());
            stmt.setString(2, avaliacao.getComentario());
            stmt.setInt(3, avaliacao.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove uma avaliação
     */
    public boolean deletar(int id) throws SQLException {
        String sql = "DELETE FROM avaliacoes WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Aprova uma avaliação (para moderação)
     */
    public boolean aprovar(int id) throws SQLException {
        String sql = "UPDATE avaliacoes SET aprovado = true WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Lista avaliações pendentes de aprovação
     */
    public List<Avaliacao> listarPendentesAprovacao() throws SQLException {
        String sql = "SELECT a.*, u.nome as usuario_nome, u.email as usuario_email, " +
                    "l.titulo as livro_titulo, l.autor as livro_autor " +
                    "FROM avaliacoes a " +
                    "INNER JOIN usuarios u ON a.usuario_id = u.id " +
                    "INNER JOIN livros l ON a.livro_id = l.id " +
                    "WHERE a.aprovado = false " +
                    "ORDER BY a.data_avaliacao ASC";
        
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Avaliacao avaliacao = mapResultSetToAvaliacao(rs);
                
                Usuario usuario = new Usuario();
                usuario.setId(avaliacao.getUsuarioId());
                usuario.setNome(rs.getString("usuario_nome"));
                usuario.setEmail(rs.getString("usuario_email"));
                avaliacao.setUsuario(usuario);
                
                avaliacao.setLivroTitulo(rs.getString("livro_titulo"));
                avaliacao.setLivroAutor(rs.getString("livro_autor"));
                
                avaliacoes.add(avaliacao);
            }
        }
        return avaliacoes;
    }

    /**
     * Busca avaliações mais úteis (com mais curtidas)
     */
    public List<Avaliacao> listarMaisUteis(int livroId, int limite) throws SQLException {
        String sql = "SELECT a.*, u.nome as usuario_nome, u.email as usuario_email " +
                    "FROM avaliacoes a " +
                    "INNER JOIN usuarios u ON a.usuario_id = u.id " +
                    "WHERE a.livro_id = ? AND a.aprovado = true " +
                    "ORDER BY a.curtidas DESC, a.data_avaliacao DESC " +
                    "LIMIT ?";
        
        List<Avaliacao> avaliacoes = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            stmt.setInt(2, limite);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao avaliacao = mapResultSetToAvaliacao(rs);
                    
                    Usuario usuario = new Usuario();
                    usuario.setId(avaliacao.getUsuarioId());
                    usuario.setNome(rs.getString("usuario_nome"));
                    usuario.setEmail(rs.getString("usuario_email"));
                    avaliacao.setUsuario(usuario);
                    
                    avaliacoes.add(avaliacao);
                }
            }
        }
        return avaliacoes;
    }

    /**
     * Registra uma curtida em uma avaliação
     */
    public boolean curtirAvaliacao(int avaliacaoId, int usuarioId) throws SQLException {
        // Primeiro verifica se já curtiu
        if (usuarioJaCurtiu(avaliacaoId, usuarioId)) {
            return false;
        }
        
        String sqlInsert = "INSERT INTO avaliacao_curtidas (avaliacao_id, usuario_id) VALUES (?, ?)";
        String sqlUpdate = "UPDATE avaliacoes SET curtidas = curtidas + 1 WHERE id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
                 PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                
                stmtInsert.setInt(1, avaliacaoId);
                stmtInsert.setInt(2, usuarioId);
                stmtInsert.executeUpdate();
                
                stmtUpdate.setInt(1, avaliacaoId);
                stmtUpdate.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    /**
     * Verifica se usuário já curtiu uma avaliação
     */
    public boolean usuarioJaCurtiu(int avaliacaoId, int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM avaliacao_curtidas WHERE avaliacao_id = ? AND usuario_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacaoId);
            stmt.setInt(2, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Busca livros mais bem avaliados
     */
    public List<Object[]> buscarLivrosMaisBemAvaliados(int limite) throws SQLException {
        String sql = "SELECT l.id, l.titulo, l.autor, l.imagem_url, " +
                    "AVG(CAST(a.nota AS DECIMAL(3,2))) as media_nota, " +
                    "COUNT(a.id) as total_avaliacoes " +
                    "FROM livros l " +
                    "INNER JOIN avaliacoes a ON l.id = a.livro_id " +
                    "WHERE a.aprovado = true AND l.ativo = true " +
                    "GROUP BY l.id, l.titulo, l.autor, l.imagem_url " +
                    "HAVING COUNT(a.id) >= 3 " +
                    "ORDER BY media_nota DESC, total_avaliacoes DESC " +
                    "LIMIT ?";
        
        List<Object[]> resultado = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limite);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] linha = new Object[6];
                    linha[0] = rs.getInt("id");
                    linha[1] = rs.getString("titulo");
                    linha[2] = rs.getString("autor");
                    linha[3] = rs.getString("imagem_url");
                    linha[4] = rs.getDouble("media_nota");
                    linha[5] = rs.getInt("total_avaliacoes");
                    resultado.add(linha);
                }
            }
        }
        return resultado;
    }

    // MÉTODO AUXILIAR PRIVADO
    
    private Avaliacao mapResultSetToAvaliacao(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = new Avaliacao();
        
        avaliacao.setId(rs.getInt("id"));
        avaliacao.setUsuarioId(rs.getInt("usuario_id"));
        avaliacao.setLivroId(rs.getInt("livro_id"));
        avaliacao.setNota(rs.getInt("nota"));
        avaliacao.setComentario(rs.getString("comentario"));
        avaliacao.setAprovado(rs.getBoolean("aprovado"));
        avaliacao.setCurtidas(rs.getInt("curtidas"));
        
        Timestamp dataTimestamp = rs.getTimestamp("data_avaliacao");
        if (dataTimestamp != null) {
            avaliacao.setDataAvaliacao(dataTimestamp.toLocalDateTime());
        }
        
        Timestamp dataAtualizacaoTimestamp = rs.getTimestamp("data_atualizacao");
        if (dataAtualizacaoTimestamp != null) {
            avaliacao.setDataAtualizacao(dataAtualizacaoTimestamp.toLocalDateTime());
        }
        
        return avaliacao;
    }
}