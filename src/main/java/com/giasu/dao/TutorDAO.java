package com.giasu.dao;

import com.giasu.model.Tutor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TutorDAO {

    public Tutor findById(String id) {
        String sql = "SELECT * FROM tutor WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Tutor findByAccountId(String accountId) {
        String sql = "SELECT * FROM tutor WHERE account_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Tutor> findAll() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                "(SELECT COUNT(DISTINCT rs.student_id) FROM course c JOIN registered_subjects rs ON c.id = rs.course_id WHERE c.tutor_id = t.id) as total_students, " +
                "(SELECT COUNT(*) FROM course WHERE tutor_id = t.id) as total_courses, " +
                "(SELECT COUNT(*) FROM review WHERE tutor_id = t.id) as total_reviews " +
                "FROM tutor t JOIN account a ON t.account_id = a.id WHERE a.status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tutor t = mapRow(rs);
                t.setTotalStudents(rs.getInt("total_students"));
                t.setTotalCourses(rs.getInt("total_courses"));
                t.setTotalReviews(rs.getInt("total_reviews"));
                list.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Tutor> findVerified() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                "(SELECT COUNT(DISTINCT rs.student_id) FROM course c JOIN registered_subjects rs ON c.id = rs.course_id WHERE c.tutor_id = t.id) as total_students, " +
                "(SELECT COUNT(*) FROM course WHERE tutor_id = t.id) as total_courses, " +
                "(SELECT COUNT(*) FROM review WHERE tutor_id = t.id) as total_reviews " +
                "FROM tutor t JOIN account a ON t.account_id = a.id WHERE t.verified = 1 AND a.status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tutor t = mapRow(rs);
                t.setTotalStudents(rs.getInt("total_students"));
                t.setTotalCourses(rs.getInt("total_courses"));
                t.setTotalReviews(rs.getInt("total_reviews"));
                list.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Tutor> search(String keyword, String specialization, Integer minRating) {
        List<Tutor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, " +
                        "(SELECT COUNT(DISTINCT rs.student_id) FROM course c JOIN registered_subjects rs ON c.id = rs.course_id WHERE c.tutor_id = t.id) as total_students, " +
                        "(SELECT COUNT(*) FROM course WHERE tutor_id = t.id) as total_courses, " +
                        "(SELECT COUNT(*) FROM review WHERE tutor_id = t.id) as total_reviews " +
                        "FROM tutor t JOIN account a ON t.account_id = a.id WHERE t.verified = 1 AND a.status = 'active'");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (t.name ILIKE ? OR t.specialization ILIKE ? OR t.address ILIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        if (specialization != null && !specialization.trim().isEmpty()) {
            sql.append(" AND t.specialization = ?");
            params.add(specialization.trim());
        }
        if (minRating != null && minRating > 0) {
            sql.append(" AND t.evaluate >= ?");
            params.add(minRating);
        }

        sql.append(" ORDER BY t.evaluate DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) ps.setString(i + 1, (String) param);
                else if (param instanceof Integer) ps.setInt(i + 1, (Integer) param);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tutor t = mapRow(rs);
                t.setTotalStudents(rs.getInt("total_students"));
                t.setTotalCourses(rs.getInt("total_courses"));
                t.setTotalReviews(rs.getInt("total_reviews"));
                list.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Tutor> findPendingVerification() {
        List<Tutor> list = new ArrayList<>();
        String sql = "SELECT * FROM tutor WHERE verified = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Tutor t) {
        String sql = "INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getId());
            ps.setString(2, t.getName());
            ps.setString(3, t.getEmail());
            ps.setDate(4, t.getBirth());
            ps.setString(5, t.getPhone());
            ps.setString(6, t.getAddress());
            ps.setString(7, t.getSpecialization());
            ps.setString(8, t.getDescription());
            ps.setLong(9, t.getIdCardNumber());
            ps.setLong(10, t.getBankAccountNumber());
            ps.setString(11, t.getBankName());
            ps.setString(12, t.getAccountId());
            ps.setInt(13, t.getEvaluate());
            ps.setInt(14, t.isVerified() ? 1 : 0);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Tutor t) {
        String sql = "UPDATE tutor SET name = ?, email = ?, birth = ?, phone = ?, address = ?, specialization = ?, description = ?, bank_account_number = ?, bank_name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getName());
            ps.setString(2, t.getEmail());
            ps.setDate(3, t.getBirth());
            ps.setString(4, t.getPhone());
            ps.setString(5, t.getAddress());
            ps.setString(6, t.getSpecialization());
            ps.setString(7, t.getDescription());
            ps.setLong(8, t.getBankAccountNumber());
            ps.setString(9, t.getBankName());
            ps.setString(10, t.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean verify(String id, boolean verified) {
        String sql = "UPDATE tutor SET verified = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, verified ? 1 : 0);
            ps.setString(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<String> getAllSpecializations() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT specialization FROM tutor WHERE specialization IS NOT NULL ORDER BY specialization";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rs.getString("specialization"));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String generateNextId() {
        String sql = "SELECT id FROM tutor ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                String lastId = rs.getString("id").trim();

                int num = Integer.parseInt(
                        lastId.replace("tut", "").trim()
                ) + 1;

                return String.format("tut%03d", num);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "tut001";
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
        try { t.setBalance(rs.getLong("balance")); } catch (Exception e) {}
        return t;
    }
    public List<Tutor> searchAdvanced(String keyword, String subjectName, String level, String grade, String tutorType, Integer minPrice, Integer maxPrice, Integer minRating) {        List<Tutor> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT t.*, " +
                        "(SELECT COUNT(DISTINCT rs.student_id) FROM course c2 JOIN registered_subjects rs ON c2.id = rs.course_id WHERE c2.tutor_id = t.id) as total_students, " +
                        "(SELECT COUNT(*) FROM course c3 WHERE c3.tutor_id = t.id) as total_courses, " +
                        "(SELECT COUNT(*) FROM review r WHERE r.tutor_id = t.id) as total_reviews " +
                        "FROM tutor t " +
                        "JOIN account a ON t.account_id = a.id " +
                        "JOIN course c ON t.id = c.tutor_id " +
                        "JOIN subject s ON c.subject_id = s.id " +
                        "WHERE t.verified = 1 AND a.status = 'active'"
        );

        List<Object> params = new ArrayList<>();

        // 1. Tìm theo Từ khóa tự do (Tên gia sư, tên môn học, hoặc chuyên môn)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (t.name ILIKE ? OR s.name ILIKE ? OR t.specialization ILIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }

        // 2. Tìm theo Môn học / Chuyên môn (Dropdown Master Data)
        if (subjectName != null && !subjectName.trim().isEmpty()) {
            sql.append(" AND (s.name ILIKE ? OR t.specialization ILIKE ?)");
            String kw = "%" + subjectName.trim() + "%";
            params.add(kw); params.add(kw);
        }

        // 3. Logic lọc theo KHỐI LỚP (Ưu tiên cao nhất) - Ép khớp chuỗi biên chính xác tiếng Việt
        if (grade != null && !grade.trim().isEmpty()) {
            sql.append(" AND (s.level = ? OR s.level ILIKE ? OR s.level ILIKE ?)");
            String g = grade.trim();
            params.add(g);
            params.add(g + " %"); // Khớp khi lớp nằm ở đầu/giữa chuỗi (Ví dụ: "Lớp 1 Cơ bản")
            params.add("% " + g); // Khớp khi lớp nằm ở cuối chuỗi
        }

        // 4. Logic lọc theo CẤP HỌC (Chấp nhận cả cách ghi Lớp lẫn cách ghi Cấp trong DB)
        else if (level != null && !level.trim().isEmpty()) {
            String lvl = level.trim();
            if (lvl.equalsIgnoreCase("cap1")) {
                // Quét trúng nếu DB ghi cụ thể Lớp 1-5 HOẶC ghi chung là "Cấp 1", "Tiểu học" (loại trừ lớp 10,11,12)
                sql.append(" AND (s.level ILIKE '%Lớp 1%' OR s.level ILIKE '%Lớp 2%' OR s.level ILIKE '%Lớp 3%' OR s.level ILIKE '%Lớp 4%' OR s.level ILIKE '%Lớp 5%' OR s.level ILIKE '%Cấp 1%' OR s.level ILIKE '%Tiểu học%')");
                sql.append(" AND s.level NOT ILIKE '%Lớp 10%' AND s.level NOT ILIKE '%Lớp 11%' AND s.level NOT ILIKE '%Lớp 12%'");
            } else if (lvl.equalsIgnoreCase("cap2")) {
                // Quét trúng nếu DB ghi Lớp 6-9 HOẶC ghi chung là "Cấp 2", "THCS"
                sql.append(" AND (s.level ILIKE '%Lớp 6%' OR s.level ILIKE '%Lớp 7%' OR s.level ILIKE '%Lớp 8%' OR s.level ILIKE '%Lớp 9%' OR s.level ILIKE '%Cấp 2%' OR s.level ILIKE '%THCS%')");
            } else if (lvl.equalsIgnoreCase("cap3")) {
                // Quét trúng nếu DB ghi Lớp 10-12 HOẶC ghi chung là "Cấp 3", "THPT"
                sql.append(" AND (s.level ILIKE '%Lớp 10%' OR s.level ILIKE '%Lớp 11%' OR s.level ILIKE '%Lớp 12%' OR s.level ILIKE '%Cấp 3%' OR s.level ILIKE '%THPT%')");
            } else {
                sql.append(" AND s.level ILIKE ?");
                params.add("%" + lvl + "%");
            }
        }

        // 4.5 Logic lọc theo Trình độ Gia Sư (Sinh viên / Giáo viên) dựa trên specialization
        if (tutorType != null && !tutorType.trim().isEmpty()) {
            String type = tutorType.trim().toLowerCase();
            if (type.equals("sinhvien")) {
                sql.append(" AND t.specialization ILIKE '%Sinh viên%'");
            } else if (type.equals("giaovien")) {
                sql.append(" AND (t.specialization ILIKE '%Giáo viên%' OR t.specialization ILIKE '%Cử nhân%' OR t.specialization ILIKE '%Thạc sĩ%' OR t.specialization ILIKE '%Tiến sĩ%')");
            }
        }

        // 5. Tìm theo Khoảng học phí
        if (minPrice != null) {
            sql.append(" AND s.fee >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND s.fee <= ?");
            params.add(maxPrice);
        }

        // 6. Tìm theo Đánh giá sao tối thiểu
        if (minRating != null && minRating > 0) {
            sql.append(" AND t.evaluate >= ?");
            params.add(minRating);
        }

        // Sắp xếp mặc định theo đánh giá cao nhất
        sql.append(" ORDER BY t.evaluate DESC");

        // Thực thi câu lệnh SQL với tập tham số params động
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) ps.setString(i + 1, (String) param);
                else if (param instanceof Integer) ps.setInt(i + 1, (Integer) param);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tutor t = mapRow(rs);
                t.setTotalStudents(rs.getInt("total_students"));
                t.setTotalCourses(rs.getInt("total_courses"));
                t.setTotalReviews(rs.getInt("total_reviews"));
                list.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    public boolean updateEvaluate(String tutorId, double evaluate) {
        String sql = "UPDATE tutor SET evaluate = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (int) Math.round(evaluate));
            ps.setString(2, tutorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Update balance by delta within an existing transaction connection */
    public boolean updateBalance(String tutorId, long delta, Connection conn) throws SQLException {
        String sql = "UPDATE tutor SET balance = balance + ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setLong(1, delta);
        ps.setString(2, tutorId);
        return ps.executeUpdate() > 0;
    }

    /** Update balance by delta (standalone) */
    public boolean updateBalance(String tutorId, long delta) {
        String sql = "UPDATE tutor SET balance = balance + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, delta);
            ps.setString(2, tutorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Reload latest balance from DB */
    public long getBalance(String tutorId) {
        String sql = "SELECT balance FROM tutor WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}

