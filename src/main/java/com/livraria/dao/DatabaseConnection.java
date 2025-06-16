package com.livraria.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @deprecated Use {@link DataSourceFactory#getConnection()} em vez desta classe.
 */
@Deprecated
public class DatabaseConnection {

    // IMPORTANTE: Altere estes valores para os da sua configuração local do MySQL.
    private static final String URL = "jdbc:mysql://localhost:3306/livraria_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // seu usuário do MySQL
    private static final String PASS = ""; // sua senha do MySQL

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Carrega o driver JDBC
            Class.forName(DRIVER);
            // Obtém a conexão
            connection = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            // Lançar uma exceção em tempo de execução para sinalizar falha grave
            throw new RuntimeException("Erro ao conectar-se à base de dados", e);
        }
        return connection;
    }
}
