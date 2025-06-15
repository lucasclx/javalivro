<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>${not empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;500;600&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <header class="navbar no-print">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/livros?action=listar" class="navbar-brand">
                Livraria Mil Páginas
            </a>
            <nav class="d-flex gap-2">
                <a class="nav-link" href="${pageContext.request.contextPath}/livros?action=listar">Home</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/livros?action=destaques">Destaques</a>
                </nav>
        </div>
    </header>

    <main class="container py-5">