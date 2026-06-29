<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header class="header">
            <div class="navbar">
                <div class="navbar-container">
                    <div class="navbar-logo">
                        <a href="<c:url value='/'/>">
                            <i class="fas fa-graduation-cap"></i>
                            <span>TutorHub</span>
                        </a>
                    </div>

                    <nav class="navbar-menu">
                        <a href="<c:url value='/'/>" class="nav-link ${param.activeMenu == 'home' ? 'active' : ''}">
                            <i class="fas fa-home"></i> Trang chủ
                        </a>
                        <a href="<c:url value='/tutors'/>"
                            class="nav-link ${param.activeMenu == 'tutors' ? 'active' : ''}">
                            <i class="fas fa-chalkboard-user"></i> Tìm Gia Sư
                        </a>

                        <c:choose>
                            <c:when test="${empty sessionScope.account}">
                                <a href="<c:url value='/login'/>" class="nav-link">
                                    <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${sessionScope.account.role == 1}">
                                        <a href="<c:url value='/profile'/>" class="nav-link">
                                            <i class="fas fa-user"></i> Hồ Sơ
                                        </a>
                                        <a href="<c:url value='/dashboard'/>" class="nav-link">
                                            <i class="fas fa-calendar"></i> Đặt Lịch
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.account.role == 2}">
                                        <a href="<c:url value='/dashboard'/>" class="nav-link">
                                            <i class="fas fa-chart-line"></i> Dashboard
                                        </a>
                                        <a href="<c:url value='/profile'/>" class="nav-link">
                                            <i class="fas fa-briefcase"></i> Hồ Sơ
                                        </a>
                                    </c:when>
                                    <c:when test="${sessionScope.account.role == 3}">
                                        <a href="<c:url value='/admin/dashboard'/>" class="nav-link">
                                            <i class="fas fa-chart-bar"></i> Admin Panel
                                        </a>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </nav>

                    <div class="navbar-user">
                        <c:choose>
                            <c:when test="${empty sessionScope.account}">
                                <a href="<c:url value='/register'/>" class="btn btn-primary">
                                    <i class="fas fa-user-plus"></i> Đăng Ký
                                </a>
                            </c:when>
                            <c:otherwise>
                                <div class="user-dropdown">
                                    <button class="user-button">
                                        <i class="fas fa-user-circle"></i>
                                        <span>${sessionScope.userProfile.name}</span>
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <div class="dropdown-menu">
                                        <c:choose>
                                            <c:when test="${sessionScope.account.role == 1}">
                                                <a href="<c:url value='/profile'/>" class="dropdown-item">
                                                    <i class="fas fa-user"></i> Hồ Sơ Cá Nhân
                                                </a>
                                            </c:when>
                                            <c:when test="${sessionScope.account.role == 2}">
                                                <a href="<c:url value='/profile'/>" class="dropdown-item">
                                                    <i class="fas fa-briefcase"></i> Hồ Sơ Gia Sư
                                                </a>
                                            </c:when>
                                            <c:when test="${sessionScope.account.role == 3}">
                                                <a href="<c:url value='/admin/dashboard'/>" class="dropdown-item">
                                                    <i class="fas fa-cog"></i> Quản Lý Hệ Thống
                                                </a>
                                            </c:when>
                                        </c:choose>

                                        <hr class="dropdown-divider" />

                                        <a href="<c:url value='/logout'/>" class="dropdown-item text-danger">
                                            <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <button class="mobile-menu-toggle">
                        <span></span>
                        <span></span>
                        <span></span>
                    </button>
                </div>
            </div>
        </header>