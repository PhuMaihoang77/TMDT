-- ============================================
-- Gia Su Online - Database Schema (PostgreSQL Version)
-- ============================================

-- Xóa các bảng cũ nếu đã tồn tại (Sử dụng CASCADE để tự động xử lý ràng buộc khóa ngoại)
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

-- ============================================
-- Bảng account - Tài khoản đăng nhập
-- role: 1=Student/PhuHuynh, 2=Tutor, 3=Admin
-- ============================================
CREATE TABLE account (
    id CHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role INT DEFAULT 1 CHECK (role IN (1, 2, 3)),
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    reset_token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Bảng student - Phụ huynh / Học sinh
-- ============================================
CREATE TABLE student (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    birth DATE NULL,
    description TEXT NULL,
    avatar VARCHAR(255) DEFAULT 'default-avatar.png',
    account_id CHAR(20),
    FOREIGN KEY (account_id) REFERENCES account(id)
);

-- ============================================
-- Bảng subject - Môn học
-- ============================================
CREATE TABLE subject (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    level VARCHAR(50) NOT NULL,
    description TEXT,
    fee DECIMAL(12) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- ============================================
-- Bảng tutor - Gia sư
-- ============================================
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
    FOREIGN KEY (account_id) REFERENCES account(id)
);

-- ============================================
-- Bảng course - Khóa học
-- ============================================
CREATE TABLE course (
    id CHAR(20) PRIMARY KEY,
    subject_id CHAR(20),
    tutor_id CHAR(20),
    time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    FOREIGN KEY (subject_id) REFERENCES subject(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);

-- ============================================
-- Bảng registered_subjects - Đăng ký khóa học
-- ============================================
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

-- ============================================
-- Bảng lesson - Buổi học
-- ============================================
CREATE TABLE lesson (
    course_id CHAR(20),
    student_id CHAR(20),
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'absent', 'scheduled')),
    time TIMESTAMP NOT NULL,
    PRIMARY KEY (course_id, student_id, time),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- ============================================
-- Bảng booking - Đặt lịch
-- ============================================
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

-- ============================================
-- Bảng complaint - Khiếu nại
-- ============================================
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

-- ============================================
-- Bảng payment - Thanh toán
-- ============================================
CREATE TABLE payment (
    id CHAR(20) PRIMARY KEY,
    course_id CHAR(20) NOT NULL,
    tutor_id CHAR(20) NOT NULL,
    student_id CHAR(20) NOT NULL,
    amount DECIMAL(12) NOT NULL,
    payment_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'bank_transfer',
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'pending', 'failed')),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

-- ============================================
-- Bảng notifications - Thông báo
-- ============================================
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

-- ============================================
-- Bảng review - Đánh giá gia sư
-- ============================================
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

-- ============================================
-- Bảng interest - Quan tâm (yêu thích gia sư)
-- ============================================
CREATE TABLE interest (
    id_st CHAR(20) NOT NULL,
    id_tt CHAR(20) NOT NULL,
    PRIMARY KEY (id_st, id_tt),
    FOREIGN KEY (id_st) REFERENCES student(id),
    FOREIGN KEY (id_tt) REFERENCES tutor(id)
);


-- ============================================
-- DỮ LIỆU MẪU
-- ============================================

