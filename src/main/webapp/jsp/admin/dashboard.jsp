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
            <jsp:include page="/layout/header.jsp" />

            <c:if test="${sessionScope.account.role == 3}">
                <div class="admin-layout">
                    <jsp:include page="/layout/admin-sidebar.jsp" />
                    <main class="admin-content">
                        <section class="dashboard-grid">
                            <h1>Dashboard</h1>
                            <!-- Admin Dashboard -->
                            <div class="dashboard-cards">
                                <div class="dash-card">
                                    <i class="fas fa-wallet"
                                        style="background: rgba(46, 204, 113, 0.12); color: #2ecc71; font-size: 1.5rem; display: flex; align-items: center; justify-content: center; width: 50px; height: 50px; border-radius: 12px;"></i>
                                    <h3 style="margin-top: 10px;">Tổng Doanh Thu</h3>
                                    <p class="dash-value"
                                        style="color: #2ecc71; font-size: 1.8rem; font-weight: 700; margin: 0;">
                                        ${requestScope.totalRevenue}</p>
                                    <a href="${pageContext.request.contextPath}/admin/payments"
                                        style="color: #2ecc71; text-decoration: none; font-size: 0.9rem;">Quản lý giao
                                        dịch
                                        &rarr;</a>
                                </div>

                                <div class="dash-card">
                                    <i class="fas fa-users"
                                        style="background: rgba(52, 152, 219, 0.12); color: #3498db; font-size: 1.5rem; display: flex; align-items: center; justify-content: center; width: 50px; height: 50px; border-radius: 12px;"></i>
                                    <h3 style="margin-top: 10px;">Tổng Người Dùng</h3>
                                    <p class="dash-value"
                                        style="color: #3498db; font-size: 1.8rem; font-weight: 700; margin: 0;">
                                        ${requestScope.totalUsers}</p>
                                    <a href="${pageContext.request.contextPath}/admin/users"
                                        style="color: #3498db; text-decoration: none; font-size: 0.9rem;">Quản lý người
                                        dùng
                                        &rarr;</a>
                                </div>

                                <div class="dash-card">
                                    <i class="fas fa-user-clock"
                                        style="background: rgba(241, 196, 15, 0.12); color: #f1c40f; font-size: 1.5rem; display: flex; align-items: center; justify-content: center; width: 50px; height: 50px; border-radius: 12px;"></i>
                                    <h3 style="margin-top: 10px;">Gia Sư Chờ Duyệt</h3>
                                    <p class="dash-value"
                                        style="color: #f1c40f; font-size: 1.8rem; font-weight: 700; margin: 0;">
                                        ${requestScope.pendingTutorsCount}</p>
                                    <a href="${pageContext.request.contextPath}/admin/tutors"
                                        style="color: #f1c40f; text-decoration: none; font-size: 0.9rem;">Duyệt hồ sơ
                                        &rarr;</a>
                                </div>

                                <div class="dash-card">
                                    <i class="fas fa-calendar-alt"
                                        style="background: rgba(155, 89, 182, 0.12); color: #9b59b6; font-size: 1.5rem; display: flex; align-items: center; justify-content: center; width: 50px; height: 50px; border-radius: 12px;"></i>
                                    <h3 style="margin-top: 10px;">Tổng Lịch Đặt</h3>
                                    <p class="dash-value"
                                        style="color: #9b59b6; font-size: 1.8rem; font-weight: 700; margin: 0;">
                                        ${requestScope.totalBookings}</p>
                                    <a href="${pageContext.request.contextPath}/admin/complaints"
                                        style="color: #9b59b6; text-decoration: none; font-size: 0.9rem;">Khiếu nại &
                                        Lịch
                                        &rarr;</a>
                                </div>
                            </div>

                            <!-- Statistics Charts Row -->
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 2rem; margin-top: 1rem;">
                                <!-- Column Chart: Revenue Over Time -->
                                <div class="section-card"
                                    style="background: white; padding: 1.5rem; border-radius: 1rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 10px;">
                                        <h2
                                            style="font-size: 1.25rem; margin: 0; display: flex; align-items: center; gap: 8px;">
                                            <i class="fas fa-chart-bar" style="color: #3498db;"></i> Doanh Thu Theo Thời
                                            Gian
                                        </h2>
                                        <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                                            <select id="revenueYearFilter" class="form-control"
                                                style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem; display: none;">
                                                <!-- Will populate dynamically -->
                                            </select>
                                            <div id="customDateContainer"
                                                style="display: none; gap: 10px; align-items: center;">
                                                <input type="date" id="revenueStartDate" class="form-control"
                                                    style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem; font-family: inherit;">
                                                <span style="font-size: 0.9rem; color: #64748b;">đến</span>
                                                <input type="date" id="revenueEndDate" class="form-control"
                                                    style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem; font-family: inherit;">
                                            </div>
                                            <select id="revenueTimeFilter" class="form-control"
                                                style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem;">
                                                <option value="7days">7 ngày qua</option>
                                                <option value="30days">30 ngày qua</option>
                                                <option value="monthly">Theo tháng trong năm</option>
                                                <option value="yearly">Theo năm</option>
                                                <option value="custom">Tùy chọn ngày</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div style="position: relative; height: 320px; width: 100%;">
                                        <canvas id="revenueColumnChart"></canvas>
                                    </div>
                                </div>

                                <!-- Pie Chart: Subject Revenue Distribution -->
                                <div class="section-card"
                                    style="background: white; padding: 1.5rem; border-radius: 1rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 10px;">
                                        <h2
                                            style="font-size: 1.25rem; margin: 0; display: flex; align-items: center; gap: 8px;">
                                            <i class="fas fa-chart-pie" style="color: #e74c3c;"></i> Doanh Thu Theo Môn
                                            Học
                                        </h2>
                                        <input type="month" id="pieMonthFilter" class="form-control"
                                            style="padding: 6px 12px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 0.9rem; font-family: inherit;">
                                    </div>
                                    <div style="position: relative; height: 320px; width: 100%;">
                                        <canvas id="revenuePieChart"></canvas>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Pending Tutors and Recent Bookings list -->
                            <div
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 2rem; margin-top: 2rem;">
                                <div class="section-card"
                                    style="background: white; padding: 1.5rem; border-radius: 1rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                                    <h2
                                        style="font-size: 1.2rem; margin-bottom: 1rem; display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-user-check" style="color: #2ecc71;"></i> Gia Sư Chờ Xác Minh
                                    </h2>
                                    <table class="data-table"
                                        style="font-size: 0.9rem; width: 100%; border-collapse: collapse;">
                                        <thead>
                                            <tr>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Họ Tên</th>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Chuyên Môn</th>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty requestScope.pendingTutors}">
                                                    <c:forEach var="tut" items="${requestScope.pendingTutors}"
                                                        varStatus="loop">
                                                        <c:if test="${loop.index < 4}">
                                                            <tr>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    <strong>${tut.name}</strong>
                                                                </td>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    ${tut.specialization}</td>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    <a href="${pageContext.request.contextPath}/admin/tutors"
                                                                        class="btn btn-sm btn-primary"
                                                                        style="padding: 4px 8px; font-size: 0.8rem; border-radius: 4px; background: #3498db; color: white; text-decoration: none;">Xem</a>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="3"
                                                            style="text-align: center; color: #94a3b8; padding: 15px;">
                                                            Không có
                                                            gia sư chờ xác minh</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="section-card"
                                    style="background: white; padding: 1.5rem; border-radius: 1rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                                    <h2
                                        style="font-size: 1.2rem; margin-bottom: 1rem; display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-history" style="color: #9b59b6;"></i> Lịch Đặt Gần Đây
                                    </h2>
                                    <table class="data-table"
                                        style="font-size: 0.9rem; width: 100%; border-collapse: collapse;">
                                        <thead>
                                            <tr>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Mã Lịch</th>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Người Đặt</th>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Thời Gian</th>
                                                <th
                                                    style="text-align: left; padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                    Trạng Thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty requestScope.recentBookings}">
                                                    <c:forEach var="b" items="${requestScope.recentBookings}"
                                                        varStatus="loop">
                                                        <c:if test="${loop.index < 4}">
                                                            <tr>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    <code>${b.id}</code>
                                                                </td>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    ${b.student.name}</td>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    ${b.bookingTime}</td>
                                                                <td
                                                                    style="padding: 10px; border-bottom: 1px solid #e2e8f0;">
                                                                    <span
                                                                        class="badge-status-sm ${b.status eq 'confirmed' ? 'badge-status-sm-confirmed' : (b.status eq 'pending' ? 'badge-status-sm-pending' : 'badge-status-sm-failed')}">
                                                                        ${b.status eq 'confirmed' ? 'Đã duyệt' :
                                                                        (b.status eq 'pending' ? 'Chờ duyệt' : 'Đã
                                                                        hủy')}
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="4"
                                                            style="text-align: center; color: #94a3b8; padding: 15px;">
                                                            Chưa có
                                                            lịch đặt nào</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                        </section>
                    </main>
                </div>
            </c:if>

            <c:if test="${sessionScope.account.role != 3}">
                <div class="dashboard-wrapper" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
                    <main>
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
                                                                        <span class="badge badge-warning"
                                                                            style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Đang
                                                                            chờ duyệt</span>
                                                                    </c:when>
                                                                    <c:when test="${b.status eq 'confirmed'}">
                                                                        <span class="badge badge-success"
                                                                            style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã
                                                                            xác nhận</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-danger"
                                                                            style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã
                                                                            hủy</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${b.status eq 'pending'}">
                                                                        <a href="<c:url value='/booking?action=cancel&amp;id=${b.id}'/>"
                                                                            class="btn btn-sm btn-danger"
                                                                            onclick="return confirm('Bạn có chắc chắn muốn hủy đặt lịch này?');">
                                                                            <i class="fas fa-times"></i> Hủy
                                                                        </a>
                                                                    </c:when>
                                                                    <c:when test="${b.status eq 'confirmed'}">
                                                                        <a href="${pageContext.request.contextPath}/payment?courseId=${b.courseId}&tutorId=${b.tutorId}"
                                                                            class="btn btn-sm btn-success"
                                                                            style="margin-right: 5px;">
                                                                            <i class="fas fa-credit-card"></i> Thanh
                                                                            Toán
                                                                        </a>
                                                                        <button type="button"
                                                                            class="btn btn-sm btn-warning"
                                                                            onclick="openFeedbackModal('${b.id}', '${b.studentId}', '${b.tutorId}', '${b.courseId}', '${b.tutor.name}')">
                                                                            <i class="fas fa-exclamation-triangle"></i>
                                                                            Khiếu Nại /
                                                                            Đánh Giá
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span style="color: var(--gray-400);">Không có
                                                                            hành
                                                                            động</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr class="empty-row">
                                                        <td colspan="5" style="text-align: center;">Chưa có lịch học
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="section-card" style="margin-top: 2rem;">
                                    <h2>Lịch Sử Thanh Toán & Hóa Đơn</h2>
                                    <div style="text-align:right; margin-bottom: 0.5rem;">
                                        <a href="${pageContext.request.contextPath}/wallet" class="btn btn-sm"
                                            style="background: linear-gradient(135deg,#6c63ff,#3ecf8e); color:white; padding: 6px 14px; border-radius: 20px; text-decoration:none;">
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
                                                                <span
                                                                    class="badge-payment ${p.paymentType eq 'DEPOSIT' ? 'badge-payment-deposit' : (p.paymentType eq 'WITHDRAW' ? 'badge-payment-withdraw' : 'badge-payment-other')}">
                                                                    ${p.typeDisplay}
                                                                </span>
                                                            </td>
                                                            <td>${p.tutor.name}</td>
                                                            <td><span
                                                                    style="color: #e74c3c; font-weight: 600;">${p.getSignedFormattedAmount(1)}</span>
                                                            </td>
                                                            <td>${p.paymentDate}</td>
                                                            <td>${p.methodDisplay}</td>
                                                            <td>
                                                                <span
                                                                    class="badge-status ${p.status eq 'completed' ? 'badge-status-completed' : (p.status eq 'pending' ? 'badge-status-pending' : 'badge-status-failed')}">
                                                                    ${p.statusDisplay}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr class="empty-row">
                                                        <td colspan="7" style="text-align: center;">Chưa có lịch sử
                                                            thanh toán</td>
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

                                    <div class="dash-card" style="cursor:pointer;"
                                        onclick="window.location='${pageContext.request.contextPath}/wallet'">
                                        <i class="fas fa-wallet" style="color:#6c63ff;"></i>
                                        <h3>Số Dư Ví</h3>
                                        <p class="dash-value" style="color:#6c63ff;">${requestScope.tutorBalance}</p>
                                        <a href="${pageContext.request.contextPath}/wallet"
                                            style="font-size:0.8rem;">Rút Tiền
                                            &rarr;</a>
                                    </div>

                                    <div class="dash-card">
                                        <i class="fas fa-star"></i>
                                        <h3>Đánh Giá Trung Bình</h3>
                                        <p class="dash-value">${requestScope.averageRating} / 5</p>
                                    </div>
                                </div>


                                <div class="section-card" style="margin-bottom: 2rem;">
                                    <h2><i class="fas fa-plus-circle"></i> Tạo Khóa Học Mới</h2>
                                    <form action="<c:url value='/dashboard'/>" method="post"
                                        style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px;">
                                        <input type="hidden" name="action" value="createCourse">

                                        <div class="form-group">
                                            <label>Tên Môn Học</label>
                                            <input type="text" name="name" class="form-control"
                                                placeholder="VD: Toán Nâng Cao" required
                                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                                        </div>

                                        <div class="form-group">
                                            <label>Lớp / Trình Độ</label>
                                            <input type="text" name="level" class="form-control"
                                                placeholder="VD: Lớp 10, IELTS 6.5" required
                                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                                        </div>

                                        <div class="form-group">
                                            <label>Học Phí (VNĐ / Giờ)</label>
                                            <input type="number" name="fee" class="form-control"
                                                placeholder="VD: 200000" required
                                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                                        </div>

                                        <div class="form-group">
                                            <label>Mô tả chi tiết</label>
                                            <input type="text" name="description" class="form-control"
                                                placeholder="Tóm tắt nội dung học..." required
                                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ccc;">
                                        </div>

                                        <div class="form-group" style="grid-column: 1 / -1;">
                                            <button type="submit" class="btn btn-primary" style="padding: 10px 20px;"><i
                                                    class="fas fa-save"></i> Đăng Khóa Học</button>
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
                                                                        <span class="badge badge-warning"
                                                                            style="background-color: #f39c12; color: white; padding: 4px 8px; border-radius: 4px;">Chờ
                                                                            phê duyệt</span>
                                                                    </c:when>
                                                                    <c:when test="${b.status eq 'confirmed'}">
                                                                        <span class="badge badge-success"
                                                                            style="background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px;">Đã
                                                                            xác nhận</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge badge-danger"
                                                                            style="background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px;">Đã
                                                                            từ chối</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${b.status eq 'pending'}">
                                                                        <a href="${pageContext.request.contextPath}/dashboard?action=confirm&id=${b.id}"
                                                                            class="btn btn-sm btn-success"
                                                                            style="margin-right: 5px;">
                                                                            <i class="fas fa-check"></i> Chấp Nhận
                                                                        </a>
                                                                        <a href="${pageContext.request.contextPath}/dashboard?action=cancel&id=${b.id}"
                                                                            class="btn btn-sm btn-danger"
                                                                            onclick="return confirm('Bạn có chắc muốn từ chối lịch học này?');">
                                                                            <i class="fas fa-times"></i> Từ Chối
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span style="color: var(--gray-400);">Không có
                                                                            hành
                                                                            động</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr class="empty-row">
                                                        <td colspan="5" style="text-align: center;">Chưa có lịch dạy
                                                        </td>
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
                                                                <span
                                                                    class="badge-payment ${p.paymentType eq 'DEPOSIT' ? 'badge-payment-deposit' : (p.paymentType eq 'WITHDRAW' ? 'badge-payment-withdraw' : 'badge-payment-other')}">
                                                                    ${p.typeDisplay}
                                                                </span>
                                                            </td>
                                                            <td>${p.student.name}</td>
                                                            <td><span
                                                                    style="color: #2ecc71; font-weight: 600;">${p.getSignedFormattedAmount(2)}</span>
                                                            </td>
                                                            <td>${p.paymentDate}</td>
                                                            <td>${p.methodDisplay}</td>
                                                            <td>
                                                                <span
                                                                    class="badge-status ${p.status eq 'completed' ? 'badge-status-completed' : (p.status eq 'pending' ? 'badge-status-pending' : 'badge-status-failed')}">
                                                                    ${p.statusDisplay}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr class="empty-row">
                                                        <td colspan="7" style="text-align: center;">Chưa có lịch sử nhận
                                                            thanh toán
                                                        </td>
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
            </c:if>
            <jsp:include page="/layout/feedback-modal.jsp" />
            <jsp:include page="/layout/footer.jsp" />

            <script src="<c:url value='/js/main.js'/>"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
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

            <c:if test="${sessionScope.account.role == 3}">
                <!-- Chart.js CDN -->
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Populate year options dynamically (from 2024 to current year)
                        const yearSelect = document.getElementById('revenueYearFilter');
                        const currentYear = new Date().getFullYear();
                        for (let y = currentYear; y >= 2024; y--) {
                            const opt = document.createElement('option');
                            opt.value = y;
                            opt.textContent = "Năm " + y;
                            yearSelect.appendChild(opt);
                        }

                        // Set initial month for pie chart to current month
                        const monthInput = document.getElementById('pieMonthFilter');
                        const today = new Date();
                        const currentMonthStr = today.getFullYear() + '-' + String(today.getMonth() + 1).padStart(2, '0');
                        monthInput.value = currentMonthStr;

                        // Set initial date range for custom filter to last 7 days
                        const startDateInput = document.getElementById('revenueStartDate');
                        const endDateInput = document.getElementById('revenueEndDate');
                        const oneWeekAgo = new Date();
                        oneWeekAgo.setDate(today.getDate() - 6);

                        const formatDateStr = (date) => {
                            return date.getFullYear() + '-' + String(date.getMonth() + 1).padStart(2, '0') + '-' + String(date.getDate()).padStart(2, '0');
                        };
                        startDateInput.value = formatDateStr(oneWeekAgo);
                        endDateInput.value = formatDateStr(today);

                        // Chart instances
                        let columnChart = null;
                        let pieChart = null;

                        // Fetch and render Column Chart
                        function fetchColumnChartData() {
                            const type = document.getElementById('revenueTimeFilter').value;
                            const year = yearSelect.value;
                            const customDateContainer = document.getElementById('customDateContainer');

                            // Show/hide year/date selectors depending on filter type
                            if (type === 'monthly') {
                                yearSelect.style.display = 'block';
                                customDateContainer.style.display = 'none';
                            } else if (type === 'custom') {
                                yearSelect.style.display = 'none';
                                customDateContainer.style.display = 'flex';
                            } else {
                                yearSelect.style.display = 'none';
                                customDateContainer.style.display = 'none';
                            }

                            let url = '${pageContext.request.contextPath}/admin/api/revenue?type=' + type + '&year=' + year;
                            if (type === 'custom') {
                                url += '&startDate=' + startDateInput.value + '&endDate=' + endDateInput.value;
                            }

                            fetch(url)
                                .then(response => response.json())
                                .then(data => {
                                    const labels = data.map(item => item.label);
                                    const values = data.map(item => item.value);

                                    if (columnChart) {
                                        columnChart.destroy();
                                    }

                                    const ctx = document.getElementById('revenueColumnChart').getContext('2d');
                                    columnChart = new Chart(ctx, {
                                        type: 'bar',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                label: 'Doanh Thu',
                                                data: values,
                                                backgroundColor: 'rgba(52, 152, 219, 0.85)',
                                                borderColor: '#3498db',
                                                borderWidth: 1,
                                                borderRadius: 6,
                                                barPercentage: 0.6
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: {
                                                    display: false
                                                },
                                                tooltip: {
                                                    callbacks: {
                                                        label: function (context) {
                                                            let label = context.dataset.label || '';
                                                            if (label) {
                                                                label += ': ';
                                                            }
                                                            if (context.parsed.y !== null) {
                                                                label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                                            }
                                                            return label;
                                                        }
                                                    }
                                                }
                                            },
                                            scales: {
                                                y: {
                                                    beginAtZero: true,
                                                    ticks: {
                                                        callback: function (value) {
                                                            return new Intl.NumberFormat('vi-VN', { notation: 'compact' }).format(value);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                })
                                .catch(error => console.error('Lỗi khi lấy dữ liệu biểu đồ cột:', error));
                        }

                        // Fetch and render Pie Chart
                        function fetchPieChartData() {
                            const monthVal = monthInput.value; // format: YYYY-MM
                            if (!monthVal) return;

                            const parts = monthVal.split('-');
                            const year = parts[0];
                            const month = parts[1];

                            const url = '${pageContext.request.contextPath}/admin/api/pie-revenue?month=' + month + '&year=' + year;
                            fetch(url)
                                .then(response => response.json())
                                .then(data => {
                                    const labels = data.map(item => item.label);
                                    const values = data.map(item => item.value);

                                    if (pieChart) {
                                        pieChart.destroy();
                                    }

                                    const ctx = document.getElementById('revenuePieChart').getContext('2d');

                                    if (data.length === 0) {
                                        ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
                                        ctx.font = '15px sans-serif';
                                        ctx.fillStyle = '#64748b';
                                        ctx.textAlign = 'center';
                                        ctx.textBaseline = 'middle';
                                        ctx.fillText('Không có dữ liệu doanh thu trong tháng này', ctx.canvas.width / 2, ctx.canvas.height / 2);
                                        return;
                                    }

                                    pieChart = new Chart(ctx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                data: values,
                                                backgroundColor: [
                                                    'rgba(46, 204, 113, 0.85)',
                                                    'rgba(52, 152, 219, 0.85)',
                                                    'rgba(155, 89, 182, 0.85)',
                                                    'rgba(241, 196, 15, 0.85)',
                                                    'rgba(230, 126, 34, 0.85)',
                                                    'rgba(231, 76, 60, 0.85)',
                                                    'rgba(149, 165, 166, 0.85)'
                                                ],
                                                borderWidth: 2,
                                                borderColor: '#ffffff'
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: {
                                                    position: 'right',
                                                    labels: {
                                                        font: {
                                                            size: 11
                                                        },
                                                        boxWidth: 12
                                                    }
                                                },
                                                tooltip: {
                                                    callbacks: {
                                                        label: function (context) {
                                                            let label = context.label || '';
                                                            if (label) {
                                                                label += ': ';
                                                            }
                                                            if (context.parsed !== null) {
                                                                label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed);
                                                            }
                                                            return label;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                })
                                .catch(error => console.error('Lỗi khi lấy dữ liệu biểu đồ tròn:', error));
                        }

                        // Event listeners
                        document.getElementById('revenueTimeFilter').addEventListener('change', fetchColumnChartData);
                        yearSelect.addEventListener('change', fetchColumnChartData);
                        startDateInput.addEventListener('change', fetchColumnChartData);
                        endDateInput.addEventListener('change', fetchColumnChartData);
                        monthInput.addEventListener('change', fetchPieChartData);

                        // Initial load
                        fetchColumnChartData();
                        fetchPieChartData();
                    });
                </script>
            </c:if>
        </body>

        </html>