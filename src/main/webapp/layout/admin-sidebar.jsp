<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="admin-sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-tachometer-alt"></i> Admin Panel</h3>
    </div>

    <nav class="sidebar-nav">
        <a href="<c:url value='/admin/dashboard'/>" class="sidebar-link ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-chart-line"></i>
            <span>Dashboard</span>
        </a>

        <a href="<c:url value='/admin/users'/>" class="sidebar-link ${param.activePage == 'users' ? 'active' : ''}">
            <i class="fas fa-users"></i>
            <span>Người Dùng</span>
            <c:if test="${not empty totalUsers}">
                <span class="badge-count">${totalUsers}</span>
            </c:if>
        </a>

        <a href="<c:url value='/admin/tutors'/>" class="sidebar-link ${param.activePage == 'tutors' ? 'active' : ''}">
            <i class="fas fa-chalkboard-user"></i>
            <span>Xác Minh Gia Sư</span>
            <c:if test="${not empty pendingTutors}">
                <span class="badge-warning">${pendingTutors}</span>
            </c:if>
        </a>

        <a href="<c:url value='/admin/payments'/>" class="sidebar-link ${param.activePage == 'payments' ? 'active' : ''}">
            <i class="fas fa-credit-card"></i>
            <span>Thanh Toán</span>
        </a>

        <a href="<c:url value='/admin/complaints'/>" class="sidebar-link ${param.activePage == 'complaints' ? 'active' : ''}">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Giải Quyết Khiếu Nại</span>
        </a>

        <div class="sidebar-divider"></div>

        <a href="<c:url value='/'/>" class="sidebar-link">
            <i class="fas fa-home"></i>
            <span>Về Trang Chủ</span>
        </a>

        <a href="<c:url value='/logout'/>" class="sidebar-link text-danger">
            <i class="fas fa-sign-out-alt"></i>
            <span>Đăng Xuất</span>
        </a>
    </nav>
</aside>
