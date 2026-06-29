package com.giasu.model;

import java.sql.Timestamp;

public class Account {
    private String id;
    private String email;
    private String password;
    private int role; // 1=Student, 2=Tutor, 3=Admin
    private String status;
    private String resetToken;
    private Timestamp createdAt;
    private String name; // Display name

    public Account() {}

    public Account(String id, String email, String password, int role, String status) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
        this.status = status;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRoleName() {
        switch (role) {
            case 1: return "Phụ huynh";
            case 2: return "Gia sư";
            case 3: return "Quản trị viên";
            default: return "Unknown";
        }
    }
}
