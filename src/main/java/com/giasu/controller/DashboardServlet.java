package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private InterestDAO interestDAO = new InterestDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        String action = req.getParameter("action");
        String bookingId = req.getParameter("id");

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (action != null && bookingId != null && account.getRole() == 2) {
            if (action.equals("confirm")) {
                bookingDAO.updateStatus(bookingId, "confirmed");
                Booking booking = bookingDAO.findById(bookingId);
                if (booking != null && booking.getCourseId() != null) {
                    if (!courseDAO.isStudentRegistered(booking.getCourseId(), booking.getStudentId())) {
                        courseDAO.registerCourse(booking.getCourseId(), booking.getStudentId(), 10, "pending_payment");
                    }
                }
            } else if (action.equals("cancel")) {
                bookingDAO.updateStatus(bookingId, "rejected");
            }
            // Xử lý xong, reload lại trang dashboard để cập nhật trạng thái mới
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Pull session flash messages
        String success = (String) session.getAttribute("success");
        if (success != null) {
            req.setAttribute("success", success);
            session.removeAttribute("success");
        }
        String error = (String) session.getAttribute("error");
        if (error != null) {
            req.setAttribute("error", error);
            session.removeAttribute("error");
        }
        if (action != null && bookingId != null && account.getRole() == 2) {
            if (action.equals("confirm")) {
                bookingDAO.updateStatus(bookingId, "confirmed");
                Booking booking = bookingDAO.findById(bookingId);
                if (booking != null && booking.getCourseId() != null) {
                    if (!courseDAO.isStudentRegistered(booking.getCourseId(), booking.getStudentId())) {
                        courseDAO.registerCourse(booking.getCourseId(), booking.getStudentId(), 10, "pending_payment");
                    }
                }
            } else if (action.equals("cancel")) {
                bookingDAO.updateStatus(bookingId, "rejected");
            }
            // Xử lý xong, reload lại trang dashboard để cập nhật trạng thái mới
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        if (account.getRole() == 2) {
            // Tutor dashboard
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByTutorId(tutor.getId());
            List<Course> courses = courseDAO.findByTutorId(tutor.getId());
            List<Payment> payments = paymentDAO.findByTutorId(tutor.getId());
            List<Review> reviews = reviewDAO.findByTutorId(tutor.getId());

            // Compute statistics
            long monthlyIncome = 0;
            for (Payment p : payments) {
                if ("completed".equals(p.getStatus())) {
                    monthlyIncome += p.getAmount();
                }
            }

            double avgRating = 0;
            if (!reviews.isEmpty()) {
                double sum = 0;
                for (Review r : reviews)
                    sum += r.getRating();
                avgRating = sum / reviews.size();
            } else {
                avgRating = tutor.getEvaluate();
            }

            // Count unique students
            java.util.Set<String> uniqueStudents = new java.util.HashSet<>();
            for (Booking b : bookings) {
                if ("confirmed".equals(b.getStatus())) {
                    uniqueStudents.add(b.getStudentId());
                }
            }
            int studentCount = uniqueStudents.size();
            if (studentCount == 0 && tutor.getTotalStudents() > 0) {
                studentCount = tutor.getTotalStudents();
            }

            // Tutor real balance
            Tutor freshTutor = tutorDAO.findById(tutor.getId());
            long tutorBalance = (freshTutor != null) ? freshTutor.getBalance() : 0;
            req.setAttribute("tutorBalance", String.format("%,d VND", tutorBalance));

            req.setAttribute("bookings", bookings);
            req.setAttribute("tutorBookings", bookings);
            req.setAttribute("courses", courses);
            req.setAttribute("payments", payments);
            req.setAttribute("reviews", reviews);

            req.setAttribute("totalStudents", studentCount);
            req.setAttribute("totalCourses", courses.size());
            req.setAttribute("monthlyIncome", String.format("%,d VND", monthlyIncome));
            req.setAttribute("averageRating", String.format("%.1f", avgRating));

            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else if (account.getRole() == 1) {
            // Student dashboard
            Student student = (Student) session.getAttribute("userProfile");
            List<Booking> bookings = bookingDAO.findByStudentId(student.getId());
            List<Payment> payments = paymentDAO.findByStudentId(student.getId());

            // Find favorite tutors count
            int favoriteCount = 0;
            String sqlFav = "SELECT COUNT(*) FROM interest WHERE id_st = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sqlFav)) {
                ps.setString(1, student.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next())
                        favoriteCount = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Future/Active bookings count
            int upcomingCount = 0;
            for (Booking b : bookings) {
                if ("pending".equals(b.getStatus()) || "confirmed".equals(b.getStatus())) {
                    upcomingCount++;
                }
            }




            req.setAttribute("bookings", bookings);
            req.setAttribute("studentBookings", bookings);
            req.setAttribute("payments", payments);

            req.setAttribute("upcomingCount", upcomingCount);
            req.setAttribute("favoriteTutors", favoriteCount);

            // Load danh sach gia su yeu thich
            List<Tutor> favoriteTutorList = interestDAO.findFavoriteTutorsByStudentId(student.getId());
            req.setAttribute("favoriteTutorList", favoriteTutorList);

            // Real balance from DB
            Student freshStudent = studentDAO.findById(student.getId());
            long studentBalance = (freshStudent != null) ? freshStudent.getBalance() : 0;
            if (freshStudent != null) session.setAttribute("userProfile", freshStudent);
            req.setAttribute("balance", String.format("%,d VND", studentBalance));

            req.getRequestDispatcher("/jsp/auth/dashboard.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        String action = req.getParameter("action");

        // Chỉ cho phép Gia sư (role == 2) tạo khóa học
        if (account != null && account.getRole() == 2 && "createCourse".equals(action)) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");

            String name = req.getParameter("name");
            String level = req.getParameter("level");
            long fee = Long.parseLong(req.getParameter("fee"));
            String description = req.getParameter("description");

            SubjectDAO subjectDAO = new SubjectDAO();

            // 1. Tạo và Insert Subject trước
            Subject subject = new Subject();
            subject.setId(subjectDAO.generateNextId());
            subject.setName(name);
            subject.setLevel(level);
            subject.setFee(fee);
            subject.setDescription(description);
            subject.setStatus("active");

            if (subjectDAO.insert(subject)) {
                // 2. Insert Course gắn với Subject vừa tạo
                Course course = new Course();
                course.setId(courseDAO.generateNextId());
                course.setSubjectId(subject.getId());
                course.setTutorId(tutor.getId());
                course.setStatus("active");

                courseDAO.insert(course);
            }
        }

        // Reload lại trang dashboard để thấy dữ liệu mới
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }

}
