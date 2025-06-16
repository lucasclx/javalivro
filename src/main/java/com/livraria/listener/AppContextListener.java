package com.livraria.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.livraria.dao.DataSourceFactory;

/**
 * Listener para inicialização e destruição do contexto da aplicação.
 * Configurado no web.xml para ser executado no startup/shutdown da aplicação.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Livraria Mil Páginas - Aplicação Iniciando ===");
        
        try {
            // Inicializa o pool de conexões
            DataSourceFactory.init(sce.getServletContext());
            // Testa rapidamente a conexão
            testDatabaseConnection();
            
            // Define atributos globais da aplicação
            sce.getServletContext().setAttribute("appName", "Livraria Mil Páginas");
            sce.getServletContext().setAttribute("appVersion", "1.0.0");
            sce.getServletContext().setAttribute("startupTime", System.currentTimeMillis());
            
            System.out.println("✓ Aplicação inicializada com sucesso");
            
        } catch (Exception e) {
            System.err.println("✗ Erro durante inicialização: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== Aplicação Pronta para Uso ===");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Livraria Mil Páginas - Aplicação Encerrando ===");

        // Finaliza pool de conexões
        DataSourceFactory.shutdown();

        // Cleanup se necessário
        Long startupTime = (Long) sce.getServletContext().getAttribute("startupTime");
        if (startupTime != null) {
            long uptime = System.currentTimeMillis() - startupTime;
            System.out.println("✓ Tempo de execução: " + (uptime / 1000) + " segundos");
        }
        
        System.out.println("✓ Aplicação encerrada com sucesso");
    }
    
    /**
     * Testa a conexão com o banco de dados na inicialização
     */
    private void testDatabaseConnection() {
        try (java.sql.Connection connection = DataSourceFactory.getConnection()) {
            if (connection != null) {
                System.out.println("✓ Conexão com banco de dados testada com sucesso");
            }
        } catch (Exception e) {
            System.err.println("⚠ Aviso: Não foi possível testar a conexão com o banco: " + e.getMessage());
            System.err.println("  Certifique-se de que o MySQL está rodando e as configurações estão corretas.");
            // Não lança exceção para permitir que a aplicação inicie mesmo sem BD
        }
    }
}