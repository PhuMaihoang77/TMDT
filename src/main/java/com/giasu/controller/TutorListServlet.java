package com.giasu.controller;

import com.giasu.dao.CourseDAO;
import com.giasu.dao.TutorDAO;
import com.giasu.model.Course;
import com.giasu.model.Tutor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/tutors")
public class TutorListServlet extends HttpServlet {
    private TutorDAO tutorDAO = new TutorDAO();
    private CourseDAO courseDAO = new CourseDAO();
    private Course course = new Course();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Nhận các tham số từ View
        String keyword = req.getParameter("keyword");
        String subjectName = req.getParameter("subjectName");
        String level = req.getParameter("level");
        String minPriceStr = req.getParameter("minPrice");
        String maxPriceStr = req.getParameter("maxPrice");
        String ratingStr = req.getParameter("rating");

        // 2. Xử lý ép kiểu dữ liệu an toàn
        Integer minRating = 0;
        Integer minPrice = null;
        Integer maxPrice = null;

        try {
            if (ratingStr != null && !ratingStr.isEmpty()) minRating = Integer.parseInt(ratingStr);
            if (minPriceStr != null && !minPriceStr.isEmpty()) minPrice = Integer.parseInt(minPriceStr);
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) maxPrice = Integer.parseInt(maxPriceStr);
        } catch (NumberFormatException e) {
            // Log lỗi nếu cần, bỏ qua ép kiểu nếu người dùng nhập linh tinh
        }

        // 3. Gọi hàm SQL thông minh
        List<Tutor> tutors = tutorDAO.searchAdvanced(keyword, subjectName, level, minPrice, maxPrice, minRating);

// 4. Nạp và LỌC danh sách khóa học cho từng gia sư
        for (Tutor t : tutors) {
            List<Course> allCourses = courseDAO.findByTutorId(t.getId());
            List<Course> filteredCourses = new ArrayList<>();

            // Kiểm tra xem người dùng có đang dùng bất kỳ bộ lọc nào không
            boolean isFiltering = (keyword != null && !keyword.trim().isEmpty()) ||
                    (subjectName != null && !subjectName.trim().isEmpty()) ||
                    (level != null && !level.trim().isEmpty()) ||
                    (minPrice != null) || (maxPrice != null);

            if (!isFiltering) {
                // Lướt bình thường: Nạp toàn bộ danh sách lớp
                filteredCourses = allCourses;
            } else {
                // Đang tìm kiếm: Lọc khắt khe để loại bỏ các lớp không khớp
                for (Course c : allCourses) {
                    boolean isMatch = true;

                    // 1. Lọc theo Môn Học (Dropdown)
                    if (subjectName != null && !subjectName.trim().isEmpty()) {
                        String subToLower = subjectName.trim().toLowerCase();
                        if (!c.getSubject().getName().toLowerCase().contains(subToLower) &&
                                !(t.getSpecialization() != null && t.getSpecialization().toLowerCase().contains(subToLower))) {
                            isMatch = false;
                        }
                    }

                    // 2. Lọc theo Cấp bậc (Dropdown)
                    if (isMatch && level != null && !level.trim().isEmpty()) {
                        if (c.getSubject().getLevel() == null || !c.getSubject().getLevel().equalsIgnoreCase(level.trim())) {
                            isMatch = false;
                        }
                    }

                    // 3. Lọc theo Giá
                    if (isMatch && minPrice != null && c.getSubject().getFee() < minPrice) isMatch = false;
                    if (isMatch && maxPrice != null && c.getSubject().getFee() > maxPrice) isMatch = false;

                    // 4. Lọc theo Keyword (Thanh tìm kiếm chung) - FIX QUAN TRỌNG TẠI ĐÂY
                    if (isMatch && keyword != null && !keyword.trim().isEmpty()) {
                        String kw = keyword.trim().toLowerCase();

                        boolean matchCourse = c.getSubject().getName().toLowerCase().contains(kw);
                        boolean matchTutor = t.getName().toLowerCase().contains(kw);

                        // LOGIC: NẾU GÕ TÊN MÔN -> CHỈ HIỆN ĐÚNG MÔN ĐÓ.
                        // NẾU GÕ TÊN THẦY -> MỚI ĐƯỢC HIỆN TOÀN BỘ MÔN CỦA THẦY.
                        if (!matchCourse && !matchTutor) {
                            isMatch = false;
                        }
                    }

                    // Chỉ đưa vào danh sách nếu lớp học vượt qua mọi bài kiểm tra
                    if (isMatch) {
                        filteredCourses.add(c);
                    }
                }
            }
            // Nạp danh sách đã lọc SIÊU CHUẨN vào Gia sư
            t.setCourses(filteredCourses);
        }

        // 5. Đẩy dữ liệu sang View
        req.setAttribute("tutors", tutors);
        req.setAttribute("specializations", tutorDAO.getAllSpecializations()); // Vẫn giữ để làm data cho Dropdown

        // Giữ lại trạng thái form sau khi Submit
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedSubject", subjectName);
        req.setAttribute("selectedLevel", level);
        req.setAttribute("minPrice", minPriceStr);
        req.setAttribute("maxPrice", maxPriceStr);
        req.setAttribute("selectedRating", ratingStr);

        req.getRequestDispatcher("/jsp/tutor/tutor-list.jsp").forward(req, resp);
    }
}