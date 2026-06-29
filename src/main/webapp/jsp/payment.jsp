<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Học Phí | TutorHub</title>
    <link rel="stylesheet" href="<c:url value='/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/booking.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Extra styles for payment page */
        .wallet-balance-box {
            margin-top: 1.2rem;
            padding: 1rem 1.2rem;
            background: linear-gradient(135deg, rgba(108,99,255,0.08), rgba(162,155,254,0.06));
            border: 1px solid rgba(108,99,255,0.25);
            border-radius: 12px;
        }
        .wallet-balance-box .label {
            font-size: 0.82rem;
            color: var(--color-muted, #94a3b8);
            margin-bottom: 0.3rem;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .wallet-balance-box .amount {
            font-size: 1.35rem;
            font-weight: 700;
            color: #6c63ff;
        }
        .wallet-balance-box .insufficient-warn {
            margin-top: 0.5rem;
            font-size: 0.83rem;
            color: #e74c3c;
            display: flex; align-items: center; gap: 0.4rem;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.6rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            font-size: 0.9rem;
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row .key { color: var(--color-muted, #94a3b8); }
        .summary-row .val { font-weight: 600; }
        .price-big { font-size: 1.5rem; font-weight: 800; color: #e74c3c; }
        .history-section { margin-top: 2.5rem; }
        .history-section h3 {
            font-size: 1.05rem; font-weight: 600; margin-bottom: 1rem;
            display: flex; align-items: center; gap: 0.5rem;
        }
        .history-table { width: 100%; border-collapse: collapse; font-size: 0.87rem; }
        .history-table th {
            text-align: left; padding: 0.7rem 1rem;
            background: rgba(255,255,255,0.04);
            font-weight: 600; font-size: 0.78rem;
            text-transform: uppercase; letter-spacing: 0.05em;
            color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.07);
        }
        .history-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .history-table tr:last-child td { border-bottom: none; }
        .history-table tr:hover td { background: rgba(255,255,255,0.02); }
        .badge-ok     { background: rgba(46,204,113,0.12); color: #2ecc71; padding: 0.25em 0.65em; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        .badge-type   { background: rgba(108,99,255,0.12); color: #a29bfe; padding: 0.25em 0.65em; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }
        .amt-out { color: #e74c3c; font-weight: 600; }
        .amt-in  { color: #2ecc71; font-weight: 600; }
    </style>
</head>
<body>

<jsp:include page="/layout/header.jsp"/>

<main class="page-container">
    <section class="page-header">
        <h1>
            <i class="fas fa-credit-card"></i>
            Thanh Toán Học Phí
        </h1>
        <p>Xác nhận thanh toán từ ví điện tử TutorHub</p>
    </section>

    <div class="booking-container">

        <!-- ===== ALERTS ===== -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- ===== PAYMENT CONFIRMATION FORM ===== -->
        <c:if test="${not empty course && not empty tutor}">
            <div class="booking-content">

                <!-- COURSE + TUTOR INFO CARD -->
                <div class="booking-tutor-card">
                    <h3>Thông Tin Thanh Toán</h3>

                    <div class="summary-row">
                        <span class="key"><i class="fas fa-user-tie"></i> Gia Sư</span>
                        <span class="val">${tutor.name}</span>
                    </div>
                    <div class="summary-row">
                        <span class="key"><i class="fas fa-book"></i> Môn Học</span>
                        <span class="val">${course.subject.name}</span>
                    </div>
                    <div class="summary-row">
                        <span class="key"><i class="fas fa-money-bill-wave"></i> Học Phí</span>
                        <span class="val price-big">
                            <fmt:formatNumber value="${course.subject.fee}" pattern="#,##0"/> VND
                        </span>
                    </div>
                    <div class="summary-row">
                        <span class="key"><i class="fas fa-id-card"></i> Mã Khóa Học</span>
                        <span class="val" style="font-family:monospace;color:#a29bfe">${course.id}</span>
                    </div>

                    <!-- Wallet Balance -->
                    <div class="wallet-balance-box">
                        <div class="label">
                            <i class="fas fa-wallet" style="color:#6c63ff"></i>
                            Số dư ví hiện tại của bạn
                        </div>
                        <div class="amount">
                            <fmt:formatNumber value="${balance}" pattern="#,##0"/> VND
                        </div>
                        <c:if test="${insufficient}">
                            <div class="insufficient-warn">
                                <i class="fas fa-exclamation-triangle"></i>
                                Số dư không đủ! Cần nạp thêm ít nhất
                                <strong>
                                    <fmt:formatNumber value="${course.subject.fee - balance}" pattern="#,##0"/> VND
                                </strong>.
                                <a href="${pageContext.request.contextPath}/wallet"
                                   style="color:#6c63ff;margin-left:0.3rem">Nạp tiền →</a>
                            </div>
                        </c:if>
                        <c:if test="${!insufficient}">
                            <div style="margin-top:0.5rem;font-size:0.82rem;color:#2ecc71">
                                <i class="fas fa-check-circle"></i>
                                Số dư đủ để thanh toán. Còn lại sau khi trả:
                                <strong>
                                    <fmt:formatNumber value="${balance - course.subject.fee}" pattern="#,##0"/> VND
                                </strong>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- PAYMENT FORM -->
                <form action="<c:url value='/payment'/>" method="post" class="booking-form"
                      onsubmit="return confirmPayment(this)">

                    <h3>Xác Nhận Thanh Toán</h3>

                    <!-- Hidden fields -->
                    <input type="hidden" name="courseId" value="${course.id}">
                    <input type="hidden" name="tutorId"  value="${tutor.id}">
                    <input type="hidden" name="amount"   value="${course.subject.fee}">

                    <!-- Phương thức -->
                    <div class="form-group">
                        <label>Phương Thức Thanh Toán</label>
                        <div style="padding:0.75rem 1rem;background:rgba(108,99,255,0.06);border:1px solid rgba(108,99,255,0.2);border-radius:10px;display:flex;align-items:center;gap:0.6rem;font-size:0.9rem;">
                            <i class="fas fa-wallet" style="color:#6c63ff"></i>
                            Ví Điện Tử TutorHub
                        </div>
                    </div>

                    <!-- Note -->
                    <div class="form-group">
                        <label>Ghi Chú (tùy chọn)</label>
                        <textarea name="note" rows="3" class="form-textarea"
                                  placeholder="Nhập ghi chú nếu có..."></textarea>
                    </div>

                    <!-- Actions -->
                    <c:choose>
                        <c:when test="${insufficient}">
                            <a href="${pageContext.request.contextPath}/wallet"
                               class="btn btn-primary btn-block btn-lg">
                                <i class="fas fa-plus"></i> Nạp Tiền Vào Ví
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn btn-success btn-block btn-lg" id="payBtn">
                                <i class="fas fa-lock"></i>
                                Xác Nhận Thanh Toán
                                <strong>
                                    (<fmt:formatNumber value="${course.subject.fee}" pattern="#,##0"/> VND)
                                </strong>
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <a href="<c:url value='/tutors'/>" class="btn btn-outline btn-block" style="margin-top:0.75rem">
                        <i class="fas fa-arrow-left"></i> Quay Lại
                    </a>

                </form>
            </div>
        </c:if>

        <!-- ===== PAYMENT HISTORY (when no course param) ===== -->
        <c:if test="${empty course}">
            <c:choose>
                <c:when test="${not empty payments}">
                    <div class="history-section">
                        <h3>
                            <i class="fas fa-history" style="color:#6c63ff"></i>
                            Lịch Sử Thanh Toán Học Phí
                            <span style="background:rgba(108,99,255,0.12);color:#a29bfe;padding:0.2em 0.7em;border-radius:20px;font-size:0.78rem">${payments.size()}</span>
                        </h3>
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>Mã GD</th>
                                    <th>Khóa Học</th>
                                    <th>Số Tiền</th>
                                    <th>Phương Thức</th>
                                    <th>Trạng Thái</th>
                                    <th>Thời Gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${payments}">
                                    <tr>
                                        <td style="font-family:monospace;color:#a29bfe">${p.id}</td>
                                        <td>${not empty p.courseId ? p.courseId : '-'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.paymentType == 'DEPOSIT'}">
                                                    <span class="amt-in">+<fmt:formatNumber value="${p.amount}" pattern="#,##0"/> VND</span>
                                                </c:when>
                                                <c:when test="${p.paymentType == 'WITHDRAW'}">
                                                    <span class="amt-out">-<fmt:formatNumber value="${p.amount}" pattern="#,##0"/> VND</span>
                                                </c:when>
                                                <c:when test="${sessionScope.account.role == 2}">
                                                    <span class="amt-in">+<fmt:formatNumber value="${p.amount}" pattern="#,##0"/> VND</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="amt-out">-<fmt:formatNumber value="${p.amount}" pattern="#,##0"/> VND</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.paymentMethod == 'wallet'}">Ví Điện Tử</c:when>
                                                <c:when test="${p.paymentMethod == 'bank_transfer'}">Chuyển Khoản</c:when>
                                                <c:when test="${p.paymentMethod == 'momo'}">MoMo</c:when>
                                                <c:otherwise>${p.paymentMethod}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="${p.status == 'completed' ? 'badge-ok' : 'badge-type'}">
                                                <c:choose>
                                                    <c:when test="${p.status == 'completed'}">Hoàn Thành</c:when>
                                                    <c:when test="${p.status == 'pending'}">Đang Xử Lý</c:when>
                                                    <c:otherwise>${p.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td style="color:#94a3b8;font-size:0.82rem">
                                            <fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center;padding:3rem;color:#94a3b8">
                        <i class="fas fa-receipt" style="font-size:3rem;opacity:0.25;display:block;margin-bottom:1rem"></i>
                        <p>Chưa có giao dịch thanh toán nào.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

    </div>
</main>

<jsp:include page="/layout/footer.jsp"/>
<script src="<c:url value='/js/main.js'/>"></script>
<script>
function confirmPayment(form) {
    const amount = '<fmt:formatNumber value="${course.subject.fee}" pattern="#,##0"/> VND';
    const tutor  = '${tutor.name}';
    if (!confirm('Xác nhận thanh toán ' + amount + ' cho gia sư ' + tutor + '?\n\nThao tác này không thể hoàn tác.')) {
        return false;
    }
    const btn = document.getElementById('payBtn');
    if (btn) {
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        btn.style.pointerEvents = 'none';
        btn.style.opacity = '0.7';
        // Disable after a slight delay to allow form submission to trigger
        setTimeout(() => { btn.disabled = true; }, 100);
    }
    return true;
}
</script>
</body>
</html>