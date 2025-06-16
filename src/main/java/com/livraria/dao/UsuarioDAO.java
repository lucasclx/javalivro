package com.livraria.dao;

import com.livraria.model.Usuario;
import com.livraria.util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    /**
     * Valida as credenciais de um utilizador na base de dados.
     * @param email O email do utilizador.
     * @param senha A senha do utilizador.
     * @return Um objeto Usuario se as credenciais forem válidas, caso contrário, null.
     */
    public Usuario validarLogin(String email, String senha) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hash = rs.getString("senha");
                    if (PasswordUtil.verifyPassword(senha, hash)) {
                        return mapResultSetToUsuario(rs);
                    }
                }
            }
        }
        return null;
    }

    /**
     * Insere um novo utilizador na base de dados.
     * @param usuario O objeto Usuario a ser inserido.
     * @return true se a inserção for bem-sucedida, false caso contrário.
     */
    public boolean inserir(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO usuarios (nome, email, senha, admin) VALUES (?, ?, ?, ?)";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            String hash = PasswordUtil.hashPassword(usuario.getSenha());
            stmt.setString(3, hash);
            // também atualiza o objeto para não manter a senha em texto simples
            usuario.setSenha(hash);
            stmt.setBoolean(4, usuario.isAdmin());
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Busca um utilizador pelo seu email.
     * @param email O email a ser procurado.
     * @return Um objeto Usuario se encontrado, caso contrário, null.
     */
    public Usuario buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUsuario(rs);
                }
            }
        }
        return null;
    }
    
    private Usuario mapResultSetToUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setNome(rs.getString("nome"));
        usuario.setEmail(rs.getString("email"));
        usuario.setSenha(rs.getString("senha"));
        usuario.setAdmin(rs.getBoolean("admin"));
        return usuario;
    }
}