package com.giasu.controller;

import com.giasu.dao.InterestDAO;
import com.giasu.model.Account;
import com.giasu.model.Student;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    private InterestDAO interestDAO = new InterestDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("favorite", false);
            sendJsonResponse(resp, result);
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        if (acc.getRole() != 1) {
            Map<String, Object> result = new HashMap<>();
            result.put("favorite", false);
            sendJsonResponse(resp, result);
            return;
        }

        Student student = (Student) session.getAttribute("userProfile");
        if (student == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("favorite", false);
            sendJsonResponse(resp, result);
            return;
        }

        String tutorId = req.getParameter("tutorId");
        if (tutorId == null || tutorId.trim().isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("favorite", false);
            sendJsonResponse(resp, result);
            return;
        }

        boolean isFav = interestDAO.isFavorite(student.getId(), tutorId.trim());
        Map<String, Object> result = new HashMap<>();
        result.put("favorite", isFav);
        sendJsonResponse(resp, result);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            sendErrorResponse(resp, "Vui lòng đăng nhập trước khi thực hiện chức năng này.");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        if (acc.getRole() != 1) {
            sendErrorResponse(resp, "Chỉ học sinh/phụ huynh mới có thể sử dụng chức năng yêu thích gia sư.");
            return;
        }

        Student student = (Student) session.getAttribute("userProfile");
        if (student == null) {
            sendErrorResponse(resp, "Không tìm thấy hồ sơ học sinh tương ứng.");
            return;
        }

        String tutorId = req.getParameter("tutorId");
        if (tutorId == null || tutorId.trim().isEmpty()) {
            sendErrorResponse(resp, "Mã gia sư không hợp lệ.");
            return;
        }

        tutorId = tutorId.trim();
        Map<String, Object> result = new HashMap<>();

        boolean isFav = interestDAO.isFavorite(student.getId(), tutorId);
        boolean success;
        boolean nowFavorite;

        if (isFav) {
            success = interestDAO.delete(student.getId(), tutorId);
            nowFavorite = false;
        } else {
            success = interestDAO.insert(student.getId(), tutorId);
            nowFavorite = true;
        }

        result.put("success", success);
        result.put("favorite", nowFavorite);
        if (success) {
            result.put("message", nowFavorite ? "Đã thêm gia sư vào danh sách yêu thích!" : "Đã xóa gia sư khỏi danh sách yêu thích.");
        } else {
            result.put("message", "Đã xảy ra lỗi, vui lòng thử lại.");
        }

        sendJsonResponse(resp, result);
    }

    private void sendErrorResponse(HttpServletResponse resp, String msg) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", msg);
        sendJsonResponse(resp, result);
    }

    private void sendJsonResponse(HttpServletResponse resp, Object data) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
}
