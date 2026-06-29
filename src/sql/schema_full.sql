-- ============================================
-- Gia Su Online - Database Schema (PostgreSQL Version)
-- ============================================

-- Xoa cac bang cu neu da ton tai
DROP TABLE IF EXISTS interest CASCADE;
DROP TABLE IF EXISTS complaint CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS lesson CASCADE;
DROP TABLE IF EXISTS registered_subjects CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS tutor CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS subject CASCADE;
DROP TABLE IF EXISTS account CASCADE;

-- Bang account
CREATE TABLE account (
    id CHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role INT DEFAULT 1 CHECK (role IN (1, 2, 3)),
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    reset_token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bang student
CREATE TABLE student (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    birth DATE NULL,
    description TEXT NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    account_id CHAR(20),
    balance DECIMAL(12) NOT NULL DEFAULT 0,
    FOREIGN KEY (account_id) REFERENCES account(id)
);

-- Bang subject
CREATE TABLE subject (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    level VARCHAR(50) NOT NULL,
    description TEXT,
    fee DECIMAL(12) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- Bang tutor
CREATE TABLE tutor (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    description TEXT,
    id_card_number BIGINT NOT NULL,
    bank_account_number BIGINT NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    account_id CHAR(20),
    evaluate INT DEFAULT 0 CHECK (evaluate BETWEEN 0 AND 5),
    verified SMALLINT DEFAULT 0,
    balance DECIMAL(12) NOT NULL DEFAULT 0,
    FOREIGN KEY (account_id) REFERENCES account(id)
);

-- Bang course
CREATE TABLE course (
    id CHAR(20) PRIMARY KEY,
    subject_id CHAR(20),
    tutor_id CHAR(20),
    time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    FOREIGN KEY (subject_id) REFERENCES subject(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);

-- Bang registered_subjects
CREATE TABLE registered_subjects (
    course_id CHAR(20),
    student_id CHAR(20),
    registration_date DATE NOT NULL,
    number_of_lessons INT NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending_approval', 'pending_payment', 'registered', 'completed', 'cancelled', 'trial')),
    PRIMARY KEY (course_id, student_id),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Bang lesson
CREATE TABLE lesson (
    course_id CHAR(20),
    student_id CHAR(20),
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'absent', 'scheduled')),
    time TIMESTAMP NOT NULL,
    PRIMARY KEY (course_id, student_id, time),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Bang booking
CREATE TABLE booking (
    id CHAR(20) PRIMARY KEY,
    course_id CHAR(20),
    tutor_id CHAR(20),
    student_id CHAR(20),
    booking_time TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pending','confirmed','cancelled')),
    note TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Bang complaint
CREATE TABLE complaint (
    id CHAR(20) PRIMARY KEY,
    booking_id CHAR(20),
    student_id CHAR(20) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'resolved', 'rejected')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Bang payment
CREATE TABLE payment (
    id CHAR(20) PRIMARY KEY,
    course_id CHAR(20) NULL,
    tutor_id CHAR(20) NULL,
    student_id CHAR(20) NULL,
    amount DECIMAL(12) NOT NULL,
    payment_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'bank_transfer',
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'pending', 'failed')),
    payment_type VARCHAR(50) DEFAULT 'PAYMENT',
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- Bang notifications
CREATE TABLE notifications (
    id CHAR(36) PRIMARY KEY,
    account_id CHAR(20) NOT NULL,
    title VARCHAR(255),
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_read SMALLINT DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'sent' CHECK (status IN ('sent', 'pending', 'failed')),
    FOREIGN KEY (account_id) REFERENCES account(id)
);

-- Bang review
CREATE TABLE review (
    id CHAR(20) PRIMARY KEY,
    tutor_id CHAR(20) NOT NULL,
    student_id CHAR(20) NOT NULL,
    course_id CHAR(20),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (course_id) REFERENCES course(id)
);

-- Bang interest
CREATE TABLE interest (
    id_st CHAR(20) NOT NULL,
    id_tt CHAR(20) NOT NULL,
    PRIMARY KEY (id_st, id_tt),
    FOREIGN KEY (id_st) REFERENCES student(id),
    FOREIGN KEY (id_tt) REFERENCES tutor(id)
);

-- ============================================
-- DU LIEU MAU
-- ============================================

-- Accounts
INSERT INTO account (id, email, password, role, status) VALUES
('acc001', 'phuhuynh1@gmail.com', '123456', 1, 'active'),
('acc002', 'phuhuynh2@gmail.com', '123456', 1, 'active'),
('acc003', 'phuhuynh3@gmail.com', '123456', 1, 'active'),
('acc004', 'giasu1@gmail.com', '123456', 2, 'active'),
('acc005', 'giasu2@gmail.com', '123456', 2, 'active'),
('acc006', 'giasu3@gmail.com', '123456', 2, 'active'),
('acc007', 'giasu4@gmail.com', '123456', 2, 'active'),
('acc008', 'giasu5@gmail.com', '123456', 2, 'active'),
('acc009', 'admin@gmail.com', '123456', 3, 'active'),
('acc010', 'phuhuynh4@gmail.com', '123456', 1, 'active'),
('acc011', 'giasu6@gmail.com', '123456', 2, 'inactive'),
('acc012', 'phuhuynh5@gmail.com', '123456', 1, 'active');

-- Students
INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st001', 'Nguyen Van Nghia', '0901111001', 'Quan 1, TP.HCM', '2005-01-15', 'Can tim gia su Toan cho con lop 10', 'acc001'),
('st002', 'Le Thi Lien', '0901111002', 'Quan 3, TP.HCM', '2006-03-20', 'Muon con hoc them Tieng Anh giao tiep', 'acc002'),
('st003', 'Tran Van Nho', '0901111003', 'Quan 7, TP.HCM', '2004-07-10', 'Tim gia su Hoa hoc cho con', 'acc003'),
('st004', 'Pham Thi Dung', '0901111004', 'Quan Binh Thanh, TP.HCM', '2005-11-25', 'Can gia su day kem tai nha', 'acc010'),
('st005', 'Hoang Minh Tuan', '0901111005', 'Quan 5, TP.HCM', '2007-02-14', 'Muon hoc them Vat ly', 'acc012');

-- Tutors
INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut001', 'Nguyen Tuan Canh', 'giasu1@gmail.com', '1990-01-15', '0901000001', 'Quan 1, TP.HCM', 'Toan', 'Thac si Toan hoc, 10 nam kinh nghiem day Toan lop 10-12. Nhieu hoc sinh dat giai HSG cap thanh pho.', 123456789012, 123456789012345, 'BIDV', 'acc004', 5, 1),
('tut002', 'Tran Thi Mai', 'giasu2@gmail.com', '1988-05-12', '0901000002', 'Quan 3, TP.HCM', 'Tieng Anh', 'IELTS 8.0, chuyen luyen giao tiep va luyen thi IELTS. Tung du hoc tai Uc.', 123456789013, 123456789012346, 'Sacombank', 'acc005', 4, 1),
('tut003', 'Le Hoang Minh', 'giasu3@gmail.com', '1992-07-07', '0901000003', 'Quan 7, TP.HCM', 'Hoa hoc', 'Giao vien truong chuyen, 8 nam kinh nghiem. Phuong phap day truc quan, de hieu.', 123456789014, 123456789012347, 'Techcombank', 'acc006', 4, 1),
('tut004', 'Pham Minh Huong', 'giasu4@gmail.com', '1991-09-20', '0901000004', 'Quan Binh Thanh, TP.HCM', 'Vat ly', 'Tien si Vat ly, giang vien dai hoc. Day nhiet tinh, tan tam.', 123456789015, 123456789012348, 'MB Bank', 'acc007', 5, 1),
('tut005', 'Nguyen Thu Ha', 'giasu5@gmail.com', '1993-03-08', '0901000005', 'Quan 5, TP.HCM', 'Ngu van', 'Cu nhan Su pham Ngu van, 6 nam kinh nghiem. Giup hoc sinh yeu thich mon Van.', 123456789016, 123456789012349, 'TPBank', 'acc008', 3, 1),
('tut006', 'Do Van Thanh', 'giasu6@gmail.com', '1995-11-11', '0901000006', 'Quan Tan Binh, TP.HCM', 'Toan', 'Sinh vien nam cuoi DH Bach Khoa. Day Toan cap 2 va 3.', 123456789017, 123456789012350, 'Agribank', 'acc011', 0, 0);

-- Subjects
INSERT INTO subject (id, name, level, description, fee, status) VALUES
('sub001', 'Toan', 'Lop 10', 'Toan nang cao lop 10 - Dai so va Hinh hoc', 2000000, 'active'),
('sub002', 'Tieng Anh', 'Giao tiep', 'Tieng Anh giao tiep co ban den nang cao', 1800000, 'active'),
('sub003', 'Hoa hoc', 'Lop 10', 'Hoa hoc co ban va nang cao lop 10', 1900000, 'active'),
('sub004', 'Vat ly', 'Lop 12', 'Vat ly on thi THPT Quoc gia', 2200000, 'active'),
('sub005', 'Ngu van', 'Lop 11', 'Ngu van nang cao lop 11', 1700000, 'active'),
('sub006', 'Toan', 'Lop 6', 'Toan co ban lop 6', 1500000, 'active'),
('sub007', 'Tieng Anh', 'IELTS', 'Luyen thi IELTS tu 5.0 den 7.0', 2500000, 'active'),
('sub008', 'Hoa hoc', 'Lop 12', 'Hoa hoc on thi THPT Quoc gia', 2100000, 'active'),
('sub009', 'Toan', 'Lop 5', 'Toan nang cao lop 5 - Boi duong HSG', 1600000, 'active'),
('sub010', 'Vat ly', 'Lop 11', 'Vat ly nang cao lop 11', 2000000, 'active');

-- Courses
INSERT INTO course (id, subject_id, tutor_id, time) VALUES
('course001', 'sub001', 'tut001', '2025-05-01 08:00:00'),
('course002', 'sub002', 'tut002', '2025-05-02 09:00:00'),
('course003', 'sub003', 'tut003', '2025-05-03 10:00:00'),
('course004', 'sub004', 'tut004', '2025-06-01 08:00:00'),
('course005', 'sub005', 'tut005', '2025-06-15 09:00:00'),
('course006', 'sub006', 'tut001', '2025-07-01 14:00:00'),
('course007', 'sub007', 'tut002', '2025-07-01 10:00:00'),
('course008', 'sub008', 'tut003', '2025-07-15 08:00:00'),
('course009', 'sub009', 'tut001', '2025-08-01 08:00:00'),
('course010', 'sub010', 'tut004', '2025-08-01 14:00:00');

-- Registered Subjects
INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course001', 'st001', '2025-04-25', 10, 'completed'),
('course002', 'st002', '2025-04-26', 8, 'registered'),
('course003', 'st003', '2025-04-27', 12, 'registered'),
('course004', 'st004', '2025-05-20', 10, 'pending_approval'),
('course005', 'st001', '2025-06-01', 8, 'pending_payment'),
('course006', 'st005', '2025-06-20', 15, 'pending_approval'),
('course007', 'st002', '2025-06-25', 10, 'registered');

-- Bookings
INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk001', 'course001', 'tut001', 'st001', '2025-05-01 08:00:00', 'confirmed', 'Hoc tai nha'),
('bk002', 'course002', 'tut002', 'st002', '2025-05-02 09:00:00', 'confirmed', 'Hoc online qua Zoom'),
('bk003', 'course004', 'tut004', 'st004', '2025-06-01 08:00:00', 'pending', 'Muon hoc thu 1 buoi'),
('bk004', 'course006', 'tut001', 'st005', '2025-07-01 14:00:00', 'pending', 'Con hoc lop 6');

-- Payments
INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay001', 'course001', 'tut001', 'st001', 20000000, '2025-04-26 10:00:00', 'bank_transfer', 'completed'),
('pay002', 'course002', 'tut002', 'st002', 14400000, '2025-04-27 11:00:00', 'bank_transfer', 'completed'),
('pay003', 'course003', 'tut003', 'st003', 22800000, '2025-04-28 09:00:00', 'bank_transfer', 'pending');

-- Reviews
INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev001', 'tut001', 'st001', 'course001', 5, 'Thay day rat hay, con tien bo nhieu. Rat recommend!'),
('rev002', 'tut002', 'st002', 'course002', 4, 'Co day nhiet tinh, phat am chuan. Con tu tin giao tiep hon.'),
('rev003', 'tut001', 'st004', NULL, 5, 'Thay Canh rat kien nhan va tan tam voi hoc sinh.');

-- Lessons
INSERT INTO lesson (course_id, student_id, status, time) VALUES
('course001', 'st001', 'completed', '2025-05-01 08:00:00'),
('course001', 'st001', 'completed', '2025-05-03 08:00:00'),
('course001', 'st001', 'completed', '2025-05-05 08:00:00'),
('course001', 'st001', 'completed', '2025-05-07 08:00:00'),
('course001', 'st001', 'completed', '2025-05-09 08:00:00'),
('course002', 'st002', 'completed', '2025-05-02 09:00:00'),
('course002', 'st002', 'completed', '2025-05-04 09:00:00'),
('course002', 'st002', 'scheduled', '2025-05-06 09:00:00'),
('course003', 'st003', 'scheduled', '2025-05-03 10:00:00'),
('course003', 'st003', 'scheduled', '2025-05-05 10:00:00');

-- Notifications
INSERT INTO notifications (id, account_id, title, message, type, is_read) VALUES
('notif001', 'acc001', 'Dat lich thanh cong', 'Ban da dat lich hoc Toan voi gia su Nguyen Tuan Canh thanh cong.', 'success', 1),
('notif002', 'acc004', 'Booking moi', 'Phu huynh Pham Thi Dung muon dat lich hoc Vat ly.', 'info', 0),
('notif003', 'acc009', 'Gia su moi dang ky', 'Gia su Do Van Thanh da dang ky va cho duyet ho so.', 'warning', 0);

-- Interest
INSERT INTO interest (id_st, id_tt) VALUES
('st001', 'tut001'),
('st001', 'tut004'),
('st002', 'tut002'),
('st003', 'tut003');

-- Update avatars
UPDATE tutor SET avatar = 'giasutoan-TuanCanh.png' WHERE id = 'tut001';
UPDATE tutor SET avatar = 'giasuTiengAnh-TranThiMai.png' WHERE id = 'tut002';
UPDATE tutor SET avatar = 'giasuHoaHoc-LeHoangMinh.png' WHERE id = 'tut003';
UPDATE tutor SET avatar = 'giasuVatLi-PhamMinhHuong.png' WHERE id = 'tut004';
UPDATE tutor SET avatar = 'giasuNguVan-NguyenThuHa.png' WHERE id = 'tut005';

-- Complaints
INSERT INTO complaint (id, booking_id, student_id, title, description, status) VALUES
('comp001', 'bk001', 'st001', 'Gia su di tre', 'Gia su thuong xuyen di tre 15-20 phut va khong day bu.', 'pending'),
('comp002', 'bk002', 'st002', 'Lop hoc khong dung chat luong', 'Gia su khong chuan bi bai giang chu dao nhu cam ket.', 'resolved');
