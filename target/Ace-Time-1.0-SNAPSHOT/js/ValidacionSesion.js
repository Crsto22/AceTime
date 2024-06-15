
        document.getElementById('registroForm').addEventListener('submit', function(event) {
            const nombreUsuario = document.getElementById('nombreUsuario').value;
            const errorNombreUsuario = document.getElementById('errorNombreUsuario');
            const regex = /^\S+$/; // Expresión regular para verificar una sola palabra (sin espacios)

            if (!regex.test(nombreUsuario)) {
                errorNombreUsuario.classList.remove('hidden');
                event.preventDefault(); // Prevenir envío del formulario
            } else {
                errorNombreUsuario.classList.add('hidden');
            }
        });
