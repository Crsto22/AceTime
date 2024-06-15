<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proceso de Compra</title>
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.3.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="flex flex-col justify-center items-center min-h-screen bg-gray-100 dark:bg-gray-800">
    <%
        String id_compra = request.getParameter("id_compra");
        String id_comprador = request.getParameter("id_comprador");
        String id_usuario = request.getParameter("id_usuario");
        String fecha_comprobante = request.getParameter("fecha_comprobante");
    %>
    <main class="flex flex-col items-center justify-center min-h-screen">
        <div class="mb-4 text-lg font-bold text-yellow-900">Tu reloj en proceso de compra...</div>

        <div id="progress-bar" class="w-full max-w-md bg-gray-200 rounded-full dark:bg-gray-700">
            <div id="progress"
                class="bg-yellow-500 text-xs font-medium text-blue-100 text-center p-0.5 leading-none rounded-full"
                style="width: 1%">1%</div>
        </div>
    </main>
    <script>
        const progressBar = document.getElementById('progress');
        let progress = 1;
        function updateProgress() {
            if (progress <= 100) {
                progressBar.style.width = progress + '%';
                progressBar.innerText = progress + '%';
                progress++;
                setTimeout(updateProgress, 50);
            } else {
                window.location.href = 'exitocompra.jsp?id_compra=<%=id_compra %>&id_comprador=<%=id_comprador %>&id_usuario=<%=id_usuario %>&fecha_comprobante=<%=fecha_comprobante %>';
            }
        }
        updateProgress();
    </script>
</body>
