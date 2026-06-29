package com.giasu.dao;

import com.giasu.model.Subject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

    public Subject findById(String id) {
        String sql = "SELECT * FROM subject WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject ORDER BY name, level";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Subject> findActive() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT * FROM subject WHERE status = 'active' ORDER BY name, level";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Subject> findByTutorId(String tutorId) {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT DISTINCT s.* FROM subject s JOIN course c ON s.id = c.subject_id WHERE c.tutor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Subject mapRow(ResultSet rs) throws SQLException {
        Subject s = new Subject();
        s.setId(rs.getString("id"));
        s.setName(rs.getString("name"));
        s.setLevel(rs.getString("level"));
        s.setDescription(rs.getString("description"));
        s.setFee(rs.getLong("fee"));
        s.setStatus(rs.getString("status"));
        return s;
    }



    // Tạo ID tự động (sj001, sj002...)
    public String generateNextId() {
        String sql = "SELECT id FROM subject ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id").trim();
                int num = Integer.parseInt(lastId.replace("sj", "")) + 1;
                return String.format("sj%03d", num);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "sj001";
    }

    // Insert Môn học mới
    public boolean insert(Subject s) {
        String sql = "INSERT INTO subject (id, name, level, description, fee, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getId());
            ps.setString(2, s.getName());
            ps.setString(3, s.getLevel());
            ps.setString(4, s.getDescription());
            ps.setLong(5, s.getFee());
            ps.setString(6, s.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

}