-- 1. Account
INSERT INTO public.account (id, email, password, role, status, reset_token, created_at) VALUES
('acc001', 'phuhuynh1@gmail.com', '123456', 1, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc003', 'phuhuynh3@gmail.com', '123456', 1, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc004', 'giasu1@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc005', 'giasu2@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc006', 'giasu3@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc007', 'giasu4@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc008', 'giasu5@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc009', 'admin@gmail.com', '123456', 3, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc010', 'phuhuynh4@gmail.com', '123456', 1, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc012', 'phuhuynh5@gmail.com', '123456', 1, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc011', 'giasu6@gmail.com', '123456', 2, 'active', NULL, '2026-06-08 15:34:57.424066'),
('acc013', 'dangminhhoang2004thd@gmail.com', '12313', 2, 'active', NULL, '2026-06-09 11:50:21.515933'),
('acc002', 'phuhuynh2@gmail.com', '123456', 1, 'inactive', NULL, '2026-06-08 15:34:57.424066');

-- 2. Subject
INSERT INTO public.subject (id, name, level, description, fee, status) VALUES
('sub001', 'Toán', 'Lớp 10', 'Toán nâng cao lớp 10 - Đại số và Hình học', 2000000, 'active'),
('sub002', 'Tiếng Anh', 'Giao tiếp', 'Tiếng Anh giao tiếp cơ bản đến nâng cao', 1800000, 'active'),
('sub003', 'Hóa học', 'Lớp 10', 'Hóa học cơ bản và nâng cao lớp 10', 1900000, 'active'),
('sub004', 'Vật lý', 'Lớp 12', 'Vật lý ôn thi THPT Quốc gia', 2200000, 'active'),
('sub005', 'Ngữ văn', 'Lớp 11', 'Ngữ văn nâng cao lớp 11', 1700000, 'active'),
('sub006', 'Toán', 'Lớp 6', 'Toán cơ bản lớp 6', 1500000, 'active'),
('sub007', 'Tiếng Anh', 'IELTS', 'Luyện thi IELTS từ 5.0 đến 7.0', 2500000, 'active'),
('sub008', 'Hóa học', 'Lớp 12', 'Hóa học ôn thi THPT Quốc gia', 2100000, 'active'),
('sub009', 'Toán', 'Lớp 5', 'Toán nâng cao lớp 5 - Bồi dưỡng HSG', 1600000, 'active'),
('sub010', 'Vật lý', 'Lớp 11', 'Vật lý nâng cao lớp 11', 2000000, 'active');

-- 3. Tutor
INSERT INTO public.tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, avatar, account_id, evaluate, verified) VALUES
('tut001', 'Nguyễn Tuấn Cảnh', 'giasu1@gmail.com', '1990-01-15', '0901000001', 'Quận 1, TP.HCM', 'Toán', 'Thạc sĩ Toán học, 10 năm kinh nghiệm.', 123456789012, 123456789012345, 'BIDV', 'giasutoan-TuanCanh.png', 'acc004', 5, 1),
('tut002', 'Trần Thị Mai', 'giasu2@gmail.com', '1988-05-12', '0901000002', 'Quận 3, TP.HCM', 'Tiếng Anh', 'IELTS 8.0, chuyên luyện giao tiếp.', 123456789013, 123456789012346, 'Sacombank', 'giasuTiengAnh-TranThiMai.png', 'acc005', 4, 1),
('tut003', 'Lê Hoàng Minh', 'giasu3@gmail.com', '1992-07-07', '0901000003', 'Quận 7, TP.HCM', 'Hóa học', 'Giáo viên trường chuyên, 8 năm kinh nghiệm.', 123456789014, 123456789012347, 'Techcombank', 'giasuHoaHoc-LeHoangMinh.png', 'acc006', 4, 1),
('tut004', 'Phạm Minh Hương', 'giasu4@gmail.com', '1991-09-20', '0901000004', 'Quận Bình Thạnh, TP.HCM', 'Vật lý', 'Tiến sĩ Vật lý, giảng viên đại học.', 123456789015, 123456789012348, 'MB Bank', 'giasuVatLi-PhamMinhHuong.png', 'acc007', 5, 1),
('tut005', 'Nguyễn Thu Hà', 'giasu5@gmail.com', '1993-03-08', '0901000005', 'Quận 5, TP.HCM', 'Ngữ văn', 'Cử nhân Sư phạm Ngữ văn.', 123456789016, 123456789012349, 'TPBank', 'giasuNguVan-NguyenThuHa.png', 'acc008', 3, 1),
('tut006', 'Đỗ Văn Thành', 'giasu6@gmail.com', '1995-11-11', '0901000006', 'Quận Tân Bình, TP.HCM', 'Toán', 'Sinh viên năm cuối ĐH Bách Khoa.', 123456789017, 123456789012350, 'Agribank', 'default-avatar.png', 'acc011', 0, 0),
('tut007', 'UIA', 'dangminhhoang2004thd@gmail.com', '2000-12-13', '0901111004', 'wer', 'Toán', '', 24252323, 5345233, 'MB bank', 'default-avatar.png', 'acc013', 0, 1);
-- 4. Course
INSERT INTO public.course VALUES 
('course001', 'sub001', 'tut001', '2025-05-01 08:00:00', 'active'),
('course002', 'sub002', 'tut002', '2025-05-02 09:00:00', 'active'),
('course003', 'sub003', 'tut003', '2025-05-03 10:00:00', 'active'),
('course004', 'sub004', 'tut004', '2025-06-01 08:00:00', 'active'),
('course005', 'sub005', 'tut005', '2025-06-15 09:00:00', 'active'),
('course006', 'sub006', 'tut001', '2025-07-01 14:00:00', 'active'),
('course007', 'sub007', 'tut002', '2025-07-01 10:00:00', 'active'),
('course008', 'sub008', 'tut003', '2025-07-15 08:00:00', 'active'),
('course009', 'sub009', 'tut001', '2025-08-01 08:00:00', 'active'),
('course010', 'sub010', 'tut004', '2025-08-01 14:00:00', 'active');

