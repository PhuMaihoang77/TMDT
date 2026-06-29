<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trung Tâm Thông Báo | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .notifications-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .page-header-notif {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #eee;
            padding-bottom: 1rem;
        }
        .page-header-notif h1 {
            font-size: 1.8rem;
            margin: 0;
            color: #333;
        }
        .notif-card-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .notif-card {
            display: flex;
            gap: 1rem;
            padding: 1.25rem;
            border-radius: 8px;
            background: #fff;
            border-left: 5px solid #ccc;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
        }
        .notif-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .notif-card.unread {
            background: #f4fbf7;
        }
        .notif-card.notif-success {
            border-left-color: #10b981;
        }
        .notif-card.notif-danger {
            border-left-color: #ef4444;
        }
        .notif-card.notif-warning {
            border-left-color: #f59e0b;
        }
        .notif-card.notif-info {
            border-left-color: #3b82f6;
        }
        .notif-icon {
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f3f4f6;
        }
        .notif-success .notif-icon {
            color: #10b981;
            background: #e6f7f0;
        }
        .notif-danger .notif-icon {
            color: #ef4444;
            background: #fee2e2;
        }
        .notif-warning .notif-icon {
            color: #f59e0b;
            background: #fef3c7;
        }
        .notif-info .notif-icon {
            color: #3b82f6;
            background: #dbeafe;
        }
        .notif-content {
            flex: 1;
        }
        .notif-title {
            font-size: 1.05rem;
            font-weight: 600;
            margin: 0 0 0.25rem 0;
            color: #2d3748;
        }
        .notif-msg {
            font-size: 0.95rem;
            color: #4a5568;
            margin: 0 0 0.5rem 0;
            line-height: 1.4;
        }
        .notif-time {
            font-size: 0.8rem;
            color: #a0aec0;
        }
        .btn-mark-read {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 0.85rem;
            cursor: pointer;
            padding: 0;
            font-weight: 600;
        }
        .btn-mark-read:hover {
            text-decoration: underline;
        }
        .notif-unread-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
            position: absolute;
            top: 1.25rem;
            right: 1.25rem;
        }
        .empty-notifs {
            text-align: center;
            padding: 3rem;
            color: #718096;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        .empty-notifs i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #cbd5e0;
        }
    </style>
</head>
<body>
    <jsp:include page="/layout/header.jsp"/>

    <main class="notifications-container">
        <div class="page-header-notif">
            <h1>Trung Tâm Thông Báo</h1>
            <c:if test="${not empty requestScope.notifications}">
                <button class="btn btn-outline btn-sm" id="btnReadAllPage">
                    <i class="fas fa-check-double"></i> Đọc tất cả
                </button>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty requestScope.notifications}">
                <div class="notif-card-list">
                    <c:forEach var="n" items="${requestScope.notifications}">
                        <div class="notif-card notif-${n.type} ${!n.isRead() ? 'unread' : ''}" data-id="${n.id}">
                            <div class="notif-icon">
                                <c:choose>
                                    <c:when test="${n.type == 'success'}">
                                        <i class="fas fa-check-circle"></i>
                                    </c:when>
                                    <c:when test="${n.type == 'danger'}">
                                        <i class="fas fa-exclamation-circle"></i>
                                    </c:when>
                                    <c:when test="${n.type == 'warning'}">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-info-circle"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="notif-content">
                                <h3 class="notif-title">${n.title}</h3>
                                <p class="notif-msg">${n.message}</p>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span class="notif-time">
                                        <i class="far fa-clock"></i>
                                        <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                    <c:if test="${!n.isRead()}">
                                        <button class="btn-mark-read btnPageMarkRead" data-id="${n.id}">Đánh dấu đã đọc</button>
                                    </c:if>
                                </div>
                            </div>
                            <c:if test="${!n.isRead()}">
                                <span class="notif-unread-dot"></span>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-notifs">
                    <i class="far fa-bell-slash"></i>
                    <h3>Không có thông báo</h3>
                    <p>Bạn chưa nhận được thông báo nào từ hệ thống.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/layout/footer.jsp"/>
    <script src="<c:url value='/js/main.js'/>"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mark single as read from page list
            document.querySelectorAll('.btnPageMarkRead').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const notifId = this.dataset.id;
                    const card = this.closest('.notif-card');
                    const btnElement = this;
                    
                    fetch('${pageContext.request.contextPath}/notifications?action=read&id=' + notifId, {
                        method: 'POST'
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            card.classList.remove('unread');
                            const dot = card.querySelector('.notif-unread-dot');
                            if (dot) dot.remove();
                            btnElement.remove();
                            // Update header count if global count method exists
                            if (window.updateUnreadCount) {
                                window.updateUnreadCount();
                            }
                        }
                    })
                    .catch(err => console.error(err));
                });
            });

            // Mark all as read from page button
            const readAllBtn = document.getElementById('btnReadAllPage');
            if (readAllBtn) {
                readAllBtn.addEventListener('click', function() {
                    fetch('${pageContext.request.contextPath}/notifications?action=readAll', {
                        method: 'POST'
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            document.querySelectorAll('.notif-card.unread').forEach(card => {
                                card.classList.remove('unread');
                                const dot = card.querySelector('.notif-unread-dot');
                                if (dot) dot.remove();
                                const btn = card.querySelector('.btnPageMarkRead');
                                if (btn) btn.remove();
                            });
                            readAllBtn.remove();
                            if (window.updateUnreadCount) {
                                window.updateUnreadCount();
                            }
                        }
                    })
                    .catch(err => console.error(err));
                });
            }
        });
    </script>
</body>
</html>
