package com.giasu.dao;

import com.giasu.model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    public Account findByEmail(String email) {
        String sql = "SELECT * FROM account WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account findById(String id) {
        String sql = "SELECT * FROM account WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account login(String email, String password) {
        String sql = "SELECT * FROM account WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Account acc) {
        String sql = "INSERT INTO account (id, email, password, role, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getId().trim());
            ps.setString(2, acc.getEmail());
            ps.setString(3, acc.getPassword());
            ps.setInt(4, acc.getRole());
            ps.setString(5, acc.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Account acc) {
        String sql = "UPDATE account SET email = ?, password = ?, role = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, acc.getEmail());
            ps.setString(2, acc.getPassword());
            ps.setInt(3, acc.getRole());
            ps.setString(4, acc.getStatus());
            ps.setString(5, acc.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(String id, String status) {
        String sql = "UPDATE account SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Account> findAll() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.*, COALESCE(s.name, t.name, 'Admin') as name " +
                     "FROM account a " +
                     "LEFT JOIN student s ON a.id = s.account_id " +
                     "LEFT JOIN tutor t ON a.id = t.account_id " +
                     "ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Account acc = mapRow(rs);
                acc.setName(rs.getString("name"));
                list.add(acc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countByRole(int role) {
        String sql = "SELECT COUNT(*) FROM account WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public String generateNextId() {

        String sql = "SELECT id FROM account ORDER BY id DESC LIMIT 1";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                // FIX POSTGRESQL CHAR(20)
                String lastId = rs.getString("id").trim();

                int num = Integer.parseInt(
                        lastId.replace("acc", "")
                );

                num++;

                return String.format("acc%03d", num);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "acc001";
    }

    private Account mapRow(ResultSet rs) throws SQLException {
        Account acc = new Account();
        acc.setId(rs.getString("id"));
        acc.setEmail(rs.getString("email"));
        acc.setPassword(rs.getString("password"));
        acc.setRole(rs.getInt("role"));
        acc.setStatus(rs.getString("status"));
        try { acc.setResetToken(rs.getString("reset_token")); } catch (Exception e) {}
        try { acc.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception e) {}
        return acc;
    }
}
