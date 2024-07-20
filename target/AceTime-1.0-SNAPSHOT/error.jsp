<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error en el envío</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
            <h1 class="text-2xl font-bold text-red-600 mb-4">Error en el envío del mensaje</h1>
            <p class="text-gray-700 mb-4">Lo sentimos, ha ocurrido un error al intentar enviar su mensaje. Por favor, inténtelo de nuevo más tarde.</p>
            <% if(request.getAttribute("error") != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                    <strong class="font-bold">Detalles del error:</strong>
                    <span class="block sm:inline"><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            <% if(request.getAttribute("stackTrace") != null) { %>
                <div class="mt-4">
                    <h2 class="text-lg font-semibold mb-2">Stack Trace:</h2>
                    <pre class="text-xs bg-gray-100 p-2 rounded overflow-x-auto"><%= request.getAttribute("stackTrace") %></pre>
                </div>
            <% } %>
            <div class="mt-6">
                <a href="javascript:history.back()" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Volver al formulario
                </a>
            </div>
        </div>
    </div>
</body>
</html>