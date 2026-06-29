<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Gia Sư | TutorHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tutor-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<jsp:include page="/layout/header.jsp"/>

<main class="page-container">
    <section class="tutor-detail">

        <div class="tutor-detail-header">
            <div class="tutor-detail-image">
                <c:choose>
                    <c:when test="${not empty requestScope.tutor.avatar}">
                        <img src="${pageContext.request.contextPath}/images/tutors/${requestScope.tutor.avatar}" alt="${requestScope.tutor.name}">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-placeholder-xlarge">
                            <i class="fas fa-user"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${requestScope.tutor.verified}">
                    <span class="badge-verified-large">
                        <i class="fas fa-check-circle"></i> Đã Xác Minh
                    </span>
                </c:if>
            </div>

            <div class="tutor-detail-info">
                <div class="detail-header-top">
                    <h1>${requestScope.tutor.name}</h1>
                    <p class="detail-specialization">
                        <i class="fas fa-book"></i> Chuyên ngành: ${requestScope.tutor.specialization}
                    </p>
                </div>

                <div class="detail-rating">
                    <div class="stars">
                        <c:choose>
                            <c:when test="${requestScope.avgRating > 0}">
                                <c:forEach begin="1" end="${requestScope.avgRating}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach begin="1" end="5">
                                    <i class="fas fa-star" style="color: var(--gray-300);"></i>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span><strong>${requestScope.avgRating} / 5</strong> (${requestScope.totalReviews} đánh giá)</span>
                </div>

                <div class="detail-stats">
                    <div class="stat">
                        <h4>${requestScope.totalStudents}</h4>
                        <p>Học Sinh Đã Học</p>
                    </div>
                    <div class="stat">
                        <h4>${requestScope.totalCourses}</h4>
                        <p>Lớp Học Mở</p>
                    </div>
                    <div class="stat">
                        <h4>${requestScope.totalReviews}</h4>
                        <p>Lượt Phản Hồi</p>
                    </div>
                </div>

                <div class="detail-contact">
                    <p><i class="fas fa-envelope"></i> <strong>Email:</strong> ${requestScope.tutor.email}</p>
                    <p><i class="fas fa-phone"></i> <strong>Điện thoại:</strong> ${requestScope.tutor.phone}</p>
                    <p><i class="fas fa-map-marker-alt"></i> <strong>Địa chỉ:</strong> ${requestScope.tutor.address}</p>
                </div>

                <c:if test="${not empty sessionScope.account and sessionScope.account.role eq 1}">
                    <div style="margin-top: 0.5rem;">
                        <a href="${pageContext.request.contextPath}/booking?tutorId=${requestScope.tutor.id}" class="btn btn-primary btn-lg">
                            <i class="fas fa-calendar-plus"></i> Đặt Lịch Học Ngay
                        </a>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="detail-content">
            <div class="content-section">
                <h3><i class="fas fa-info-circle"></i> Giới Thiệu Bản Thân</h3>
                <p>${requestScope.tutor.description}</p>
            </div>

            <c:if test="${not empty requestScope.courses}">
                <div class="content-section">
                    <h3><i class="fas fa-graduation-cap"></i> Các Lớp Học Đang Đảm Nhiệm</h3>
                    <div class="courses-grid">
                        <c:forEach var="course" items="${requestScope.courses}">
                            <div class="course-card">
                                <div>
                                    <h4>${course.subject.name}</h4>
                                    <p>${course.subject.description}</p>
                                </div>
                                <div class="course-footer">
                                    <span class="course-price">${course.subject.fee}đ/giờ</span>

                                    <c:choose>
                                        <c:when test="${not empty sessionScope.account and sessionScope.account.role eq 1}">
                                            <a href="${pageContext.request.contextPath}/booking?courseId=${course.id}&amp;tutorId=${requestScope.tutor.id}" class="btn btn-sm btn-primary">
                                                Chọn Lớp
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/jsp/auth/login.jsp?redirect=${pageContext.request.contextPath}/booking?courseId=${course.id}%26tutorId=${requestScope.tutor.id}" class="btn btn-sm btn-primary">
                                                Chọn Lớp
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <div class="content-section">
                <h3><i class="fas fa-comments"></i> Phản Hồi Từ Phụ Huynh & Học Sinh</h3>
                <c:choose>
                    <c:when test="${not empty requestScope.reviews}">
                        <div class="reviews-list" style="display: flex; flex-direction: column; gap: 15px;">
                            <c:forEach var="rev" items="${requestScope.reviews}">
                                <div class="review-card" style="background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0;">
                                    <div class="review-card-header" style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                        <span style="font-weight: bold; color: #1e293b;"><i class="fas fa-user-circle"></i> ${rev.student.name}</span>
                                        <span style="color: #f59e0b;">
                                            <c:forEach begin="1" end="${rev.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <c:forEach begin="${rev.rating + 1}" end="5">
                                                <i class="far fa-star" style="color: #cbd5e1;"></i>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <p style="margin: 0; color: #475569;">${rev.comment}</p>
                                    <small style="color: #94a3b8; display: block; margin-top: 5px;">${rev.createdAt}</small>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="color: var(--gray-500); font-style: italic; text-align: center; padding: 1rem 0;">
                            <i class="fas fa-comment-slash" style="font-size: 1.5rem; display: block; margin-bottom: 0.5rem; color: var(--gray-300);"></i>
                            Gia sư này chưa có phản hồi nào từ phụ huynh & học sinh.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </section>
</main>

<jsp:include page="/layout/footer.jsp"/>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>