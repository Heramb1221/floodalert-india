document.addEventListener('DOMContentLoaded', function() {
    // Toggle password visibility
    const togglePassword = document.querySelector('.toggle-password');
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    }
    
    // Password strength indicator
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            const strengthMeter = document.querySelector('.strength-meter');
            const strengthText = document.querySelector('.strength-text');
            const password = this.value;
            let strength = 0;
            
            // Check password length
            if (password.length >= 8) strength++;
            
            // Check for uppercase letters
            if (/[A-Z]/.test(password)) strength++;
            
            // Check for numbers
            if (/[0-9]/.test(password)) strength++;
            
            // Check for special characters
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            // Update strength meter
            switch(strength) {
                case 0:
                case 1:
                    strengthMeter.style.width = '25%';
                    strengthMeter.style.backgroundColor = 'var(--warning-red)';
                    strengthText.textContent = 'Weak';
                    break;
                case 2:
                    strengthMeter.style.width = '50%';
                    strengthMeter.style.backgroundColor = 'var(--warning-orange)';
                    strengthText.textContent = 'Moderate';
                    break;
                case 3:
                    strengthMeter.style.width = '75%';
                    strengthMeter.style.backgroundColor = 'var(--safe-green)';
                    strengthText.textContent = 'Strong';
                    break;
                case 4:
                    strengthMeter.style.width = '100%';
                    strengthMeter.style.backgroundColor = 'var(--safe-green)';
                    strengthText.textContent = 'Very Strong';
                    break;
            }
        });
    }
    
    // Generate water drops
    function createWaterDrops() {
        const container = document.querySelector('.auth-illustration');
        if (!container) return;
        
        for (let i = 0; i < 5; i++) {
            const drop = document.createElement('div');
            drop.className = 'water-drop';
            
            const size = Math.random() * 15 + 10;
            const left = Math.random() * 90;
            const top = Math.random() * 90;
            const delay = Math.random() * 8;
            
            drop.style.width = `${size}px`;
            drop.style.height = `${size}px`;
            drop.style.left = `${left}%`;
            drop.style.top = `${top}%`;
            drop.style.animationDelay = `${delay}s`;
            
            container.appendChild(drop);
        }
    }
    
    createWaterDrops();
    
    // Form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match');
                return false;
            }
            
            if (!terms) {
                e.preventDefault();
                alert('You must agree to the terms and conditions');
                return false;
            }
            
            return true;
        });
    }
});