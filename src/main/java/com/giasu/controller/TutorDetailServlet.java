package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/tutor-detail")
public class TutorDetailServlet extends HttpServlet {
    private TutorDAO tutorDAO = new TutorDAO();
    private SubjectDAO subjectDAO = new SubjectDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private ReviewDAO reviewDAO = new ReviewDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tutorId = req.getParameter("id");
        if (tutorId == null || tutorId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/tutors");
            return;
        }

        Tutor tutor = tutorDAO.findById(tutorId);
        if (tutor == null) {
            resp.sendRedirect(req.getContextPath() + "/tutors");
            return;
        }

        List<Subject> subjects = subjectDAO.findByTutorId(tutorId);
        List<Course> courses = courseDAO.findByTutorId(tutorId);
        List<Review> reviews = reviewDAO.findByTutorId(tutorId);
        double avgRating = reviewDAO.getAverageRating(tutorId);

        // Xử lí logic thống kê
        int totalCourses = (courses != null) ? courses.size() : 0; //số lượng lớp học
        int totalReviews = (reviews != null) ? reviews.size() : 0; // số lượt phản hồi

        // Đếm số lượng học sinh đã học (dựa vào danh sách booking đã được chấp nhận)
        int totalStudents = bookingDAO.countStudentsByTutorId(tutorId);


        req.setAttribute("tutor", tutor);
        req.setAttribute("subjects", subjects);
        req.setAttribute("courses", courses);
        req.setAttribute("reviews", reviews);
        req.setAttribute("avgRating", avgRating);
        req.setAttribute("totalCourses", totalCourses);
        req.setAttribute("totalReviews", totalReviews);
        req.setAttribute("totalStudents", totalStudents);
        req.getRequestDispatcher("/jsp/tutor/tutor-detail.jsp").forward(req, resp);
    }
}
