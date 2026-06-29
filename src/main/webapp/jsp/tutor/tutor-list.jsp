<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Gia Sư | TutorHub</title>

    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/tutor-list.css?v=3'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="/layout/header.jsp">
    <jsp:param name="activeMenu" value="tutors"/>
</jsp:include>

<main class="page-container">

    <section class="page-header">
        <h1>Danh Sách Gia Sư</h1>
        <p>Tìm gia sư phù hợp với nhu cầu của bạn</p>
    </section>

    <div class="tutors-container">

        <!-- FILTER SIDEBAR -->
        <aside class="filters-sidebar">
            <h3>Bộ Lọc Nâng Cao</h3>

            <form action="<c:url value='/tutors'/>" method="get" class="filter-form">

                <div class="filter-group">
                    <label>Tìm Kiếm Chung</label>
                    <div style="position: relative; width: 100%;">
                        <i class="fas fa-search" style="position: absolute; top: 50%; left: 14px; transform: translateY(-50%); color: #94a3b8; pointer-events: none;"></i>
                        <input type="text"
                               name="keyword"
                               placeholder="Tên gia sư, môn..."
                               value="${requestScope.keyword}"
                               class="filter-input"
                               style="padding-left: 38px !important; width: 100%; box-sizing: border-box;">
                    </div>
                </div>

                <div class="filter-group">
                    <label>Môn Học / Chuyên Ngành</label>
                    <select name="subjectName" class="filter-select">
                        <option value="">Tất Cả</option>
                        <c:forEach var="spec" items="${requestScope.specializations}">
                            <option value="${spec}" <c:if test="${spec == requestScope.selectedSubject}">selected</c:if>>
                                    ${spec}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Trình Độ / Cấp Bậc</label>
                    <select name="level" class="filter-select">
                        <option value="">Tất Cả</option>
                        <option value="Tiểu Học" <c:if test="${requestScope.selectedLevel == 'Tiểu Học'}">selected</c:if>>Tiểu Học</option>
                        <option value="THCS" <c:if test="${requestScope.selectedLevel == 'THCS'}">selected</c:if>>Cấp 2 (THCS)</option>
                        <option value="THPT" <c:if test="${requestScope.selectedLevel == 'THPT'}">selected</c:if>>Cấp 3 (THPT)</option>
                        <option value="Đại Học" <c:if test="${requestScope.selectedLevel == 'Đại Học'}">selected</c:if>>Đại Học / Chuyên Môn</option>
                        <option value="Ngoại Ngữ" <c:if test="${requestScope.selectedLevel == 'Ngoại Ngữ'}">selected</c:if>>Ngoại Ngữ (IELTS, TOEIC...)</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Khoảng Giá (VNĐ/Giờ)</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="number" name="minPrice" placeholder="Từ..." value="${requestScope.minPrice}" class="filter-input" min="0" step="10000">
                        <input type="number" name="maxPrice" placeholder="Đến..." value="${requestScope.maxPrice}" class="filter-input" min="0" step="10000">
                    </div>
                </div>

                <div class="filter-group">
                    <label>Đánh Giá</label>
                    <select name="rating" class="filter-select">
                        <option value="">Tất Cả</option>
                        <option value="5" <c:if test="${requestScope.selectedRating == '5'}">selected</c:if>>5 Sao</option>
                        <option value="4" <c:if test="${requestScope.selectedRating == '4'}">selected</c:if>>Từ 4 Sao Trở Lên</option>
                        <option value="3" <c:if test="${requestScope.selectedRating == '3'}">selected</c:if>>Từ 3 Sao Trở Lên</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-filter"></i> Lọc Kết Quả
                </button>

                <a href="<c:url value='/tutors'/>" class="btn btn-outline btn-block" style="text-align: center; margin-top: 10px;">
                    Xóa bộ lọc
                </a>

            </form>
        </aside>

        <!-- TUTORS LIST CONTENT -->
        <section class="tutors-content">

            <c:set var="isSearching" value="${not empty requestScope.keyword or not empty requestScope.selectedSubject or not empty requestScope.selectedLevel}" />

            <div class="tutors-header" style="display: flex; justify-content: space-between; align-items: center; padding-bottom: 1rem; border-bottom: 1px solid #f1f5f9; margin-bottom: 1.5rem;">
                <p class="results-count" style="margin: 0;">
                    Tìm thấy <strong>${empty requestScope.tutors ? 0 : requestScope.tutors.size()}</strong> gia sư
                </p>

                <c:if test="${not empty requestScope.tutors}">
                    <div class="toggle-container">
                        <span class="toggle-text">Ẩn lớp học</span>
                        <label class="toggle-switch">
                            <input type="checkbox" id="global-toggle" <c:if test="${isSearching}">checked</c:if> onchange="toggleAllCourses()">
                            <span class="toggle-slider"></span>
                        </label>
                        <span class="toggle-text" style="color: #10b981;">Hiện lớp học</span>
                    </div>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${not empty requestScope.tutors}">
                    <div class="tutors-list">
                        <c:forEach var="tutor" items="${requestScope.tutors}">
                            <div class="tutor-list-card">

                                <!-- Favorite Heart Button -->
                                <button class="favorite-btn" 
                                        data-tutor-id="${tutor.id}" 
                                        onclick="toggleFavorite('${tutor.id}', this)" 
                                        title="Thêm vào yêu thích">
                                    <i class="far fa-heart"></i>
                                </button>

                                <!-- IMAGE -->
                                <div class="tutor-list-image">
                                    <c:choose>
                                        <c:when test="${not empty tutor.avatar}">
                                            <img src="${pageContext.request.contextPath}/images/tutors/${tutor.avatar}" alt="${tutor.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="avatar-placeholder-large">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${tutor.verified}">
                                        <span class="badge-verified-large">
                                            <i class="fas fa-check-circle"></i> Verified
                                        </span>
                                    </c:if>
                                </div>

                                <!-- INFO -->
                                <div class="tutor-list-details">
                                    <h3>${tutor.name}</h3>

                                    <div class="tutor-rating-large">
                                        <c:forEach begin="1" end="${tutor.evaluate}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>
                                        <span>${tutor.evaluate} / 5</span>
                                    </div>

                                    <p><strong>Chuyên:</strong> ${tutor.specialization}</p>
                                    <p><strong>Địa chỉ:</strong> ${tutor.address}</p>
                                    <p><strong>SĐT:</strong> ${tutor.phone}</p>

                                    <p class="tutor-description-large">
                                            ${tutor.description}
                                    </p>

                                    <!-- COURSES SECTION -->
                                    <c:if test="${not empty tutor.courses}">
                                        <div class="courses-container">
                                            <div class="individual-course-toggle" onclick="toggleSingleCourse('${tutor.id}')">
                                                <p class="courses-title">Các Lớp Học Đang Mở (${tutor.courses.size()})</p>
                                                <i class="fas fa-chevron-down chevron-icon ${isSearching ? 'rotate' : ''}" id="chevron-${tutor.id}"></i>
                                            </div>

                                            <div class="course-list-wrapper ${isSearching ? 'show' : ''}" id="course-wrapper-${tutor.id}">
                                                <div class="course-list-inner">
                                                    <div class="courses-wrapper">
                                                        <c:forEach var="course" items="${tutor.courses}">
                                                            <div class="course-item">
                                                                <div class="course-info">
                                                                    <span class="course-level">${course.subject.level}</span>
                                                                    <span class="course-name">${course.subject.name}</span>
                                                                </div>
                                                                <div class="course-action">
                                                                    <span class="course-price">${course.subject.formattedFee}/giờ</span>
                                                                    <a href="${pageContext.request.contextPath}/booking?courseId=${course.id}&tutorId=${tutor.id}" class="btn-choose-course">
                                                                        Chọn Lớp Này
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- ACTIONS -->
                                    <div class="tutor-actions">
                                        <a href="${pageContext.request.contextPath}/tutor-detail?id=${tutor.id}" class="btn btn-primary">
                                            Xem chi tiết
                                        </a>
                                        <a href="${pageContext.request.contextPath}/booking?tutorId=${tutor.id}" class="btn btn-success">
                                            Đặt lịch
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="empty-state-large">
                        <i class="fas fa-search"></i>
                        <h3>Không tìm thấy gia sư</h3>
                        <a href="<c:url value='/tutors'/>" class="btn btn-primary">
                            Xem tất cả
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>

    </div>

