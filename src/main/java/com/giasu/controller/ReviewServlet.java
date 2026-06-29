package com.giasu.controller;

import com.giasu.dao.ReviewDAO;
import com.giasu.dao.TutorDAO;
import com.giasu.model.Account;
import com.giasu.model.Review;
import com.giasu.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Đảm bảo đồng bộ hóa tiếng Việt không bị lỗi font
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        // Lấy profile học sinh từ Session (Nếu của bạn lưu thẳng Account, hãy đổi lại logic)
        Student student = (Student) session.getAttribute("userProfile");

        // Phòng ngự vòng 1: Chưa đăng nhập hoặc không phải học sinh -> Sút về trang Login
        if (account == null || account.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean isSuccess = false;
        try {
            String tutorId = req.getParameter("tutorId");
            String courseId = req.getParameter("courseId");
            String comment = req.getParameter("comment");
            String ratingRaw = req.getParameter("rating");

            // Xử lý chuẩn hóa chuỗi Rating để KHÔNG BAO GIỜ bị lỗi NumberFormatException nữa
            int rating = 5; // Mặc định là 5 sao nếu có lỗi
            if (ratingRaw != null) {
                // Xóa khoảng trắng thừa
                ratingRaw = ratingRaw.trim();

                // Phòng hờ nếu form gửi lên chuỗi dạng mảng "5,5" hoặc "5,"
                if (ratingRaw.contains(",")) {
                    ratingRaw = ratingRaw.split(",")[0].trim();
                }

                // Tiến hành parse an toàn
                try {
                    rating = Integer.parseInt(ratingRaw);
                } catch (NumberFormatException nfe) {
                    System.err.println("[TutorHub Error] Không thể parse rating: " + ratingRaw);
                    rating = 5; // Fallback về 5 sao
                }
            }

            // Tạo đối tượng Model Review
            Review review = new Review();
            review.setId(reviewDAO.generateNextId());
            review.setTutorId(tutorId);

            // Lấy Student ID an toàn
            if (student != null) {
                review.setStudentId(student.getId());
            } else {
                review.setStudentId(req.getParameter("studentId")); // Backup nếu session userProfile chưa kịp set
            }

            // Validate tránh lỗi khóa ngoại nếu Course trống
            if (courseId != null && !courseId.trim().isEmpty() && !courseId.equals("null")) {
                review.setCourseId(courseId.trim());
            } else {
                review.setCourseId(null);
            }

            review.setComment(comment != null ? comment.trim() : "");
            review.setRating(rating);

            // Thực thi ghi vào Database
            if (reviewDAO.insert(review)) {
                // Tính toán lại điểm trung bình thực tế từ Database của gia sư đó
                double avgRating = reviewDAO.getAverageRating(tutorId);
                tutorDAO.updateEvaluate(tutorId, avgRating);
                isSuccess = true;
            }

        } catch (Exception e) {
            System.err.println("[TutorHub System Failure] Lỗi nghiêm trọng tại ReviewServlet:");
            e.printStackTrace();
        }

        // Điều hướng kết quả về màn hình để hiển thị Toast Notification mượt mà
        if (isSuccess) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?status=success&msgType=review");
        } else {
            resp.sendRedirect(req.getContextPath() + "/dashboard?status=fail");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}