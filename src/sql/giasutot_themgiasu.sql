-- =========================================================================
-- Gia Su Online - TỆP SCRIPT TÍCH HỢP TẤT CẢ CÁC CẤP (1, 2, 3 + GỐC)
-- ĐÃ KHỬ LỖI XUNG ĐỘT KHÓA CHÍNH, KHÓA NGOẠI VÀ TRÙNG LẶP MÃ HỌC VIÊN
-- =========================================================================

-- Xóa dọn sạch các bảng cũ trước khi khởi tạo hệ thống mới
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

-- =========================================================================
-- PHẦN I: KHỞI TẠO CẤU TRÚC BẢNG (DATABASE SCHEMA)
-- =========================================================================

CREATE TABLE account (
    id CHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role INT DEFAULT 1 CHECK (role IN (1, 2, 3)),
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    reset_token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE subject (
    id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    level VARCHAR(50) NOT NULL,
    description TEXT,
    fee DECIMAL(12) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

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

CREATE TABLE course (
    id CHAR(20) PRIMARY KEY,
    subject_id CHAR(20),
    tutor_id CHAR(20),
    time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    FOREIGN KEY (subject_id) REFERENCES subject(id),
    FOREIGN KEY (tutor_id) REFERENCES tutor(id)
);

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

CREATE TABLE lesson (
    course_id CHAR(20),
    student_id CHAR(20),
    status VARCHAR(50) NOT NULL CHECK (status IN ('completed', 'absent', 'scheduled')),
    time TIMESTAMP NOT NULL,
    PRIMARY KEY (course_id, student_id, time),
    FOREIGN KEY (course_id) REFERENCES course(id),
    FOREIGN KEY (student_id) REFERENCES student(id)
);

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

CREATE TABLE interest (
    id_st CHAR(20) NOT NULL,
    id_tt CHAR(20) NOT NULL,
    PRIMARY KEY (id_st, id_tt),
    FOREIGN KEY (id_st) REFERENCES student(id),
    FOREIGN KEY (id_tt) REFERENCES tutor(id)
);

-- =========================================================================
-- PHẦN II: NẠP DỮ LIỆU ĐỢT 1 (DỮ LIỆU GỐC ĐẠI TRÀ - ID 001 -> 012)
-- =========================================================================

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

INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st001', 'Nguyễn Văn Nghĩa', '0901111001', 'Quận 1, TP.HCM', '2005-01-15', 'Cần tìm gia sư Toán cho con lớp 10', 'acc001'),
('st002', 'Lê Thị Liên', '0901111002', 'Quận 3, TP.HCM', '2006-03-20', 'Muốn con học thêm Tiếng Anh giao tiếp', 'acc002'),
('st003', 'Trần Văn Nhỏ', '0901111003', 'Quận 7, TP.HCM', '2004-07-10', 'Tìm gia sư Hóa học cho con', 'acc003'),
('st004', 'Phạm Thị Dung', '0901111004', 'Quận Bình Thạnh, TP.HCM', '2005-11-25', 'Cần gia sư dạy kèm tại nhà', 'acc010'),
('st005', 'Hoàng Minh Tuấn', '0901111005', 'Quận 5, TP.HCM', '2007-02-14', 'Muốn học thêm Vật lý', 'acc012');

INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut001', 'Nguyễn Tuấn Cảnh', 'giasu1@gmail.com', '1990-01-15', '0901000001', 'Quận 1, TP.HCM', 'Toán', 'Thạc sĩ Toán học, 10 năm kinh nghiệm dạy Toán lớp 10-12. Nhiều học sinh đạt giải HSG cấp thành phố.', 123456789012, 123456789012345, 'BIDV', 'acc004', 5, 1),
('tut002', 'Trần Thị Mai', 'giasu2@gmail.com', '1988-05-12', '0901000002', 'Quận 3, TP.HCM', 'Tiếng Anh', 'IELTS 8.0, chuyên luyện giao tiếp và luyện thi IELTS. Từng du học tại Úc.', 123456789013, 123456789012346, 'Sacombank', 'acc005', 4, 1),
('tut003', 'Lê Hoàng Minh', 'giasu3@gmail.com', '1992-07-07', '0901000003', 'Quận 7, TP.HCM', 'Hóa học', 'Giáo viên trường chuyên, 8 năm kinh nghiệm. Phương pháp dạy trực quan, dễ hiểu.', 123456789014, 123456789012347, 'Techcombank', 'acc006', 4, 1),
('tut004', 'Phạm Minh Hương', 'giasu4@gmail.com', '1991-09-20', '0901000004', 'Quận Bình Thạnh, TP.HCM', 'Vật lý', 'Tiến sĩ Vật lý, giảng viên đại học. Dạy nhiệt tình, tận tâm.', 123456789015, 123456789012348, 'MB Bank', 'acc007', 5, 1),
('tut005', 'Nguyễn Thu Hà', 'giasu5@gmail.com', '1993-03-08', '0901000005', 'Quận 5, TP.HCM', 'Ngữ văn', 'Cử nhân Sư phạm Ngữ văn, 6 năm kinh nghiệm. Giúp học sinh yêu thích môn Văn.', 123456789016, 123456789012349, 'TPBank', 'acc008', 3, 1),
('tut006', 'Đỗ Văn Thành', 'giasu6@gmail.com', '1995-11-11', '0901000006', 'Quận Tân Bình, TP.HCM', 'Toán', 'Sinh viên năm cuối ĐH Bách Khoa. Dạy Toán cấp 2 và 3.', 123456789017, 123456789012350, 'Agribank', 'acc011', 0, 0);

INSERT INTO subject (id, name, level, description, fee, status) VALUES
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

INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course001', 'st001', '2025-04-25', 10, 'completed'),
('course002', 'st002', '2025-04-26', 8, 'registered'),
('course003', 'st003', '2025-04-27', 12, 'registered'),
('course004', 'st004', '2025-05-20', 10, 'pending_approval'),
('course005', 'st001', '2025-06-01', 8, 'pending_payment'),
('course006', 'st005', '2025-06-20', 15, 'pending_approval'),
('course007', 'st002', '2025-06-25', 10, 'registered');

INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk001', 'course001', 'tut001', 'st001', '2025-05-01 08:00:00', 'confirmed', 'Học tại nhà'),
('bk002', 'course002', 'tut002', 'st002', '2025-05-02 09:00:00', 'confirmed', 'Học online qua Zoom'),
('bk003', 'course004', 'tut004', 'st004', '2025-06-01 08:00:00', 'pending', 'Muốn học thử 1 buổi'),
('bk004', 'course006', 'tut001', 'st005', '2025-07-01 14:00:00', 'pending', 'Con học lớp 6');

INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay001', 'course001', 'tut001', 'st001', 20000000, '2025-04-26 10:00:00', 'bank_transfer', 'completed'),
('pay002', 'course002', 'tut002', 'st002', 14400000, '2025-04-27 11:00:00', 'bank_transfer', 'completed'),
('pay003', 'course003', 'tut003', 'st003', 22800000, '2025-04-28 09:00:00', 'bank_transfer', 'pending');

INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev001', 'tut001', 'st001', 'course001', 5, 'Thầy dạy rất hay, con tiến bộ nhiều. Rất recommend!'),
('rev002', 'tut002', 'st002', 'course002', 4, 'Cô dạy nhiệt tình, phát âm chuẩn. Con tự tin giao tiếp hơn.'),
('rev003', 'tut001', 'st004', NULL, 5, 'Thầy Cảnh rất kiên nhẫn và tận tâm với học sinh.');

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

INSERT INTO notifications (id, account_id, title, message, type, is_read) VALUES
('notif001', 'acc001', 'Đặt lịch thành công', 'Bạn đã đặt lịch học Toán với gia sư Nguyễn Tuấn Cảnh thành công.', 'success', 1),
('notif002', 'acc004', 'Booking mới', 'Phụ huynh Phạm Thị Dung muốn đặt lịch học Vật lý.', 'info', 0),
('notif003', 'acc009', 'Gia sư mới đăng ký', 'Gia sư Đỗ Văn Thành đã đăng ký và chờ duyệt hồ sơ.', 'warning', 0);

INSERT INTO interest (id_st, id_tt) VALUES
('st001', 'tut001'),
('st001', 'tut004'),
('st002', 'tut002'),
('st003', 'tut003');

UPDATE tutor SET avatar = 'tut001.png' WHERE id = 'tut001';
UPDATE tutor SET avatar = 'tut002.png' WHERE id = 'tut002';
UPDATE tutor SET avatar = 'tut003.png' WHERE id = 'tut003';
UPDATE tutor SET avatar = 'tut004.png' WHERE id = 'tut004';
UPDATE tutor SET avatar = 'tut005.png' WHERE id = 'tut005';

INSERT INTO complaint (id, booking_id, student_id, title, description, status) VALUES
('comp001', 'bk001', 'st001', 'Gia sư đi trễ', 'Gia sư thường xuyên đi trễ 15-20 phút và không dạy bù.', 'pending'),
('comp002', 'bk002', 'st002', 'Lớp học không đúng chất lượng', 'Gia sư không chuẩn bị bài giảng chu đáo như cam kết.', 'resolved');


-- =========================================================================
-- ĐỢT 2: DỮ LIỆU CẤP 1 (TIỂU HỌC) - THỰC TẾ TRÙNG KHỚP ĐỜI SỐNG (ID 013 -> 024)
-- =========================================================================

INSERT INTO account (id, email, password, role, status) VALUES
('acc013', 'sv.lephuong@gmail.com', '123456', 2, 'active'),
('acc014', 'sv.hoangnam@gmail.com', '123456', 2, 'active'),
('acc015', 'sv.minhthu@gmail.com', '123456', 2, 'active'),
('acc016', 'sv.tienanh@gmail.com', '123456', 2, 'active'),
('acc017', 'gv.hongvan.sp@gmail.com', '123456', 2, 'active'),
('acc018', 'gv.minhtuan.sp@gmail.com', '123456', 2, 'active'),
('acc019', 'gv.thanhhung.school@gmail.com', '123456', 2, 'active'),
('acc020', 'gv.kimoanh.school@gmail.com', '123456', 2, 'active'),
('acc021', 'phuhuynh.dat@gmail.com', '123456', 1, 'active'),
('acc022', 'phuhuynh.thao@gmail.com', '123456', 1, 'active'),
('acc023', 'phuhuynh.dung@gmail.com', '123456', 1, 'active'),
('acc024', 'phuhuynh.tuan@gmail.com', '123456', 1, 'active');

INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st006', N'Bé Trương Tấn Phát', '0901234567', N'Thủ Đức, Ho Chi Minh City', '2019-05-20', N'Con phụ huynh Đạt, chuẩn bị vào Lớp 1, cần rèn chữ và học số đếm.', 'acc021'),
('st007', N'Bé Nguyễn Hoài An', '0907654321', N'Quận 9, TP.HCM', '2017-08-12', N'Học sinh Lớp 4, cần tìm gia sư sinh viên kèm bài tập về nhà mỗi tối.', 'acc022'),
('st008', N'Bé Lê Minh Khôi', '0911223344', N'Quận 7, TP.HCM', '2018-03-14', N'Học sinh Lớp 3, cần lấy lại gốc môn Toán và học thêm Tiếng Anh trường.', 'acc023'),
('st009', N'Bé Phạm Ngọc Vy', '0933445566', N'Bình Thạnh, TP.HCM', '2015-11-02', N'Học sinh Lớp 5, chuẩn bị thi học kỳ và cần học thêm toán tư duy.', 'acc024');

INSERT INTO subject (id, name, level, description, fee, status) VALUES
('sub011', N'Rèn Chữ & Toán Lớp 1', N'Lớp 1', N'Dạy nét chữ cơ bản, tư thế ngồi và toán cộng trừ lớp 1.', 120000, 'active'),
('sub012', N'Kèm Bài Tập Về Nhà (Báo Bài)', N'Cấp 1', N'Dò bài cũ, hướng dẫn làm bài tập Toán + Tiếng Việt theo SGK hàng ngày.', 130000, 'active'),
('sub013', N'Tiếng Anh Ôn Tập Trên Trường', N'Cấp 1', N'Bám sát ngữ pháp, từ vựng theo sách giáo khoa của Bộ Giáo Dục.', 140000, 'active'),
('sub014', N'Toán Tư Duy Tiểu Học', N'Cấp 1', N'Học toán qua hình ảnh, sơ đồ logic, kích thích tư duy nhạy bén.', 150000, 'active'),
('sub015', N'Toán & Tiếng Việt Lớp 4-5 Nâng Cao', N'Cấp 1', N'Hệ thống lại kiến thức, giải toán nâng cao và rèn tập làm văn miêu tả.', 220000, 'active'),
('sub016', N'Tiếng Anh Giao Tiếp Thực Tiễn', N'Cấp 1', N'Luyện phản xạ nghe nói, phát âm chuẩn cho trẻ tiểu học.', 250000, 'active'),
('sub017', N'Ôn Thi Học Kỳ Khối Tiểu Học', N'Cấp 1', N'Tổng ôn kiến thức trọng tâm, giải đề thi mẫu của các trường.', 300000, 'active');

INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut007', N'Lê Thị Phương', 'sv.lephuong@gmail.com', '2005-04-12', '0961110001', N'Quận 5, TP.HCM', N'Sinh viên Sư phạm Tiểu học', N'Sinh viên năm 3. Nhận dạy trọn gói từ Lớp 1 đến Lớp 5. Chuyên kèm bài tập về nhà (báo bài) mỗi tối.', 123456789021, 9001, 'Vietcombank', 'acc013', 4, 1),
('tut008', N'Hoàng Văn Nam', 'sv.hoangnam@gmail.com', '2004-09-20', '0961110002', N'Thủ Đức, TP.HCM', N'Sinh viên Bách Khoa', N'Sinh viên năm 4. Chỉ nhận dạy Lớp 4 và Lớp 5 môn Toán và Toán tư duy.', 123456789022, 9002, 'TPBank', 'acc014', 5, 1),
('tut009', N'Nguyễn Minh Thư', 'sv.minhthu@gmail.com', '2006-02-18', '0961110003', N'Quận 10, TP.HCM', N'Sinh viên Ngoại Thương', N'Sinh viên năm 2, chữ rất đẹp. Chuyên nhận rèn chữ, uốn tư thế cầm bút Lớp 1, 2.', 123456789023, 9003, 'MB Bank', 'acc015', 4, 1),
('tut010', N'Phạm Tiến Anh', 'sv.tienanh@gmail.com', '2005-11-30', '0961110004', N'Quận 7, TP.HCM', N'Sinh viên Ngôn Ngữ Anh', N'Sinh viên năm 3, IELTS 6.5. Chuyên nhận dạy kèm Tiếng Anh tiểu học bám sát chương trình trường.', 123456789024, 9004, 'Techcombank', 'acc016', 5, 1),
('tut011', N'Phạm Nguyễn Hồng Vân', 'gv.hongvan.sp@gmail.com', '2003-05-14', '0961110005', N'Tân Phú, TP.HCM', N'Cử nhân Sư phạm Tiểu học', N'Mới tốt nghiệp ĐH Sư Phạm. Có 4 năm kinh nghiệm thực tế. Nhận dạy tổ hợp Toán + Văn nâng cao.', 123456789025, 9005, 'ACB', 'acc017', 5, 1),
('tut012', N'Nguyễn Minh Tuấn', 'gv.minhtuan.sp@gmail.com', '2002-08-22', '0961110006', N'Quận 3, TP.HCM', N'Cử nhân Sư phạm Tiếng Anh', N'Mới tốt nghiệp. Chuyên dạy Tiếng Anh giao tiếp thực tiễn nghe nói phản xạ.', 123456789026, 9006, 'VietinBank', 'acc018', 0, 1),
('tut013', N'Thầy Nguyễn Thanh Hùng', 'gv.thanhhung.school@gmail.com', '1985-03-15', '0961110007', N'Quận 10, TP.HCM', N'Giáo viên Tiểu học Trường Công', N'Giáo viên đứng lớp hơn 10 năm. Nhận dạy ôn thi học kỳ, lấy lại gốc cho học sinh cá biệt.', 123456789027, 9007, 'Vietcombank', 'acc019', 5, 1),
('tut014', N'Cô Lê Kim Oanh', 'gv.kimoanh.school@gmail.com', '1980-10-12', '0961110008', N'Bình Thạnh, TP.HCM', N'Giáo viên Tiểu học Trường Công', N'Giáo viên cốt cán trường tiểu học điểm. Nhận rèn chữ chuẩn bị vào Lớp 1 VIP.', 123456789028, 9008, 'BIDV', 'acc020', 5, 1);

UPDATE tutor SET avatar = 'tut007.png' WHERE id = 'tut007';
UPDATE tutor SET avatar = 'tut008.png' WHERE id = 'tut008';
UPDATE tutor SET avatar = 'tut009.png' WHERE id = 'tut009';
UPDATE tutor SET avatar = 'tut010.png' WHERE id = 'tut010';
UPDATE tutor SET avatar = 'tut011.png' WHERE id = 'tut011';
UPDATE tutor SET avatar = 'tut012.png' WHERE id = 'tut012';
UPDATE tutor SET avatar = 'tut013.png' WHERE id = 'tut013';
UPDATE tutor SET avatar = 'tut014.png' WHERE id = 'tut014';

INSERT INTO course (id, subject_id, tutor_id, time) VALUES
('course011', 'sub012', 'tut007', '2026-07-01 18:00:00'),
('course012', 'sub014', 'tut008', '2026-07-02 19:30:00'), 
('course013', 'sub011', 'tut009', '2026-07-01 17:00:00'),
('course014', 'sub013', 'tut010', '2026-07-03 18:30:00'),
('course015', 'sub015', 'tut011', '2026-07-05 08:30:00'),
('course016', 'sub016', 'tut012', '2026-07-02 19:00:00'),
('course017', 'sub017', 'tut013', '2026-07-01 19:30:00'),
('course018', 'sub011', 'tut014', '2026-07-02 16:30:00');

INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course018', 'st006', '2026-06-25', 10, 'registered'),
('course011', 'st007', '2026-05-10', 12, 'completed'),
('course012', 'st009', '2026-06-28', 8, 'pending_payment');

INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk005', 'course018', 'tut014', 'st006', '2026-07-02 16:30:00', 'confirmed', N'Học rèn chữ chuẩn bị vào lớp 1.'),
('bk006', 'course011', 'tut007', 'st007', '2026-05-12 18:00:00', 'confirmed', N'Kèm bài tập về nhà hàng tối.'),
('bk007', 'course012', 'tut008', 'st009', '2026-07-02 19:30:00', 'pending', N'Học toán tư duy lớp 5.');

INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay004', 'course018', 'tut014', 'st006', 1200000, '2026-06-25 11:00:00', 'bank_transfer', 'completed'),
('pay005', 'course011', 'tut007', 'st007', 1560000, '2026-05-10 14:00:00', 'bank_transfer', 'completed');

INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev004', 'tut007', 'st007', 'course011', 5, N'Chị Phương dạy rất có tâm, bé làm hết bài tập trên lớp đầy đủ.');


-- =========================================================================
-- ĐỢT 3: DỮ LIỆU CẤP 2 (THCS) - ĐƠN MÔN TRƯỜNG CÔNG & TỰ DO (ID 025 -> 038)
-- =========================================================================

INSERT INTO account (id, email, password, role, status) VALUES
('acc025', 'sv.bachkhoa.linh@gmail.com', '123456', 2, 'active'),
('acc026', 'sv.supham.quan@gmail.com', '123456', 2, 'active'),
('acc027', 'sv.ngonngu.ha@gmail.com', '123456', 2, 'active'),
('acc028', 'sv.kinhte.minh@gmail.com', '123456', 2, 'active'),
('acc029', 'gv.spvan.trang@gmail.com', '123456', 2, 'active'),
('acc030', 'gv.sptoan.dung@gmail.com', '123456', 2, 'active'),
('acc031', 'gv.tudo.tuan@gmail.com', '123456', 2, 'active'),
('acc032', 'gv.truongcong.son@gmail.com', '123456', 2, 'active'),
('acc033', 'gv.truongchuyen.nga@gmail.com', '123456', 2, 'active'),
('acc034', 'gv.truongcong.huong@gmail.com', '123456', 2, 'active'),
('acc035', 'phuhuynh.khunghoang@gmail.com', '123456', 1, 'active'),
('acc036', 'phuhuynh.chienluoc@gmail.com', '123456', 1, 'active'),
('acc037', 'phuhuynh.binhthuong@gmail.com', '123456', 1, 'active'),
('acc038', 'phuhuynh.nuocrut10@gmail.com', '123456', 1, 'active');

INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st011', N'Bé Nguyễn Hoàng Long', '0931234501', N'Quận 10, TP.HCM', '2012-07-15', N'Học sinh Lớp 8 sa sút điểm số môn Toán hình học, cần tìm người lấy lại gốc gấp.', 'acc035'),
('st012', N'Bé Lê Trần Nhã Đan', '0931234502', N'Quận 7, TP.HCM', '2014-03-22', N'Học sinh Lớp 6 học lực khá, định hướng cày nâng cao môn Tiếng Anh thi chuyên cấp 3.', 'acc036'),
('st013', N'Bé Phạm Minh Triết', '0931234503', N'Bình Thạnh, TP.HCM', '2013-05-10', N'Học sinh Lớp 7 học lực trung bình khá. Muốn học chắc chắn kiến thức SGK trường.', 'acc037'),
('st014', N'Bé Trần Gia Bảo', '0931234504', N'Quận 3, TP.HCM', '2011-09-02', N'Học sinh Lớp 9 nước rút, mục tiêu thi đỗ suất vào trường cấp 3 công lập tuyển sinh.', 'acc038');

INSERT INTO subject (id, name, level, description, fee, status) VALUES
('sub021', N'Toán Lấy Lại Gốc Lớp 7', N'Lớp 7', N'Lấy lại căn bản đại số và hình học tam giác cho học sinh bị hổng kiến thức.', 140000, 'active'),
('sub022', N'Lý & Hóa Lớp 8 Cơ Bản', N'Lớp 8', N'Học công thức vật lý, hóa trị, phương trình hóa học bám sát SGK.', 150000, 'active'),
('sub023', N'Kèm Bài Tập Về Nhà Lớp 6 (Báo Bài)', N'Lớp 6', N'Kèm học sinh làm bài tập Toán và soạn bài Văn theo thời khóa biểu trên lớp.', 130000, 'active'),
('sub024', N'Tiếng Anh Bám Sát Chương Trình Lớp 6', N'Lớp 6', N'Ôn tập từ vựng, ngữ pháp theo bộ sách mới Kết nối tri thức / Chân trời sáng tạo.', 140000, 'active'),
('sub025', N'Tiếng Anh Định Hướng IELTS Sớm', N'Lớp 8', N'Luyện 4 kỹ năng nghe nói đọc viết nâng cao, xây nền tảng IELTS sớm từ cấp 2.', 180000, 'active'),
('sub026', N'Học Tốt Toán Lớp 6 (Cơ Bản)', N'Lớp 6', N'Dạy chắc chắn kiến thức số học và hình học cơ bản, chuẩn bị bài trước khi lên lớp.', 200000, 'active'),
('sub027', N'Bổ Trợ Kiến Thức Ngữ Văn Lớp 8', N'Lớp 8', N'Phân tích tác phẩm văn học, viết văn nghị luận văn học mộc mạc, bám sát trường.', 220000, 'active'),
('sub028', N'Học Chuẩn Kiến Thức Toán Lớp 7', N'Lớp 7', N'Giảng dạy theo tiến độ SGK trường công, đảm bảo điểm số 7-8 trong các bài kiểm tra.', 220000, 'active'),
('sub029', N'Toán Ôn Thi Vào 10 Thực Chiến', N'Lớp 9', N'Hệ thống toán tuyển sinh, luyện đề thi thử của Sở Giáo Dục các năm.', 350000, 'active'),
('sub030', N'Luyện Viết Văn Nghị Luận Lớp 9 Vào 10', N'Lớp 9', N'Bắt bài cấu trúc nghị luận xã hội và nghị luận văn học giành điểm cao thi vào 10.', 350000, 'active'),
('sub031', N'Tiếng Anh Chuyên Lớp 9 Ôn Thi Vào 10', N'Lớp 9', N'Cày đề chuyên sâu, từ vựng nâng cao cho học sinh đặt mục tiêu trường chuyên.', 400000, 'active');

INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut015', N'Trần Minh Linh', 'sv.bachkhoa.linh@gmail.com', '2005-03-15', '0971110001', N'Quận 10, TP.HCM', N'Sinh viên - Toán Lý Hóa Lớp 8,9', N'Sinh viên năm 3 ĐH Bách Khoa. Chỉ nhận dạy các môn tự nhiên Toán, Lý, Hóa khối Lớp 8 và Lớp 9.', 123456789033, 9001, 'TPBank', 'acc025', 5, 1),
('tut016', N'Nguyễn Hồng Quân', 'sv.supham.quan@gmail.com', '2006-08-20', '0971110002', N'Quận 5, TP.HCM', N'Sinh viên - Sư phạm Toán', N'Sinh viên năm 2 ĐH Sư Phạm ngành Sư phạm Toán. Chuyên trị học sinh mất gốc Toán hình lớp 6,7,8.', 123456789034, 9002, 'MB Bank', 'acc026', 4, 1),
('tut017', N'Lê Thanh Hà', 'sv.ngonngu.ha@gmail.com', '2005-12-10', '0971110003', N'Quận 7, TP.HCM', N'Sinh viên - Tiếng Anh Nâng Cao', N'Sinh viên năm 3 ĐH Ngoại Thương, IELTS 7.5. Chuyên dạy định hướng chuyên / IELTS sớm.', 123456789035, 9003, 'Vietcombank', 'acc027', 5, 1),
('tut018', N'Phạm Nhật Minh', 'sv.kinhte.minh@gmail.com', '2006-02-28', '0971110004', N'Bình Thạnh, TP.HCM', N'Sinh viên - Kèm Báo Bài Cấp 2', N'Sinh viên năm 2 ĐH Kinh Tế. Nhận kèm bài tập về nhà môn Toán hoặc Anh Lớp 6, Lớp 7 cơ bản.', 123456789036, 9004, 'Techcombank', 'acc028', 4, 1),
('tut019', N'Cô Nguyễn Thu Trang', 'gv.spvan.trang@gmail.com', '2003-10-02', '0971110005', N'Tân Phú, TP.HCM', N'Giáo viên - Sư phạm Ngữ Văn', N'Mới tốt nghiệp cử nhân Sư phạm Văn loại Giỏi. Nhận dạy môn Ngữ Văn khối lớp từ Lớp 6 đến Lớp 9.', 123456789037, 9005, 'ACB', 'acc029', 5, 1),
('tut020', N'Thầy Lê Văn Dũng', 'gv.sptoan.dung@gmail.com', '2002-04-12', '0971110006', N'Quận 3, TP.HCM', N'Giáo viên - Sư phạm Toán', N'Tốt nghiệp Khoa Toán, có 3 năm kinh nghiệm. Né áp lực lớp 9, chỉ nhận dạy Toán lớp 6, 7, 8 thong thả.', 123456789038, 9006, 'VietinBank', 'acc030', 4, 1),
('tut021', N'Thầy Hoàng Minh Tuấn', 'gv.tudo.tuan@gmail.com', '1999-05-25', '0971110007', N'Gò Vấp, TP.HCM', N'Giáo viên tự do - Tiếng Anh cơ bản', N'Mở lớp thong thả bám sát 100% SGK Bộ Giáo Dục cho khối Lớp 6, 7. Giúp học sinh trung bình vững bài.', 123456789039, 9007, 'HDBank', 'acc031', 0, 1),
('tut022', N'Thầy Phạm Thanh Sơn', 'gv.truongcong.son@gmail.com', '1981-11-14', '0971110008', N'Quận 10, TP.HCM', N'Giáo viên Trường Công - Chuyên Toán 9', N'Giáo viên môn Toán trường THCS công lập đứng lớp 15 năm. Chuyên mở lớp luyện đề tuyển sinh lớp 10.', 123456789040, 9008, 'Vietcombank', 'acc032', 5, 1),
('tut023', N'Cô Vũ Thị Nga', 'gv.truongchuyen.nga@gmail.com', '1986-02-18', '0971110009', N'Quận 1, TP.HCM', N'Giáo viên Trường Chuyên - Tiếng Anh', N'Giáo viên chuyên bồi dưỡng học sinh giỏi môn Anh. Luyện thi vào 10 chuyên Anh nâng cao.', 123456789041, 9009, 'BIDV', 'acc033', 5, 1),
('tut024', N'Cô Nguyễn Thị Hương', 'gv.truongcong.huong@gmail.com', '1983-09-30', '0971110010', N'Bình Thạnh, TP.HCM', N'Giáo viên Trường Công - Ngữ Văn', N'Giáo viên đứng lớp dạy Văn trường công bình thường. Buổi tối mở lớp bổ trợ kiến thức Ngữ Văn Lớp 8 thong thả.', 123456789042, 9010, 'Sacombank', 'acc034', 5, 1);

UPDATE tutor SET avatar = 'tut015.png' WHERE id = 'tut015';
UPDATE tutor SET avatar = 'tut016.png' WHERE id = 'tut016';
UPDATE tutor SET avatar = 'tut017.png' WHERE id = 'tut017';
UPDATE tutor SET avatar = 'tut018.png' WHERE id = 'tut018';
UPDATE tutor SET avatar = 'tut019.png' WHERE id = 'tut019';
UPDATE tutor SET avatar = 'tut020.png' WHERE id = 'tut020';
UPDATE tutor SET avatar = 'tut021.png' WHERE id = 'tut021';
UPDATE tutor SET avatar = 'tut022.png' WHERE id = 'tut022';
UPDATE tutor SET avatar = 'tut023.png' WHERE id = 'tut023';
UPDATE tutor SET avatar = 'tut024.png' WHERE id = 'tut024';

INSERT INTO course (id, subject_id, tutor_id, time) VALUES
('course019', 'sub022', 'tut015', '2026-07-01 19:30:00'),
('course020', 'sub021', 'tut016', '2026-07-02 18:00:00'),
('course021', 'sub025', 'tut017', '2026-07-01 17:00:00'),
('course022', 'sub030', 'tut019', '2026-07-05 08:00:00'),
('course023', 'sub028', 'tut020', '2026-07-03 19:00:00'),
('course024', 'sub026', 'tut021', '2026-07-02 18:30:00'),
('course025', 'sub029', 'tut022', '2026-07-01 19:00:00'),
('course026', 'sub027', 'tut024', '2026-07-02 19:30:00');

INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course025', 'st014', '2026-06-25', 24, 'registered'),
('course026', 'st013', '2026-05-01', 8, 'completed'),
('course020', 'st011', '2026-06-28', 12, 'pending_payment');

INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk008', 'course025', 'tut022', 'st014', '2026-07-01 19:00:00', 'confirmed', N'Luyện thi vào lớp 10 cấp tốc công lập Q.3.'),
('bk009', 'course026', 'tut024', 'st013', '2026-05-02 19:30:00', 'confirmed', N'Học bổ trợ kiến thức Văn 8 bình thường.'),
('bk010', 'course020', 'tut016', 'st011', '2026-07-02 18:00:00', 'pending', N'Bé bị hổng nhiều kiến thức hình học tam giác lớp 7.');

INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay006', 'course025', 'tut022', 'st014', 8400000, '2026-06-25 14:20:00', 'bank_transfer', 'completed'),
('pay007', 'course026', 'tut024', 'st013', 1760000, '2026-05-01 09:00:00', 'bank_transfer', 'completed');

INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev006', 'tut024', 'st013', 'course026', 5, N'Cô Hương dạy rất chuẩn chương trình trường, con học hiểu bài, bài kiểm tra cuối kỳ đạt điểm khá ổn định.');


-- =========================================================================
-- ĐỢT 4 [MỚI]: DỮ LIỆU CẤP 3 (THPT) - THỰC CHIẾN ĐƠN MÔN (ID: acc039+, tut025+, st015+, sub032+, course027+)
-- THÊM CHUẨN XÁC VÀO CUỐI FILE ĐỂ BẠN KIỂM SOÁT VÀ CẬP NHẬT ẢNH AVATAR
-- =========================================================================

-- 1. Bơm tài khoản Cấp 3
INSERT INTO account (id, email, password, role, status) VALUES
-- Tài khoản nhóm Sinh viên đi làm thêm (Nhóm 1)
('acc039', 'sv.thukhoa.khoaa@gmail.com', '123456', 2, 'active'),
('acc040', 'sv.chuyenly.bach@gmail.com', '123456', 2, 'active'),
('acc041', 'sv.ielts8.khanh@gmail.com', '123456', 2, 'active'),
-- Tài khoản nhóm Giáo viên mới ra trường / tự do (Nhóm 2)
('acc042', 'gv.sptoan.hai@gmail.com', '123456', 2, 'active'),
('acc043', 'gv.tudo.gpa.chi@gmail.com', '123456', 2, 'active'),
-- Tài khoản nhóm Giáo viên đang đứng lớp trường THPT công lập (Nhóm 3)
('acc044', 'gv.thpt.minh.toan12@gmail.com', '123456', 2, 'active'),
('acc045', 'gv.thpt.lan.van12@gmail.com', '123456', 2, 'active'),
('acc046', 'gv.thpt.duc.ly11@gmail.com', '123456', 2, 'active'),
-- Tài khoản nhóm Phụ huynh / Học sinh Cấp 3 mới
('acc047', 'phuhuynh.c3.gpa@gmail.com', '123456', 1, 'active'),
('acc048', 'hocsinh.c3.ielts@gmail.com', '123456', 1, 'active'),
('acc049', 'hocsinh.c3.nuocrut12@gmail.com', '123456', 1, 'active');

-- 2. Bơm danh mục môn học Cấp 3
INSERT INTO subject (id, name, level, description, fee, status) VALUES
-- Môn học bám sát học bạ lớp 10, 11 (Xét tuyển GPA)
('sub032', N'Toán Lớp 10 Đại Số & Hình Học', N'Lớp 10', N'Xây dựng nền tảng toán cấp 3, bám sát sách giáo khoa mới, giúp đạt GPA học bạ cao.', 160000, 'active'),
('sub033', N'Vật Lý Lớp 10 Cơ Bản', N'Lớp 10', N'Giúp học sinh làm quen động học, động lực học lớp 10, giải bài tập SGK thong thả.', 160000, 'active'),
('sub034', N'Bổ Trợ Kiến Thức Toán Lớp 11', N'Lớp 11', N'Giảng dạy chuẩn kiến thức lượng giác, tổ hợp xác suất, hình học không gian lớp 11.', 220000, 'active'),
('sub035', N'Bổ Trợ Ngữ Văn Lớp 11 Học Bạ', N'Lớp 11', N'Phân tích tác phẩm, rèn kỹ năng viết văn nghị luận bám sát phân phối chương trình trường.', 220000, 'active'),
-- Khóa cày chứng chỉ xét tuyển thẳng đại học
('sub036', N'Luyện Thi IELTS Cấp Tốc Học Sinh Cấp 3', N'Cấp 3', N'Luyện chiến thuật 4 kỹ năng Nghe-Nói-Đọc-Viết cấp tốc, cam kết mục tiêu 6.5+ ra trường.', 250000, 'active'),
-- Khóa thực chiến Lớp 12 ôn thi tốt nghiệp THPT Quốc Gia
('sub037', N'Toán 12 - Luyện Thi Tốt Nghiệp THPT', N'Lớp 12', N'Tổng ôn toàn bộ chuyên đề toán 12 trắc nghiệm, mẹo bấm máy tính Casio, giải đề thực chiến.', 200000, 'active'),
('sub038', N'Tổng Ôn Cấp Tốc Hóa Học Lớp 12', N'Lớp 12', N'Cày lý thuyết este, polime, kim loại, bắt bài các dạng bài tập phân hóa thi tốt nghiệp.', 200000, 'active'),
('sub039', N'Toán 12 VIP - Mục Tiêu 8+, 9+', N'Lớp 12', N'Khóa học nâng cao do giáo viên lão làng đứng lớp, luyện đề form chuẩn của Bộ Giáo Dục.', 400000, 'active'),
('sub040', N'Ngữ Văn 12 - Nghị Luận Văn Học Thực Chiến', N'Lớp 12', N'Rèn tư duy viết văn sâu sắc, cam kết đạt điểm cao phần đọc hiểu và nghị luận văn học thi THPT.', 400000, 'active');

-- 3. Bơm danh sách gia sư Cấp 3
INSERT INTO tutor (id, name, email, birth, phone, address, specialization, description, id_card_number, bank_account_number, bank_name, account_id, evaluate, verified) VALUES
('tut025', N'Nguyễn Hoàng Đăng', 'sv.thukhoa.khoaa@gmail.com', '2006-01-20', '0981110001', N'Quận 5, TP.HCM', N'Sinh viên - Á Khoa Khối A 12', N'Sinh viên năm 2 ĐH Ngoại Thương, Á khoa khối A với 28.5 điểm thi THPT. Chuyên nhận dạy Toán 12 trắc nghiệm, mẹo giải nhanh.', 123456789051, 9501, 'Vietcombank', 'acc039', 5, 1),
('tut026', N'Bùi Xuân Bách', 'sv.chuyenly.bach@gmail.com', '2005-07-15', '0981110002', N'Thủ Đức, TP.HCM', N'Sinh viên - Vật Lý Khối 10,11', N'Sinh viên năm 3 ĐH Bách Khoa, cựu học sinh chuyên Vật lý. Chuyên dạy Vật lý lớp 10, lớp 11 từ cơ bản đến nâng cao.', 123456789052, 9502, 'TPBank', 'acc040', 4, 1),
('tut027', N'Nguyễn Nam Khánh', 'sv.ielts8.khanh@gmail.com', '2005-11-12', '0981110003', N'Quận 7, TP.HCM', N'Sinh viên - Luyện Thi IELTS Cấp Tốc', N'Sinh viên năm 3 ĐH Kinh Tế, đạt chứng chỉ IELTS 8.0. Có kinh nghiệm luyện đề IELTS cho học sinh cấp 3.', 123456789053, 9503, 'MB Bank', 'acc041', 5, 1),
('tut028', N'Thầy Trần Minh Hải', 'gv.sptoan.hai@gmail.com', '2002-03-14', '0981110004', N'Tân Phú, TP.HCM', N'Giáo viên - Sư phạm Toán 10,11', N'Mới tốt nghiệp ĐH Sư Phạm Khoa Toán. Nhận dạy Toán lớp 10, lớp 11 bám sát tư duy hình học không gian mindmap.', 123456789054, 9504, 'ACB', 'acc042', 4, 1),
('tut029', N'Cô Lê Quỳnh Chi', 'gv.tudo.gpa.chi@gmail.com', '1998-09-18', '0981110005', N'Quận 10, TP.HCM', N'Giáo viên tự do - Toán Văn 11 GPA', N'Giáo viên tự do chuyên môn Ngữ Văn Cấp 3. Nhận mở lớp thong thả bám sát 100% SGK trường công cho khối 11.', 123456789055, 9505, 'VietinBank', 'acc043', 0, 1),
('tut030', N'Thầy Nguyễn Quang Minh', 'gv.thpt.minh.toan12@gmail.com', '1976-04-12', '0981110006', N'Quận 3, TP.HCM', N'Giáo viên THPT - Chuyên Ôn Thi 12', N'Giáo viên trường THPT chuyên điểm danh tiếng. Trên 20 năm thâm niên luyện thi tốt nghiệp THPT Quốc Gia mục tiêu 9+.', 123456789056, 9506, 'Vietcombank', 'acc044', 5, 1),
('tut031', N'Cô Hoàng Thúy Lan', 'gv.thpt.lan.van12@gmail.com', '1982-10-30', '0981110007', N'Bình Thạnh, TP.HCM', N'Giáo viên THPT - Chuyên Ngữ Văn 12', N'Giáo viên trường công lập THPT danh tiếng tại TP.HCM. Chuyên luyện viết văn Nghị luận văn học khối 12 nước rút.', 123456789057, 9507, 'BIDV', 'acc045', 5, 1),
('tut032', N'Thầy Phạm Minh Đức', 'gv.thpt.duc.ly11@gmail.com', '1985-02-15', '0981110008', N'Quận 10, TP.HCM', N'Giáo viên THPT - Vật Lý 11 Trường Công', N'Giáo viên đứng lớp bộ môn Vật lý trường THPT công lập. Buổi tối mở lớp bổ trợ kiến thức bám sát đề thi trường.', 123456789058, 9508, 'Sacombank', 'acc046', 5, 1);

-- Thiết lập tên tệp ảnh đại diện tương thích cho khối Cấp 3 mới thêm
UPDATE tutor SET avatar = 'tut025.png' WHERE id = 'tut025';
UPDATE tutor SET avatar = 'tut026.png' WHERE id = 'tut026';
UPDATE tutor SET avatar = 'tut027.png' WHERE id = 'tut027';
UPDATE tutor SET avatar = 'tut028.png' WHERE id = 'tut028';
UPDATE tutor SET avatar = 'tut029.png' WHERE id = 'tut029';
UPDATE tutor SET avatar = 'tut030.png' WHERE id = 'tut030';
UPDATE tutor SET avatar = 'tut031.png' WHERE id = 'tut031';
UPDATE tutor SET avatar = 'tut032.png' WHERE id = 'tut032';

-- 4. Bơm Phụ huynh & Học sinh Cấp 3 mới
INSERT INTO student (id, name, phone, address, birth, description, account_id) VALUES
('st015', N'Nguyễn Hoài Bảo Nam', '0945678001', N'Tân Phú, TP.HCM', '2009-08-14', N'Học sinh Lớp 11 bám sát phương thức xét học bạ sớm, cần giữ vững điểm số GPA môn Ngữ Văn luôn đạt trên 8.5.', 'acc047'),
('st016', N'Lê Kim Linh Đan', '0945678002', N'Quận 7, TP.HCM', '2009-03-22', N'Học sinh Lớp 11 tự lên sàn tìm lớp cày IELTS cấp tốc để được miễn thi tốt nghiệp môn Anh và xét tuyển thẳng.', 'acc048'),
('st017', N'Trần Nguyễn Gia Huy', '0945678003', N'Quận 3, TP.HCM', '2008-11-02', N'Học sinh Lớp 12 nước rút, học lực trung bình khá, cần tìm thầy cô lão làng trường công cày đề Toán thực chiến.', 'acc049');

-- 5. Bơm Khóa học / Lớp học Cấp 3 mới
INSERT INTO course (id, subject_id, tutor_id, time) VALUES
('course027', 'sub037', 'tut025', '2026-07-01 19:30:00'),
('course028', 'sub033', 'tut026', '2026-07-02 18:00:00'),
('course029', 'sub036', 'tut027', '2026-07-01 17:30:00'),
('course030', 'sub034', 'tut028', '2026-07-03 19:00:00'),
('course031', 'sub035', 'tut029', '2026-07-02 18:00:00'),
('course032', 'sub039', 'tut030', '2026-07-01 19:00:00'),
('course033', 'sub040', 'tut031', '2026-07-02 19:30:00'),
('course034', 'sub034', 'tut032', '2026-07-01 20:00:00');

-- 6. Bơm Giao dịch thương mại giả lập Cấp 3 mới
INSERT INTO registered_subjects (course_id, student_id, registration_date, number_of_lessons, status) VALUES
('course032', 'st017', '2026-06-25', 20, 'registered'),
('course031', 'st015', '2026-05-01', 10, 'completed'),
('course029', 'st016', '2026-06-28', 16, 'pending_payment');

INSERT INTO booking (id, course_id, tutor_id, student_id, booking_time, status, note) VALUES
('bk011', 'course032', 'tut030', 'st017', '2026-07-01 19:00:00', 'confirmed', N'Luyện thi tốt nghiệp THPT Quốc Gia môn Toán nước rút mục tiêu 9+.'),
('bk012', 'course031', 'tut029', 'st015', '2026-05-02 18:00:00', 'confirmed', N'Học bám sát chương trình trường giữ vững điểm GPA học bạ Văn.'),
('bk013', 'course029', 'tut027', 'st016', '2026-07-01 17:30:00', 'pending', N'Học viên lớp 11 cần luyện chiến thuật làm bài IELTS Đọc và Nghe.');

INSERT INTO payment (id, course_id, tutor_id, student_id, amount, payment_date, payment_method, status) VALUES
('pay008', 'course032', 'tut030', 'st017', 8000000, '2026-06-25 15:30:00', 'bank_transfer', 'completed'),
('pay009', 'course031', 'tut029', 'st015', 2200000, '2026-05-01 09:15:00', 'bank_transfer', 'completed');

INSERT INTO review (id, tutor_id, student_id, course_id, rating, comment) VALUES
('rev007', 'tut029', 'st015', 'course031', 5, N'Cô giảng bài rất mộc mạc, dễ hiểu, bám sát bài kiểm tra trên trường. Điểm học bạ môn Văn của con giữ vững mức 8.8.');