</main>

<jsp:include page="/layout/footer.jsp"/>
<script src="<c:url value='/js/main.js?v=3'/>"></script>
<script>
// Favorite toggle function
function toggleFavorite(tutorId, btn) {
    const icon = btn.querySelector('i');
    
    fetch('${pageContext.request.contextPath}/favorite', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'tutorId=' + encodeURIComponent(tutorId)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            if (data.favorite) {
                icon.className = 'fas fa-heart';
                btn.classList.add('active');
            } else {
                icon.className = 'far fa-heart';
                btn.classList.remove('active');
            }
        } else {
            alert(data.message);
        }
    })
    .catch(err => {
        console.error('Favorite error:', err);
        alert('Có lỗi xảy ra, vui lòng thử lại.');
    });
}

// Load favorite status on page load
document.addEventListener('DOMContentLoaded', function() {
    const favBtns = document.querySelectorAll('.favorite-btn');
    // Only check if user might be logged in (student)
    if (favBtns.length > 0 && ${not empty sessionScope.account && sessionScope.account.role == 1}) {
        favBtns.forEach(btn => {
            const tutorId = btn.getAttribute('data-tutor-id');
            fetch('${pageContext.request.contextPath}/favorite?tutorId=' + encodeURIComponent(tutorId))
                .then(r => r.json())
                .then(data => {
                    if (data.favorite) {
                        btn.querySelector('i').className = 'fas fa-heart';
                        btn.classList.add('active');
                    }
                })
                .catch(() => {});
        });
    }
});
</script>
</body>
</html>