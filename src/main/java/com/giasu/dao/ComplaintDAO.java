package com.giasu.dao;

import com.giasu.model.Booking;
import com.giasu.model.Complaint;
import com.giasu.model.Student;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public List<Complaint> findAll() {
        List<Complaint> list = new ArrayList<>();

        String sql = "SELECT c.*, s.name AS st_name, b.id AS b_id " +
                "FROM complaint c " +
                "LEFT JOIN student s ON c.student_id = s.id " +
                "LEFT JOIN booking b ON c.booking_id = b.id " +
                "ORDER BY c.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowFull(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateStatus(String id, String status) {
        String sql = "UPDATE complaint SET status = ?, resolved_at = CASE WHEN ? IN ('resolved','rejected') THEN CURRENT_TIMESTAMP ELSE NULL END WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setString(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Complaint mapRowFull(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setId(rs.getString("id"));
        complaint.setBookingId(rs.getString("booking_id"));
        complaint.setStudentId(rs.getString("student_id"));
        complaint.setTitle(rs.getString("title"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        complaint.setResolvedAt(rs.getTimestamp("resolved_at"));

        Student student = new Student();
        student.setId(rs.getString("student_id"));
        student.setName(rs.getString("st_name"));
        complaint.setStudent(student);

        String bookingId = rs.getString("b_id");
        if (bookingId != null) {
            Booking booking = new Booking();
            booking.setId(bookingId);
            complaint.setBooking(booking);
        }

        return complaint;
    }

    public boolean insert(Complaint c) {
        String sql = "INSERT INTO complaint (id, booking_id, student_id, title, description, status) VALUES (?, ?, ?, ?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getId());
            ps.setString(2, c.getBookingId());
            ps.setString(3, c.getStudentId());
            ps.setString(4, c.getTitle());
            ps.setString(5, c.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String generateNextId() {
        // ID dài tối đa 20 ký tự (do DB cấu hình CHAR(20))
        // Sử dụng time milis kết hợp tiền tố, tuyệt đối không bao giờ trùng và không bị lỗi parse String
        return "comp" + String.valueOf(System.currentTimeMillis()).substring(3);
    }
}
