package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/auth/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account account = (Account) session.getAttribute("account");

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        if (account.getRole() == 1) {
            Student student = (Student) session.getAttribute("userProfile");
            student.setName(name);
            student.setPhone(phone);
            student.setAddress(address);
            String description = req.getParameter("description");
            student.setDescription(description);

            if (studentDAO.update(student)) {
                session.setAttribute("userProfile", student);
                req.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                req.setAttribute("error", "Có lỗi xảy ra!");
            }
        } else if (account.getRole() == 2) {
            Tutor tutor = (Tutor) session.getAttribute("userProfile");
            tutor.setName(name);
            tutor.setPhone(phone);
            tutor.setAddress(address);
            tutor.setSpecialization(req.getParameter("specialization"));
            tutor.setDescription(req.getParameter("description"));
            tutor.setBankName(req.getParameter("bankName"));

            try {
                tutor.setBankAccountNumber(Long.parseLong(req.getParameter("bankAccountNumber")));
            } catch (Exception e) {}

            if (tutorDAO.update(tutor)) {
                session.setAttribute("userProfile", tutor);
                req.setAttribute("success", "Cập nhật hồ sơ thành công!");
            } else {
                req.setAttribute("error", "Có lỗi xảy ra!");
            }
        }

        req.getRequestDispatcher("/jsp/auth/profile.jsp").forward(req, resp);
    }
}
