<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ví Điện Tử - TutorHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6c63ff;
            --primary-light: #a29bfe;
            --success: #00b894;
            --danger: #e17055;
            --warning: #fdcb6e;
            --info: #74b9ff;
            --dark: #0d0d1a;
            --card-bg: #1a1a2e;
            --surface: #16213e;
            --text: #e2e8f0;
            --muted: #94a3b8;
            --border: rgba(255,255,255,0.08);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--text);
            min-height: 100vh;
        }

        /* -------- NAVBAR -------- */
        .navbar {
            background: rgba(26,26,46,0.97);
            backdrop-filter: blur(20px);
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .brand { font-size: 1.4rem; font-weight: 800; color: var(--primary-light); text-decoration: none; }
        .nav-links { display: flex; gap: 1.5rem; align-items: center; }
        .nav-links a {
            color: var(--muted); text-decoration: none; font-size: 0.9rem;
            transition: color 0.2s; padding: 0.4rem 0.8rem; border-radius: 8px;
        }
        .nav-links a:hover { color: var(--text); background: rgba(255,255,255,0.05); }
        .nav-links a.active { color: var(--primary-light); background: rgba(108,99,255,0.1); }
        .nav-user { display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; }
        .nav-user .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem; font-weight: 700; color: #fff;
        }

        /* -------- LAYOUT -------- */
        .container { max-width: 1100px; margin: 0 auto; padding: 2rem; }

        /* -------- PAGE HEADER -------- */
        .page-header {
            margin-bottom: 2rem;
            display: flex; align-items: center; gap: 1rem;
        }
        .page-header .icon-wrap {
            width: 52px; height: 52px; border-radius: 14px;
            background: linear-gradient(135deg, var(--primary), var(--primary-light));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
        }
        .page-header h1 { font-size: 1.8rem; font-weight: 700; }
        .page-header p { color: var(--muted); font-size: 0.9rem; margin-top: 0.2rem; }

        /* -------- ALERTS -------- */
        .alert {
            padding: 1rem 1.2rem; border-radius: 12px; margin-bottom: 1.5rem;
            font-size: 0.92rem; display: flex; align-items: flex-start; gap: 0.75rem;
            animation: slideIn 0.3s ease;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .alert i { margin-top: 0.1rem; flex-shrink: 0; font-size: 1rem; }
        .alert-success {
            background: rgba(0,184,148,0.12);
            border: 1px solid rgba(0,184,148,0.35);
            color: #00d2a8;
        }
        .alert-error {
            background: rgba(225,112,85,0.12);
            border: 1px solid rgba(225,112,85,0.35);
            color: #ff7675;
        }

        /* -------- BALANCE CARD -------- */
        .balance-card {
            background: linear-gradient(135deg, #6c63ff 0%, #a29bfe 50%, #74b9ff 100%);
            border-radius: 22px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(108,99,255,0.35);
        }
        .balance-card::before {
            content: '';
            position: absolute;
            top: -70px; right: -70px;
            width: 220px; height: 220px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
        }
        .balance-card::after {
            content: '';
            position: absolute;
            bottom: -40px; left: 40%;
            width: 150px; height: 150px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }
        .balance-card-inner { position: relative; z-index: 1; }
        .balance-label {
            font-size: 0.82rem; opacity: 0.8;
            letter-spacing: 0.1em; text-transform: uppercase;
            margin-bottom: 0.6rem;
        }
        .balance-amount {
            font-size: 3rem; font-weight: 800;
            letter-spacing: -1.5px; margin-bottom: 0.25rem;
        }
        .balance-unit { font-size: 1.1rem; font-weight: 500; opacity: 0.75; }
        .balance-actions {
            margin-top: 2rem; display: flex; gap: 0.75rem; flex-wrap: wrap;
        }
        .btn-glass {
            background: rgba(255,255,255,0.18);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 0.65rem 1.4rem;
            border-radius: 10px;
            font-size: 0.88rem; font-weight: 600;
            cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem;
            transition: all 0.2s; text-decoration: none;
            backdrop-filter: blur(10px);
        }
        .btn-glass:hover { background: rgba(255,255,255,0.28); transform: translateY(-1px); }

        /* -------- GRID -------- */
        .panels {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        @media (max-width: 700px) { .panels { grid-template-columns: 1fr; } }

        /* -------- PANEL -------- */
        .panel {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border);
            padding: 1.8rem;
            transition: border-color 0.2s;
        }
        .panel:hover { border-color: rgba(255,255,255,0.15); }
        .panel-header {
            display: flex; align-items: center; gap: 0.75rem;
            margin-bottom: 1.2rem;
        }
        .panel-icon {
            width: 38px; height: 38px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }
        .deposit-icon { background: rgba(0,184,148,0.15); color: var(--success); }
        .withdraw-icon { background: rgba(253,203,110,0.15); color: var(--warning); }
        .info-icon { background: rgba(116,185,255,0.15); color: var(--info); }
        .panel-title { font-size: 1rem; font-weight: 600; }
        .panel-sub { font-size: 0.82rem; color: var(--muted); margin-bottom: 1.2rem; line-height: 1.5; }

        /* -------- FORM -------- */
        .form-group { margin-bottom: 1rem; }
        .form-group label {
            display: block; font-size: 0.82rem;
            color: var(--muted); margin-bottom: 0.4rem; font-weight: 500;
        }
        .form-group input {
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            color: var(--text);
            font-size: 1rem;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(108,99,255,0.15);
        }
        .quick-amounts {
            display: flex; gap: 0.4rem; flex-wrap: wrap; margin-bottom: 1rem;
        }
        .quick-btn {
            background: var(--surface); color: var(--muted);
            border: 1px solid var(--border);
            padding: 0.35rem 0.75rem; border-radius: 8px;
            font-size: 0.78rem; font-weight: 600;
            cursor: pointer; transition: all 0.15s; font-family: inherit;
        }
        .quick-btn:hover { border-color: var(--primary); color: var(--primary-light); }
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.75rem 1.5rem; border-radius: 10px;
            border: none; cursor: pointer; font-size: 0.9rem; font-weight: 600;
            font-family: inherit; transition: all 0.2s; text-decoration: none;
        }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; transform: none !important; }
        .btn-success { background: var(--success); color: #fff; }
        .btn-success:hover:not(:disabled) { background: #00a381; transform: translateY(-1px); box-shadow: 0 4px 15px rgba(0,184,148,0.3); }
        .btn-warning { background: var(--warning); color: #1a1a2e; }
        .btn-warning:hover:not(:disabled) { filter: brightness(0.92); transform: translateY(-1px); box-shadow: 0 4px 15px rgba(253,203,110,0.3); }
        .info-box {
            background: rgba(116,185,255,0.07);
            border: 1px solid rgba(116,185,255,0.2);
            border-radius: 8px; padding: 0.8rem 1rem;
            font-size: 0.82rem; color: var(--muted);
            margin-bottom: 1rem; line-height: 1.6;
        }

        /* -------- TRANSACTION TABLE -------- */
        .section-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 1rem;
        }
        .section-title {
            font-size: 1.05rem; font-weight: 600; color: var(--text);
            display: flex; align-items: center; gap: 0.5rem;
        }
        .tx-count {
            background: rgba(108,99,255,0.15); color: var(--primary-light);
            padding: 0.2em 0.6em; border-radius: 20px; font-size: 0.78rem; font-weight: 600;
        }
        .tx-table-wrap {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border);
            overflow: hidden;
        }
        .tx-table { width: 100%; border-collapse: collapse; }
        .tx-table thead th {
            background: var(--surface);
            padding: 0.9rem 1.2rem;
            font-size: 0.75rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.06em;
            color: var(--muted); text-align: left;
        }
        .tx-table tbody td {
            padding: 0.9rem 1.2rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.87rem;
            vertical-align: middle;
        }
        .tx-table tbody tr:last-child td { border-bottom: none; }
        .tx-table tbody tr:hover { background: rgba(255,255,255,0.025); }
        .badge {
            display: inline-block; padding: 0.28em 0.7em; border-radius: 6px;
            font-size: 0.74rem; font-weight: 600; letter-spacing: 0.02em;
        }
        .badge-deposit  { background: rgba(0,184,148,0.15);  color: #00d2a8; }
        .badge-withdraw { background: rgba(253,203,110,0.15); color: var(--warning); }
        .badge-payment  { background: rgba(108,99,255,0.15);  color: var(--primary-light); }
        .badge-ok       { background: rgba(0,184,148,0.12);   color: #00d2a8; }
        .badge-fail     { background: rgba(225,112,85,0.12);   color: #ff7675; }
        .amount-in  { color: #00d2a8; font-weight: 600; }
        .amount-out { color: #ff7675; font-weight: 600; }
        .code-id { color: var(--primary-light); font-family: monospace; font-size: 0.82rem; }
        .empty-state {
            text-align: center; padding: 4rem 2rem; color: var(--muted);
        }
        .empty-state .empty-icon {
            font-size: 3rem; margin-bottom: 1rem; opacity: 0.25;
        }
        .empty-state p { font-size: 0.95rem; }
        .empty-state .sub { font-size: 0.82rem; margin-top: 0.4rem; opacity: 0.7; }
    </style>
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
    <a class="brand" href="${pageContext.request.contextPath}/">TutorHub</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/tutors">Gia Sư</a>
        <a href="${pageContext.request.contextPath}/wallet" class="active">Ví Tiền</a>
    </div>
    <div class="nav-user">
        <div class="avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.userProfile.name}">
                    ${fn:substring(sessionScope.userProfile.name, 0, 1)}
                </c:when>
                <c:otherwise>U</c:otherwise>
            </c:choose>
        </div>
        <span style="color:var(--muted);font-size:0.88rem">${sessionScope.userProfile.name}</span>
        <a href="${pageContext.request.contextPath}/logout"
           style="color:var(--danger);font-size:0.85rem;margin-left:0.5rem;text-decoration:none">
            <i class="fas fa-sign-out-alt"></i>
        </a>
    </div>
</nav>

<!-- ===== CONTAINER ===== -->
<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div class="icon-wrap">💳</div>
        <div>
            <h1>Ví Điện Tử</h1>
            <p>Quản lý số dư và lịch sử giao dịch của bạn</p>
        </div>
    </div>

    <!-- ALERTS -->
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

    <!-- BALANCE CARD -->
    <div class="balance-card">
        <div class="balance-card-inner">
            <div class="balance-label">
                <i class="fas fa-wallet" style="margin-right:0.4rem"></i>Số Dư Hiện Tại
            </div>
            <div class="balance-amount">
                <fmt:formatNumber value="${balance}" pattern="#,##0"/>
                <span class="balance-unit">VND</span>
            </div>
            <div class="balance-actions">
                <c:if test="${sessionScope.account.role == 1}">
                    <a href="#depositPanel" onclick="document.getElementById('depositAmount').focus()" class="btn-glass">
                        <i class="fas fa-plus"></i> Nạp Tiền
                    </a>
                </c:if>
                <c:if test="${sessionScope.account.role == 2}">
                    <a href="#withdrawPanel" onclick="document.getElementById('withdrawAmount').focus()" class="btn-glass">
                        <i class="fas fa-arrow-down"></i> Rút Tiền
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-glass">
                    <i class="fas fa-th-large"></i> Dashboard
                </a>
            </div>
        </div>
    </div>

    <!-- PANELS -->
    <div class="panels">

        <!-- DEPOSIT (Student only) -->
        <c:if test="${sessionScope.account.role == 1}">
            <div class="panel" id="depositPanel">
                <div class="panel-header">
                    <div class="panel-icon deposit-icon"><i class="fas fa-plus"></i></div>
                    <div class="panel-title">Nạp Tiền Vào Ví</div>
                </div>
                <p class="panel-sub">
                    Nạp tiền vào ví điện tử để thanh toán học phí cho gia sư.
                    Giao dịch được ghi lại đầy đủ trong lịch sử.
                </p>
                <form action="${pageContext.request.contextPath}/wallet" method="post" id="depositForm">
                    <input type="hidden" name="action" value="deposit">
                    <div class="form-group">
                        <label for="depositAmount">Số Tiền Nạp (VND)</label>
                        <input type="number" id="depositAmount" name="amount"
                               min="10000" step="10000" max="100000000"
                               placeholder="Ví dụ: 500,000" required>
                    </div>
                    <div class="quick-amounts">
                        <button type="button" class="quick-btn" onclick="setDeposit(100000)">100K</button>
                        <button type="button" class="quick-btn" onclick="setDeposit(200000)">200K</button>
                        <button type="button" class="quick-btn" onclick="setDeposit(500000)">500K</button>
                        <button type="button" class="quick-btn" onclick="setDeposit(1000000)">1 Triệu</button>
                        <button type="button" class="quick-btn" onclick="setDeposit(2000000)">2 Triệu</button>
                        <button type="button" class="quick-btn" onclick="setDeposit(5000000)">5 Triệu</button>
                    </div>
                    <button type="submit" class="btn btn-success" id="depositBtn"
                            onclick="return confirmDeposit()">
                        <i class="fas fa-check"></i> Xác Nhận Nạp Tiền
                    </button>
                </form>
            </div>
        </c:if>

        <!-- WITHDRAW (Tutor only) -->
        <c:if test="${sessionScope.account.role == 2}">
            <div class="panel" id="withdrawPanel">
                <div class="panel-header">
                    <div class="panel-icon withdraw-icon"><i class="fas fa-arrow-down"></i></div>
                    <div class="panel-title">Rút Tiền Về Ngân Hàng</div>
                </div>
                <p class="panel-sub">
                    Rút số dư từ việc dạy học về tài khoản ngân hàng của bạn.
                </p>
                <div class="info-box">
                    <i class="fas fa-info-circle" style="color:var(--info);margin-right:0.4rem"></i>
                    Tối thiểu rút: <strong>50,000 VND</strong>. Số dư sau rút phải ≥ 0.
                    Số dư hiện tại: <strong><fmt:formatNumber value="${balance}" pattern="#,##0"/> VND</strong>.
                </div>
                <form action="${pageContext.request.contextPath}/wallet" method="post" id="withdrawForm">
                    <input type="hidden" name="action" value="withdraw">
                    <div class="form-group">
                        <label for="withdrawAmount">Số Tiền Rút (VND)</label>
                        <input type="number" id="withdrawAmount" name="amount"
                               min="50000" step="10000" max="${balance}"
                               placeholder="Ví dụ: 500,000" required>
                    </div>
                    <div class="quick-amounts">
                        <button type="button" class="quick-btn" onclick="setWithdraw(100000)">100K</button>
                        <button type="button" class="quick-btn" onclick="setWithdraw(500000)">500K</button>
                        <button type="button" class="quick-btn" onclick="setWithdraw(1000000)">1 Triệu</button>
                        <button type="button" class="quick-btn" onclick="setWithdraw(${balance})">Toàn bộ</button>
                    </div>
                    <button type="submit" class="btn btn-warning" id="withdrawBtn"
                            onclick="return confirmWithdraw()">
                        <i class="fas fa-arrow-down"></i> Xác Nhận Rút Tiền
                    </button>
                </form>
            </div>
        </c:if>

        <!-- INFO PANEL -->
        <div class="panel">
            <div class="panel-header">
                <div class="panel-icon info-icon"><i class="fas fa-shield-alt"></i></div>
                <div class="panel-title">Hướng Dẫn & Bảo Mật</div>
            </div>
            <ul style="font-size:0.85rem;color:var(--muted);line-height:2.2;padding-left:1.2rem">
                <c:if test="${sessionScope.account.role == 1}">
                    <li>Nạp tiền vào ví trước khi đặt lịch học</li>
                    <li>Thanh toán học phí từ trang Dashboard</li>
                    <li>Mỗi giao dịch đều được ghi lại đầy đủ</li>
                    <li>Số dư được bảo mật và mã hóa an toàn</li>
                </c:if>
                <c:if test="${sessionScope.account.role == 2}">
                    <li>Nhận tiền khi học sinh thanh toán học phí</li>
                    <li>Có thể rút tiền bất cứ lúc nào về ngân hàng</li>
                    <li>Tối thiểu rút 50,000 VND mỗi lần</li>
                    <li>Số dư hiển thị là số dư khả dụng</li>
                </c:if>
                <c:if test="${sessionScope.account.role == 3}">
                    <li>Xem toàn bộ giao dịch của hệ thống</li>
                </c:if>
            </ul>
        </div>
    </div>

    <!-- TRANSACTION HISTORY -->
    <div class="section-header">
        <div class="section-title">
            <i class="fas fa-history" style="color:var(--primary-light)"></i>
            Lịch Sử Giao Dịch
            <c:if test="${not empty transactions}">
                <span class="tx-count">${transactions.size()}</span>
            </c:if>
        </div>
    </div>

    <div class="tx-table-wrap">
        <c:choose>
            <c:when test="${not empty transactions}">
                <table class="tx-table">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Loại</th>
                            <th>Số Tiền</th>
                            <th>Phương Thức</th>
                            <th>Trạng Thái</th>
                            <th>Thời Gian</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tx" items="${transactions}">
                            <tr>
                                <td><span class="code-id">${tx.id}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.paymentType == 'DEPOSIT'}">
                                            <span class="badge badge-deposit">
                                                <i class="fas fa-plus" style="font-size:0.65rem"></i> Nạp Tiền
                                            </span>
                                        </c:when>
                                        <c:when test="${tx.paymentType == 'WITHDRAW'}">
                                            <span class="badge badge-withdraw">
                                                <i class="fas fa-arrow-down" style="font-size:0.65rem"></i> Rút Tiền
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-payment">
                                                <i class="fas fa-graduation-cap" style="font-size:0.65rem"></i> Học Phí
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.paymentType == 'DEPOSIT'}">
                                            <span class="amount-in">
                                                +<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND
                                            </span>
                                        </c:when>
                                        <c:when test="${tx.paymentType == 'WITHDRAW'}">
                                            <span class="amount-out">
                                                -<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND
                                            </span>
                                        </c:when>
                                        <c:when test="${sessionScope.account.role == 2}">
                                            <%-- Tutor receives payment --%>
                                            <span class="amount-in">
                                                +<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Student pays --%>
                                            <span class="amount-out">
                                                -<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/> VND
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="color:var(--muted)">
                                    <c:choose>
                                        <c:when test="${tx.paymentMethod == 'bank_transfer'}">Chuyển Khoản</c:when>
                                        <c:when test="${tx.paymentMethod == 'wallet'}">Ví Điện Tử</c:when>
                                        <c:when test="${tx.paymentMethod == 'momo'}">MoMo</c:when>
                                        <c:otherwise>${tx.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge ${tx.status == 'completed' ? 'badge-ok' : 'badge-fail'}">
                                        <c:choose>
                                            <c:when test="${tx.status == 'completed'}">Hoàn Thành</c:when>
                                            <c:when test="${tx.status == 'pending'}">Đang Xử Lý</c:when>
                                            <c:when test="${tx.status == 'failed'}">Thất Bại</c:when>
                                            <c:otherwise>${tx.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td style="color:var(--muted);font-size:0.82rem">
                                    <fmt:formatDate value="${tx.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-receipt"></i></div>
                    <p>Chưa có giao dịch nào.</p>
                    <c:if test="${sessionScope.account.role == 1}">
                        <p class="sub">Hãy nạp tiền để bắt đầu sử dụng dịch vụ!</p>
                    </c:if>
                    <c:if test="${sessionScope.account.role == 2}">
                        <p class="sub">Giao dịch sẽ xuất hiện khi học sinh thanh toán học phí cho bạn.</p>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div><!-- /container -->

<script>
    function setDeposit(val) {
        document.getElementById('depositAmount').value = val;
    }
    function setWithdraw(val) {
        document.getElementById('withdrawAmount').value = val;
    }

    function confirmDeposit() {
        var amount = parseInt(document.getElementById('depositAmount').value || '0');
        if (!amount || amount < 10000) {
            alert('So tien nap toi thieu 10,000 VND.');
            return false;
        }
        var formatted = amount.toLocaleString('vi-VN');
        if (!confirm('Xac nhan nap ' + formatted + ' VND vao vi?')) return false;
        var btn = document.getElementById('depositBtn');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Dang xu ly...';
        btn.disabled = true;
        document.getElementById('depositForm').submit();
        return false;
    }

    function confirmWithdraw() {
        var amount = parseInt(document.getElementById('withdrawAmount').value || '0');
        var balance = ${empty balance ? 0 : balance};
        if (!amount || amount < 50000) {
            alert('So tien rut toi thieu 50,000 VND.');
            return false;
        }
        if (amount > balance) {
            alert('So tien rut vuot qua so du hien tai (' + balance.toLocaleString('vi-VN') + ' VND).');
            return false;
        }
        var formatted = amount.toLocaleString('vi-VN');
        if (!confirm('Xac nhan rut ' + formatted + ' VND ve ngan hang?')) return false;
        var btn = document.getElementById('withdrawBtn');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Dang xu ly...';
        btn.disabled = true;
        document.getElementById('withdrawForm').submit();
        return false;
    }

    // Fix bfcache: reset button states when user navigates back
    window.addEventListener('pageshow', function() {
        var depositBtn = document.getElementById('depositBtn');
        if (depositBtn) {
            depositBtn.disabled = false;
            depositBtn.innerHTML = '<i class="fas fa-check"></i> Xac Nhan Nap Tien';
        }
        var withdrawBtn = document.getElementById('withdrawBtn');
        if (withdrawBtn) {
            withdrawBtn.disabled = false;
            withdrawBtn.innerHTML = '<i class="fas fa-arrow-down"></i> Xac Nhan Rut Tien';
        }
    });

    window.addEventListener('DOMContentLoaded', function() {
        var alertEl = document.querySelector('.alert');
        if (alertEl) alertEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
    });
</script>
</body>
</html>
