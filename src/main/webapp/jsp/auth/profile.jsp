<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/profile.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <main class="page-container">
        <section class="page-header">
            <h1><i class="fas fa-user"></i> Hồ Sơ Cá Nhân</h1>
            <p>Cập nhật thông tin của bạn</p>
        </section>

        <div class="profile-container">
            <c:if test="${not empty requestScope.success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${requestScope.success}</span>
                </div>
            </c:if>

            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${requestScope.error}</span>
                </div>
            </c:if>

            <form action="<c:url value='/profile'/>" method="post" class="profile-form">
                <div class="profile-section">
                    <h3>Thông Tin Cơ Bản</h3>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Họ Tên</label>
                            <input 
                                type="text" 
                                id="name" 
                                name="name" 
                                class="form-input"
                                value="${sessionScope.userProfile.name}"
                                required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input 
                                type="email" 
                                id="email" 
                                class="form-input"
                                value="${sessionScope.account.email}"
                                disabled>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">Điện Thoại</label>
                            <input 
                                type="tel" 
                                id="phone" 
                                name="phone" 
                                class="form-input"
                                value="${sessionScope.userProfile.phone}">
                        </div>

                        <div class="form-group">
                            <label for="address">Địa Chỉ</label>
                            <input 
                                type="text" 
                                id="address" 
                                name="address" 
                                class="form-input"
                                value="${sessionScope.userProfile.address}">
                        </div>
                    </div>
                </div>

                <!-- Student-specific fields -->
                <c:if test="${sessionScope.account.role == 1}">
                    <div class="profile-section">
                        <h3>Thông Tin Học Sinh</h3>

                        <div class="form-group">
                            <label for="description">Giới Thiệu Về Bạn</label>
                            <textarea 
                                id="description" 
                                name="description" 
                                class="form-textarea"
                                placeholder="Mô tả về bạn, nhu cầu học tập..."
                                rows="4">${sessionScope.userProfile.description}</textarea>
                        </div>
                    </div>
                </c:if>

                <!-- Tutor-specific fields -->
                <c:if test="${sessionScope.account.role == 2}">
                    <div class="profile-section">
                        <h3>Thông Tin Gia Sư</h3>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="specialization">Chuyên Ngành</label>
                                <input 
                                    type="text" 
                                    id="specialization" 
                                    name="specialization" 
                                    class="form-input"
                                    value="${sessionScope.userProfile.specialization}"
                                    required>
                            </div>

                            <div class="form-group">
                                <label for="bankName">Tên Ngân Hàng</label>
                                <input 
                                    type="text" 
                                    id="bankName" 
                                    name="bankName" 
                                    class="form-input"
                                    value="${sessionScope.userProfile.bankName}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bankAccountNumber">Số Tài Khoản Ngân Hàng</label>
                            <input 
                                type="text" 
                                id="bankAccountNumber" 
                                name="bankAccountNumber" 
                                class="form-input"
                                value="${sessionScope.userProfile.bankAccountNumber}">
                        </div>

                        <div class="form-group">
                            <label for="description">Giới Thiệu Về Bạn</label>
                            <textarea 
                                id="description" 
                                name="description" 
                                class="form-textarea"
                                placeholder="Mô tả kinh nghiệm, phương pháp dạy..."
                                rows="4">${sessionScope.userProfile.description}</textarea>
                        </div>
                    </div>
                </c:if>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-save"></i> Lưu Thay Đổi
                    </button>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
