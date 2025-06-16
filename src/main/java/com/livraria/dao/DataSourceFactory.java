package com.livraria.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DataSourceFactory {
    private static final String PROPERTIES_PATH = "/WEB-INF/db.properties";
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream in = DataSourceFactory.class.getResourceAsStream(PROPERTIES_PATH)) {
            if (in != null) {
                PROPERTIES.load(in);
            } else {
                System.err.println("Database properties not found: " + PROPERTIES_PATH);
            }
        } catch (IOException e) {
            throw new ExceptionInInitializerError("Failed to load database properties: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        String driver = PROPERTIES.getProperty("driver", "com.mysql.cj.jdbc.Driver");
        String url = PROPERTIES.getProperty("url");
        String user = PROPERTIES.getProperty("username");
        String pass = PROPERTIES.getProperty("password");
        Class.forName(driver);
        return DriverManager.getConnection(url, user, pass);
    }
}
