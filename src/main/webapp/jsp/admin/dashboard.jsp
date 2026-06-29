<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <c:choose>
        <c:when test="${sessionScope.account.role == 3}">
            <div class="admin-layout">
                <jsp:include page="/layout/admin-sidebar.jsp"/>
                <main class="admin-content">
        </c:when>
        <c:otherwise>
            <div class="dashboard-wrapper" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
                <main>
        </c:otherwise>
    </c:choose>
            <section class="dashboard-grid">
                <h1>Dashboard</h1>
                
                <c:if test="${sessionScope.account.role == 1}">
                    <!-- Student Dashboard -->
                    <div class="dashboard-cards">
                        <div class="dash-card">
                            <i class="fas fa-calendar-check"></i>
                            <h3>Lớp Sắp Tới</h3>
                            <p class="dash-value">${requestScope.upcomingCount}</p>
                            <a href="#">Xem Chi Tiết</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Gia Sư Yêu Thích</h3>
                            <p class="dash-value">${requestScope.favoriteTutors}</p>
                            <a href="#">Xem Danh Sách</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-wallet"></i>
                            <h3>So Du Tai Khoan</h3>
                            <p class="dash-value">${requestScope.balance}</p>
                            <a href="${pageContext.request.contextPath}/wallet">Quan Ly Vi</a>
                        </div>
                    </div>

                    <div class="section-card">
                        <h2>Lịch Học Gần Đây</h2>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Gia Sư</th>
                                    <th>Khóa Học</th>
                                    <th>Thời Gian</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.studentBookings}">
                                        <c:forEach var="b" items="${requestScope.studentBookings}">
                                            <tr>
                                                <td><strong>${b.tutor.name}</strong></td>
                                                <td>${b.tutor.specialization}</td>
                                                <td>${b.bookingTime}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Đang chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã hủy</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <a href="<c:url value='/booking?action=cancel&amp;id=${b.id}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy đặt lịch này?');">
                                                                <i class="fas fa-times"></i> Hủy
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <a href="${pageContext.request.contextPath}/payment?courseId=${b.courseId}&tutorId=${b.tutorId}" class="btn btn-sm btn-success" style="margin-right: 5px;">
                                                                <i class="fas fa-credit-card"></i> Thanh Toán
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-warning"
                                                                    onclick="openFeedbackModal('${b.id}', '${b.studentId}', '${b.tutorId}', '${b.courseId}', '${b.tutor.name}')">
                                                                <i class="fas fa-exclamation-triangle"></i> Khiếu Nại / Đánh Giá
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--gray-400);">Không có hành động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="5" style="text-align: center;">Chưa có lịch học</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="section-card" style="margin-top: 2rem;">
                        <h2>Lịch Sử Thanh Toán & Hóa Đơn</h2>
                        <div style="text-align:right; margin-bottom: 0.5rem;">
                            <a href="${pageContext.request.contextPath}/wallet" class="btn btn-sm" style="background: linear-gradient(135deg,#6c63ff,#3ecf8e); color:white; padding: 6px 14px; border-radius: 20px; text-decoration:none;">
                                <i class="fas fa-wallet"></i> Quản Lý Ví
                            </a>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mã Giao Dịch</th>
                                    <th>Loại GD</th>
                                    <th>Gia Sư</th>
                                    <th>Số Tiền</th>
                                    <th>Ngày Thanh Toán</th>
                                    <th>Phương Thức</th>
                                    <th>Trạng Thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.payments}">
                                        <c:forEach var="p" items="${requestScope.payments}">
                                            <tr>
                                                <td><strong>${p.id}</strong></td>
                                                <td>
                                                    <span style="font-size:0.8rem; font-weight:600; padding:3px 8px; border-radius:12px;
                                                        background-color: ${p.paymentType eq 'DEPOSIT' ? '#d4edda' : (p.paymentType eq 'WITHDRAW' ? '#f8d7da' : '#cce5ff')};
                                                        color: ${p.paymentType eq 'DEPOSIT' ? '#155724' : (p.paymentType eq 'WITHDRAW' ? '#721c24' : '#004085')};">
                                                        ${p.typeDisplay}
                                                    </span>
                                                </td>
                                                <td>${p.tutor.name}</td>
                                                <td><span style="color: #e74c3c; font-weight: 600;">${p.getSignedFormattedAmount(1)}</span></td>
                                                <td>${p.paymentDate}</td>
                                                <td>${p.methodDisplay}</td>
                                                <td>
                                                    <span class="badge" style="background-color: ${p.status eq 'completed' ? '#2ecc71' : (p.status eq 'pending' ? '#f39c12' : '#e74c3c')}; color: white; padding: 4px 8px; border-radius: 4px;">
                                                        ${p.statusDisplay}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="7" style="text-align: center;">Chưa có lịch sử thanh toán</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${sessionScope.account.role == 2}">
                    <!-- Tutor Dashboard -->
                    <div class="dashboard-cards">
                        <div class="dash-card">
                            <i class="fas fa-users"></i>
                            <h3>Số Học Sinh</h3>
                            <p class="dash-value">${requestScope.totalStudents}</p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-graduation-cap"></i>
                            <h3>Số Lớp Dạy</h3>
                            <p class="dash-value">${requestScope.totalCourses}</p>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-coins"></i>
                            <h3>Thu Nhập (Hoàn Tất)</h3>
                            <p class="dash-value">${requestScope.monthlyIncome}</p>
                        </div>

                        <div class="dash-card" style="cursor:pointer;" onclick="window.location='${pageContext.request.contextPath}/wallet'">
                            <i class="fas fa-wallet" style="color:#6c63ff;"></i>
                            <h3>Số Dư Ví</h3>
                            <p class="dash-value" style="color:#6c63ff;">${requestScope.tutorBalance}</p>
                            <a href="${pageContext.request.contextPath}/wallet" style="font-size:0.8rem;">Rút Tiền &rarr;</a>
                        </div>

                        <div class="dash-card">
                            <i class="fas fa-star"></i>
                            <h3>Đánh Giá Trung Bình</h3>
                            <p class="dash-value">${requestScope.averageRating} / 5</p>
                        </div>
                    </div>


                    <div class="section-card" style="margin-bottom: 2rem;">
                        <h2><i class="fas fa-plus-circle"></i> Tạo Khóa Học Mới</h2>
                        <form action="<c:url value='/dashboard'/>" method="post" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px;">
                            <input type="hidden" name="action" value="createCourse">

                            <div class="form-group">
                                <label>Tên Môn Học</label>
                                <input type="text" name="name" class="form-control" placeholder="VD: Toán Nâng Cao" required style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                            </div>

                            <div class="form-group">
                                <label>Lớp / Trình Độ</label>
                                <input type="text" name="level" class="form-control" placeholder="VD: Lớp 10, IELTS 6.5" required style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                            </div>

                            <div class="form-group">
                                <label>Học Phí (VNĐ / Giờ)</label>
                                <input type="number" name="fee" class="form-control" placeholder="VD: 200000" required style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                            </div>

                            <div class="form-group">
                                <label>Mô tả chi tiết</label>
                                <input type="text" name="description" class="form-control" placeholder="Tóm tắt nội dung học..." required style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                            </div>

                            <div class="form-group" style="grid-column: 1 / -1;">
                                <button type="submit" class="btn btn-primary" style="padding: 10px 20px;"><i class="fas fa-save"></i> Đăng Khóa Học</button>
                            </div>
                        </form>
                    </div>




                    <div class="section-card">
                        <h2>Lịch Dạy</h2>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Học Sinh</th>
                                    <th>Lớp Học</th>
                                    <th>Thời Gian</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.tutorBookings}">
                                        <c:forEach var="b" items="${requestScope.tutorBookings}">
                                            <tr>
                                                <td><strong>${b.student.name}</strong></td>
                                                <td>${b.tutor.specialization}</td>
                                                <td>${b.bookingTime}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Chờ phê duyệt</span>
                                                        </c:when>
                                                        <c:when test="${b.status eq 'confirmed'}">
                                                            <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã từ chối</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'pending'}">
                                                            <a href="${pageContext.request.contextPath}/dashboard?action=confirm&id=${b.id}" class="btn btn-sm btn-success" style="margin-right: 5px;">
                                                                <i class="fas fa-check"></i> Chấp Nhận
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/dashboard?action=cancel&id=${b.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn từ chối lịch học này?');">
                                                                <i class="fas fa-times"></i> Từ Chối
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--gray-400);">Không có hành động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="5" style="text-align: center;">Chưa có lịch dạy</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="section-card" style="margin-top: 2rem;">
                        <h2>Lịch Sử Doanh Thu & Thanh Toán</h2>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mã Hóa Đơn</th>
                                    <th>Loại GD</th>
                                    <th>Học Sinh</th>
                                    <th>Số Tiền</th>
                                    <th>Ngày Thanh Toán</th>
                                    <th>Phương Thức</th>
                                    <th>Trạng Thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.payments}">
                                        <c:forEach var="p" items="${requestScope.payments}">
                                            <tr>
                                                <td><strong>${p.id}</strong></td>
                                                <td>
                                                    <span style="font-size:0.8rem; font-weight:600; padding:3px 8px; border-radius:12px;
                                                        background-color: ${p.paymentType eq 'DEPOSIT' ? '#d4edda' : (p.paymentType eq 'WITHDRAW' ? '#f8d7da' : '#cce5ff')};
                                                        color: ${p.paymentType eq 'DEPOSIT' ? '#155724' : (p.paymentType eq 'WITHDRAW' ? '#721c24' : '#004085')};">
                                                        ${p.typeDisplay}
                                                    </span>
                                                </td>
                                                <td>${p.student.name}</td>
                                                <td><span style="color: #2ecc71; font-weight: 600;">${p.getSignedFormattedAmount(2)}</span></td>
                                                <td>${p.paymentDate}</td>
                                                <td>${p.methodDisplay}</td>
                                                <td>
                                                    <span class="badge" style="background-color: ${p.status eq 'completed' ? '#2ecc71' : (p.status eq 'pending' ? '#f39c12' : '#e74c3c')}; color: white; padding: 4px 8px; border-radius: 4px;">
                                                        ${p.statusDisplay}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="empty-row">
                                            <td colspan="7" style="text-align: center;">Chưa có lịch sử nhận thanh toán</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </section>
        </main>
    </div>
            <jsp:include page="/layout/feedback-modal.jsp"/>
            <jsp:include page="/layout/footer.jsp"/>

            <script src="<c:url value='/js/main.js'/>"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const urlParams = new URLSearchParams(window.location.search);
                    const status = urlParams.get('status');
                    const msgType = urlParams.get('msgType');

                    if (status === 'success') {
                        if (msgType === 'review') {
                            showNotification('Đăng đánh giá công khai thành công!', 'success');
                        } else if (msgType === 'complaint') {
                            showNotification('Gửi khiếu nại tới Ban quản trị thành công!', 'success');
                        }
                        // Xóa param trên url để nhìn chuyên nghiệp hơn
                        window.history.replaceState({}, document.title, window.location.pathname);
                    } else if (status === 'fail') {
                        showNotification('Có lỗi hệ thống xảy ra, vui lòng thực hiện lại!', 'error');
                        window.history.replaceState({}, document.title, window.location.pathname);
                    }
                });
            </script>
</body>
</html>

