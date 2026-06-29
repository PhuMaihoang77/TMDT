package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        // 1. Kiểm tra đăng nhập
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String bookingId = req.getParameter("id");

        // 2. Xử lý Action (Confirm/Cancel) nếu có
        if ("confirm".equals(action) || "cancel".equals(action)) {
            handleStatusUpdate(req, resp, account, bookingId, action);
            return;
        }

        // 3. Hiển thị form Booking
        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");

        if (tutorId != null && !tutorId.isEmpty()) {
            req.setAttribute("tutor", tutorDAO.findById(tutorId));
            req.setAttribute("courses", courseDAO.findByTutorId(tutorId));
        }
        if (courseId != null && !courseId.isEmpty()) {
            req.setAttribute("selectedCourse", courseDAO.findById(courseId));
        }

        req.getRequestDispatcher("/jsp/booking/booking.jsp").forward(req, resp);
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp, Account account, String bookingId, String action) throws IOException {
        Booking booking = bookingDAO.findById(bookingId);
        if (booking == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        boolean authorized = false;
        HttpSession session = req.getSession();

        // Kiểm tra quyền hạn
        if (account.getRole() == 3) {
            authorized = true;
        } else if (account.getRole() == 2) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            if (tutor != null && booking.getTutorId().equals(tutor.getId())) authorized = true;
        } else if (account.getRole() == 1 && "cancel".equals(action)) {
            Student student = (Student) session.getAttribute("userProfile");
            if (student != null && booking.getStudentId().equals(student.getId())) authorized = true;
        }

        if (authorized) {
            String status = "confirm".equals(action) ? "confirmed" : "rejected";
            bookingDAO.updateStatus(bookingId, status);

            if ("confirmed".equals(status) && booking.getCourseId() != null) {
                if (!courseDAO.isStudentRegistered(booking.getCourseId(), booking.getStudentId())) {
                    courseDAO.registerCourse(booking.getCourseId(), booking.getStudentId(), 10, "pending_payment");
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Student student = (Student) session.getAttribute("userProfile");

        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseId = req.getParameter("courseId");
        String tutorId = req.getParameter("tutorId");
        String bookingTimeStr = req.getParameter("bookingTime");
        String note = req.getParameter("note");

        // Logic bổ sung tutorId nếu thiếu
        if ((tutorId == null || tutorId.isEmpty()) && courseId != null) {
            Course c = courseDAO.findById(courseId);
            if (c != null) tutorId = c.getTutorId();
        }

        Booking booking = new Booking();
        booking.setId(bookingDAO.generateNextId());
        booking.setCourseId(courseId);
        booking.setTutorId(tutorId);
        booking.setStudentId(student.getId());
        booking.setStatus("pending");
        booking.setNote(note);

        try {
            booking.setBookingTime(Timestamp.valueOf(bookingTimeStr.replace("T", " ") + ":00"));
        } catch (Exception e) {
            booking.setBookingTime(new Timestamp(System.currentTimeMillis()));
        }

        bookingDAO.insert(booking);
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}