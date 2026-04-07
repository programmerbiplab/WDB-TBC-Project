// Hotels Page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    
    // Prevent image flickering - smooth loading
    const hotelImages = document.querySelectorAll('.hotel-image img');
    
    hotelImages.forEach(img => {
        // Add loading class
        img.style.opacity = '0';
        img.style.transition = 'opacity 0.3s ease-in-out';
        
        // When image loads, fade it in
        img.addEventListener('load', function() {
            setTimeout(() => {
                this.style.opacity = '1';
            }, 50);
        });
        
        // Handle errors gracefully
        img.addEventListener('error', function() {
            // Image failed to load, but placeholder emoji will show
            this.style.opacity = '0';
        });
    });
    
    // Smooth scroll for filter results
    const filterForm = document.querySelector('.filters-form');
    if (filterForm) {
        filterForm.addEventListener('submit', function() {
            // Show loading state
            const submitBtn = this.querySelector('.btn-filter');
            if (submitBtn) {
                submitBtn.textContent = 'Loading...';
                submitBtn.style.opacity = '0.7';
            }
        });
    }
    
    // Auto-submit filters on select change (optional enhancement)
    const autoSubmitSelects = document.querySelectorAll('.filter-group select');
    autoSubmitSelects.forEach(select => {
        select.addEventListener('change', function() {
            // Add a small delay for better UX
            setTimeout(() => {
                this.closest('form').submit();
            }, 300);
        });
    });
});