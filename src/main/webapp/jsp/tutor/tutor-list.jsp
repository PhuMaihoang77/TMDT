<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Gia Sư | TutorHub</title>

    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/tutor-list.css?v=3'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

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

            <div class="sidebar-header">
                <h3><i class="fas fa-sliders-h" style="color: var(--primary);"></i> Bộ Lọc Tìm Kiếm</h3>
                <button type="button" class="btn-reset" onclick="window.location.href='${pageContext.request.contextPath}/tutors'">
                    <i class="fas fa-sync-alt"></i> Reset Bộ Lọc
                </button>
            </div>

            <form id="filterForm" class="filter-form" action="${pageContext.request.contextPath}/tutors" method="GET">

                <!-- 1. Từ khóa -->
                <div class="filter-group">
                    <label>TỪ KHÓA TỰ DO</label>
                    <div class="search-input-group">
                        <i class="fas fa-search"></i>
                        <!-- Thêm thuộc tính value để giữ lại từ khóa sau khi load trang -->
                        <input type="text" name="keyword" class="filter-input"
                               placeholder="Tìm tên thầy cô, môn học..."
                               value="${requestScope.keyword != null ? requestScope.keyword : ''}">
                    </div>
                </div>

                <!-- 2. Môn Học -->
                <div class="filter-group">
                    <label>MÔN HỌC / CHUYÊN MÔN</label>
                    <select id="subjectSelect" name="subject" class="filter-select">
                        <option value="">Tất cả môn học</option>
                        <c:forEach var="spec" items="${requestScope.specializations}">
                            <option value="${spec}" ${spec == requestScope.selectedSubject ? 'selected' : ''}>
                                    ${spec}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 3. Cấp học & Khối lớp -->
                <div class="filter-row">
                    <div class="filter-group w-50">
                        <label>CẤP HỌC</label>
                        <select id="levelSelect" name="level" class="filter-select">
                            <option value="">Tất cả</option>
                            <option value="cap1" ${param.level == 'cap1' ? 'selected' : ''}>Cấp 1</option>
                            <option value="cap2" ${param.level == 'cap2' ? 'selected' : ''}>Cấp 2</option>
                            <option value="cap3" ${param.level == 'cap3' ? 'selected' : ''}>Cấp 3</option>
                        </select>
                    </div>
                    <div class="filter-group w-50">
                        <label>KHỐI LỚP</label>
                        <select id="gradeSelect" name="grade" class="filter-select">
                            <option value="">Chọn lớp...</option>
                        </select>
                    </div>
                </div>

                <!-- 4. Khu vực giảng dạy (Nằm trong box xám) -->
                <div class="filter-box">
                    <label class="box-label">KHU VỰC GIẢNG DẠY</label>

                    <div class="filter-group">
                        <label class="sub-label">TỈNH / THÀNH PHỐ</label>
                        <select id="province" name="province" class="filter-select mb-2">
                            <option value="">Tất cả Tỉnh/Thành</option>
                            <option value="HCM">TP. Hồ Chí Minh</option>
                            <option value="HN">Hà Nội</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label class="sub-label">PHƯỜNG / XÃ</label>
                        <select id="ward" name="ward" class="filter-select">
                            <option value="">Chọn Phường/Xã...</option>
                        </select>
                    </div>
                </div>

                <!-- 5. Trình Độ Gia Sư -->
                <div class="filter-group">
                    <label>TRÌNH ĐỘ GIA SƯ</label>
                    <div class="segmented-control">
                        <input type="radio" id="role-all" name="tutorType" value="" ${empty requestScope.selectedTutorType ? 'checked' : ''}>
                        <label for="role-all">Tất cả</label>

                        <input type="radio" id="role-sv" name="tutorType" value="sinhvien" ${requestScope.selectedTutorType == 'sinhvien' ? 'checked' : ''}>
                        <label for="role-sv">Sinh Viên</label>

                        <input type="radio" id="role-gv" name="tutorType" value="giaovien" ${requestScope.selectedTutorType == 'giaovien' ? 'checked' : ''}>
                        <label for="role-gv">Giáo Viên</label>
                    </div>
                </div>
                <!-- 6. Học Phí Tối Đa -->
                <div class="filter-group">
                    <label>HỌC PHÍ TỐI ĐA (VNĐ / GIỜ)</label>
                    <div class="price-slider-container">
                        <input type="range" name="maxPrice" id="priceRange" min="100000" max="3000000" step="50000"
                               value="${requestScope.maxPrice != null ? requestScope.maxPrice : '3000000'}"
                               oninput="updatePriceLabel(this.value)">
                        <span id="priceLabel" class="price-label">Không giới hạn</span>
                    </div>
                </div>

                <!-- 7. Đánh Giá -->
                <div class="filter-group">
                    <label>ĐÁNH GIÁ TỐI THIỂU</label>
                    <select name="rating" class="filter-select">
                        <option value="" ${requestScope.selectedRating == '' ? 'selected' : ''}>Tất cả sao</option>
                        <option value="5" ${requestScope.selectedRating == '5' ? 'selected' : ''}>5 Sao (Tuyệt đối)</option>
                        <option value="4" ${requestScope.selectedRating == '4' ? 'selected' : ''}>Từ 4 Sao Trở Lên</option>
                        <option value="3" ${requestScope.selectedRating == '3' ? 'selected' : ''}>Từ 3 Sao Trở Lên</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-filter">
                    Lọc Kết Quả
                </button>
            </form>
        </aside>

        <!-- TUTORS LIST CONTENT -->
        <section class="tutors-content">

            <c:set var="isSearching" value="${not empty requestScope.keyword or not empty requestScope.selectedSubject or not empty requestScope.selectedLevel or not empty requestScope.selectedGrade}" />
            <div class="tutors-control-bar">
                <div class="results-count">
                    Tìm thấy <strong>${empty requestScope.tutors ? 0 : requestScope.tutors.size()}</strong> gia sư phù hợp
                </div>

                <div class="control-actions">
                    <c:if test="${not empty requestScope.tutors}">
                        <div class="toggle-container">
                            <span class="toggle-text">Ẩn lớp học</span>
                            <label class="toggle-switch">
                                <input type="checkbox" id="global-toggle" <c:if test="${isSearching}">checked</c:if> onchange="toggleAllCourses()">
                                <span class="toggle-slider"></span>
                            </label>
                            <span class="toggle-text" style="color: var(--primary);">Hiện lớp</span>
                        </div>
                    </c:if>

                    <div class="sort-container">
                        <label for="sortBy" class="sort-label">Sắp xếp:</label>
                        <select id="sortBy" name="sortBy" form="filterForm" class="sort-select" onchange="this.form.submit()">
                            <option value="default" ${param.sortBy == 'default' ? 'selected' : ''}>Mặc định</option>
                            <option value="price_asc" ${param.sortBy == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                            <option value="price_desc" ${param.sortBy == 'price_desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                            <option value="rating_desc" ${param.sortBy == 'rating_desc' ? 'selected' : ''}>Đánh giá: Cao xuống Thấp</option>
                        </select>
                    </div>
                </div>
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
                                    <div class="tutor-name-section">
                                        <div class="tutor-name-left">
                                            <h3>${tutor.name}</h3>

<%--                                            <c:choose>--%>
<%--                                                <c:when test="${tutor.tutorType == 'giaovien' || tutor.tutorType == 'GiaoVien'}">--%>
<%--                                                    <span class="tutor-type-badge badge-gv">GIÁO VIÊN</span>--%>
<%--                                                </c:when>--%>
<%--                                                <c:when test="${tutor.tutorType == 'sinhvien' || tutor.tutorType == 'SinhVien'}">--%>
<%--                                                    <span class="tutor-type-badge badge-sv">SINH VIÊN</span>--%>
<%--                                                </c:when>--%>
<%--                                                <c:otherwise>--%>
<%--                                                    <span class="tutor-type-badge badge-default">GIA SƯ</span>--%>
<%--                                                </c:otherwise>--%>
<%--                                            </c:choose>--%>
                                        </div>

                                        <div class="tutor-rating-large">
                                            <c:forEach begin="1" end="${tutor.evaluate}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                            <span>(${tutor.evaluate}.0)</span>
                                        </div>
                                    </div>

                                    <div class="tutor-meta-compact">
                                        <p><strong>Chức danh / Trình độ:</strong> ${tutor.specialization}</p>
                                        <p><strong>Địa bàn giảng dạy:</strong> ${tutor.address}</p>
                                        <p><strong>Liên hệ:</strong> <span class="phone-text">${tutor.phone}</span></p>
                                    </div>

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
                                                                    <span class="course-price">
                                                                            <fmt:formatNumber value="${course.subject.fee}" type="number" maxFractionDigits="0"/>đ/giờ
                                                                    </span>
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

function updatePriceLabel(value) {
    const label = document.getElementById('priceLabel');
    // Đổi điều kiện thành 3 triệu
    if (value >= 3000000) {
        label.innerText = "Không giới hạn";
    } else {
        label.innerText = parseInt(value).toLocaleString('vi-VN') + " đ";
    }
}

$(document).ready(function() {
    $('#subjectSelect').select2({
        placeholder: "Tất cả môn học",
        allowClear: true, // Cho phép bấm nút X để xóa tìm kiếm
        width: '100%',
        language: {
            noResults: function() {
                return "Không tìm thấy môn học";
            }
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const levelSelect = document.getElementById('levelSelect');
    const gradeSelect = document.getElementById('gradeSelect');

    // Bản đồ cấu trúc Khối lớp tương ứng với từng Cấp học tại VN
    const gradeMap = {
        'cap1': ['Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5'],
        'cap2': ['Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9'],
        'cap3': ['Lớp 10', 'Lớp 11', 'Lớp 12']
    };

    // Hàm cập nhật danh sách Khối lớp
    function updateGrades(selectedLevel, currentGrade) {
        // Xóa sạch các option cũ, chỉ giữ lại option mặc định
        gradeSelect.innerHTML = '<option value="">Chọn lớp...</option>';

        if (selectedLevel && gradeMap[selectedLevel]) {
            gradeMap[selectedLevel].forEach(grade => {
                const option = document.createElement('option');
                option.value = grade;
                option.textContent = grade;
                // Giữ lại trạng thái selected sau khi submit form
                if (grade === currentGrade) {
                    option.selected = true;
                }
                gradeSelect.appendChild(option);
            });
        }
    }

    // Lắng nghe sự kiện khi người dùng thay đổi Cấp học
    levelSelect.addEventListener('change', function() {
        updateGrades(this.value, '');
    });

    // Kích hoạt chạy lần đầu khi load lại trang để giữ trạng thái đã chọn
    const initialLevel = "${param.level}";
    const initialGrade = "${requestScope.selectedGrade}";
    if (initialLevel) {
        updateGrades(initialLevel, initialGrade);
    }
    // BỔ SUNG: Đồng bộ nhãn chữ hiển thị học phí ngay khi trang vừa tải xong
    const priceRange = document.getElementById('priceRange');
    if (priceRange) {
        updatePriceLabel(priceRange.value);
    }
});

</script>

</body>
</html>