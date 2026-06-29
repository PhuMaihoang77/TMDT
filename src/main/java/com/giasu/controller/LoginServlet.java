package com.giasu.controller;

import com.giasu.dao.*;
import com.giasu.model.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            Account acc = (Account) session.getAttribute("account");
            redirectByRole(req, resp, acc);
            return;
        }
        req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Account account = accountDAO.login(email, password);

        if (account != null) {
            HttpSession session = req.getSession();
            session.setAttribute("account", account);

            // Load profile info based on role
            if (account.getRole() == 1) {
                Student student = studentDAO.findByAccountId(account.getId());
                session.setAttribute("userProfile", student);
            } else if (account.getRole() == 2) {
                Tutor tutor = tutorDAO.findByAccountId(account.getId());
                session.setAttribute("userProfile", tutor);
            }

            redirectByRole(req, resp, account);
        } else {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
        }
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp, Account account) throws IOException {
        switch (account.getRole()) {
            case 1: resp.sendRedirect(req.getContextPath() + "/"); break;
            case 2: resp.sendRedirect(req.getContextPath() + "/dashboard"); break;
            case 3: resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); break;
            default: resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
