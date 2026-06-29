package com.giasu.model;

import java.sql.Timestamp;

public class Complaint {
    private String id;
    private String bookingId;
    private String studentId;
    private String title;
    private String description;
    private String status;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // Join fields
    private Booking booking;
    private Student student;

    public Complaint() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public String getStatusDisplay() {
        if (status == null) return "Chưa xác định";
        switch (status) {
            case "pending": return "Chờ xử lý";
            case "resolved": return "Đã giải quyết";
            case "rejected": return "Bị từ chối";
            default: return status;
        }
    }
}
