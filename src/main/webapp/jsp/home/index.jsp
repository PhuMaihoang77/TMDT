<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TutorHub - Nền Tảng Tìm Gia Sư Hàng Đầu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/layout/header.jsp">
        <jsp:param name="activeMenu" value="home"/>
    </jsp:include>

    <main>
        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-content">
                <h1 class="hero-title">Tìm Gia Sư Tài Năng</h1>
                <p class="hero-subtitle">Kết nối với những gia sư giỏi nhất - Học tập hiệu quả hơn</p>
                
                <div class="hero-search">
                    <form action="<c:url value='/tutors'/>" method="get" class="search-form">
                        <div class="search-input-group">
                            <i class="fas fa-search"></i>
                            <input 
                                type="text" 
                                name="keyword" 
                                placeholder="Tìm gia sư, môn học..." 
                                class="search-input">
                        </div>
                        <button type="submit" class="btn btn-primary search-btn">
                            <i class="fas fa-search"></i> Tìm Kiếm
                        </button>
                    </form>
                </div>

                <div class="hero-stats">
                    <div class="stat-item">
                        <h3>10K+</h3>
                        <p>Gia Sư</p>
                    </div>
                    <div class="stat-item">
                        <h3>50K+</h3>
                        <p>Học Sinh</p>
                    </div>
                    <div class="stat-item">
                        <h3>100K+</h3>
                        <p>Lớp Học</p>
                    </div>
                </div>
            </div>

            <div class="hero-image">
                <div class="hero-shape"></div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features">
            <div class="section-header">
                <h2>Tại Sao Chọn TutorHub?</h2>
                <p>Nền tảng được tin tưởng bởi hàng ngàn gia đình Việt Nam</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3>Gia Sư Được Xác Minh</h3>
                    <p>Tất cả gia sư đều được kiểm duyệt kỹ lưỡng về trình độ và đạo đức</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Đánh Giá Từ Học Sinh</h3>
                    <p>Xem đánh giá và kinh nghiệm thực tế từ những học sinh khác</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>100% An Toàn</h3>
                    <p>Giao dịch an toàn với hệ thống thanh toán được bảo vệ</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>Hỗ Trợ 24/7</h3>
                    <p>Đội hỗ trợ khách hàng luôn sẵn sàng giúp đỡ bạn</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Lịch Linh Hoạt</h3>
                    <p>Chọn lịch học phù hợp với thời gian của bạn</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <h3>Giá Cạnh Tranh</h3>
                    <p>Các mức giá được đặt bởi gia sư, phù hợp với mọi ngân sách</p>
                </div>
            </div>
        </section>

        <!-- Popular Tutors Section -->
        <section class="popular-tutors">
            <div class="slider-header-top">
                <div>
                    <h2 class="slider-title">
                        <i class="fas fa-award"></i> Gia Sư Nổi Bật
                    </h2>
                    <p class="slider-subtitle">Những người hướng dẫn được học viên tin tưởng nhất</p>
                </div>
                <div class="slider-controls">
                    <button id="prevBtn" type="button"><i class="fas fa-chevron-left"></i></button>
                    <button id="nextBtn" type="button"><i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
            <div class="slider-container" id="sliderContainer" style="overflow: hidden; width: 100%;">
                <div class="slider-track" id="sliderTrack">
                    <c:choose>
                        <c:when test="${not empty requestScope.tutors}">
                            <c:forEach var="tutor" items="${requestScope.tutors}">
                                <div class="slider-card" onclick="window.location.href='<c:url value="/tutor-detail?id=${tutor.id}"/>'">
                                    <div class="card-image-wrapper">
                                        <c:choose>
                                            <c:when test="${not empty tutor.avatar}">
                                                <img src="${pageContext.request.contextPath}/images/tutors/${tutor.avatar}" alt="${tutor.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${tutor.name}&backgroundColor=e2e8f0" alt="Avatar">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="image-overlay"></div>

                                        <div class="rating-badge">
                                            <i class="fas fa-star"></i> ${tutor.evaluate}.0
                                        </div>
                                        <div class="subject-badge">
                                                ${not empty tutor.specialization ? tutor.specialization : 'Gia Sư'}
                                        </div>
                                    </div>

                                    <div class="card-info">
                                        <h3>
                                                ${tutor.name}
                                            <c:if test="${tutor.verified}">
                                                <i class="fas fa-check-circle verified-icon" title="Đã xác minh"></i>
                                            </c:if>
                                        </h3>

                                        <div class="tutor-mini-meta">
                                            <p><i class="fas fa-graduation-cap"></i> Gia sư chuyên nghiệp</p>
                                            <p><i class="fas fa-map-marker-alt"></i> ${not empty tutor.address ? tutor.address : 'Toàn quốc'}</p>
                                        </div>

                                        <p class="tutor-desc">
                                                ${not empty tutor.description ? tutor.description : 'Gia sư tận tâm, chuyên nghiệp, hỗ trợ học viên đạt mục tiêu học tập.'}
                                        </p>

                                        <div class="card-footer">
                                            <span class="detail-link">Xem thông tin chi tiết <i class="fas fa-arrow-right"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="width:100%; text-align:center; padding: 2rem;">
                                <i class="fas fa-user-graduate" style="font-size:3rem; color:#cbd5e1; margin-bottom:1rem;"></i>
                                <p>Chưa có gia sư nổi bật. Hãy quay lại sau!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- Call to Action Section -->
        <section class="cta-section">
            <div class="cta-content">
                <h2>Bạn Là Gia Sư?</h2>
                <p>Gia Tăng Thu Nhập Của Bạn Bằng Cách Dạy Trên TutorHub</p>
                <a href="<c:url value='/register'/>" class="btn btn-light btn-lg">
                    Trở Thành Gia Sư Ngay
                </a>
            </div>
        </section>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>?v=2"></script>
</body>
</html>