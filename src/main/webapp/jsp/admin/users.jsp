<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="users"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-users"></i> Quản Lý Người Dùng</h1>
                <p>Danh sách người dùng đăng ký trên hệ thống TutorHub.</p>

                <div class="section-card" style="margin-top: 1.5rem;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã TK</th>
                                <th>Họ Tên</th>
                                <th>Email</th>
                                <th>Vai Trò</th>
                                <th>Ngày Tạo</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.accounts}">
                                    <c:forEach var="acc" items="${requestScope.accounts}">
                                        <tr>
                                            <td><code>${acc.id}</code></td>
                                            <td><strong>${acc.name}</strong></td>
                                            <td>${acc.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${acc.role == 1}"><span class="badge badge-info" style="background-color: #3498db; color: white; padding: 2px 6px; border-radius: 4px;">Học sinh</span></c:when>
                                                    <c:when test="${acc.role == 2}"><span class="badge badge-primary" style="background-color: #9b59b6; color: white; padding: 2px 6px; border-radius: 4px;">Gia sư</span></c:when>
                                                    <c:when test="${acc.role == 3}"><span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 2px 6px; border-radius: 4px;">Admin</span></c:when>
                                                </c:choose>
                                            </td>
                                            <td>${acc.createdAt}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${acc.status eq 'active'}">
                                                        <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 2px 6px; border-radius: 4px;">Đang hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger" style="background-color: #95a5a6; color: white; padding: 2px 6px; border-radius: 4px;">Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${acc.role != 3}">
                                                    <form action="<c:url value='/admin/users'/>" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?');">
                                                        <input type="hidden" name="action" value="toggleStatus">
                                                        <input type="hidden" name="accountId" value="${acc.id}">
                                                        <input type="hidden" name="currentStatus" value="${acc.status}">
                                                        <c:choose>
                                                            <c:when test="${acc.status eq 'active'}">
                                                                <button type="submit" class="btn btn-sm btn-danger" style="padding: 4px 8px; font-size: 0.85rem; border-radius: 4px; background-color: #e74c3c; color: white; border: none; cursor: pointer;">
                                                                    <i class="fas fa-ban"></i> Khóa
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="btn btn-sm btn-success" style="padding: 4px 8px; font-size: 0.85rem; border-radius: 4px; background-color: #2ecc71; color: white; border: none; cursor: pointer;">
                                                                    <i class="fas fa-check"></i> Kích hoạt
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </c:if>
                                                <c:if test="${acc.role == 3}">
                                                    <span style="color: var(--gray-400); font-style: italic;">Hệ thống</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center;">Chưa có tài khoản nào đăng ký</td>
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
