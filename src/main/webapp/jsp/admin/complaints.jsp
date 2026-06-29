<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khiếu Nại | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="complaints"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-exclamation-triangle"></i> Quản Lý Khiếu Nại</h1>
                <p>Xem và xử lý các khiếu nại của học sinh.</p>

                <div class="section-card" style="margin-top: 2rem;">
                    <h2>Danh Sách Khiếu Nại</h2>
                    <table class="data-table" style="margin-top: 1rem; width: 100%;">
                        <thead>
                            <tr>
                                <th>Mã khiếu nại</th>
                                <th>Học sinh</th>
                                <th>Mã đặt lịch</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.complaints}">
                                    <c:forEach var="complaint" items="${requestScope.complaints}">
                                        <tr>
                                            <td><code>${complaint.id}</code></td>
                                            <td>${complaint.student.name}</td>
                                            <td>${complaint.booking.id}</td>
                                            <td>${complaint.title}</td>
                                            <td>${complaint.statusDisplay}</td>
                                            <td><fmt:formatDate value="${complaint.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${complaint.status == 'pending'}">
                                                        <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                                            <form action="<c:url value='/admin/complaints'/>" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="resolveComplaint"/>
                                                                <input type="hidden" name="complaintId" value="${complaint.id}"/>
                                                                <button type="submit" class="btn btn-sm btn-success">Giải quyết</button>
                                                            </form>
                                                            <form action="<c:url value='/admin/complaints'/>" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="rejectComplaint"/>
                                                                <input type="hidden" name="complaintId" value="${complaint.id}"/>
                                                                <button type="submit" class="btn btn-sm btn-danger">Từ chối</button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-500);">Không có hành động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center; color: var(--gray-500);">Chưa có khiếu nại nào</td>
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
