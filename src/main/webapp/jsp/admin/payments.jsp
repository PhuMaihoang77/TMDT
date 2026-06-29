<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Thanh Toán | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin-dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <div class="admin-layout">
        <jsp:include page="/layout/admin-sidebar.jsp">
            <jsp:param name="activePage" value="payments"/>
        </jsp:include>

        <main class="admin-content">
            <section class="admin-section">
                <h1><i class="fas fa-credit-card"></i> Quản Lý Giao Dịch</h1>
                <p>Xem lịch sử thanh toán học phí và phê duyệt các giao dịch chờ xử lý.</p>

                <!-- REVENUE CARD -->
                <div class="dashboard-cards" style="margin-top: 1.5rem; display: grid; grid-template-columns: 1fr; max-width: 350px;">
                    <div class="dash-card">
                        <i class="fas fa-wallet" style="color: #2ecc71;"></i>
                        <h3>Tổng Doanh Thu Hệ Thống</h3>
                        <p class="dash-value" style="color: #2ecc71;">${requestScope.totalRevenue}</p>
                        <small>Từ tất cả giao dịch thành công</small>
                    </div>
                </div>

                <!-- TRANSACTION LIST -->
                <div class="section-card" style="margin-top: 2rem;">
                    <h2>Danh Sách Giao Dịch</h2>
                    <table class="data-table" style="margin-top: 1rem;">
                        <thead>
                            <tr>
                                <th>Mã GD</th>
                                <th>Loại GD</th>
                                <th>Học Sinh</th>
                                <th>Gia Sư</th>
                                <th>Số Tiền</th>
                                <th>Thời Gian</th>
                                <th>Phương Thức</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.payments}">
                                    <c:forEach var="pay" items="${requestScope.payments}">
                                        <tr>
                                            <td><code>${pay.id}</code></td>
                                            <td>
                                                <span style="font-size:0.78rem; font-weight:600; padding:3px 8px; border-radius:12px;
                                                    background-color: ${pay.paymentType eq 'DEPOSIT' ? '#d4edda' : (pay.paymentType eq 'WITHDRAW' ? '#f8d7da' : '#cce5ff')};
                                                    color: ${pay.paymentType eq 'DEPOSIT' ? '#155724' : (pay.paymentType eq 'WITHDRAW' ? '#721c24' : '#004085')};">
                                                    ${pay.typeDisplay}
                                                </span>
                                            </td>
                                            <td><strong>${pay.student.name}</strong></td>
                                            <td><strong>${pay.tutor.name}</strong></td>
                                            <td style="color: #27ae60; font-weight: bold;">${pay.formattedAmount}</td>
                                            <td>${pay.paymentDate}</td>
                                            <td>${pay.methodDisplay}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pay.status eq 'completed'}">
                                                        <span class="badge badge-success" style="background-color: #2ecc71; color: white; padding: 2px 6px; border-radius: 4px;">Thành công</span>
                                                    </c:when>
                                                    <c:when test="${pay.status eq 'pending'}">
                                                        <span class="badge badge-warning" style="background-color: #f39c12; color: white; padding: 2px 6px; border-radius: 4px;">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-danger" style="background-color: #e74c3c; color: white; padding: 2px 6px; border-radius: 4px;">Thất bại</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pay.status eq 'pending'}">
                                                        <div style="display: flex; gap: 4px;">
                                                            <form action="<c:url value='/admin/payments'/>" method="post" style="display:inline;" onsubmit="return confirm('Xác nhận giao dịch này thành công?');">
                                                                <input type="hidden" name="action" value="updatePayment">
                                                                <input type="hidden" name="paymentId" value="${pay.id}">
                                                                <input type="hidden" name="status" value="completed">
                                                                <button type="submit" class="btn btn-sm btn-success" style="padding: 4px 8px; border-radius:4px; border:none; background-color:#2ecc71; color:white; cursor:pointer;">
                                                                    <i class="fas fa-check-circle"></i> Duyệt
                                                                </button>
                                                            </form>
                                                            <form action="<c:url value='/admin/payments'/>" method="post" style="display:inline;" onsubmit="return confirm('Hủy giao dịch này?');">
                                                                <input type="hidden" name="action" value="updatePayment">
                                                                <input type="hidden" name="paymentId" value="${pay.id}">
                                                                <input type="hidden" name="status" value="failed">
                                                                <button type="submit" class="btn btn-sm btn-danger" style="padding: 4px 8px; border-radius:4px; border:none; background-color:#e74c3c; color:white; cursor:pointer;">
                                                                    <i class="fas fa-times-circle"></i> Hủy
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--gray-400); font-style: italic;">Hoàn tất</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" style="text-align: center; color: var(--gray-500); padding: 1.5rem 0;">Chưa có lịch sử giao dịch nào</td>
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
