package com.giasu.model;

import java.sql.Date;
import java.util.List;

public class Tutor {
    private String id;
    private String name;
    private String email;
    private Date birth;
    private String phone;
    private String address;
    private String specialization;
    private String description;
    private long idCardNumber;
    private long bankAccountNumber;
    private String bankName;
    private String avatar;
    private String accountId;
    private int evaluate;
    private boolean verified;
    private long balance;

    // Additional display fields
    private int totalStudents;
    private int totalCourses;
    private int totalReviews;

    private List<Course> courses;


    public Tutor() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getBirth() { return birth; }
    public void setBirth(Date birth) { this.birth = birth; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public long getIdCardNumber() { return idCardNumber; }
    public void setIdCardNumber(long idCardNumber) { this.idCardNumber = idCardNumber; }

    public long getBankAccountNumber() { return bankAccountNumber; }
    public void setBankAccountNumber(long bankAccountNumber) { this.bankAccountNumber = bankAccountNumber; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getAccountId() { return accountId; }
    public void setAccountId(String accountId) { this.accountId = accountId; }

    public int getEvaluate() { return evaluate; }
    public void setEvaluate(int evaluate) { this.evaluate = evaluate; }

    public boolean isVerified() { return verified; }
    public void setVerified(boolean verified) { this.verified = verified; }

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public int getTotalCourses() { return totalCourses; }
    public void setTotalCourses(int totalCourses) { this.totalCourses = totalCourses; }

    public int getTotalReviews() { return totalReviews; }
    public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }

    public List<Course> getCourses() { return courses; }
    public void setCourses(List<Course> courses) { this.courses = courses; }

    public long getBalance() { return balance; }
    public void setBalance(long balance) { this.balance = balance; }

}

