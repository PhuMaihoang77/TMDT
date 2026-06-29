package com.giasu.dao;

import com.giasu.model.Course;
import com.giasu.model.Subject;
import com.giasu.model.Tutor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    private static final String BASE_SELECT =
            "SELECT " +
                    "c.id as c_id, c.subject_id, c.tutor_id, c.time, c.status as c_status, " +
                    "s.id as s_id, s.name as s_name, s.level as s_level, s.fee as s_fee, s.description as s_desc, " +
                    "t.id as t_id, t.name as t_name, t.specialization as t_spec, t.evaluate as t_eval " +
                    "FROM course c " +
                    "JOIN subject s ON c.subject_id = s.id " +
                    "JOIN tutor t ON c.tutor_id = t.id ";

    // ================= FIND BY ID =================
    public Course findById(String id) {
        String sql = BASE_SELECT + "WHERE c.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return mapRowFull(rs);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================= FIND BY TUTOR =================
    public List<Course> findByTutorId(String tutorId) {
        List<Course> list = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE c.tutor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tutorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRowFull(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= FIND ALL =================
    public List<Course> findAll() {
        List<Course> list = new ArrayList<>();
        String sql = BASE_SELECT;

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

    // ================= MAPPING =================
    private Course mapRowFull(ResultSet rs) throws SQLException {

        Course c = new Course();
        c.setId(rs.getString("c_id"));
        c.setSubjectId(rs.getString("subject_id"));
        c.setTutorId(rs.getString("tutor_id"));
        c.setTime(rs.getTimestamp("time"));
        c.setStatus(rs.getString("c_status"));

        Subject s = new Subject();
        s.setId(rs.getString("s_id"));
        s.setName(rs.getString("s_name"));
        s.setLevel(rs.getString("s_level"));
        s.setFee(rs.getLong("s_fee"));
        s.setDescription(rs.getString("s_desc"));

        c.setSubject(s);

        Tutor t = new Tutor();
        t.setId(rs.getString("t_id"));
        t.setName(rs.getString("t_name"));
        t.setSpecialization(rs.getString("t_spec"));
        t.setEvaluate(rs.getInt("t_eval"));

        c.setTutor(t);

        return c;
    }

    // ================= REGISTER COURSE =================
    public boolean registerCourse(String courseId, String studentId, int lessons, String status) {
        String sql = "INSERT INTO registered_subjects " +
                "(course_id, student_id, registration_date, number_of_lessons, status) " +
                "VALUES (?, ?, CURRENT_DATE, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, courseId);
            ps.setString(2, studentId);
            ps.setInt(3, lessons);
            ps.setString(4, status);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= CHECK REGISTERED =================
    public boolean isStudentRegistered(String courseId, String studentId) {
        String sql = "SELECT 1 FROM registered_subjects WHERE course_id = ? AND student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, courseId);
            ps.setString(2, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= TẠO KHÓA HỌC =================
    // Tạo ID tự động (c001, c002...)
    public String generateNextId() {
        String sql = "SELECT id FROM course ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("id").trim();
                int num = Integer.parseInt(lastId.replace("c", "")) + 1;
                return String.format("c%03d", num);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "c001";
    }

    // Insert Khóa học mới
    public boolean insert(Course c) {
        String sql = "INSERT INTO course (id, subject_id, tutor_id, time, status) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getId());
            ps.setString(2, c.getSubjectId());
            ps.setString(3, c.getTutorId());
            ps.setString(4, c.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(String courseId, String status) {
        String sql = "UPDATE course SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Update course status within existing transaction */
    public boolean updateStatus(String courseId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE course SET status = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setString(2, courseId);
        return ps.executeUpdate() > 0;
    }

}