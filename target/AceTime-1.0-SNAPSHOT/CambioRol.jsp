<!DOCTYPE html>
<%
    // Obtaining session variables
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String rol = (String) session.getAttribute("rol");

    if ("cliente".equals(rol) || rol == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invitación a Registrarse</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.11.1/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="text-center">
        <h1 class="mb-10 md:text-3xl font-bold text-xl">¿Cómo quieres ingresar?</h1>
        <form id="loginForm" class="space-y-6">
            <div class="flex justify-center space-x-10 mb-10">
                <label class="flex flex-col items-center cursor-pointer">
                    <input type="radio" name="role" value="cliente" class="hidden peer" />
                    <div class="peer-checked:border-orange-500 peer-checked:bg-orange-200 peer-checked:cursor-pointer md:w-48 md:h-48 w-32 h-32 rounded-full border-2 bg-white border-orange-200 flex items-center justify-center hover:bg-orange-200">
                        <img src="img/cliente.png" alt="Cliente" class="md:w-36 md:h-36 w-24 h-24 rounded-full">
                    </div>
                    <span class="mt-4 text-lg">Cliente</span>
                </label>
                <label class="flex flex-col items-center cursor-pointer">
                    <input type="radio" name="role" value="administrador" class="hidden peer" />
                    <div class="peer-checked:border-orange-500 peer-checked:bg-orange-200 peer-checked:cursor-pointer md:w-48 md:h-48 w-32 h-32 rounded-full border-2 bg-white border-orange-200 flex items-center justify-center hover:bg-orange-200">
                        <img src="img/administrador.png" alt="Administrador" class="md:w-36 md:h-36 w-24 h-24 rounded-full">
                    </div>
                    <span class="mt-4 text-lg">Administrador</span>
                </label>
            </div>
            <button type="button" class="h-12 px-6 m-2 text-white bg-orange-500 hover:bg-orange-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800" onclick="redirectUser()">Ingresar</button>
        </form>
    </div>
    <script>
        function redirectUser() {
            const selectedRole = document.querySelector('input[name="role"]:checked');
            if (selectedRole) {
                if (selectedRole.value === 'cliente') {
                    window.location.href = 'index.jsp';
                } else if (selectedRole.value === 'administrador') {
                    window.location.href = 'indexpanel.jsp';
                }
            } 
        }
    </script>
</body>
</html>