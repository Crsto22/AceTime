//BUSQUEDA LINEAL - JAVASCRIPT
                function filterTable() {
                    const input = document.getElementById('searchInput');
                    const filter = input.value.toLowerCase();
                    const table = document.getElementById('purchaseTable');
                    const tr = table.getElementsByTagName('tr');

                    for (let i = 1; i < tr.length; i++) {
                        const dniTd = tr[i].getElementsByTagName('td')[2];
                        if (dniTd) {
                            const dniValue = dniTd.textContent || dniTd.innerText;
                            if (dniValue.toLowerCase().indexOf(filter) > -1) {
                                tr[i].style.display = '';
                            } else {
                                tr[i].style.display = 'none';
                            }
                        }
                    }
                }