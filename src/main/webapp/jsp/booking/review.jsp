<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
    >

    <title>Đánh Giá Gia Sư | TutorHub</title>

    <link
            rel="stylesheet"
            href="<c:url value='/css/main.css'/>"
    >

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    >

    <style>

        body{
            background:#f5f5f5;
            font-family:Arial;
        }

        .review-container{
            width:700px;
            margin:40px auto;
            background:white;
            padding:30px;
            border-radius:10px;
        }

        .form-group{
            margin-bottom:20px;
        }

        label{
            display:block;
            margin-bottom:8px;
            font-weight:bold;
        }

        textarea,
        select{
            width:100%;
            padding:10px;
            box-sizing:border-box;
        }

        .btn-submit{
            width:100%;
            padding:12px;
            background:#28a745;
            color:white;
            border:none;
            cursor:pointer;
            font-size:16px;
        }

        .review-list{
            margin-top:40px;
        }

        .review-item{
            border-bottom:1px solid #ddd;
            padding:15px 0;
        }

        .review-stars{
            color:#ffc107;
            margin-bottom:10px;
        }

        .review-comment{
            margin-bottom:10px;
        }

        .review-user{
            font-size:14px;
            color:#666;
        }

        .alert{
            padding:12px;
            margin-bottom:20px;
            border-radius:5px;
        }

        .success{
            background:#d4edda;
            color:#155724;
        }

        .error{
            background:#f8d7da;
            color:#721c24;
        }

    </style>

</head>

<body>

<jsp:include page="/layout/header.jsp"/>

<div class="review-container">

    <h2>

        <i class="fas fa-star"></i>

        Đánh Giá Gia Sư

    </h2>

    <!-- SUCCESS -->

    <c:if test="${not empty requestScope.success}">

        <div class="alert success">

                ${requestScope.success}

        </div>

    </c:if>

    <!-- ERROR -->

    <c:if test="${not empty requestScope.error}">

        <div class="alert error">

                ${requestScope.error}

        </div>

    </c:if>

    <!-- FORM -->

    <form
            action="<c:url value='/review'/>"
            method="post"
    >

        <!-- tutorId -->

        <input
                type="hidden"
                name="tutorId"
                value="${requestScope.tutor.id}"
        >

        <!-- courseId -->

        <input
                type="hidden"
                name="courseId"
                value="${requestScope.course.id}"
        >

        <div class="form-group">

            <label>

                Đánh Giá

            </label>

            <select name="rating" required>

                <option value="5">
                    5 Sao
                </option>

                <option value="4">
                    4 Sao
                </option>

                <option value="3">
                    3 Sao
                </option>

                <option value="2">
                    2 Sao
                </option>

                <option value="1">
                    1 Sao
                </option>

            </select>

        </div>

        <div class="form-group">

            <label>

                Bình Luận

            </label>

            <textarea
                    name="comment"
                    rows="5"
                    required
                    placeholder="Nhập đánh giá của bạn..."
            ></textarea>

        </div>

        <button
                type="submit"
                class="btn-submit"
        >

            Gửi Đánh Giá

        </button>

    </form>

    <!-- REVIEW LIST -->

    <div class="review-list">

        <h3>

            Danh Sách Đánh Giá

        </h3>

        <c:forEach
                var="review"
                items="${requestScope.reviews}"
        >

            <div class="review-item">

                <div class="review-stars">

                    <c:forEach
                            begin="1"
                            end="${review.rating}"
                            var="i"
                    >

                        <i class="fas fa-star"></i>

                    </c:forEach>

                </div>

                <div class="review-comment">

                        ${review.comment}

                </div>

                <div class="review-user">

                    Người đánh giá:
                        ${review.studentName}

                </div>

            </div>

        </c:forEach>

    </div>

</div>

<jsp:include page="/layout/footer.jsp"/>

</body>

</html>