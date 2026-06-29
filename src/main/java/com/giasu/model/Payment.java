package com.giasu.model;

import java.sql.Timestamp;

public class Payment {
    private String id;
    private String courseId;
    private String tutorId;
    private String studentId;
    private long amount;
    private Timestamp paymentDate;
    private String paymentMethod;
    private String status;
    private String paymentType; // 'PAYMENT', 'DEPOSIT', 'WITHDRAW'

    // Join fields
    private Tutor tutor;
    private Student student;
    private Course course;

    public Payment() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public String getTutorId() { return tutorId; }
    public void setTutorId(String tutorId) { this.tutorId = tutorId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod != null ? paymentMethod.trim() : null; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status != null ? status.trim() : null; }

    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType != null ? paymentType.trim() : null; }

    public Tutor getTutor() { return tutor; }
    public void setTutor(Tutor tutor) { this.tutor = tutor; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }

    public String getFormattedAmount() {
        return String.format("%,d", amount) + " VND";
    }

    /** Returns +/- formatted amount based on transaction type and viewer role (1=student,2=tutor) */
    public String getSignedFormattedAmount(int userRole) {
        if ("DEPOSIT".equals(paymentType))  return "+" + String.format("%,d", amount) + " VND";
        if ("WITHDRAW".equals(paymentType)) return "-" + String.format("%,d", amount) + " VND";
        if (userRole == 2) return "+" + String.format("%,d", amount) + " VND"; // Tutor receives
        return "-" + String.format("%,d", amount) + " VND";                    // Student pays
    }

    public String getStatusDisplay() {
        if (status == null) return "";
        switch (status) {
            case "completed": return "Hoan thanh";
            case "pending":   return "Dang xu ly";
            case "failed":    return "That bai";
            default: return status;
        }
    }

    public String getTypeDisplay() {
        if (paymentType == null) return "Giao dich";
        switch (paymentType) {
            case "DEPOSIT":  return "Nap tien";
            case "WITHDRAW": return "Rut tien";
            case "PAYMENT":  return "Thanh toan hoc phi";
            default: return paymentType;
        }
    }

    public String getMethodDisplay() {
        if (paymentMethod == null) return "";
        switch (paymentMethod) {
            case "bank_transfer": return "Chuyen khoan";
            case "wallet":        return "Vi dien tu";
            case "cash":          return "Tien mat";
            case "momo":          return "MoMo";
            default: return paymentMethod;
        }
    }
}