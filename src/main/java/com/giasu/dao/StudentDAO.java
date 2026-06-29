package com.giasu.dao;

import com.giasu.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student findById(String id) {
        String sql = "SELECT * FROM student WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Student findByAccountId(String accountId) {
        String sql = "SELECT * FROM student WHERE account_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Student st) {
        String sql = "INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, st.getId());
            ps.setString(2, st.getName());
            ps.setString(3, st.getPhone());
            ps.setString(4, st.getAddress());
            ps.setDate(5, st.getBirth());
            ps.setString(6, st.getDescription());
            ps.setString(7, st.getAccountId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Student st) {
        String sql = "UPDATE student SET name = ?, phone = ?, address = ?, birth = ?, description = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, st.getName());
            ps.setString(2, st.getPhone());
            ps.setString(3, st.getAddress());
            ps.setDate(4, st.getBirth());
            ps.setString(5, st.getDescription());
            ps.setString(6, st.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Student> findAll() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateNextId() {
        String sql = "SELECT id FROM student ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id").trim();
                int num = Integer.parseInt(
                        lastId.replace("st", "").trim()
                ) + 1;
                return String.format("st%03d", num);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "st001";
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student st = new Student();
        st.setId(rs.getString("id"));
        st.setName(rs.getString("name"));
        st.setPhone(rs.getString("phone"));
        st.setAddress(rs.getString("address"));
        st.setBirth(rs.getDate("birth"));
        st.setDescription(rs.getString("description"));
        try { st.setAvatar(rs.getString("avatar")); } catch (Exception e) {}
        st.setAccountId(rs.getString("account_id"));
        try { st.setBalance(rs.getLong("balance")); } catch (Exception e) {}
        return st;
    }

    /** Update balance by delta (positive = add, negative = deduct) */
    public boolean updateBalance(String studentId, long delta) {
        String sql = "UPDATE student SET balance = balance + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, delta);
            ps.setString(2, studentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Update balance within an existing transaction connection */
    public boolean updateBalance(String studentId, long delta, Connection conn) throws SQLException {
        String sql = "UPDATE student SET balance = balance + ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setLong(1, delta);
        ps.setString(2, studentId);
        return ps.executeUpdate() > 0;
    }

    /** Reload latest balance from DB */
    public long getBalance(String studentId) {
        String sql = "SELECT balance FROM student WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
