// ============================================
// WORLD HOTELS - MAIN JAVASCRIPT
// Student: Biplab
// Date: January 12, 2025
// ============================================

// Mobile Menu Toggle
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const navLinks = document.getElementById('navLinks');
    
    if (mobileMenuBtn && navLinks) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('active');
            
            // Animate hamburger menu
            const spans = this.querySelectorAll('span');
            if (navLinks.classList.contains('active')) {
                spans[0].style.transform = 'rotate(45deg) translateY(10px)';
                spans[1].style.opacity = '0';
                spans[2].style.transform = 'rotate(-45deg) translateY(-10px)';
            } else {
                spans[0].style.transform = 'none';
                spans[1].style.opacity = '1';
                spans[2].style.transform = 'none';
            }
        });
        
        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.navbar')) {
                navLinks.classList.remove('active');
                const spans = mobileMenuBtn.querySelectorAll('span');
                spans[0].style.transform = 'none';
                spans[1].style.opacity = '1';
                spans[2].style.transform = 'none';
            }
        });
    }
});

// Flash Message Auto-Close
document.addEventListener('DOMContentLoaded', function() {
    const flashMessages = document.querySelectorAll('.flash-message');
    
    flashMessages.forEach(function(message) {
        // Auto-close after 5 seconds
        setTimeout(function() {
            message.style.opacity = '0';
            setTimeout(function() {
                message.remove();
            }, 300);
        }, 5000);
    });
});

// Form Validation Helper
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function validatePhone(phone) {
    const re = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    return re.test(phone);
}

// Date Validation
function setMinDate(inputId, minDate = null) {
    const input = document.getElementById(inputId);
    if (input) {
        const today = minDate || new Date().toISOString().split('T')[0];
        input.setAttribute('min', today);
    }
}

