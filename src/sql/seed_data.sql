-- Insert Subjects
INSERT INTO subject (id, name, level, description, fee, status) VALUES
('sub001', 'Toan', 'Cap 1', 'Toan tieu hoc', 150000, 'active'),
('sub002', 'Toan', 'Cap 2', 'Toan THCS', 200000, 'active'),
('sub003', 'Toan', 'Cap 3', 'Toan THPT', 250000, 'active'),
('sub004', 'Vat Ly', 'Cap 2', 'Vat Ly THCS', 200000, 'active'),
('sub005', 'Vat Ly', 'Cap 3', 'Vat Ly THPT', 250000, 'active'),
('sub006', 'Hoa Hoc', 'Cap 2', 'Hoa Hoc THCS', 200000, 'active'),
('sub007', 'Hoa Hoc', 'Cap 3', 'Hoa Hoc THPT', 250000, 'active'),
('sub008', 'Tieng Anh', 'Cap 1', 'Tieng Anh tieu hoc', 180000, 'active'),
('sub009', 'Tieng Anh', 'Cap 2', 'Tieng Anh THCS', 220000, 'active'),
('sub010', 'Tieng Anh', 'Cap 3', 'Tieng Anh THPT', 280000, 'active'),
('sub011', 'Ngu Van', 'Cap 2', 'Ngu Van THCS', 180000, 'active'),
('sub012', 'Ngu Van', 'Cap 3', 'Ngu Van THPT', 220000, 'active'),
('sub013', 'Sinh Hoc', 'Cap 3', 'Sinh Hoc THPT', 200000, 'active');

-- Insert Tutors (linked to existing role=2 accounts)
INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, avatar, account_id, evaluate, verified) VALUES
('tut001', 'Nguyen Van An', 'giasu1@gmail.com', '1990-05-15', '0912345678', 'Ha Noi', 'Toan, Vat Ly', 'Giang vien Toan 10 nam kinh nghiem', 123456789, 987654321, 'Vietcombank', 'default-avatar.png', 'acc004', 5, 1),
('tut002', 'Tran Thi Binh', 'giasu2@gmail.com', '1992-08-20', '0923456789', 'Ho Chi Minh', 'Tieng Anh, Ngu Van', 'Giao vien Tieng Anh 8 nam kinh nghiem', 234567890, 876543210, 'Techcombank', 'default-avatar.png', 'acc005', 4, 1),
('tut003', 'Le Van Cuong', 'giasu3@gmail.com', '1988-12-10', '0934567890', 'Da Nang', 'Hoa Hoc, Sinh Hoc', 'Thac si Hoa Hoc, 12 nam giang day', 345678901, 765432109, 'BIDV', 'default-avatar.png', 'acc006', 5, 1),
('tut004', 'Pham Thi Duong', 'giasu4@gmail.com', '1995-03-22', '0945678901', 'Hai Phong', 'Toan, Tieng Anh', 'Tot nghiep Su Pham Toan, 5 nam kinh nghiem', 456789012, 654321098, 'Vietcombank', 'default-avatar.png', 'acc007', 4, 1),
('tut005', 'Hoang Van Em', 'giasu5@gmail.com', '1993-07-18', '0956789012', 'Can Tho', 'Vat Ly, Toan', 'Ky su Vat Ly, day kem 7 nam', 567890123, 543210987, 'Agribank', 'default-avatar.png', 'acc008', 3, 1),
('tut006', 'Dang Minh Hoang', 'dangminhhoang2004thd@gmail.com', '2000-01-01', '0967890123', 'Ha Noi', 'Toan, Tieng Anh, Hoa Hoc', 'Sinh vien su pham uu tu', 678901234, 432109876, 'MB Bank', 'default-avatar.png', 'acc013', 4, 1);

-- Insert Courses
INSERT INTO course (id, subject_id, tutor_id, time, status) VALUES
('course001', 'sub001', 'tut001', '2026-07-05 08:00:00', 'active'),
('course002', 'sub002', 'tut001', '2026-07-06 09:00:00', 'active'),
('course003', 'sub008', 'tut002', '2026-07-05 10:00:00', 'active'),
('course004', 'sub006', 'tut003', '2026-07-07 08:00:00', 'active'),
('course005', 'sub002', 'tut004', '2026-07-08 14:00:00', 'active'),
('course006', 'sub009', 'tut004', '2026-07-09 15:00:00', 'active'),
('course007', 'sub004', 'tut005', '2026-07-10 08:00:00', 'active'),
('course008', 'sub009', 'tut002', '2026-07-11 09:00:00', 'active'),
('course009', 'sub010', 'tut006', '2026-07-12 10:00:00', 'active'),
('course010', 'sub003', 'tut006', '2026-07-13 14:00:00', 'active');
