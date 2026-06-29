<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="dashboard"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-chart-line"></i> Dashboard</h1>

                <div class="dashboard-cards">
                    <div class="dash-card">
                        <i class="fas fa-users"></i>
                        <h3>Tổng Người Dùng</h3>
                        <p class="dash-value">${requestScope.totalUsers}</p>
                        <small>Học sinh + Gia sư</small>
                    </div>

                    <div class="dash-card">
                        <i class="fas fa-chalkboard-user"></i>
                        <h3>Gia Sư Chưa Xác Minh</h3>
                        <p class="dash-value dash-warning">${requestScope.pendingTutorsCount}</p>
                        <a href="<c:url value='/admin/tutors'/>" class="btn btn-sm btn-warning">Xem Chi Tiết</a>
                    </div>

                    <div class="dash-card">
                        <i class="fas fa-credit-card"></i>
                        <h3>Tổng Doanh Thu</h3>
                        <p class="dash-value">${requestScope.totalRevenue}</p>
                        <small>Thanh toán thành công</small>
                    </div>

                    <div class="dash-card">
                        <i class="fas fa-calendar"></i>
                        <h3>Tổng Lớp Học</h3>
                        <p class="dash-value">${requestScope.totalBookings}</p>
                        <small>Tất cả thời gian</small>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="section-card">
                    <h2>Hoạt Động Gần Đây</h2>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Loại</th>
                                <th>Chi Tiết</th>
                                <th>Thời Gian</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.recentBookings}">
                                    <c:forEach var="b" items="${requestScope.recentBookings}">
                                        <tr>
                                            <td><span class="badge badge-info" style="background-color: #3498db; color: white; padding: 2px 6px; border-radius: 4px;">Đặt lịch</span></td>
                                            <td>Học sinh <strong>${b.student.name}</strong> đăng ký học gia sư <strong>${b.tutor.name}</strong> (${b.tutor.specialization})</td>
                                            <td>${b.bookingTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status eq 'pending'}">
                                                        <span style="color: #f39c12;"><i class="fas fa-clock"></i> Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${b.status eq 'confirmed'}">
                                                        <span style="color: #2ecc71;"><i class="fas fa-check-circle"></i> Thành công</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #e74c3c;"><i class="fas fa-times-circle"></i> Đã hủy</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr class="empty-row">
                                        <td colspan="4" style="text-align: center;">Chưa có hoạt động</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>