package com.giasu.dao;

import com.giasu.model.Review;
import com.giasu.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> findByTutorId(String tutorId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, s.name as st_name FROM review r LEFT JOIN student s ON r.student_id = s.id WHERE r.tutor_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = mapRow(rs);
                Student st = new Student();
                st.setId(rs.getString("student_id"));
                st.setName(rs.getString("st_name"));
                r.setStudent(st);
                list.add(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Review r) {
        String sql = "INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getId());
            ps.setString(2, r.getTutorId());
            ps.setString(3, r.getStudentId());
            ps.setString(4, r.getCourseId());
            ps.setInt(5, r.getRating());
            ps.setString(6, r.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public double getAverageRating(String tutorId) {
        String sql = "SELECT AVG(rating) FROM review WHERE tutor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public String generateNextId() {
        return "rev" + String.valueOf(System.currentTimeMillis()).substring(3);
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getString("id"));
        r.setTutorId(rs.getString("tutor_id"));
        r.setStudentId(rs.getString("student_id"));
        r.setCourseId(rs.getString("course_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
