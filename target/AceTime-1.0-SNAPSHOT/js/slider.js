 const slider = document.getElementById('slider');
    const prev = document.getElementById('prev');
    const next = document.getElementById('next');

    let currentIndex = 0;
    const totalItems = slider.children.length;

    // Clonar los elementos al inicio para el bucle infinito
    const clonedItems = Array.from(slider.children).map(item => item.cloneNode(true));
    slider.append(...clonedItems);

    function updateSliderPosition() {
        slider.style.transform = `translateX(-${currentIndex * 25}%)`; // 25% por cada item
    }

    function moveToNext() {
        currentIndex++;
        if (currentIndex >= totalItems) {
            currentIndex = 0;
            setTimeout(() => {
                updateSliderPosition();
            }, 20);
        } else {
            updateSliderPosition();
        }
    }

    function moveToPrev() {
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = totalItems - 1;
            setTimeout(() => {
                updateSliderPosition();
            }, 20);
        } else {
            updateSliderPosition();
        }
    }

    prev.addEventListener('click', moveToPrev);
    next.addEventListener('click', moveToNext);

    window.addEventListener('resize', () => {
        updateSliderPosition();
    });

    // Auto slide every 3 seconds
    setInterval(moveToNext, 2000);