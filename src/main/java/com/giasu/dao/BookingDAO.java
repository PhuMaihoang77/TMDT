package com.giasu.dao;

import com.giasu.model.Booking;
import com.giasu.model.Student;
import com.giasu.model.Tutor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public boolean insert(Booking b) {

        String sql =
                "INSERT INTO booking " +
                        "(id, course_id, tutor_id, student_id, booking_time, status, note) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getId().trim());
            ps.setString(2, b.getCourseId().trim());
            ps.setString(3, b.getTutorId().trim());
            ps.setString(4, b.getStudentId().trim());
            ps.setTimestamp(5, b.getBookingTime());
            ps.setString(6, b.getStatus() == null ? "pending" : b.getStatus().trim());
            ps.setString(7, b.getNote() == null ? "" : b.getNote());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateStatus(String id, String status) {

        String sql =
                "UPDATE booking SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.trim());
            ps.setString(2, id.trim());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Booking> findByStudentId(String studentId) {
        return findByField("b.student_id", studentId);
    }

    public List<Booking> findByTutorId(String tutorId) {
        return findByField("b.tutor_id", tutorId);
    }

    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
        String sql =
                "SELECT b.*, " +
                        "t.name AS t_name, " +
                        "t.specialization AS t_spec, " +
                        "s.name AS st_name, " +
                        "c.status AS c_status " +
                        "FROM booking b " +
                        "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                        "LEFT JOIN student s ON b.student_id = s.id " +
                        "LEFT JOIN course c ON b.course_id = c.id " +
                        "ORDER BY b.created_at DESC";
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

    public Booking findById(String id) {

        String sql =
                "SELECT b.*, " +
                        "t.name AS t_name, " +
                        "t.specialization AS t_spec, " +
                        "s.name AS st_name " +
                        "FROM booking b " +
                        "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                        "LEFT JOIN student s ON b.student_id = s.id " +
                        "WHERE b.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowFull(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public String generateNextId() {

        String sql =
                "SELECT id FROM booking ORDER BY id DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                String lastId = rs.getString("id");

                if (lastId != null) {

                    lastId = lastId.trim();

                    int num = Integer.parseInt(
                            lastId.replace("bk", "").trim()
                    ) + 1;

                    return String.format("bk%03d", num);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "bk001";
    }

    private List<Booking> findByField(String field, String value) {
        List<Booking> list = new ArrayList<>();
        String sql =
                "SELECT b.*, " +
                        "t.name AS t_name, " +
                        "t.specialization AS t_spec, " +
                        "s.name AS st_name, " +
                        "c.status AS c_status " +
                        "FROM booking b " +
                        "LEFT JOIN tutor t ON b.tutor_id = t.id " +
                        "LEFT JOIN student s ON b.student_id = s.id " +
                        "LEFT JOIN course c ON b.course_id = c.id " +
                        "WHERE " + field + " = ? " +
                        "ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value.trim());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowFull(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Booking mapRowFull(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getString("id").trim());
        b.setCourseId(rs.getString("course_id").trim());
        b.setTutorId(rs.getString("tutor_id").trim());
        b.setStudentId(rs.getString("student_id").trim());
        b.setBookingTime(rs.getTimestamp("booking_time"));
        String status = rs.getString("status");
        b.setStatus(status == null ? "" : status.trim());
        b.setNote(rs.getString("note"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        // Course status (may be null if no JOIN or course not found)
        try {
            String cStatus = rs.getString("c_status");
            b.setCourseStatus(cStatus == null ? "" : cStatus.trim());
        } catch (SQLException ignored) {
            b.setCourseStatus("");
        }

        Tutor t = new Tutor();
        t.setId(rs.getString("tutor_id").trim());
        t.setName(rs.getString("t_name"));
        t.setSpecialization(rs.getString("t_spec"));
        b.setTutor(t);

        Student s = new Student();
        s.setId(rs.getString("student_id").trim());
        s.setName(rs.getString("st_name"));
        b.setStudent(s);

        return b;
    }

    public int countStudentsByTutorId(String tutorId) {
        int count = 0;
        // Đã sửa "bookings" thành "booking" và chuyển status về chữ thường để khớp với DB
        String query = "SELECT COUNT(DISTINCT student_id) FROM booking WHERE tutor_id = ? AND LOWER(status) = 'accepted'";

        try (java.sql.Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, tutorId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi đếm học sinh: " + e.getMessage());
        }
        return count;
    }
}