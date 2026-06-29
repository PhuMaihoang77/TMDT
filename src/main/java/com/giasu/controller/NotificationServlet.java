package com.giasu.controller;

import com.giasu.dao.NotificationDAO;
import com.giasu.model.Account;
import com.giasu.model.Notification;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        String action = req.getParameter("action");

        if ("list".equals(action)) {
            List<Notification> list = notificationDAO.findByAccountId(acc.getId());
            sendJsonResponse(resp, list);
        } else if ("unreadCount".equals(action)) {
            int count = notificationDAO.countUnread(acc.getId());
            Map<String, Object> map = new HashMap<>();
            map.put("count", count);
            sendJsonResponse(resp, map);
        } else {
            // Forward to notifications list page
            List<Notification> list = notificationDAO.findByAccountId(acc.getId());
            req.setAttribute("notifications", list);
            req.getRequestDispatcher("/jsp/home/notifications.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        String action = req.getParameter("action");
        Map<String, Object> result = new HashMap<>();

        if ("read".equals(action)) {
            String id = req.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                boolean success = notificationDAO.markAsRead(id);
                result.put("success", success);
            } else {
                result.put("success", false);
                result.put("message", "ID không hợp lệ");
            }
        } else if ("readAll".equals(action)) {
            boolean success = notificationDAO.markAllAsRead(acc.getId());
            result.put("success", success);
        } else {
            result.put("success", false);
            result.put("message", "Hành động không được hỗ trợ");
        }

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
