package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();
    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");
        Student student = (Student) session.getAttribute("userProfile");

        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String tutorId = req.getParameter("tutorId");
        String courseId = req.getParameter("courseId");
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");

        Review review = new Review();
        review.setId(reviewDAO.generateNextId());
        review.setTutorId(tutorId);
        review.setStudentId(student.getId());
        review.setCourseId(courseId);
        review.setComment(comment);

        try {
            review.setRating(Integer.parseInt(ratingStr));
        } catch (Exception e) {
            review.setRating(5);
        }

        reviewDAO.insert(review);

        // Cập nhật điểm đánh giá trung bình của gia sư
        double avgRating = reviewDAO.getAverageRating(tutorId);
        tutorDAO.updateEvaluate(tutorId, avgRating);

        resp.sendRedirect(req.getContextPath() + "/tutor-detail?id=" + tutorId);
    }
}
