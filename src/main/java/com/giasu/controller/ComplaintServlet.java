package com.giasu.controller;

import com.giasu.dao.ComplaintDAO;
import com.giasu.model.Account;
import com.giasu.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/complaint")
public class ComplaintServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null || acc.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Complaint c = new Complaint();
            c.setId(complaintDAO.generateNextId()); // Hàm sinh ID đã được fix ở DAO
            c.setBookingId(request.getParameter("bookingId"));
            c.setStudentId(request.getParameter("studentId"));
            c.setTitle(request.getParameter("title"));
            c.setDescription(request.getParameter("description"));

            if (complaintDAO.insert(c)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?status=success&msgType=complaint");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?status=fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?status=fail");
        }
    }
}