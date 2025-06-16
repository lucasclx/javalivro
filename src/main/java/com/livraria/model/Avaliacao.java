package com.livraria.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Avaliacao {
    private int id;
    private int usuarioId;
    private int livroId;
    private int nota;
    private String comentario;
    private boolean aprovado;
    private int curtidas;
    private LocalDateTime dataAvaliacao;
    private LocalDateTime dataAtualizacao;
    
    // Objetos relacionados (para facilitar exibição)
    private Usuario usuario;
    private Livro livro;
    
    // Campos auxiliares para consultas
    private String livroTitulo;
    private String livroAutor;
    private String livroImagemUrl;

    // Construtores
    public Avaliacao() {
        this.dataAvaliacao = LocalDateTime.now();
        this.aprovado = false;
        this.curtidas = 0;
    }

    public Avaliacao(int usuarioId, int livroId, int nota, String comentario) {
        this();
        this.usuarioId = usuarioId;
        this.livroId = livroId;
        this.nota = nota;
        this.comentario = comentario;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public int getLivroId() {
        return livroId;
    }

    public void setLivroId(int livroId) {
        this.livroId = livroId;
    }

    public int getNota() {
        return nota;
    }

    public void setNota(int nota) {
        if (nota < 1 || nota > 5) {
            throw new IllegalArgumentException("Nota deve estar entre 1 e 5");
        }
        this.nota = nota;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public boolean isAprovado() {
        return aprovado;
    }

    public void setAprovado(boolean aprovado) {
        this.aprovado = aprovado;
    }

    public int getCurtidas() {
        return curtidas;
    }

    public void setCurtidas(int curtidas) {
        this.curtidas = curtidas;
    }

    public LocalDateTime getDataAvaliacao() {
        return dataAvaliacao;
    }

    public void setDataAvaliacao(LocalDateTime dataAvaliacao) {
        this.dataAvaliacao = dataAvaliacao;
    }

    public LocalDateTime getDataAtualizacao() {
        return dataAtualizacao;
    }

    public void setDataAtualizacao(LocalDateTime dataAtualizacao) {
        this.dataAtualizacao = dataAtualizacao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Livro getLivro() {
        return livro;
    }

    public void setLivro(Livro livro) {
        this.livro = livro;
    }

    public String getLivroTitulo() {
        return livroTitulo;
    }

    public void setLivroTitulo(String livroTitulo) {
        this.livroTitulo = livroTitulo;
    }

    public String getLivroAutor() {
        return livroAutor;
    }

    public void setLivroAutor(String livroAutor) {
        this.livroAutor = livroAutor;
    }

    public String getLivroImagemUrl() {
        return livroImagemUrl;
    }

    public void setLivroImagemUrl(String livroImagemUrl) {
        this.livroImagemUrl = livroImagemUrl;
    }

    // Métodos Utilitários

    /**
     * Retorna a data formatada para exibição brasileira
     */
    public String getDataFormatada() {
        if (dataAvaliacao == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm");
        return dataAvaliacao.format(formatter);
    }

    /**
     * Retorna data relativa (há X dias, há X horas, etc.)
     */
    public String getDataRelativa() {
        if (dataAvaliacao == null) {
            return "";
        }
        
        LocalDateTime agora = LocalDateTime.now();
        long segundos = java.time.Duration.between(dataAvaliacao, agora).getSeconds();
        
        if (segundos < 60) {
            return "Agora mesmo";
        } else if (segundos < 3600) {
            long minutos = segundos / 60;
            return "Há " + minutos + (minutos == 1 ? " minuto" : " minutos");
        } else if (segundos < 86400) {
            long horas = segundos / 3600;
            return "Há " + horas + (horas == 1 ? " hora" : " horas");
        } else if (segundos < 2592000) {
            long dias = segundos / 86400;
            return "Há " + dias + (dias == 1 ? " dia" : " dias");
        } else {
            return getDataFormatada();
        }
    }

    /**
     * Retorna as estrelas como string HTML
     */
    public String getEstrelasHtml() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= nota) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    /**
     * Retorna descrição textual da nota
     */
    public String getDescricaoNota() {
        switch (nota) {
            case 1: return "Muito Ruim";
            case 2: return "Ruim";
            case 3: return "Regular";
            case 4: return "Bom";
            case 5: return "Excelente";
            default: return "Sem avaliação";
        }
    }

    /**
     * Verifica se a avaliação tem comentário
     */
    public boolean temComentario() {
        return comentario != null && !comentario.trim().isEmpty();
    }

    /**
     * Retorna comentário truncado para prévia
     */
    public String getComentarioPrevia(int maxLength) {
        if (!temComentario()) {
            return "";
        }
        
        if (comentario.length() <= maxLength) {
            return comentario;
        }
        
        return comentario.substring(0, maxLength) + "...";
    }

    /**
     * Verifica se foi editada (data de atualização diferente da criação)
     */
    public boolean foiEditada() {
        return dataAtualizacao != null && 
               !dataAtualizacao.equals(dataAvaliacao);
    }

    /**
     * Retorna o nome do usuário ou "Usuário Anônimo"
     */
    public String getNomeUsuario() {
        if (usuario != null && usuario.getNome() != null) {
            return usuario.getNome();
        }
        return "Usuário Anônimo";
    }

    /**
     * Retorna inicial do nome do usuário para avatar
     */
    public String getInicialUsuario() {
        String nome = getNomeUsuario();
        if (nome.length() > 0) {
            return String.valueOf(nome.charAt(0)).toUpperCase();
        }
        return "?";
    }

    /**
     * Verifica se a avaliação é válida
     */
    public boolean isValida() {
        return usuarioId > 0 && 
               livroId > 0 && 
               nota >= 1 && nota <= 5 &&
               (comentario == null || comentario.length() <= 2000);
    }

    /**
     * Verifica se pode ser editada pelo usuário
     */
    public boolean podeSerEditada(int usuarioLogadoId) {
        return this.usuarioId == usuarioLogadoId && 
               dataAvaliacao != null &&
               dataAvaliacao.isAfter(LocalDateTime.now().minusDays(7)); // 7 dias para editar
    }

    /**
     * Verifica se pode ser excluída pelo usuário
     */
    public boolean podeSerExcluida(int usuarioLogadoId) {
        return this.usuarioId == usuarioLogadoId ||
               (usuario != null && usuario.isAdmin());
    }

    /**
     * Retorna classificação de utilidade baseada em curtidas
     */
    public String getClassificacaoUtilidade() {
        if (curtidas >= 10) {
            return "Muito Útil";
        } else if (curtidas >= 5) {
            return "Útil";
        } else if (curtidas >= 1) {
            return "Relevante";
        } else {
            return "";
        }
    }

    /**
     * Calcula score da avaliação (para ordenação)
     */
    public double calcularScore() {
        double score = nota * 20; // Nota vale 20 pontos cada estrela
        
        // Bônus por comentário detalhado
        if (temComentario()) {
            if (comentario.length() > 200) {
                score += 10;
            } else if (comentario.length() > 50) {
                score += 5;
            }
        }
        
        // Bônus por curtidas
        score += Math.min(curtidas * 2, 20); // Máximo 20 pontos por curtidas
        
        // Penalidade por idade (avaliações mais antigas valem menos)
        if (dataAvaliacao != null) {
            long diasAtras = java.time.Duration.between(dataAvaliacao, LocalDateTime.now()).toDays();
            double penalidade = Math.min(diasAtras * 0.1, 10); // Máximo 10 pontos de penalidade
            score -= penalidade;
        }
        
        return Math.max(score, 0);
    }

    @Override
    public String toString() {
        return "Avaliacao{" +
                "id=" + id +
                ", usuarioId=" + usuarioId +
                ", livroId=" + livroId +
                ", nota=" + nota +
                ", comentario='" + (comentario != null ? comentario.substring(0, Math.min(50, comentario.length())) + "..." : "null") + '\'' +
                ", aprovado=" + aprovado +
                ", curtidas=" + curtidas +
                ", dataAvaliacao=" + dataAvaliacao +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Avaliacao avaliacao = (Avaliacao) obj;
        return id == avaliacao.id;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(id);
    }
}