package com.livraria.servlet;

import com.livraria.dao.AvaliacaoDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.model.Avaliacao;
import com.livraria.model.Usuario;
import com.livraria.model.Livro;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/avaliacoes")
public class AvaliacaoServlet extends HttpServlet {

    private AvaliacaoDAO avaliacaoDAO;
    private LivroDAO livroDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        avaliacaoDAO = new AvaliacaoDAO();
        livroDAO = new LivroDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "listar") {
                case "listar":
                    listarAvaliacoes(request, response);
                    break;
                case "ajax":
                    handleAjaxRequest(request, response);
                    break;
                case "estatisticas":
                    obterEstatisticas(request, response);
                    break;
                case "minhas":
                    listarMinhasAvaliacoes(request, response);
                    break;
                case "admin":
                    listarParaModeracao(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erro ao acessar o banco de dados", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "avaliar":
                    adicionarAvaliacao(request, response);
                    break;
                case "editar":
                    editarAvaliacao(request, response);
                    break;
                case "curtir":
                    curtirAvaliacao(request, response);
                    break;
                case "denunciar":
                    denunciarAvaliacao(request, response);
                    break;
                case "moderar":
                    moderarAvaliacao(request, response);
                    break;
                case "deletar":
                    deletarAvaliacao(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida para POST");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            enviarRespostaJson(response, false, "Erro interno do servidor");
        }
    }

    /**
     * Lista avaliações de um livro específico
     */
    private void listarAvaliacoes(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int livroId = Integer.parseInt(request.getParameter("livroId"));
        int pagina = Integer.parseInt(request.getParameter("pagina") != null ? request.getParameter("pagina") : "1");
        int itensPorPagina = 10;
        
        // Buscar avaliações
        List<Avaliacao> avaliacoes = avaliacaoDAO.listarPorLivro(livroId);
        
        // Calcular estatísticas
        double mediaAvaliacoes = avaliacaoDAO.calcularMediaAvaliacoes(livroId);
        int totalAvaliacoes = avaliacaoDAO.contarAvaliacoes(livroId);
        int[] distribuicaoNotas = avaliacaoDAO.contarPorNota(livroId);
        
        // Verificar se usuário já avaliou
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        boolean usuarioJaAvaliou = false;
        
        if (usuario != null) {
            usuarioJaAvaliou = avaliacaoDAO.usuarioJaAvaliou(usuario.getId(), livroId);
        }
        
        // Verificar curtidas do usuário
        Map<Integer, Boolean> usuarioJaCurtiu = new HashMap<>();
        if (usuario != null) {
            for (Avaliacao avaliacao : avaliacoes) {
                usuarioJaCurtiu.put(avaliacao.getId(), 
                    avaliacaoDAO.usuarioJaCurtiu(avaliacao.getId(), usuario.getId()));
            }
        }
        
        // Buscar dados do livro
        Livro livro = livroDAO.buscarPorId(livroId);
        
        // Definir atributos para JSP
        request.setAttribute("avaliacoes", avaliacoes);
        request.setAttribute("livro", livro);
        request.setAttribute("mediaAvaliacoes", mediaAvaliacoes);
        request.setAttribute("totalAvaliacoes", totalAvaliacoes);
        request.setAttribute("distribuicaoNotas", distribuicaoNotas);
        request.setAttribute("usuarioJaAvaliou", usuarioJaAvaliou);
        request.setAttribute("usuarioJaCurtiu", usuarioJaCurtiu);
        
        // Forward para JSP ou página de detalhes do livro
        request.getRequestDispatcher("/pages/livro-detalhes.jsp").forward(request, response);
    }

    /**
     * Adiciona nova avaliação
     */
    private void adicionarAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            enviarRespostaJson(response, false, "Usuário não autenticado");
            return;
        }
        
        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            int nota = Integer.parseInt(request.getParameter("nota"));
            String comentario = request.getParameter("comentario");
            
            // Validações
            if (nota < 1 || nota > 5) {
                enviarRespostaJson(response, false, "Nota deve estar entre 1 e 5");
                return;
            }
            
            if (comentario != null && comentario.length() > 2000) {
                enviarRespostaJson(response, false, "Comentário muito longo");
                return;
            }
            
            // Verificar se já avaliou
            if (avaliacaoDAO.usuarioJaAvaliou(usuario.getId(), livroId)) {
                enviarRespostaJson(response, false, "Você já avaliou este livro");
                return;
            }
            
            // Verificar se livro existe
            Livro livro = livroDAO.buscarPorId(livroId);
            if (livro == null) {
                enviarRespostaJson(response, false, "Livro não encontrado");
                return;
            }
            
            // Criar avaliação
            Avaliacao avaliacao = new Avaliacao(usuario.getId(), livroId, nota, comentario);
            avaliacao.setAprovado(true); // Auto-aprovar por enquanto
            
            if (avaliacaoDAO.inserir(avaliacao)) {
                enviarRespostaJson(response, true, "Avaliação adicionada com sucesso");
                
                // Log da ação
                System.out.println("Nova avaliação: Usuário " + usuario.getId() + 
                                 " avaliou livro " + livroId + " com nota " + nota);
            } else {
                enviarRespostaJson(response, false, "Erro ao salvar avaliação");
            }
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "Dados inválidos");
        } catch (Exception e) {
            e.printStackTrace();
            enviarRespostaJson(response, false, "Erro interno do servidor");
        }
    }

    /**
     * Edita avaliação existente
     */
    private void editarAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            enviarRespostaJson(response, false, "Usuário não autenticado");
            return;
        }
        
        try {
            int avaliacaoId = Integer.parseInt(request.getParameter("avaliacaoId"));
            int nota = Integer.parseInt(request.getParameter("nota"));
            String comentario = request.getParameter("comentario");
            
            // Buscar avaliação existente
            Avaliacao avaliacao = avaliacaoDAO.buscarPorId(avaliacaoId);
            if (avaliacao == null) {
                enviarRespostaJson(response, false, "Avaliação não encontrada");
                return;
            }
            
            // Verificar permissão
            if (!avaliacao.podeSerEditada(usuario.getId())) {
                enviarRespostaJson(response, false, "Você não pode editar esta avaliação");
                return;
            }
            
            // Validações
            if (nota < 1 || nota > 5) {
                enviarRespostaJson(response, false, "Nota deve estar entre 1 e 5");
                return;
            }
            
            if (comentario != null && comentario.length() > 2000) {
                enviarRespostaJson(response, false, "Comentário muito longo");
                return;
            }
            
            // Atualizar avaliação
            avaliacao.setNota(nota);
            avaliacao.setComentario(comentario);
            
            if (avaliacaoDAO.atualizar(avaliacao)) {
                enviarRespostaJson(response, true, "Avaliação atualizada com sucesso");
            } else {
                enviarRespostaJson(response, false, "Erro ao atualizar avaliação");
            }
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "Dados inválidos");
        }
    }

    /**
     * Curtir/descurtir avaliação
     */
    private void curtirAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            enviarRespostaJson(response, false, "Usuário não autenticado");
            return;
        }
        
        try {
            int avaliacaoId = Integer.parseInt(request.getParameter("avaliacaoId"));
            
            // Verificar se avaliação existe
            Avaliacao avaliacao = avaliacaoDAO.buscarPorId(avaliacaoId);
            if (avaliacao == null) {
                enviarRespostaJson(response, false, "Avaliação não encontrada");
                return;
            }
            
            // Não pode curtir própria avaliação
            if (avaliacao.getUsuarioId() == usuario.getId()) {
                enviarRespostaJson(response, false, "Você não pode curtir sua própria avaliação");
                return;
            }
            
            boolean jaCurtiu = avaliacaoDAO.usuarioJaCurtiu(avaliacaoId, usuario.getId());
            
            if (jaCurtiu) {
                // Implementar descurtir se necessário
                enviarRespostaJson(response, false, "Você já curtiu esta avaliação");
            } else {
                if (avaliacaoDAO.curtirAvaliacao(avaliacaoId, usuario.getId())) {
                    JsonObject jsonResponse = new JsonObject();
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Avaliação curtida com sucesso");
                    jsonResponse.addProperty("novaQuantidadeCurtidas", avaliacao.getCurtidas() + 1);
                    
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(gson.toJson(jsonResponse));
                } else {
                    enviarRespostaJson(response, false, "Erro ao curtir avaliação");
                }
            }
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "ID inválido");
        }
    }

    /**
     * Denunciar avaliação
     */
    private void denunciarAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            enviarRespostaJson(response, false, "Usuário não autenticado");
            return;
        }
        
        try {
            int avaliacaoId = Integer.parseInt(request.getParameter("avaliacaoId"));
            String motivo = request.getParameter("motivo");
            String descricao = request.getParameter("descricao");
            
            if (motivo == null || motivo.trim().isEmpty()) {
                enviarRespostaJson(response, false, "Motivo da denúncia é obrigatório");
                return;
            }
            
            // Aqui seria implementada a lógica de denúncia na tabela avaliacao_denuncias
            // Por enquanto, apenas log
            System.out.println("Denúncia recebida: Usuário " + usuario.getId() + 
                             " denunciou avaliação " + avaliacaoId + 
                             " por: " + motivo);
            
            enviarRespostaJson(response, true, "Denúncia enviada com sucesso. Nossa equipe irá analisar.");
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "ID inválido");
        }
    }

    /**
     * Deletar avaliação
     */
    private void deletarAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            enviarRespostaJson(response, false, "Usuário não autenticado");
            return;
        }
        
        try {
            int avaliacaoId = Integer.parseInt(request.getParameter("avaliacaoId"));
            
            // Buscar avaliação
            Avaliacao avaliacao = avaliacaoDAO.buscarPorId(avaliacaoId);
            if (avaliacao == null) {
                enviarRespostaJson(response, false, "Avaliação não encontrada");
                return;
            }
            
            // Verificar permissão
            if (!avaliacao.podeSerExcluida(usuario.getId()) && !usuario.isAdmin()) {
                enviarRespostaJson(response, false, "Você não tem permissão para excluir esta avaliação");
                return;
            }
            
            if (avaliacaoDAO.deletar(avaliacaoId)) {
                enviarRespostaJson(response, true, "Avaliação excluída com sucesso");
                
                // Log da ação
                System.out.println("Avaliação " + avaliacaoId + " excluída por usuário " + usuario.getId());
            } else {
                enviarRespostaJson(response, false, "Erro ao excluir avaliação");
            }
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "ID inválido");
        }
    }

    /**
     * Lista avaliações do usuário logado
     */
    private void listarMinhasAvaliacoes(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=loginPage");
            return;
        }
        
        List<Avaliacao> minhasAvaliacoes = avaliacaoDAO.listarPorUsuario(usuario.getId());
        request.setAttribute("minhasAvaliacoes", minhasAvaliacoes);
        
        request.getRequestDispatcher("/pages/minhas-avaliacoes.jsp").forward(request, response);
    }

    /**
     * Lista avaliações pendentes de moderação (admin)
     */
    private void listarParaModeracao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null || !usuario.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        List<Avaliacao> avaliacoesPendentes = avaliacaoDAO.listarPendentesAprovacao();
        request.setAttribute("avaliacoesPendentes", avaliacoesPendentes);
        
        request.getRequestDispatcher("/admin/avaliacoes-moderacao.jsp").forward(request, response);
    }

    /**
     * Moderar avaliação (admin)
     */
    private void moderarAvaliacao(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuario == null || !usuario.isAdmin()) {
            enviarRespostaJson(response, false, "Acesso negado");
            return;
        }
        
        try {
            int avaliacaoId = Integer.parseInt(request.getParameter("avaliacaoId"));
            String acao = request.getParameter("acao");
            
            if ("aprovar".equals(acao)) {
                if (avaliacaoDAO.aprovar(avaliacaoId)) {
                    enviarRespostaJson(response, true, "Avaliação aprovada");
                } else {
                    enviarRespostaJson(response, false, "Erro ao aprovar avaliação");
                }
            } else if ("remover".equals(acao)) {
                if (avaliacaoDAO.deletar(avaliacaoId)) {
                    enviarRespostaJson(response, true, "Avaliação removida");
                } else {
                    enviarRespostaJson(response, false, "Erro ao remover avaliação");
                }
            } else {
                enviarRespostaJson(response, false, "Ação inválida");
            }
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "ID inválido");
        }
    }

    /**
     * Handle requisições AJAX
     */
    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String tipo = request.getParameter("tipo");
        
        switch (tipo != null ? tipo : "") {
            case "estatisticas":
                obterEstatisticasJson(request, response);
                break;
            case "mais-bem-avaliados":
                listarMaisBemAvaliadosJson(request, response);
                break;
            case "ranking-avaliadores":
                obterRankingAvaliadoresJson(request, response);
                break;
            default:
                enviarRespostaJson(response, false, "Tipo de requisição inválido");
        }
    }

    /**
     * Obtém estatísticas de um livro via AJAX
     */
    private void obterEstatisticasJson(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            
            double media = avaliacaoDAO.calcularMediaAvaliacoes(livroId);
            int total = avaliacaoDAO.contarAvaliacoes(livroId);
            int[] distribuicao = avaliacaoDAO.contarPorNota(livroId);
            
            JsonObject estatisticas = new JsonObject();
            estatisticas.addProperty("media", media);
            estatisticas.addProperty("total", total);
            estatisticas.add("distribuicao", gson.toJsonTree(distribuicao));
            
            response.getWriter().write(gson.toJson(estatisticas));
            
        } catch (NumberFormatException e) {
            enviarRespostaJson(response, false, "ID inválido");
        }
    }

    /**
     * Lista livros mais bem avaliados via AJAX
     */
    private void listarMaisBemAvaliadosJson(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int limite = Integer.parseInt(request.getParameter("limite") != null ? 
                                    request.getParameter("limite") : "10");
        
        List<Object[]> livrosMaisBemAvaliados = avaliacaoDAO.buscarLivrosMaisBemAvaliados(limite);
        response.getWriter().write(gson.toJson(livrosMaisBemAvaliados));
    }

    /**
     * Obtém ranking de avaliadores via AJAX
     */
    private void obterRankingAvaliadoresJson(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        // Implementar busca de ranking de avaliadores
        // Por enquanto retorna array vazio
        response.getWriter().write("[]");
    }

    /**
     * Obtém estatísticas gerais
     */
    private void obterEstatisticas(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        // Implementar estatísticas gerais de avaliações
        // Por enquanto apenas forward
        request.getRequestDispatcher("/pages/estatisticas-avaliacoes.jsp").forward(request, response);
    }

    // MÉTODOS AUXILIARES
    
    /**
     * Envia resposta JSON padrão
     */
    private void enviarRespostaJson(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", success);
        jsonResponse.addProperty("message", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.write(gson.toJson(jsonResponse));
        }
    }

    /**
     * Valida parâmetros obrigatórios
     */
    private boolean validarParametros(HttpServletRequest request, String... parametros) {
        for (String param : parametros) {
            String valor = request.getParameter(param);
            if (valor == null || valor.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }

    /**
     * Sanitiza entrada de texto
     */
    private String sanitizarTexto(String texto) {
        if (texto == null) {
            return null;
        }
        
        // Remove tags HTML e caracteres perigosos
        return texto.trim()
                   .replaceAll("<[^>]*>", "")
                   .replaceAll("[<>\"'&]", "");
    }

    /**
     * Log de ações importantes
     */
    private void logAcao(String acao, int usuarioId, int avaliacaoId) {
        String timestamp = java.time.LocalDateTime.now().toString();
        System.out.println(String.format("[%s] AVALIACAO_%s: Usuario=%d, Avaliacao=%d", 
                                        timestamp, acao, usuarioId, avaliacaoId));
    }
}