// Smooth Scroll
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Loading Indicator
function showLoading() {
    const loader = document.createElement('div');
    loader.id = 'loading-overlay';
    loader.innerHTML = '<div class="spinner"></div>';
    loader.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    `;
    document.body.appendChild(loader);
}

function hideLoading() {
    const loader = document.getElementById('loading-overlay');
    if (loader) {
        loader.remove();
    }
}

// Confirm Action
function confirmAction(message) {
    return confirm(message);
}

// Format Currency
function formatCurrency(amount, currency = 'GBP') {
    const symbols = {
        'GBP': '£',
        'USD': '$',
        'EUR': '€',
        'NPR': 'रू'
    };
    return (symbols[currency] || '') + parseFloat(amount).toFixed(2);
}

// Calculate Nights Between Dates
function calculateNights(checkIn, checkOut) {
    const oneDay = 24 * 60 * 60 * 1000;
    const firstDate = new Date(checkIn);
    const secondDate = new Date(checkOut);
    return Math.round(Math.abs((secondDate - firstDate) / oneDay));
}

// Initialize tooltips (if needed)
function initTooltips() {
    const tooltips = document.querySelectorAll('[data-tooltip]');
    tooltips.forEach(el => {
        el.addEventListener('mouseenter', function() {
            const tooltip = document.createElement('div');
            tooltip.className = 'tooltip';
            tooltip.textContent = this.getAttribute('data-tooltip');
            document.body.appendChild(tooltip);
            
            const rect = this.getBoundingClientRect();
            tooltip.style.top = (rect.top - tooltip.offsetHeight - 5) + 'px';
            tooltip.style.left = (rect.left + (rect.width - tooltip.offsetWidth) / 2) + 'px';
        });
        
        el.addEventListener('mouseleave', function() {
            const tooltip = document.querySelector('.tooltip');
            if (tooltip) tooltip.remove();
        });
    });
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    initTooltips();
});

console.log('World Hotels - System Loaded ✓');
// ============================================
// MAIN.JS - Client-side Enhancements
// World Hotels Booking System
// ============================================

document.addEventListener('DOMContentLoaded', function() {
    
    // ========================================
    // Form Loading States
    // ========================================
    
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = form.querySelector('button[type="submit"]');
            
            if (submitBtn && !submitBtn.classList.contains('loading')) {
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;
                
                // Re-enable after 5 seconds (in case of error)
                setTimeout(() => {
                    submitBtn.classList.remove('loading');
                    submitBtn.disabled = false;
                }, 5000);
            }
        });
    });
    
    // ========================================
    // Flash Message Auto-dismiss
    // ========================================
    
    const flashMessages = document.querySelectorAll('.flash-message');
    
    flashMessages.forEach(message => {
        setTimeout(() => {
            message.style.animation = 'fadeOut 0.5s ease-in-out forwards';
            setTimeout(() => {
                message.remove();
            }, 500);
        }, 5000); // 5 seconds
    });
    
    // ========================================
    // Date Input Validation
    // ========================================
    
    const checkInInput = document.querySelector('input[name="check_in"]');
    const checkOutInput = document.querySelector('input[name="check_out"]');
    
    if (checkInInput && checkOutInput) {
        // Set min date to today
        const today = new Date().toISOString().split('T')[0];
        checkInInput.setAttribute('min', today);
        
        // Set max date to 90 days from today
        const maxDate = new Date();
        maxDate.setDate(maxDate.getDate() + 90);
        checkInInput.setAttribute('max', maxDate.toISOString().split('T')[0]);
        
        // Update check-out min when check-in changes
        checkInInput.addEventListener('change', function() {
            const checkInDate = new Date(this.value);
            const nextDay = new Date(checkInDate);
            nextDay.setDate(nextDay.getDate() + 1);
            
            checkOutInput.setAttribute('min', nextDay.toISOString().split('T')[0]);
            
            // Max 30 days from check-in
            const maxCheckOut = new Date(checkInDate);
            maxCheckOut.setDate(maxCheckOut.getDate() + 30);
            checkOutInput.setAttribute('max', maxCheckOut.toISOString().split('T')[0]);
        });
    }
    
    // ========================================
    // Confirm Dialogs for Destructive Actions
    // ========================================
    
    const cancelButtons = document.querySelectorAll('[data-confirm]');
    
    cancelButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const message = this.getAttribute('data-confirm');
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });
    
    // ========================================
    // Smooth Scroll to Top
    // ========================================
    
    const scrollTopBtn = document.getElementById('scrollTopBtn');
    
    if (scrollTopBtn) {
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                scrollTopBtn.style.display = 'block';
            } else {
                scrollTopBtn.style.display = 'none';
            }
        });
        
        scrollTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // ========================================
    // Form Validation Enhancements
    // ========================================
    
    const passwordInput = document.querySelector('input[name="password"]');
    const confirmPasswordInput = document.querySelector('input[name="confirm_password"]');
    
    if (passwordInput && confirmPasswordInput) {
        const validatePasswords = () => {
            if (passwordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.setCustomValidity('Passwords do not match');
            } else {
                confirmPasswordInput.setCustomValidity('');
            }
        };
        
        passwordInput.addEventListener('change', validatePasswords);
        confirmPasswordInput.addEventListener('keyup', validatePasswords);
    }
    
    // ========================================
    // Price Calculation Preview (Booking Form)
    // ========================================
    
    const bookingForm = document.getElementById('bookingForm');
    
    if (bookingForm) {
        const updatePricePreview = () => {
            // This would calculate and show price preview
            // Requires additional implementation
            console.log('Price preview updated');
        };
        
        const dateInputs = bookingForm.querySelectorAll('input[type="date"]');
        dateInputs.forEach(input => {
            input.addEventListener('change', updatePricePreview);
        });
    }
    
    // ========================================
    // Mobile Menu Toggle (if needed)
    // ========================================
    
    const menuToggle = document.querySelector('.menu-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (menuToggle && navMenu) {
        menuToggle.addEventListener('click', function() {
            navMenu.classList.toggle('active');
            this.classList.toggle('active');
        });
    }
    
    console.log('World Hotels - JavaScript loaded successfully! ');
});