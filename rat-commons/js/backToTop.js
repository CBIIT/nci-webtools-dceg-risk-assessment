document.addEventListener('DOMContentLoaded', () => {
    const backToTopButton = document.querySelector('.usa-footer__return-to-top');

    function toggleBackToTop() {
        // Hide the button if the page height is less than or equal to the viewport height
        if (document.body.scrollHeight <= window.innerHeight) {
            backToTopButton.style.display = 'none';
        } else {
            backToTopButton.style.display = 'flex';
        }
    }

    // Initial check on page load
    toggleBackToTop();

    // Show the button when scrolled down 100px
    window.addEventListener('scroll', () => {
        if (window.scrollY > 100) {
            backToTopButton.style.display = 'flex';
        } else {
            backToTopButton.style.display = 'none';
        }
    });

    // Listen for window resizing (in case content size changes)
    window.addEventListener('resize', toggleBackToTop);

    // Smooth scroll to top when the button is clicked
    backToTopButton.addEventListener('click', (e) => {
        e.preventDefault();
        window.scrollTo({
            top: 0,
            behavior: 'smooth',
        });
    });
});
