package com.giasu.controller;

import com.giasu.dao.AccountDAO;
import com.giasu.dao.StudentDAO;
import com.giasu.dao.TutorDAO;
import com.giasu.model.Account;
import com.giasu.model.Student;
import com.giasu.model.Tutor;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.message.BasicNameValuePair;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.util.Arrays;
import java.util.Properties;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private static String CLIENT_ID;
    private static String CLIENT_SECRET;
    private static String REDIRECT_URI;

    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private AccountDAO accountDAO = new AccountDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TutorDAO tutorDAO = new TutorDAO();
    private Gson gson = new Gson();

    static {
        try (InputStream input = GoogleLoginServlet.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            if (input != null) {
                props.load(input);
                CLIENT_ID = props.getProperty("google.client.id");
                CLIENT_SECRET = props.getProperty("google.client.secret");
                REDIRECT_URI = props.getProperty("google.redirect.uri");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String code = req.getParameter("code");
        String error = req.getParameter("error");

        // Nếu Google tra ve loi (nguoi dung huy)
        if (error != null) {
            req.setAttribute("error", "Dang nhap Google bi huy.");
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
            return;
        }

        // Neu khong co code -> redirect den Google login
        if (code == null || code.isEmpty()) {
            if (CLIENT_ID == null || CLIENT_ID.startsWith("YOUR_")) {
                req.setAttribute("error", "Chua cau hinh Google OAuth (client_id). Vui long cau hinh trong db.properties.");
                req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
                return;
            }

            try {
                URI authUri = new URIBuilder(GOOGLE_AUTH_URL)
                        .addParameter("client_id", CLIENT_ID)
                        .addParameter("redirect_uri", REDIRECT_URI)
                        .addParameter("response_type", "code")
                        .addParameter("scope", "openid email profile")
                        .addParameter("access_type", "offline")
                        .addParameter("prompt", "consent")
                        .build();
                resp.sendRedirect(authUri.toString());
            } catch (Exception e) {
                throw new ServletException("Google OAuth URI build failed", e);
            }
            return;
        }

        // Co code -> exchange lay token + user info
        try {
            // 1. Exchange code for access_token
            String tokenResponse = Request.Post(GOOGLE_TOKEN_URL)
                    .bodyForm(Arrays.asList(
                            new BasicNameValuePair("code", code),
                            new BasicNameValuePair("client_id", CLIENT_ID),
                            new BasicNameValuePair("client_secret", CLIENT_SECRET),
                            new BasicNameValuePair("redirect_uri", REDIRECT_URI),
                            new BasicNameValuePair("grant_type", "authorization_code")
                    ))
                    .execute().returnContent().asString();

            JsonObject tokenJson = gson.fromJson(tokenResponse, JsonObject.class);

            if (tokenJson.has("error")) {
                req.setAttribute("error", "Google xac thuc that bai: " + tokenJson.get("error").getAsString());
                req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
                return;
            }

            String accessToken = tokenJson.get("access_token").getAsString();

            // 2. Get user info
            String userInfoResponse = Request.Get(GOOGLE_USERINFO_URL)
                    .addHeader("Authorization", "Bearer " + accessToken)
                    .execute().returnContent().asString();

            JsonObject userInfo = gson.fromJson(userInfoResponse, JsonObject.class);

            String googleEmail = userInfo.get("email").getAsString();
            String googleName = userInfo.has("name") ? userInfo.get("name").getAsString() : "Google User";
            String googleAvatar = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;

            // 3. Kiem tra email da ton tai chua
            Account existingAccount = accountDAO.findByEmail(googleEmail);

            if (existingAccount != null) {
                // Dang nhap vao tai khoan da co
                loginAccount(req, resp, existingAccount, googleAvatar);
            } else {
                // Tao tai khoan moi (mac dinh role 1 = Student)
                Account newAccount = new Account();
                newAccount.setId(accountDAO.generateNextId());
                newAccount.setEmail(googleEmail);
                newAccount.setPassword(""); // Google OAuth khong can password
                newAccount.setRole(1); // Mac dinh la Student
                newAccount.setStatus("active");

                boolean inserted = accountDAO.insert(newAccount);

                if (!inserted) {
                    req.setAttribute("error", "Khong the tao tai khoan tu Google. Vui long thu lai.");
                    req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
                    return;
                }

                // Tao student profile
                Student student = new Student();
                student.setId(studentDAO.generateNextId());
                student.setName(googleName);
                student.setPhone("");
                student.setAddress("");
                if (googleAvatar != null && !googleAvatar.isEmpty()) {
                    student.setAvatar(googleAvatar);
                }
                student.setAccountId(newAccount.getId());
                studentDAO.insert(student);

                // Dang nhap
                loginAccount(req, resp, newAccount, googleAvatar);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Loi ket noi Google: " + e.getMessage());
            req.getRequestDispatcher("/jsp/auth/login.jsp").forward(req, resp);
        }
    }

    private void loginAccount(HttpServletRequest req, HttpServletResponse resp,
                               Account account, String avatarUrl)
            throws IOException {
        HttpSession session = req.getSession();
        session.setAttribute("account", account);

        if (account.getRole() == 1) {
            Student student = studentDAO.findByAccountId(account.getId());
            if (student != null && avatarUrl != null && (student.getAvatar() == null || student.getAvatar().equals("default-avatar.png"))) {
                student.setAvatar(avatarUrl);
            }
            session.setAttribute("userProfile", student);
        } else if (account.getRole() == 2) {
            Tutor tutor = tutorDAO.findByAccountId(account.getId());
            session.setAttribute("userProfile", tutor);
        }

        redirectByRole(req, resp, account);
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        String contextPath = req.getContextPath();
        if (account.getRole() == 3) {
            resp.sendRedirect(contextPath + "/admin/dashboard");
        } else {
            resp.sendRedirect(contextPath + "/dashboard");
        }
    }
}
