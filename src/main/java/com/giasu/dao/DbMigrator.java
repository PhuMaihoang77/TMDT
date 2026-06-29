package com.giasu.dao;

import java.sql.Connection;
import java.sql.Statement;

public class DbMigrator {
    public static void main(String[] args) {
        System.out.println("Starting Database Migration...");
        String[] sqls = {
            "ALTER TABLE student ADD COLUMN IF NOT EXISTS balance DECIMAL(12) DEFAULT 0",
            "ALTER TABLE tutor ADD COLUMN IF NOT EXISTS balance DECIMAL(12) DEFAULT 0",
            "ALTER TABLE payment ALTER COLUMN course_id DROP NOT NULL",
            "ALTER TABLE payment ALTER COLUMN tutor_id DROP NOT NULL",
            "ALTER TABLE payment ALTER COLUMN student_id DROP NOT NULL",
            "ALTER TABLE payment ADD COLUMN IF NOT EXISTS payment_type VARCHAR(50) DEFAULT 'PAYMENT'"
        };

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            for (String sql : sqls) {
                System.out.println("Executing: " + sql);
                stmt.execute(sql);
            }
            System.out.println("Database Migration completed successfully!");
        } catch (Exception e) {
            System.err.println("Migration failed!");
            e.printStackTrace();
        }
    }
}
