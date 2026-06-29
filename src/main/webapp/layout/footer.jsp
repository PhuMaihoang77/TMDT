<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-section">
            <h4 class="footer-title">TutorHub</h4>
            <p class="footer-text">Nền tảng kết nối học sinh và gia sư hàng đầu tại Việt Nam</p>
            <div class="social-links">
                <a href="#" class="social-link"><i class="fab fa-facebook"></i></a>
                <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
            </div>
        </div>

        <div class="footer-section">
            <h5 class="footer-subtitle">Cho Học Sinh</h5>
            <ul class="footer-links">
                <li><a href="<c:url value='/tutors'/>">Tìm Gia Sư</a></li>
                <li><a href="<c:url value='/dashboard'/>">Quản Lý Lịch</a></li>
                <li><a href="#">Các Lớp</a></li>
                <li><a href="#">Đánh Giá Gia Sư</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h5 class="footer-subtitle">Cho Gia Sư</h5>
            <ul class="footer-links">
                <li><a href="<c:url value='/register'/>">Trở Thành Gia Sư</a></li>
                <li><a href="<c:url value='/dashboard'/>">Quản Lý Lớp</a></li>
                <li><a href="#">Hướng Dẫn</a></li>
                <li><a href="#">Thanh Toán</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h5 class="footer-subtitle">Hỗ Trợ</h5>
            <ul class="footer-links">
                <li><a href="#">Trung Tâm Trợ Giúp</a></li>
                <li><a href="#">Liên Hệ</a></li>
                <li><a href="#">Điều Khoản Dịch Vụ</a></li>
                <li><a href="#">Chính Sách Riêng Tư</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h5 class="footer-subtitle">Liên Hệ</h5>
            <div class="contact-info">
                <p><i class="fas fa-phone"></i> +84 912 345 678</p>
                <p><i class="fas fa-envelope"></i> support@tutorhub.vn</p>
                <p><i class="fas fa-map-marker-alt"></i> Hà Nội, Việt Nam</p>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <div class="footer-bottom-container">
            <p>&copy; 2024 TutorHub. Tất cả quyền được bảo lưu.</p>
            <div class="footer-badges">
                <span class="badge">100% An Toàn</span>
                <span class="badge">Được Xác Minh</span>
                <span class="badge">Hỗ Trợ 24/7</span>
            </div>
        </div>
    </div>
</footer>