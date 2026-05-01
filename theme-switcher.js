(function() {
    // Apply theme immediately to prevent flash
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'light') {
        document.documentElement.classList.add('light-mode');
    }

    // Export function for toggle buttons
    window.toggleTheme = function() {
        const isLight = document.documentElement.classList.toggle('light-mode');
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
        
        // Update toggle button UI if it exists on the page
        const toggleBtn = document.getElementById('themeToggle');
        if (toggleBtn) {
            toggleBtn.innerText = isLight ? 'Switch to Dark Mode' : 'Switch to Light Mode';
        }
    };
})();
