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
        String subjectName = req.getParameter("subject");
        String level = req.getParameter("level");
        String minPriceStr = req.getParameter("minPrice");
        String maxPriceStr = req.getParameter("maxPrice");
        String ratingStr = req.getParameter("rating");
        String grade = req.getParameter("grade"); // Thêm dòng này để hứng dữ liệu Lớp
        String tutorType = req.getParameter("tutorType");
        String sortBy = req.getParameter("sortBy");

        // ĐỊNH NGHĨA DANH MỤC MÔN HỌC & KỸ NĂNG CHUẨN (MASTER DATA)
        List<String> standardSubjects = java.util.Arrays.asList(
                // 1. Nhóm Tiểu học & Nền tảng
                "Toán tư duy", "Rèn chữ đẹp", "Tiếng Việt", "Báo bài",

                // 2. Nhóm Phổ thông (Cấp 2 & Cấp 3)
                "Toán", "Ngữ văn", "Vật lý", "Hóa học", "Sinh học",
                "Lịch sử", "Địa lý", "Tin học",

                // 3. Nhóm Ngoại ngữ & Chứng chỉ
                "Tiếng Anh", "Luyện thi IELTS", "Luyện thi TOEIC", "Tiếng Anh giao tiếp",
                "Tiếng Nhật", "Tiếng Hàn", "Tiếng Trung", "Tiếng Pháp",

                // 4. Nhóm Năng khiếu & Khác
                "Lập trình", "Đàn Piano", "Đàn Guitar", "Vẽ", "Năng khiếu khác"
        );


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
        // Truyền thêm biến grade vào tham số thứ 4
        // Đã truyền thêm biến tutorType vào vị trí thứ 5
        // Đảm bảo truyền đủ các tham số theo đúng thứ tự logic đã nâng cấp ở DAO
        // 3. Gọi hàm SQL thông minh
        List<Tutor> tutors = tutorDAO.searchAdvanced(keyword, subjectName, level, grade, tutorType, minPrice, maxPrice, minRating);

        // KIỂM TRA BỘ LỌC ĐƯỢC ĐẶT Ở NGOÀI VÒNG LẶP ĐỂ DÙNG CHUNG
        // KIỂM TRA BỘ LỌC ĐƯỢC ĐẶT Ở NGOÀI VÒNG LẶP ĐỂ DÙNG CHUNG
        boolean isFiltering = (keyword != null && !keyword.trim().isEmpty()) ||
                (subjectName != null && !subjectName.trim().isEmpty()) ||
                (level != null && !level.trim().isEmpty()) ||
                (grade != null && !grade.trim().isEmpty()) ||
                (tutorType != null && !tutorType.trim().isEmpty()) ||
                (minPrice != null) ||
                (maxPrice != null && maxPrice < 3000000); // BỔ SUNG: Chỉ kích hoạt lọc giá nếu thật sự kéo xuống dưới mức 3 triệu

        for (Tutor t : tutors) {
            List<Course> allCourses = courseDAO.findByTutorId(t.getId());
            List<Course> filteredCourses = new ArrayList<>();

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

                    // 2. Lọc theo Cấp bậc & Khối lớp (Dropdown)
                    if (isMatch && level != null && !level.trim().isEmpty()) {
                        String courseLevel = (c.getSubject().getLevel() != null) ? c.getSubject().getLevel().toLowerCase() : "";
                        String lvl = level.trim().toLowerCase();
                        String grd = (grade != null) ? grade.trim().toLowerCase() : "";

                        // Ưu tiên 1: Nếu có chọn Khối lớp cụ thể (Ví dụ: "Lớp 1") - Bảo đảm không dính Lớp 10, 11, 12
                        if (!grd.isEmpty()) {
                            boolean exactMatch = courseLevel.equals(grd)
                                    || courseLevel.contains(grd + " ")
                                    || courseLevel.endsWith(grd);

                            if (!exactMatch) {
                                isMatch = false;
                            }
                        }
                        // Ưu tiên 2: Nếu chỉ chọn Cấp học chung chung
                        else {
                            if (lvl.equals("cap1")) {
                                if (!courseLevel.contains("lớp 1") && !courseLevel.contains("lớp 2") && !courseLevel.contains("lớp 3") && !courseLevel.contains("lớp 4") && !courseLevel.contains("lớp 5") && !courseLevel.contains("cấp 1") && !courseLevel.contains("tiểu học")) {
                                    isMatch = false;
                                }
                                if (courseLevel.contains("lớp 10") || courseLevel.contains("lớp 11") || courseLevel.contains("lớp 12")) {
                                    isMatch = false;
                                }
                            } else if (lvl.equals("cap2")) {
                                if (!courseLevel.contains("lớp 6") && !courseLevel.contains("lớp 7") && !courseLevel.contains("lớp 8") && !courseLevel.contains("lớp 9") && !courseLevel.contains("cấp 2") && !courseLevel.contains("thcs")) {
                                    isMatch = false;
                                }
                            } else if (lvl.equals("cap3")) {
                                if (!courseLevel.contains("lớp 10") && !courseLevel.contains("lớp 11") && !courseLevel.contains("lớp 12") && !courseLevel.contains("cấp 3") && !courseLevel.contains("thpt")) {
                                    isMatch = false;
                                }
                            } else if (!courseLevel.contains(lvl)) {
                                isMatch = false;
                            }
                        }
                    }

                    // 3. Lọc theo Giá Học Phí Tối Đa
                    if (isMatch && maxPrice != null && c.getSubject().getFee() > maxPrice) {
                        isMatch = false;
                    }
                    // 4. Lọc theo Keyword (Thanh tìm kiếm chung)
                    if (isMatch && keyword != null && !keyword.trim().isEmpty()) {
                        String kw = keyword.trim().toLowerCase();
                        boolean matchCourse = c.getSubject().getName().toLowerCase().contains(kw);
                        boolean matchTutor = t.getName().toLowerCase().contains(kw);

                        if (!matchCourse && !matchTutor) {
                            isMatch = false;
                        }
                    }

                    if (isMatch) {
                        filteredCourses.add(c);
                    }
                }
            }
            // Nạp danh sách đã lọc SIÊU CHUẨN vào Gia sư
            t.setCourses(filteredCourses);
        }

        // --- BỔ SUNG LOGIC LÀM SẠCH VÀ SẮP XẾP ---

        // A. Làm sạch: Xóa các gia sư bị "trắng" lớp học
        if (isFiltering) {
            tutors.removeIf(t -> t.getCourses() == null || t.getCourses().isEmpty());
        }

        // B. Sắp xếp danh sách dựa trên tham số sortBy
        if (sortBy != null) {
            if (sortBy.equals("price_asc")) {
                tutors.sort((t1, t2) -> {
                    double minPrice1 = t1.getCourses().stream().mapToDouble(c -> c.getSubject().getFee()).min().orElse(Double.MAX_VALUE);
                    double minPrice2 = t2.getCourses().stream().mapToDouble(c -> c.getSubject().getFee()).min().orElse(Double.MAX_VALUE);
                    return Double.compare(minPrice1, minPrice2);
                });
            } else if (sortBy.equals("price_desc")) {
                tutors.sort((t1, t2) -> {
                    double minPrice1 = t1.getCourses().stream().mapToDouble(c -> c.getSubject().getFee()).min().orElse(0);
                    double minPrice2 = t2.getCourses().stream().mapToDouble(c -> c.getSubject().getFee()).min().orElse(0);
                    return Double.compare(minPrice2, minPrice1);
                });
            } else if (sortBy.equals("rating_desc")) {
                tutors.sort((t1, t2) -> Integer.compare(t2.getEvaluate(), t1.getEvaluate()));
            }
        }



        // 5. Đẩy dữ liệu sang View
        req.setAttribute("tutors", tutors);
        req.setAttribute("specializations", standardSubjects);
        // Giữ lại trạng thái form sau khi Submit
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedSubject", subjectName);
        req.setAttribute("selectedLevel", level);
        req.setAttribute("minPrice", minPriceStr);
        req.setAttribute("maxPrice", maxPriceStr);
        req.setAttribute("selectedRating", ratingStr);
        req.setAttribute("selectedGrade", grade);
        req.setAttribute("selectedTutorType", tutorType); // Gửi lại dữ liệu nút đã chọn

        req.getRequestDispatcher("/jsp/tutor/tutor-list.jsp").forward(req, resp);
    }
}