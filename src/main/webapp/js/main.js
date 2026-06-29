/* ============================================
   Main JavaScript Functionality
   ============================================ */

// Initialize dropdown menus
document.addEventListener('DOMContentLoaded', function() {
    initializeDropdowns();
    initializeMobileMenu();
    initializeFormValidation();
});

// Dropdown menu functionality
function initializeDropdowns() {
    const dropdowns = document.querySelectorAll('.user-dropdown');

    dropdowns.forEach(dropdown => {
        const button = dropdown.querySelector('.user-button');
        if (button) {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                dropdown.classList.toggle('active');
            });
        }
    });

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.user-dropdown')) {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('active');
            });
        }
    });
}

// Mobile menu toggle
function initializeMobileMenu() {
    const toggle = document.querySelector('.mobile-menu-toggle');
    const menu = document.querySelector('.navbar-menu');

    if (toggle && menu) {
        toggle.addEventListener('click', function() {
            menu.classList.toggle('active');
        });
    }
}

// Form validation
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');

    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const emailInputs = form.querySelectorAll('input[type="email"]');
            const passwordInputs = form.querySelectorAll('input[type="password"]');

            // Email validation
            emailInputs.forEach(input => {
                if (input.value && !isValidEmail(input.value)) {
                    e.preventDefault();
                    input.focus();
                    showError(input, 'Email không hợp lệ');
                }
            });

            // Password validation for registration
            if (form.querySelector('input[name="role"]')) {
                const password = form.querySelector('input[name="password"]');
                const confirm = form.querySelector('input[name="confirmPassword"]');

                if (password && confirm && password.value !== confirm.value) {
                    e.preventDefault();
                    confirm.focus();
                    showError(confirm, 'Mật khẩu không trùng khớp');
                }
            }
        });
    });
}

// Email validation helper
function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

// Show error message
function showError(element, message) {
    const parent = element.closest('.form-group') || element.parentElement;

    // Remove existing error
    const existing = parent.querySelector('.error-message');
    if (existing) existing.remove();

    // Add error
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        color: var(--danger);
        font-size: 0.875rem;
        margin-top: 0.25rem;
    `;

    parent.appendChild(errorDiv);

    // Add error state to input
    element.style.borderColor = 'var(--danger)';
    element.addEventListener('input', function() {
        element.style.borderColor = '';
        const error = parent.querySelector('.error-message');
        if (error) error.remove();
    });
}

// Smooth scroll for anchors
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

// Add hover animation to buttons
const buttons = document.querySelectorAll('.btn');
buttons.forEach(btn => {
    btn.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-2px)';
    });

    btn.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});

// Format currency
function formatCurrency(value) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(value);
}

// Format date
function formatDate(date) {
    return new Intl.DateTimeFormat('vi-VN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }).format(new Date(date));
}

// Table row hover effect
const tables = document.querySelectorAll('.data-table tbody tr');
tables.forEach(row => {
    row.addEventListener('mouseenter', function() {
        this.style.backgroundColor = 'rgba(16, 185, 129, 0.05)';
    });

    row.addEventListener('mouseleave', function() {
        this.style.backgroundColor = '';
    });
});

// Notification helper
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        z-index: 1000;
        animation: slideInRight 0.3s ease;
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);


}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100px);
        }
    }
`;
document.head.appendChild(style);

// Export functions for global use
window.formatCurrency = formatCurrency;
window.formatDate = formatDate;
window.showNotification = showNotification;

/* ============================================
   Chức năng Ẩn/Hiện khóa học mượt mà
   ============================================ */

// 1. Dùng cho công tắc TỔNG ở trên cùng
function toggleAllCourses() {
    const isChecked = document.getElementById("global-toggle").checked;
    const wrappers = document.querySelectorAll('.course-list-wrapper');
    const chevrons = document.querySelectorAll('.chevron-icon');

    wrappers.forEach(wrapper => {
        if (isChecked) wrapper.classList.add('show');
        else wrapper.classList.remove('show');
    });

    // Đồng bộ xoay tất cả mũi tên
    chevrons.forEach(chevron => {
        if (isChecked) chevron.classList.add('rotate');
        else chevron.classList.remove('rotate');
    });
}

// 2. Dùng cho thanh click TỪNG GIÁO VIÊN
function toggleSingleCourse(tutorId) {
    const wrapper = document.getElementById('course-wrapper-' + tutorId);
    const chevron = document.getElementById('chevron-' + tutorId);

    // Bật tắt class 'show' để CSS Grid làm hiệu ứng trượt
    if (wrapper.classList.contains('show')) {
        wrapper.classList.remove('show');
        chevron.classList.remove('rotate');
    } else {
        wrapper.classList.add('show');
        chevron.classList.add('rotate');
    }
}

// Export global để JSP gọi được
window.toggleAllCourses = toggleAllCourses;
window.toggleSingleCourse = toggleSingleCourse;
/* ==========================================================================
   BỔ SUNG: XỬ LÝ SỰ KIỆN THÔNG BÁO LOGIN, ERROR VÀ XÁC NHẬN LOGOUT
   ========================================================================== */

document.addEventListener('DOMContentLoaded', function() {
    // 1. Tự động bắt thông báo từ Servlet thông qua URL Parameters (nếu có)
    const urlParams = new URLSearchParams(window.location.search);

    // Nếu Đăng nhập thành công
    if (urlParams.get('loginSuccess') === 'true') {
        showNotification('Đăng nhập thành công! Chào mừng bạn quay trở lại.', 'success');
        // Xóa param trên URL cho sạch thanh địa chỉ
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    // Nếu Đăng xuất thành công
    if (urlParams.get('logoutSuccess') === 'true') {
        showNotification('Bạn đã đăng xuất tài khoản an toàn.', 'success');
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    // 2. Bắt sự kiện Click nút Đăng xuất trên Thanh Menu toàn hệ thống
    // Tìm tất cả thẻ <a> có link chứa cụm từ '/logout'
    const logoutButtons = document.querySelectorAll('a[href*="/logout"], a[href*="logout"]');

    logoutButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Chặn chuyển hướng lập tức để hiển thị hộp thoại hỏi (Confirm)
            e.preventDefault();
            const logoutUrl = this.getAttribute('href');

            // Hiển thị hộp thoại xác nhận chuyên nghiệp
            const confirmLogout = confirm("Bạn có chắc chắn muốn đăng xuất khỏi hệ thống TutorHub không?");
            if (confirmLogout) {
                // Nếu đồng ý, chuyển hướng sang LogoutServlet để xóa Session
                window.location.href = logoutUrl;
            }
        });
    });
});

