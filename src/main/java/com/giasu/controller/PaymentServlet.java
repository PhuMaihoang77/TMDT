package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

/**
 * PaymentServlet handles:
 *  GET  /payment?courseId=X&tutorId=Y  -> show payment confirmation page (student only)
 *  GET  /payment                        -> show payment history
 *  POST /payment                        -> process tuition payment (student only)
 */
@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO  paymentDAO  = new PaymentDAO();
    private StudentDAO  studentDAO  = new StudentDAO();
    private TutorDAO    tutorDAO    = new TutorDAO();
    private CourseDAO   courseDAO   = new CourseDAO();
    private SubjectDAO  subjectDAO  = new SubjectDAO();

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

        // Pull session flash messages
        pullFlash(req, session);

        String courseId = req.getParameter("courseId");
        String tutorId  = req.getParameter("tutorId");

        // Trim whitespace that might come from URL encoding issues
        if (courseId != null) courseId = courseId.trim();
        if (tutorId  != null) tutorId  = tutorId.trim();

        if (account.getRole() == 1 && courseId != null && !courseId.isEmpty()
                && tutorId != null && !tutorId.isEmpty()) {
            // ---- Show Payment Confirmation Page ----
            showPaymentForm(req, resp, session, courseId, tutorId);
        } else {
            // ---- Show Transaction History ----
            showHistory(req, resp, session, account);
        }
    }

    private void showPaymentForm(HttpServletRequest req, HttpServletResponse resp,
                                  HttpSession session, String courseId, String tutorId)
            throws ServletException, IOException {
        Student student = (Student) session.getAttribute("userProfile");
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Course course = courseDAO.findById(courseId);

        // ---- Guard: already paid ----
        if (course != null && "PAID".equalsIgnoreCase(course.getStatus())) {
            session.setAttribute("info", "Khoa hoc nay da duoc thanh toan truoc do.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        Tutor  tutor  = tutorDAO.findById(tutorId);

        // Load subject info
        if (course != null && course.getSubjectId() != null) {
            try {
                Subject subject = subjectDAO.findById(course.getSubjectId());
                if (subject != null) course.setSubject(subject);
            } catch (Exception ignored) {}
        }

        // Always reload fresh balance
        long balance = studentDAO.getBalance(student.getId());
        long price = (course != null && course.getSubject() != null)
                ? course.getSubject().getFee() : 0;
        boolean insufficient = balance < price;

        req.setAttribute("course", course);
        req.setAttribute("tutor", tutor);
        req.setAttribute("balance", balance);
        req.setAttribute("balanceFormatted", String.format("%,d", balance));
        req.setAttribute("insufficient", insufficient);
        req.getRequestDispatcher("/jsp/payment.jsp").forward(req, resp);
    }

    private void showHistory(HttpServletRequest req, HttpServletResponse resp,
                              HttpSession session, Account account)
            throws ServletException, IOException {
        List<Payment> payments;
        if (account.getRole() == 1) {
            Student student = (Student) session.getAttribute("userProfile");
            payments = paymentDAO.findByStudentId(student.getId());
        } else if (account.getRole() == 2) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            payments = paymentDAO.findByTutorId(tutor.getId());
        } else {
            payments = paymentDAO.findAll();
        }
        req.setAttribute("payments", payments);
        req.getRequestDispatcher("/jsp/payment.jsp").forward(req, resp);
    }

    // ----------------------------------------------------------------- POST --
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null || account.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Student student = (Student) session.getAttribute("userProfile");
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseId  = req.getParameter("courseId");
        String tutorId   = req.getParameter("tutorId");
        String amountStr = req.getParameter("amount");

        // Trim
        if (courseId != null) courseId = courseId.trim();
        if (tutorId  != null) tutorId  = tutorId.trim();

        // Validate amount
        long amount;
        try {
            amount = Long.parseLong(amountStr.trim());
            if (amount <= 0) throw new NumberFormatException("zero-or-negative");
        } catch (Exception e) {
            session.setAttribute("error", "Số tiền thanh toán không hợp lệ.");
            resp.sendRedirect(req.getContextPath() +
                "/payment?courseId=" + courseId + "&tutorId=" + tutorId);
            return;
        }

        // ---- Atomic transaction ----
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Double-check: course not already paid (race condition guard)
            Course latestCourse = courseDAO.findById(courseId);
            if (latestCourse != null && "PAID".equalsIgnoreCase(latestCourse.getStatus())) {
                conn.rollback();
                session.setAttribute("info", "Khoa hoc nay da duoc thanh toan truoc do.");
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }

            // 2. Re-read fresh balance to prevent stale data
            long freshBalance = studentDAO.getBalance(student.getId());
            if (freshBalance < amount) {
                conn.rollback();
                session.setAttribute("error",
                    "So du vi khong du! So du hien tai: " +
                    String.format("%,d", freshBalance) + " VND, hoc phi can thanh toan: " +
                    String.format("%,d", amount) + " VND.");
                resp.sendRedirect(req.getContextPath() +
                    "/payment?courseId=" + courseId + "&tutorId=" + tutorId);
                return;
            }

            // 3. Deduct from student
            studentDAO.updateBalance(student.getId(), -amount, conn);

            // 4. Credit tutor
            tutorDAO.updateBalance(tutorId, amount, conn);

            // 5. Insert payment record
            Payment payment = new Payment();
            payment.setId(paymentDAO.generateNextId(conn));
            payment.setCourseId(courseId);
            payment.setTutorId(tutorId);
            payment.setStudentId(student.getId());
            payment.setAmount(amount);
            payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            payment.setPaymentMethod("wallet");
            payment.setStatus("completed");
            payment.setPaymentType("PAYMENT");
            paymentDAO.insert(payment, conn);

            // 6. Mark course as PAID to prevent duplicate payments
            if (courseId != null && !courseId.isEmpty()) {
                courseDAO.updateStatus(courseId, "PAID", conn);
            }

            conn.commit();

            // 6. Refresh student session
            Student refreshed = studentDAO.findById(student.getId());
            if (refreshed != null) session.setAttribute("userProfile", refreshed);

            long remaining = refreshed != null ? refreshed.getBalance() : (freshBalance - amount);
            session.setAttribute("success",
                "✅ Thanh toán học phí thành công! " +
                "Đã thanh toán: " + String.format("%,d", amount) + " VND. " +
                "Số dư còn lại: " + String.format("%,d", remaining) + " VND.");

            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            session.setAttribute("error",
                "❌ Lỗi hệ thống khi xử lý thanh toán. Vui lòng thử lại sau.");
            resp.sendRedirect(req.getContextPath() +
                "/payment?courseId=" + courseId + "&tutorId=" + tutorId);
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); }
                catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    /** Move flash attributes from session → request scope */
    private void pullFlash(HttpServletRequest req, HttpSession session) {
        String s = (String) session.getAttribute("success");
        String e = (String) session.getAttribute("error");
        if (s != null) { req.setAttribute("success", s); session.removeAttribute("success"); }
        if (e != null) { req.setAttribute("error",   e); session.removeAttribute("error");   }
    }
}
