package com.giasu.dao;

import com.giasu.model.Payment;
import com.giasu.model.Tutor;
import com.giasu.model.Student;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

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
        String sql = "SELECT COALESCE(SUM(amount), 0) * 0.10 FROM payment WHERE status = 'completed' AND payment_type = 'PAYMENT'";
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

    public List<Map<String, Object>> getRevenueStatsByTime(String type, int year, String startDate, String endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "";
        if ("7days".equals(type)) {
            sql = "SELECT CAST(payment_date AS DATE) AS date_label, COALESCE(SUM(amount), 0) * 0.10 AS total " +
                  "FROM payment " +
                  "WHERE status = 'completed' AND payment_type = 'PAYMENT' " +
                  "  AND payment_date >= CURRENT_DATE - INTERVAL '6 days' " +
                  "GROUP BY date_label " +
                  "ORDER BY date_label";
        } else if ("30days".equals(type)) {
            sql = "SELECT CAST(payment_date AS DATE) AS date_label, COALESCE(SUM(amount), 0) * 0.10 AS total " +
                  "FROM payment " +
                  "WHERE status = 'completed' AND payment_type = 'PAYMENT' " +
                  "  AND payment_date >= CURRENT_DATE - INTERVAL '29 days' " +
                  "GROUP BY date_label " +
                  "ORDER BY date_label";
        } else if ("monthly".equals(type)) {
            sql = "SELECT EXTRACT(MONTH FROM payment_date)::INTEGER AS month_num, COALESCE(SUM(amount), 0) * 0.10 AS total " +
                  "FROM payment " +
                  "WHERE status = 'completed' AND payment_type = 'PAYMENT' " +
                  "  AND EXTRACT(YEAR FROM payment_date) = ? " +
                  "GROUP BY month_num " +
                  "ORDER BY month_num";
        } else if ("yearly".equals(type)) {
            sql = "SELECT EXTRACT(YEAR FROM payment_date)::INTEGER AS year_num, COALESCE(SUM(amount), 0) * 0.10 AS total " +
                  "FROM payment " +
                  "WHERE status = 'completed' AND payment_type = 'PAYMENT' " +
                  "GROUP BY year_num " +
                  "ORDER BY year_num";
        } else if ("custom".equals(type)) {
            sql = "SELECT CAST(payment_date AS DATE) AS date_label, COALESCE(SUM(amount), 0) * 0.10 AS total " +
                  "FROM payment " +
                  "WHERE status = 'completed' AND payment_type = 'PAYMENT' " +
                  "  AND payment_date::date >= ?::date AND payment_date::date <= ?::date " +
                  "GROUP BY date_label " +
                  "ORDER BY date_label";
        }

        if ("monthly".equals(type)) {
            Map<Integer, Long> monthlyMap = new HashMap<>();
            for (int i = 1; i <= 12; i++) {
                monthlyMap.put(i, 0L);
            }
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, year);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        monthlyMap.put(rs.getInt("month_num"), rs.getLong("total"));
                    }
                }
            } catch (SQLException e) { e.printStackTrace(); }
            for (int i = 1; i <= 12; i++) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("label", "T" + i);
                map.put("value", monthlyMap.get(i));
                list.add(map);
            }
            return list;
        }

        if ("7days".equals(type) || "30days".equals(type)) {
            int numDays = "7days".equals(type) ? 7 : 30;
            Map<String, Long> dailyMap = new LinkedHashMap<>();
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM");
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_YEAR, -(numDays - 1));
            
            // Initialize last N days to 0
            for (int i = 0; i < numDays; i++) {
                dailyMap.put(sdf.format(cal.getTime()), 0L);
                cal.add(java.util.Calendar.DAY_OF_YEAR, 1);
            }
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Date date = rs.getDate("date_label");
                    String label = sdf.format(date);
                    if (dailyMap.containsKey(label)) {
                        dailyMap.put(label, rs.getLong("total"));
                    }
                }
            } catch (SQLException e) { e.printStackTrace(); }
            
            for (Map.Entry<String, Long> entry : dailyMap.entrySet()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("label", entry.getKey());
                map.put("value", entry.getValue());
                list.add(map);
            }
            return list;
        }

        if ("custom".equals(type)) {
            Map<String, Long> dailyMap = new LinkedHashMap<>();
            java.text.SimpleDateFormat sdfStr = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.text.SimpleDateFormat sdfDisplay = new java.text.SimpleDateFormat("dd/MM");
            
            try {
                java.util.Date start = sdfStr.parse(startDate);
                java.util.Date end = sdfStr.parse(endDate);
                
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(start);
                
                int daysDiff = (int) ((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
                if (daysDiff < 0) daysDiff = 0;
                if (daysDiff > 90) daysDiff = 90;
                
                for (int i = 0; i <= daysDiff; i++) {
                    dailyMap.put(sdfStr.format(cal.getTime()), 0L);
                    cal.add(java.util.Calendar.DAY_OF_YEAR, 1);
                }
                
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, startDate);
                    ps.setString(2, endDate);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Date date = rs.getDate("date_label");
                            String label = sdfStr.format(date);
                            if (dailyMap.containsKey(label)) {
                                dailyMap.put(label, rs.getLong("total"));
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            for (Map.Entry<String, Long> entry : dailyMap.entrySet()) {
                Map<String, Object> map = new LinkedHashMap<>();
                try {
                    java.util.Date d = sdfStr.parse(entry.getKey());
                    map.put("label", sdfDisplay.format(d));
                } catch (Exception e) {
                    map.put("label", entry.getKey());
                }
                map.put("value", entry.getValue());
                list.add(map);
            }
            return list;
        }

        // Yearly
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new LinkedHashMap<>();
                map.put("label", "Năm " + rs.getInt("year_num"));
                map.put("value", rs.getLong("total"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, Object>> getSubjectRevenueStatsByMonth(int month, int year) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT COALESCE(s.name, 'Môn học khác') AS subject_name, COALESCE(SUM(p.amount), 0) * 0.10 AS total_revenue " +
                     "FROM payment p " +
                     "LEFT JOIN course c ON p.course_id = c.id " +
                     "LEFT JOIN subject s ON c.subject_id = s.id " +
                     "WHERE p.status = 'completed' AND p.payment_type = 'PAYMENT' " +
                     "  AND EXTRACT(MONTH FROM p.payment_date) = ? " +
                     "  AND EXTRACT(YEAR FROM p.payment_date) = ? " +
                     "GROUP BY s.name " +
                     "ORDER BY total_revenue DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, month);
            ps.setInt(2, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("label", rs.getString("subject_name").trim());
                    map.put("value", rs.getLong("total_revenue"));
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
