 document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('.registroForm');
    const regex = /^\S+$/; // Expresión regular para verificar una sola palabra (sin espacios)

    forms.forEach(form => {
        const nombreUsuarioInput = form.querySelector('.nombreUsuario');
        const errorNombreUsuario = form.querySelector('.errorNombreUsuario');

        form.addEventListener('submit', function(event) {
            const nombreUsuarioValue = nombreUsuarioInput.value.trim();

            if (!regex.test(nombreUsuarioValue)) {
                errorNombreUsuario.classList.remove('hidden');
                event.preventDefault(); // Prevenir envío del formulario
            } else {
                errorNombreUsuario.classList.add('hidden');
            }
        });

        // Limpiar el mensaje de error al cambiar el valor del campo
        nombreUsuarioInput.addEventListener('input', function() {
            if (regex.test(nombreUsuarioInput.value.trim())) {
                errorNombreUsuario.classList.add('hidden');
            }
        });
    });
});