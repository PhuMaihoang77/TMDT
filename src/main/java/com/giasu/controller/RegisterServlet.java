package com.giasu.controller;

import com.giasu.dao.AccountDAO;
import com.giasu.dao.StudentDAO;
import com.giasu.dao.TutorDAO;
import com.giasu.model.Account;
import com.giasu.model.Student;
import com.giasu.model.Tutor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/jsp/auth/register.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            req.setCharacterEncoding("UTF-8");

            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");

            int roleType = Integer.parseInt(
                    req.getParameter("role")
            );

            // VALIDATE

            if (!password.equals(confirmPassword)) {

                req.setAttribute(
                        "error",
                        "Mật khẩu xác nhận không khớp!"
                );

                req.getRequestDispatcher("/jsp/auth/register.jsp")
                        .forward(req, resp);

                return;
            }

            // CHECK EMAIL

            if (accountDAO.findByEmail(email) != null) {

                req.setAttribute(
                        "error",
                        "Email đã tồn tại!"
                );

                req.getRequestDispatcher("/jsp/auth/register.jsp")
                        .forward(req, resp);

                return;
            }

            // INSERT ACCOUNT

            Account acc = new Account();

            acc.setId(accountDAO.generateNextId());
            acc.setEmail(email);
            acc.setPassword(password);
            acc.setRole(roleType);
            acc.setStatus("active");

            boolean inserted = accountDAO.insert(acc);

            if (!inserted) {

                req.setAttribute(
                        "error",
                        "Không thể tạo tài khoản!"
                );

                req.getRequestDispatcher("/jsp/auth/register.jsp")
                        .forward(req, resp);

                return;
            }

            // STUDENT

            if (roleType == 1) {

                Student st = new Student();

                st.setId(studentDAO.generateNextId());
                st.setName(name);
                st.setPhone(phone);

                st.setAccountId(acc.getId());

                studentDAO.insert(st);
            }

            // TUTOR

            else {

                Tutor tutor = new Tutor();

                tutor.setId(tutorDAO.generateNextId());

                tutor.setName(name);
                tutor.setEmail(email);

                tutor.setPhone(phone);

                tutor.setAddress(
                        req.getParameter("address")
                );

                tutor.setSpecialization(
                        req.getParameter("specialization")
                );

                tutor.setDescription("");

                tutor.setVerified(false);

                tutor.setEvaluate(0);

                tutor.setAccountId(acc.getId());

                // DATE

                try {

                    tutor.setBirth(
                            Date.valueOf(
                                    req.getParameter("birth")
                            )
                    );

                } catch (Exception e) {

                    tutor.setBirth(
                            Date.valueOf("2000-01-01")
                    );
                }

                // CCCD

                try {

                    tutor.setIdCardNumber(
                            Long.parseLong(
                                    req.getParameter("idCardNumber")
                            )
                    );

                } catch (Exception e) {

                    tutor.setIdCardNumber(0);
                }

                // BANK

                try {

                    tutor.setBankAccountNumber(
                            Long.parseLong(
                                    req.getParameter("bankAccountNumber")
                            )
                    );

                } catch (Exception e) {

                    tutor.setBankAccountNumber(0);
                }

                tutor.setBankName(
                        req.getParameter("bankName")
                );

                tutorDAO.insert(tutor);
            }

            req.setAttribute(
                    "success",
                    "Đăng ký thành công!"
            );

            req.getRequestDispatcher("/jsp/auth/login.jsp")
                    .forward(req, resp);

        } catch (Exception e) {

            e.printStackTrace();

            req.setAttribute(
                    "error",
                    "Lỗi hệ thống: " + e.getMessage()
            );

            req.getRequestDispatcher("/jsp/auth/register.jsp")
                    .forward(req, resp);
        }
    }
}