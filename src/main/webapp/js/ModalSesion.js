 document.getElementById('openModal').addEventListener('click', function () {
                document.getElementById('modalContainer').classList.remove('hidden');
                document.getElementById('modalContainer').classList.add('block');
            });

            document.getElementById('closeModalButton').addEventListener('click', function () {
                document.getElementById('modalContainer').classList.remove('block');
                document.getElementById('modalContainer').classList.add('hidden');
            });

            document.getElementById('modalContainer').addEventListener('click', function (event) {
                if (event.target.id === 'modalContainer' || event.target.classList.contains('bg-gray-500')) {
                    document.getElementById('modalContainer').classList.remove('block');
                    document.getElementById('modalContainer').classList.add('hidden');
                }
            });

            // Abrir modal de registro desde el enlace en el modal de inicio de sesión
            document.getElementById('createAccountLink').addEventListener('click', function () {
                document.getElementById('modalContainer').classList.remove('block');
                document.getElementById('modalContainer').classList.add('hidden');
                document.getElementById('registroModalContainer').classList.remove('hidden');
                document.getElementById('registroModalContainer').classList.add('block');
            });

            document.getElementById('closeRegistroModalButton').addEventListener('click', function () {
                document.getElementById('registroModalContainer').classList.remove('block');
                document.getElementById('registroModalContainer').classList.add('hidden');
            });

            document.getElementById('registroModalContainer').addEventListener('click', function (event) {
                if (event.target.id === 'registroModalContainer' || event.target.classList.contains('bg-gray-500')) {
                    document.getElementById('registroModalContainer').classList.remove('block');
                    document.getElementById('registroModalContainer').classList.add('hidden');
                }
            });