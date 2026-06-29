package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

/**
 * WalletServlet handles:
 *  GET  /wallet                      -> show wallet page (balance + transaction history)
 *  POST /wallet?action=deposit       -> student top-up (simulated bank transfer)
 *  POST /wallet?action=withdraw      -> tutor withdrawal
 */
@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();

    // ------------------------------------------------------------------ GET --
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Pull session flash messages (set by POST redirect)
        String flashSuccess = (String) session.getAttribute("success");
        String flashError   = (String) session.getAttribute("error");
        if (flashSuccess != null) {
            req.setAttribute("success", flashSuccess);
            session.removeAttribute("success");
        }
        if (flashError != null) {
            req.setAttribute("error", flashError);
            session.removeAttribute("error");
        }

        List<Payment> transactions;
        long balance = 0;

        if (account.getRole() == 1) {
            // ---- Student ----
            Student student = (Student) session.getAttribute("userProfile");
            if (student == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            // Reload fresh balance from DB
            Student fresh = studentDAO.findById(student.getId());
            if (fresh != null) {
                balance = fresh.getBalance();
                session.setAttribute("userProfile", fresh);
            }
            transactions = paymentDAO.findByStudentId(student.getId());

        } else if (account.getRole() == 2) {
            // ---- Tutor ----
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            if (tutor == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            Tutor fresh = tutorDAO.findById(tutor.getId());
            if (fresh != null) {
                balance = fresh.getBalance();
                session.setAttribute("userProfile", fresh);
            }
            transactions = paymentDAO.findByTutorId(tutor.getId());

        } else {
            // Admin: show all
            transactions = paymentDAO.findAll();
        }

        req.setAttribute("balance", balance);
        req.setAttribute("balanceFormatted", String.format("%,d", balance));
        req.setAttribute("transactions", transactions);
        req.getRequestDispatcher("/jsp/auth/wallet.jsp").forward(req, resp);
    }

    // ----------------------------------------------------------------- POST --
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action    = req.getParameter("action");
        String amountStr = req.getParameter("amount");

        // Validate amount
        long amount;
        try {
            amount = Long.parseLong(amountStr.trim());
            if (amount <= 0) throw new NumberFormatException("non-positive");
        } catch (Exception e) {
            session.setAttribute("error", "Số tiền không hợp lệ. Vui lòng nhập số dương.");
            resp.sendRedirect(req.getContextPath() + "/wallet");
            return;
        }

        if ("deposit".equals(action) && account.getRole() == 1) {
            handleDeposit(req, resp, session, amount);
        } else if ("withdraw".equals(action) && account.getRole() == 2) {
            handleWithdraw(req, resp, session, amount);
        } else {
            session.setAttribute("error", "Hành động không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/wallet");
        }
    }

    // -------------------------------------------------------- DEPOSIT LOGIC --
    private void handleDeposit(HttpServletRequest req, HttpServletResponse resp,
                                HttpSession session, long amount)
            throws IOException {
        Student student = (Student) session.getAttribute("userProfile");
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Validate minimum
        if (amount < 10000) {
            session.setAttribute("error", "Số tiền nạp tối thiểu là 10,000 VND.");
            resp.sendRedirect(req.getContextPath() + "/wallet");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Update student balance
            studentDAO.updateBalance(student.getId(), amount, conn);

            // 2. Log DEPOSIT transaction
            Payment p = new Payment();
            p.setId(paymentDAO.generateNextId(conn));
            p.setStudentId(student.getId());
            p.setAmount(amount);
            p.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            p.setPaymentMethod("bank_transfer");
            p.setStatus("completed");
            p.setPaymentType("DEPOSIT");
            paymentDAO.insert(p, conn);

            conn.commit();

            // 3. Refresh session
            Student fresh = studentDAO.findById(student.getId());
            if (fresh != null) session.setAttribute("userProfile", fresh);

            session.setAttribute("success",
                "✅ Nạp tiền thành công! Đã nạp " +
                String.format("%,d", amount) + " VND vào ví. " +
                "Số dư hiện tại: " +
                String.format("%,d", fresh != null ? fresh.getBalance() : 0) + " VND.");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi hệ thống khi nạp tiền. Vui lòng thử lại sau.");
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }

        resp.sendRedirect(req.getContextPath() + "/wallet");
    }

    // ------------------------------------------------------- WITHDRAW LOGIC --
    private void handleWithdraw(HttpServletRequest req, HttpServletResponse resp,
                                 HttpSession session, long amount)
            throws IOException {
        Tutor tutor = (Tutor) session.getAttribute("userProfile");
        if (tutor == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Validate minimum
        if (amount < 50000) {
            session.setAttribute("error", "Số tiền rút tối thiểu là 50,000 VND.");
            resp.sendRedirect(req.getContextPath() + "/wallet");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Check current balance (fresh from DB)
            long currentBalance = tutorDAO.getBalance(tutor.getId());
            if (currentBalance < amount) {
                conn.rollback();
                session.setAttribute("error",
                    "❌ Số dư không đủ để rút. Số dư hiện tại: " +
                    String.format("%,d", currentBalance) + " VND, bạn muốn rút: " +
                    String.format("%,d", amount) + " VND.");
                resp.sendRedirect(req.getContextPath() + "/wallet");
                return;
            }

            // 2. Deduct tutor balance
            tutorDAO.updateBalance(tutor.getId(), -amount, conn);

            // 3. Log WITHDRAW transaction
            Payment p = new Payment();
            p.setId(paymentDAO.generateNextId(conn));
            p.setTutorId(tutor.getId());
            p.setAmount(amount);
            p.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            p.setPaymentMethod("bank_transfer");
            p.setStatus("completed");
            p.setPaymentType("WITHDRAW");
            paymentDAO.insert(p, conn);

            conn.commit();

            // 4. Refresh session
            Tutor fresh = tutorDAO.findById(tutor.getId());
            if (fresh != null) session.setAttribute("userProfile", fresh);

            session.setAttribute("success",
                "✅ Rút tiền thành công! Đã rút " +
                String.format("%,d", amount) + " VND. " +
                "Số dư còn lại: " +
                String.format("%,d", currentBalance - amount) + " VND.");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            session.setAttribute("error", "❌ Lỗi hệ thống khi rút tiền. Vui lòng thử lại sau.");
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }

        resp.sendRedirect(req.getContextPath() + "/wallet");
    }
}
