//BUSQUEDA LINEAL - JAVASCRIPT
                function filterTable() {
                    const input = document.getElementById('searchInput');
                    const filter = input.value.toLowerCase();
                    const table = document.getElementById('purchaseTable');
                    const tr = table.getElementsByTagName('tr');

                    for (let i = 1; i < tr.length; i++) {
                        const idTd = tr[i].getElementsByTagName('td')[0];
                        const dniTd = tr[i].getElementsByTagName('td')[2];
                        if (idTd || dniTd) {
                            const idValue = idTd.textContent || idTd.innerText;
                            const dniValue = dniTd.textContent || dniTd.innerText;
                            if (idValue.toLowerCase().indexOf(filter) > -1 || dniValue.toLowerCase().indexOf(filter) > -1) {
                                tr[i].style.display = '';
                            } else {
                                tr[i].style.display = 'none';
                            }
                        }
                    }
                }