function filterTable() {
    // Obtiene el valor de búsqueda y lo convierte a minúsculas
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();

    // Obtiene la tabla y todas las filas del cuerpo
    const table = document.getElementById('purchaseTable');
    const rows = table.getElementsByTagName('tr');

    // Itera sobre todas las filas (excepto la primera que es el encabezado)
    for (let i = 1; i < rows.length; i++) {
        const cells = rows[i].getElementsByTagName('td');
        let shouldShowRow = false;

        // Verifica si alguna de las celdas de la segunda columna (nombre del cliente) contiene el texto de búsqueda
        if (cells.length > 1) {
            const clientCell = cells[1];
            const clientText = clientCell.textContent || clientCell.innerText;

            if (clientText.toLowerCase().indexOf(filter) > -1) {
                shouldShowRow = true;
            }
        }

        // Muestra u oculta la fila según el resultado de la búsqueda
        rows[i].style.display = shouldShowRow ? '' : 'none';
    }
}