-- 5. Student
INSERT INTO public.student (id, name, phone, address, birth, description, avatar, account_id) VALUES
('st001', 'Nguyễn Văn Nghĩa', '0901111001', 'Quận 1, TP.HCM', '2005-01-15', 'Cần tìm gia sư Toán cho con lớp 10', 'default-avatar.png', 'acc001'),
('st002', 'Lê Thị Liên', '0901111002', 'Quận 3, TP.HCM', '2006-03-20', 'Muốn con học thêm Tiếng Anh giao tiếp', 'default-avatar.png', 'acc002'),
('st003', 'Trần Văn Nhỏ', '0901111003', 'Quận 7, TP.HCM', '2004-07-10', 'Tìm gia sư Hóa học cho con', 'default-avatar.png', 'acc003'),
('st005', 'Hoàng Minh Tuấn', '0901111005', 'Quận 5, TP.HCM', '2007-02-14', 'Muốn học thêm Vật lý', 'default-avatar.png', 'acc012'),
('st004', 'Phạm Thị Dung', '0901111004', 'Quận Bình Thạnh, TP.HCM', '2005-11-25', 'Cần gia sư dạy kèm tại nhà', 'default-avatar.png', 'acc010');
-- 6. Booking
INSERT INTO public.booking VALUES 
('bk001', 'course001', 'tut001', 'st001', '2025-05-01 08:00:00', 'confirmed', 'Học tại nhà', '2026-06-08 15:34:57.424066'),
('bk002', 'course002', 'tut002', 'st002', '2025-05-02 09:00:00', 'confirmed', 'Học online qua Zoom', '2026-06-08 15:34:57.424066'),
('bk004', 'course006', 'tut001', 'st005', '2025-07-01 14:00:00', 'pending', 'Con học lớp 6', '2026-06-08 15:34:57.424066'),
('bk003', 'course004', 'tut004', 'st004', '2025-06-01 08:00:00', 'cancelled', 'Muốn học thử 1 buổi', '2026-06-08 15:34:57.424066'),
('bk005', 'course001', 'tut001', 'st004', '2026-06-09 12:01:00', 'pending', '', '2026-06-09 12:01:46.409556');

-- 8. Registered Subjects
INSERT INTO public.registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course001', 'st001', '2025-04-25', 10, 'completed'),
('course002', 'st002', '2025-04-26', 8, 'registered'),
('course003', 'st003', '2025-04-27', 12, 'registered'),
('course004', 'st004', '2025-05-20', 10, 'pending_approval'),
('course005', 'st001', '2025-06-01', 8, 'pending_payment'),
('course006', 'st005', '2025-06-20', 15, 'pending_approval'),
('course007', 'st002', '2025-06-25', 10, 'registered');

-- 9. Lesson
INSERT INTO public.lesson (course_id, student_id, status, time) VALUES
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

-- 10. Payment
INSERT INTO public.payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay001', 'course001', 'tut001', 'st001', 20000000, '2025-04-26 10:00:00', 'bank_transfer', 'completed'),
('pay002', 'course002', 'tut002', 'st002', 14400000, '2025-04-27 11:00:00', 'bank_transfer', 'completed'),
('pay003', 'course003', 'tut003', 'st003', 22800000, '2025-04-28 09:00:00', 'bank_transfer', 'completed');

-- 11. Review
INSERT INTO public.review (id, tutor_id, student_id, course_id, rating, comment, created_at) VALUES
('rev001', 'tut001', 'st001', 'course001', 5, 'Thầy dạy rất hay, con tiến bộ nhiều. Rất recommend!', '2026-06-08 15:34:57'),
('rev002', 'tut002', 'st002', 'course002', 4, 'Cô dạy nhiệt tình, phát âm chuẩn. Con tự tin giao tiếp hơn.', '2026-06-08 15:34:57'),
('rev003', 'tut001', 'st004', NULL, 5, 'Thầy Cảnh rất kiên nhẫn và tận tâm với học sinh.', '2026-06-08 15:34:57');

-- 12. Interest
INSERT INTO public.interest (id_st, id_tt) VALUES
('st001', 'tut001'),
('st001', 'tut004'),
('st002', 'tut002'),
('st003', 'tut003');

-- 13. Notifications
INSERT INTO public.notifications (id, account_id, title, message, type, created_at, is_read, status) VALUES
('notif001', 'acc001', 'Đặt lịch thành công', 'Bạn đã đặt lịch học Toán với gia sư Nguyễn Tuấn Cảnh thành công.', 'success', '2026-06-08 15:34:57', 1, 'sent'),
('notif002', 'acc004', 'Booking mới', 'Phụ huynh Phạm Thị Dung muốn đặt lịch học Vật lý.', 'info', '2026-06-08 15:34:57', 0, 'sent'),
('notif003', 'acc009', 'Gia sư mới đăng ký', 'Gia sư Đỗ Văn Thành đã đăng ký và chờ duyệt hồ sơ.', 'warning', '2026-06-08 15:34:57', 0, 'sent');