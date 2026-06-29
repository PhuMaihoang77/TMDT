package com.giasu.dao;

import com.giasu.model.Payment;
import com.giasu.model.Tutor;
import com.giasu.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    // --- INSERT (standalone, for DEPOSIT/WITHDRAW without course) ---
    public boolean insert(Payment p) {
        String sql = "INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status, payment_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getId());
            setNullableString(ps, 2, p.getCourseId());
            setNullableString(ps, 3, p.getTutorId());
            setNullableString(ps, 4, p.getStudentId());
            ps.setLong(5, p.getAmount());
            ps.setTimestamp(6, p.getPaymentDate());
            ps.setString(7, p.getPaymentMethod());
            ps.setString(8, p.getStatus());
            ps.setString(9, p.getPaymentType() != null ? p.getPaymentType() : "PAYMENT");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // --- INSERT within existing transaction (for atomic pay-tuition) ---
    public boolean insert(Payment p, Connection conn) throws SQLException {
        String sql = "INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status, payment_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, p.getId());
        setNullableString(ps, 2, p.getCourseId());
        setNullableString(ps, 3, p.getTutorId());
        setNullableString(ps, 4, p.getStudentId());
        ps.setLong(5, p.getAmount());
        ps.setTimestamp(6, p.getPaymentDate());
        ps.setString(7, p.getPaymentMethod());
        ps.setString(8, p.getStatus());
        ps.setString(9, p.getPaymentType() != null ? p.getPaymentType() : "PAYMENT");
        return ps.executeUpdate() > 0;
    }

    private void setNullableString(PreparedStatement ps, int idx, String val) throws SQLException {
        if (val == null) ps.setNull(idx, Types.VARCHAR);
        else ps.setString(idx, val);
    }

    public boolean updateStatus(String id, String status) {
        String sql = "UPDATE payment SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Payment> findByStudentId(String studentId) {
        return findByField("p.student_id", studentId);
    }

    public List<Payment> findByTutorId(String tutorId) {
        return findByField("p.tutor_id", tutorId);
    }

    public List<Payment> findAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, t.name as t_name, s.name as st_name FROM payment p " +
                "LEFT JOIN tutor t ON p.tutor_id = t.id LEFT JOIN student s ON p.student_id = s.id ORDER BY p.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public long getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payment WHERE status = 'completed' AND payment_type = 'PAYMENT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public String generateNextId() {
        String sql = "SELECT id FROM payment ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id").trim();
                int num = Integer.parseInt(lastId.replace("pay", "").trim()) + 1;
                return String.format("pay%03d", num);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return "pay001";
    }

    /** Generate ID within existing transaction to avoid race conditions */
    public String generateNextId(Connection conn) throws SQLException {
        String sql = "SELECT id FROM payment ORDER BY id DESC LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String lastId = rs.getString("id").trim();
            int num = Integer.parseInt(lastId.replace("pay", "").trim()) + 1;
            return String.format("pay%03d", num);
        }
        return "pay001";
    }

    private List<Payment> findByField(String field, String value) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, t.name as t_name, s.name as st_name FROM payment p " +
                "LEFT JOIN tutor t ON p.tutor_id = t.id LEFT JOIN student s ON p.student_id = s.id WHERE " + field + " = ? ORDER BY p.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRowFull(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Payment mapRowFull(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getString("id"));
        p.setCourseId(rs.getString("course_id"));
        p.setTutorId(rs.getString("tutor_id"));
        p.setStudentId(rs.getString("student_id"));
        p.setAmount(rs.getLong("amount"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setStatus(rs.getString("status"));
        try { p.setPaymentType(rs.getString("payment_type")); } catch (Exception e) {}

        Tutor t = new Tutor();
        t.setId(rs.getString("tutor_id"));
        t.setName(rs.getString("t_name"));
        p.setTutor(t);

        Student s = new Student();
        s.setId(rs.getString("student_id"));
        s.setName(rs.getString("st_name"));
        p.setStudent(s);

        return p;
    }
}
