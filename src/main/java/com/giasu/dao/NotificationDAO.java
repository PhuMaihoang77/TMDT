package com.giasu.dao;

import com.giasu.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public boolean insert(Notification notif) {
        String sql = "INSERT INTO notifications (id, account_id, title, message, type, is_read, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, notif.getId());
            ps.setString(2, notif.getAccountId());
            ps.setString(3, notif.getTitle());
            ps.setString(4, notif.getMessage());
            ps.setString(5, notif.getType());
            ps.setShort(6, (short) (notif.isRead() ? 1 : 0));
            ps.setString(7, notif.getStatus() != null ? notif.getStatus() : "sent");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Notification> findByAccountId(String accountId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE account_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUnread(String accountId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE account_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean markAsRead(String id) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markAllAsRead(String accountId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE account_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification notif = new Notification();
        notif.setId(rs.getString("id"));
        notif.setAccountId(rs.getString("account_id"));
        notif.setTitle(rs.getString("title"));
        notif.setMessage(rs.getString("message"));
        notif.setType(rs.getString("type"));
        notif.setCreatedAt(rs.getTimestamp("created_at"));
        notif.setRead(rs.getShort("is_read") == 1);
        notif.setStatus(rs.getString("status"));
        return notif;
    }
}
