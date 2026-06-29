<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/register.css'/>">
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
                <h2>Tạo Tài Khoản Mới Thật Dễ Dàng</h2>
                <p>Tham gia cộng đồng học tập trực tuyến năng động để nâng tầm tri thức ngay hôm nay.</p>

                <div class="banner-stats">
                    <div class="stat-item">
                        <span class="stat-num">10K+</span>
                        <span class="stat-text">Học sinh đã kết nối thành công</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-num">500+</span>
                        <span class="stat-text">Gia sư chất lượng cao sẵn sàng hỗ trợ</span>
                    </div>
                </div>
            </div>
            <div class="banner-footer">
                <span>© 2026 TutorHub Inc.</span>
                <span><i class="fas fa-shield-alt"></i> An toàn tuyệt đối</span>
            </div>
        </div>

        <div class="auth-form-panel">
            <div class="auth-header">
                <h1>Tạo Tài Khoản</h1>
                <p>Chọn vai trò của bạn và điền thông tin bên dưới</p>
            </div>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <div class="role-selector">
                <button type="button" class="role-btn active" data-role="student">
                    <i class="fas fa-user-graduate"></i> Học Sinh
                </button>
                <button type="button" class="role-btn" data-role="tutor">
                    <i class="fas fa-chalkboard-teacher"></i> Gia Sư
                </button>
            </div>

            <form action="<c:url value='/register'/>" method="post" class="auth-form">
                <input type="hidden" id="roleInput" name="role" value="1">

                <div class="form-grid-2">

                    <div class="form-group">
                        <label for="name">Họ và Tên</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user"></i>
                            <input type="text" id="name" name="name" class="form-input" placeholder="Nguyễn Văn A" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số Điện Thoại</label>
                        <div class="input-wrapper">
                            <i class="fas fa-phone"></i>
                            <input type="text" id="phone" name="phone" class="form-input" placeholder="0123456789" required>
                        </div>
                    </div>

                    <div class="form-group col-span-2">
                        <label for="email">Email tài khoản</label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" class="form-input" placeholder="example@email.com" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật Khẩu</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" class="form-input" placeholder="Tối thiểu 6 ký tự" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác Nhận Mật Khẩu</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Xác nhận mật khẩu" required>
                        </div>
                    </div>

                    <div class="form-group col-span-2">
                        <label for="address">Địa Chỉ</label>
                        <div class="input-wrapper">
                            <i class="fas fa-location-dot"></i>
                            <input type="text" id="address" name="address" class="form-input" placeholder="Nhập địa chỉ cư trú" required>
                        </div>
                    </div>

                    <div id="tutorFields" class="col-span-2 form-grid-2" style="display: none; border-top: 1px dashed #e2e8f0; padding-top: 1rem; margin-top: 0.5rem;">

                        <div class="col-span-2" style="font-size: 0.85rem; font-weight: 700; color: var(--primary); display: flex; items-center: center; gap: 0.5rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.25rem;">
                            <i class="fas fa-id-badge" style="font-size: 1rem;"></i> Thông tin bổ sung cho Gia sư
                        </div>

                        <div class="form-group">
                            <label for="birth">Ngày Sinh</label>
                            <div class="input-wrapper">
                                <i class="fas fa-calendar"></i>
                                <input type="date" id="birth" name="birth" class="form-input">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="specialization">Chuyên Môn Giảng Dạy</label>
                            <div class="input-wrapper">
                                <i class="fas fa-book"></i>
                                <input type="text" id="specialization" name="specialization" class="form-input" placeholder="Ví dụ: Toán, Lý, Hóa">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="idCardNumber">Số CCCD</label>
                            <div class="input-wrapper">
                                <i class="fas fa-id-card"></i>
                                <input type="text" id="idCardNumber" name="idCardNumber" class="form-input" placeholder="Nhập số căn cước">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bankName">Tên Ngân Hàng</label>
                            <div class="input-wrapper">
                                <i class="fas fa-building-columns"></i>
                                <input type="text" id="bankName" name="bankName" class="form-input" placeholder="Ví dụ: Vietcombank">
                            </div>
                        </div>

                        <div class="form-group col-span-2">
                            <label for="bankAccountNumber">Số Tài Khoản Ngân Hàng</label>
                            <div class="input-wrapper">
                                <i class="fas fa-credit-card"></i>
                                <input type="text" id="bankAccountNumber" name="bankAccountNumber" class="form-input" placeholder="Nhập số tài khoản ngân hàng">
                            </div>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 0.75rem;">
                    <i class="fas fa-user-plus"></i> Đăng Ký Tài Khoản
                </button>

                <div class="form-divider">
                    <span>Hoặc</span>
                </div>

                <a href="<c:url value='/google-login'/>" class="btn btn-social btn-google btn-block">
                    <i class="fab fa-google"></i> Đăng Ký Bằng Google
                </a>
            </form>

            <div class="auth-footer">
                <p>Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập ngay</a></p>
            </div>
        </div>

    </div>
</div>

<script>
    const roleButtons = document.querySelectorAll('.role-btn');
    const tutorFields = document.getElementById('tutorFields');
    const tutorInputs = tutorFields.querySelectorAll('input');

    roleButtons.forEach(button => {
        button.addEventListener('click', function() {
            roleButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            const role = this.dataset.role === 'student' ? '1' : '2';
            document.getElementById('roleInput').value = role;

            if (role === '2') {
                tutorFields.style.display = 'block';
                tutorInputs.forEach(input => input.setAttribute('required', 'required'));
            } else {
                tutorFields.style.display = 'none';
                tutorInputs.forEach(input => input.removeAttribute('required'));
            }
        });
    });

    document.querySelector('.auth-form').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Mật khẩu xác nhận không khớp');
        }
    });
</script>
<script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>