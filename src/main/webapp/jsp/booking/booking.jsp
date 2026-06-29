<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Học | TutorHub</title>

    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/booking.css'/>">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<main class="page-container">

    <section class="page-header">
        <h1>
            <i class="fas fa-calendar-plus"></i>
            Đặt Lịch Học
        </h1>
        <p>Chọn lịch và khóa học phù hợp với bạn</p>
    </section>

    <div class="booking-container">

        <!-- SUCCESS -->
        <c:if test="${not empty requestScope.success}">
            <div class="alert alert-success">
                ${requestScope.success}
            </div>
        </c:if>

        <!-- ERROR -->
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-error">
                ${requestScope.error}
            </div>
        </c:if>

        <div class="booking-content">

            <!-- TUTOR INFO -->
            <c:if test="${not empty requestScope.tutor}">
                <div class="booking-tutor-card">

                    <h3>Thông Tin Gia Sư</h3>

                    <div class="tutor-booking-info">

                        <div class="tutor-booking-image">

                            <c:choose>
                                <c:when test="${not empty requestScope.tutor.avatar}">
                                    <img src="<c:url value='/images/tutors/${requestScope.tutor.avatar}'/>"
                                         alt="${requestScope.tutor.name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>

                        <div class="tutor-booking-details">

                            <h4>${requestScope.tutor.name}</h4>

                            <p>
                                <strong>Chuyên Ngành:</strong>
                                ${requestScope.tutor.specialization}
                            </p>

                            <p>
                                <strong>Đánh Giá:</strong>
                                ${requestScope.tutor.evaluate} / 5
                            </p>

                        </div>

                    </div>

                </div>
            </c:if>

            <!-- FORM (ONLY 1 FORM) -->
            <form action="<c:url value='/booking'/>"
                  method="post"
                  class="booking-form">

                <h3>Chi Tiết Đặt Lịch</h3>

                <input type="hidden"
                       name="tutorId"
                       value="${requestScope.tutor.id}">

                <!-- COURSE -->
                <div class="form-group">

                    <label>Chọn Khóa Học</label>

                    <select name="courseId"
                            class="form-select"
                            required>

                        <option value="">-- Chọn khóa học --</option>

                        <c:forEach var="course"
                                   items="${requestScope.courses}">

                            <option value="${course.id}">
                                    ${course.subject.name}
                                <c:if test="${not empty course.subject.level}">
                                    - ${course.subject.level}
                                </c:if>
                            </option>

                        </c:forEach>

                    </select>

                </div>

                <!-- TIME -->
                <div class="form-group">

                    <label>Chọn Thời Gian Học</label>

                    <input type="datetime-local"
                           name="bookingTime"
                           class="form-input"
                           required>

                </div>

                <!-- NOTE -->
                <div class="form-group">

                    <label>Ghi Chú</label>

                    <textarea name="note"
                              class="form-textarea"
                              rows="4"></textarea>

                </div>

                <!-- TERMS -->
                <div class="form-group">

                    <label>
                        <input type="checkbox" required>
                        Tôi đồng ý điều khoản
                    </label>

                </div>

                <!-- BUTTON -->
                <button type="submit"
                        class="btn btn-success btn-block btn-lg">

                    Xác Nhận Đặt Lịch

                </button>

            </form>

        </div>

    </div>

</main>

<jsp:include page="/layout/footer.jsp"/>

<script src="<c:url value='/js/main.js'/>"></script>

</body>
</html>