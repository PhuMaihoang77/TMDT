<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/login.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
<div class="auth-container">
    <div class="auth-card-split">

        <div class="auth-banner-panel">
            <div class="banner-logo">
                <i class="fas fa-graduation-cap"></i>
                <span>TutorHub</span>
            </div>
            <div class="banner-middle">
                <h2>Học Tập Hiệu Quả Cùng Gia Sư Toàn Diện</h2>
                <p>Nền tảng kết nối Học sinh & Gia sư chuyên nghiệp, uy tín hàng đầu Việt Nam.</p>

                <div class="banner-stats">
                    <div class="stat-item">
                        <span class="stat-num">10K+</span>
                        <span class="stat-text">Học sinh đã tìm thấy lớp học phù hợp</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-num">500+</span>
                        <span class="stat-text">Gia sư chất lượng cao đã kiểm duyệt hồ sơ</span>
                    </div>
                </div>
            </div>
            <div class="banner-footer">
                <span>© 2026 TutorHub Inc.</span>
                <span><i class="fas fa-shield-alt"></i> Bảo mật 100%</span>
            </div>
        </div>

        <div class="auth-form-panel">
            <div class="auth-header">
                <h1>Đăng Nhập</h1>
                <p>Chào mừng bạn quay trở lại với TutorHub!</p>
            </div>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <form action="<c:url value='/login'/>" method="post" class="auth-form">
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="example@email.com" value="${requestScope.email}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox">
                        <input type="checkbox" name="remember">
                        <span>Ghi nhớ tôi</span>
                    </label>
                    <a href="#" class="forgot-link">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                </button>

                <div class="form-divider">
                    <span>Hoặc</span>
                </div>

                <a href="<c:url value='/google-login'/>" class="btn btn-social btn-google btn-block">
                    <i class="fab fa-google"></i> Đăng Nhập Với Google
                </a>
            </form>

            <div class="auth-footer">
                <p>Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký ngay</a></p>
            </div>
        </div>

    </div>
</div>
<script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>