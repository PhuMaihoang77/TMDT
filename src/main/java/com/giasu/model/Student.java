package com.giasu.model;

import java.sql.Date;

public class Student {
    private String id;
    private String name;
    private String phone;
    private String address;
    private Date birth;
    private String description;
    private String avatar;
    private String accountId;
    private long balance;

    public Student() {}

    public Student(String id, String name, String phone, String address, Date birth, String description, String accountId) {
        this.id = id;
        this.name = name;
        this.phone = phone;
        this.address = address;
        this.birth = birth;
        this.description = description;
        this.accountId = accountId;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Date getBirth() { return birth; }
    public void setBirth(Date birth) { this.birth = birth; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getAccountId() { return accountId; }
    public void setAccountId(String accountId) { this.accountId = accountId; }

    public long getBalance() { return balance; }
    public void setBalance(long balance) { this.balance = balance; }
}
