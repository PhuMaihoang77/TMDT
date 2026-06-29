package com.giasu.dao;

import com.giasu.model.Tutor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InterestDAO {

    public boolean insert(String studentId, String tutorId) {
        String sql = "INSERT INTO interest (id_st, id_tt) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setString(2, tutorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(String studentId, String tutorId) {
        String sql = "DELETE FROM interest WHERE id_st = ? AND id_tt = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setString(2, tutorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isFavorite(String studentId, String tutorId) {
        String sql = "SELECT COUNT(*) FROM interest WHERE id_st = ? AND id_tt = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setString(2, tutorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> findFavoriteTutorIdsByStudentId(String studentId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT id_tt FROM interest WHERE id_st = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("id_tt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Tutor> findFavoriteTutorsByStudentId(String studentId) {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                "(SELECT COUNT(DISTINCT rs.student_id) FROM course c JOIN registered_subjects rs ON c.id = rs.course_id WHERE c.tutor_id = t.id) as total_students, " +
                "(SELECT COUNT(*) FROM course WHERE tutor_id = t.id) as total_courses, " +
                "(SELECT COUNT(*) FROM review WHERE tutor_id = t.id) as total_reviews " +
                "FROM interest i " +
                "JOIN tutor t ON i.id_tt = t.id " +
                "JOIN account a ON t.account_id = a.id " +
                "WHERE i.id_st = ? AND a.status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Tutor mapRow(ResultSet rs) throws SQLException {
        Tutor t = new Tutor();
        t.setId(rs.getString("id"));
        t.setName(rs.getString("name"));
        t.setEmail(rs.getString("email"));
        t.setBirth(rs.getDate("birth"));
        t.setPhone(rs.getString("phone"));
        t.setAddress(rs.getString("address"));
        t.setSpecialization(rs.getString("specialization"));
        t.setDescription(rs.getString("description"));
        t.setIdCardNumber(rs.getLong("id_card_number"));
        t.setBankAccountNumber(rs.getLong("bank_account_number"));
        t.setBankName(rs.getString("bank_name"));
        try { t.setAvatar(rs.getString("avatar")); } catch (Exception e) {}
        t.setAccountId(rs.getString("account_id"));
        t.setEvaluate(rs.getInt("evaluate"));
        t.setVerified(rs.getBoolean("verified"));
        try { t.setTotalStudents(rs.getInt("total_students")); } catch (Exception e) {}
        try { t.setTotalCourses(rs.getInt("total_courses")); } catch (Exception e) {}
        try { t.setTotalReviews(rs.getInt("total_reviews")); } catch (Exception e) {}
        return t;
    }
}
