<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gia Sư | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="tutors"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-chalkboard-user"></i> Phê Duyệt Hồ Sơ Gia Sư</h1>
                <p>Xem xét và kích hoạt hoặc từ chối các yêu cầu đăng ký làm Gia sư.</p>

                <!-- PENDING TUTORS -->
                <div class="section-card" style="margin-top: 1.5rem;">
                    <h2>Hồ Sơ Chờ Phê Duyệt (${requestScope.pendingTutors.size()})</h2>
                    <table class="data-table" style="margin-top: 1rem;">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Họ Tên & Liên Hệ</th>
                                <th>Chuyên Ngành</th>
                                <th>Thông Tin Tài Khoản</th>
                                <th>Mô Tả Bản Thân</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.pendingTutors}">
                                    <c:forEach var="tut" items="${requestScope.pendingTutors}">
                                        <tr>
                                            <td>
                                                <img src="<c:url value='/images/tutors/${tut.avatar}'/>" alt="${tut.name}" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                                            </td>
                                            <td>
                                                <strong>${tut.name}</strong><br>
                                                <small><i class="fas fa-envelope"></i> ${tut.email}</small><br>
                                                <small><i class="fas fa-phone"></i> ${tut.phone}</small><br>
                                                <small><i class="fas fa-map-marker-alt"></i> ${tut.address}</small>
                                            </td>
                                            <td><span class="badge badge-primary" style="background-color: #9b59b6; color: white; padding: 2px 6px; border-radius: 4px;">${tut.specialization}</span></td>
                                            <td>
                                                <small><strong>CCCD:</strong> ${tut.idCardNumber}</small><br>
                                                <small><strong>STK:</strong> ${tut.bankAccountNumber}</small><br>
                                                <small><strong>Ngân hàng:</strong> ${tut.bankName}</small>
                                            </td>
                                            <td>
                                                <div style="max-height: 80px; overflow-y: auto; font-size: 0.85rem; max-width: 200px;">
                                                    ${tut.description}
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; flex-direction: column; gap: 4px;">
                                                    <form action="<c:url value='/admin/tutors'/>" method="post" onsubmit="return confirm('Xác nhận phê duyệt hồ sơ gia sư này?');">
                                                        <input type="hidden" name="action" value="verifyTutor">
                                                        <input type="hidden" name="tutorId" value="${tut.id}">
                                                        <button type="submit" class="btn btn-sm btn-success" style="width:100%; border-radius: 4px; padding: 6px; font-size: 0.8rem; background-color: #2ecc71; border:none; color:white; cursor:pointer;">
                                                            <i class="fas fa-check"></i> Duyệt
                                                        </button>
                                                    </form>
                                                    <form action="<c:url value='/admin/tutors'/>" method="post" onsubmit="return confirm('Xác nhận từ chối và khóa tài khoản gia sư này?');">
                                                        <input type="hidden" name="action" value="rejectTutor">
                                                        <input type="hidden" name="tutorId" value="${tut.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger" style="width:100%; border-radius: 4px; padding: 6px; font-size: 0.8rem; background-color: #e74c3c; border:none; color:white; cursor:pointer;">
                                                            <i class="fas fa-times"></i> Từ chối
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--gray-500); padding: 1.5rem 0;">Chưa có yêu cầu phê duyệt nào mới</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- ALL TUTORS LIST -->
                <div class="section-card" style="margin-top: 2rem;">
                    <h2>Tất Cả Gia Sư</h2>
                    <table class="data-table" style="margin-top: 1rem;">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Họ Tên</th>
                                <th>Chuyên Môn</th>
                                <th>Đánh Giá</th>
                                <th>Khóa Học</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tut" items="${requestScope.allTutors}">
                                <tr>
                                    <td>
                                        <img src="<c:url value='/images/tutors/${tut.avatar}'/>" alt="${tut.name}" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                    </td>
                                    <td><strong>${tut.name}</strong><br><small>${tut.email}</small></td>
                                    <td>${tut.specialization}</td>
                                    <td><span style="color: #f1c40f;"><i class="fas fa-star"></i></span> ${tut.evaluate} / 5</td>
                                    <td>${tut.totalCourses} khóa học</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tut.verified}">
                                                <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 2px 6px; border-radius: 4px;">Đã xác minh</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 2px 6px; border-radius: 4px;">Chưa xác minh</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
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
