 const menuBtn = document.getElementById("menu-btn");
        const sidebar = document.getElementById("sidebar");
        const body = document.body;

        menuBtn.addEventListener("click", (event) => {
            event.stopPropagation();

            sidebar.classList.toggle("-translate-x-full");
            sidebar.classList.toggle("translate-x-0");
        });

        body.addEventListener("click", () => {
            if (!sidebar.classList.contains("-translate-x-full")) {
                sidebar.classList.add("-translate-x-full");
                sidebar.classList.remove("translate-x-0");
            }
        });