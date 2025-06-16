package com.livraria.dao;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.servlet.ServletContext;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Factory para obter conexões utilizando um pool HikariCP.
 * As configurações são lidas do arquivo WEB-INF/db.properties.
 */
public class DataSourceFactory {

    private static HikariDataSource dataSource;

    /**
     * Inicializa o pool de conexões utilizando as propriedades fornecidas.
     */
    public static void init(ServletContext context) {
        if (dataSource != null) {
            return; // já inicializado
        }
        try {
            String path = context.getRealPath("/WEB-INF/db.properties");
            Properties props = new Properties();
            try (InputStream in = new FileInputStream(path)) {
                props.load(in);
            }

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("jdbcUrl"));
            config.setUsername(props.getProperty("username"));
            config.setPassword(props.getProperty("password"));
            config.setDriverClassName(props.getProperty("driverClassName", "com.mysql.cj.jdbc.Driver"));
            String max = props.getProperty("maximumPoolSize");
            if (max != null) {
                config.setMaximumPoolSize(Integer.parseInt(max));
            }

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            throw new RuntimeException("Falha ao inicializar pool de conexões", e);
        }
    }

    /**
     * Obtém uma conexão do pool configurado.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new IllegalStateException("DataSource não inicializado");
        }
        return dataSource.getConnection();
    }

    /**
     * Encerra o pool de conexões.
     */
    public static void shutdown() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
