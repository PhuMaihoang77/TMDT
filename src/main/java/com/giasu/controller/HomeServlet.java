package com.giasu.controller;

import com.giasu.dao.TutorDAO;
import com.giasu.model.Tutor;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gọi hàm lấy gia sư đã xác minh từ TutorDAO của bạn
        List<Tutor> verifiedTutors = tutorDAO.findAll(); // Lấy tất cả để test hiển thị

        // Truyền dữ liệu sang index.jsp với tên biến là "tutors"
        request.setAttribute("tutors", verifiedTutors);
        request.getRequestDispatcher("/jsp/home/index.jsp").forward(request, response);
    }
}