/* ==========================================================================
   LOGIC SLIDER GIA SƯ NỔI BẬT CHẠY TUẦN HOÀN NỐI ĐUÔI VÔ HẠN (2 GIÂY)
   ========================================================================== */
document.addEventListener('DOMContentLoaded', () => {
    const track = document.getElementById('sliderTrack');
    const container = document.getElementById('sliderContainer');
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (!track || !container) return;

    const originalCards = Array.from(track.children);
    if (originalCards.length === 0 || originalCards[0].classList.contains('empty-state')) return;

    let currentIndex = 0;
    let autoSlideInterval;
    let isTransitioning = false;
    const originalLength = originalCards.length;

    // Nhân bản toàn bộ danh sách thẻ để phục vụ hiệu ứng trượt tuần hoàn nối đuôi
    originalCards.forEach(card => {
        const clone = card.cloneNode(true);
        track.appendChild(clone);
    });

    function getCardWidth() {
        const card = track.querySelector('.slider-card');
        const gap = parseFloat(window.getComputedStyle(track).gap) || 0;
        return card.offsetWidth + gap;
    }

    function move(index, hasAnimation = true) {
        if (isTransitioning && hasAnimation) return;

        if (hasAnimation) {
            track.style.transition = 'transform 0.6s cubic-bezier(0.16, 1, 0.3, 1)';
            isTransitioning = true;
        } else {
            track.style.transition = 'none';
        }

        currentIndex = index;
        const offset = -(currentIndex * getCardWidth());
        track.style.transform = `translateX(${offset}px)`;
    }

    // Lắng nghe sự kiện trượt xong để reset vị trí âm thầm, tạo mạch tuần hoàn vô hạn
    track.addEventListener('transitionend', () => {
        isTransitioning = false;

        // Điểm biên cuối: Trượt qua hết danh sách gốc thì quay lại vị trí thật ban đầu mà không giật hình
        if (currentIndex >= originalLength) {
            move(currentIndex - originalLength, false);
        }
        // Điểm biên đầu: Lùi quá thẻ đầu tiên thì chuyển sang vị trí clone tương ứng ở phía sau
        else if (currentIndex < 0) {
            move(currentIndex + originalLength, false);
        }
    });

    function nextSlide() { move(currentIndex + 1); }
    function prevSlide() { move(currentIndex - 1); }

    function startAutoSlide() {
        clearInterval(autoSlideInterval);
        autoSlideInterval = setInterval(nextSlide, 2000); // 2 giây tự chuyển slide tuần hoàn
    }

    function stopAutoSlide() { clearInterval(autoSlideInterval); }

    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            nextSlide();
            startAutoSlide();
        });
    }

    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            prevSlide();
            startAutoSlide();
        });
    }

    // Tạm dừng khi di chuột vào xem thông tin gia sư, rê chuột ra ngoài tiếp tục chạy
    container.addEventListener('mouseenter', stopAutoSlide);
    container.addEventListener('mouseleave', startAutoSlide);

    // Tự căn chỉnh lại slider khi thay đổi kích thước cửa sổ trình duyệt
    window.addEventListener('resize', () => {
        move(currentIndex, false);
    });

    startAutoSlide();
});