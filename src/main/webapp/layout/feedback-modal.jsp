<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    /* Modal Core CSS */
    .feedback-modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(15, 23, 42, 0.6); z-index: 9999;
        display: none; align-items: center; justify-content: center;
        opacity: 0; transition: opacity 0.3s ease;
    }
    .feedback-modal-overlay.active { display: flex; opacity: 1; }
    .feedback-modal-box {
        background: #fff; border-radius: 1rem; width: 90%; max-width: 500px;
        padding: 2rem; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        transform: translateY(-20px); transition: transform 0.3s ease; position: relative;
    }
    .feedback-modal-overlay.active .feedback-modal-box { transform: translateY(0); }
    .feedback-close-btn { position: absolute; top: 1rem; right: 1.5rem; font-size: 1.5rem; color: #64748b; cursor: pointer; }
    .feedback-close-btn:hover { color: #ef4444; }

    .feedback-tabs { display: flex; gap: 1rem; margin-bottom: 1.5rem; border-bottom: 2px solid #e2e8f0; }
    .feedback-tab { padding: 0.5rem 1rem; cursor: pointer; color: #64748b; font-weight: 500; padding-bottom: 0.75rem; margin-bottom: -2px; }
    .feedback-tab.active { color: #10b981; border-bottom: 2px solid #10b981; }

    .fb-form-group { margin-bottom: 1.25rem; }
    .fb-form-group label { display: block; font-weight: 500; margin-bottom: 0.5rem; color: #334155; font-size: 0.95rem; }
    .fb-input { width: 100%; padding: 0.75rem; border: 1px solid #cbd5e1; border-radius: 0.5rem; font-family: inherit; font-size: 0.95rem; box-sizing: border-box; }
    .fb-input:focus { outline: none; border-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15); }

    .feedback-panel { display: none; }
    .feedback-panel.active { display: block; }

    .fb-btn-submit { width: 100%; padding: 0.75rem; background: #10b981; color: white; border: none; border-radius: 0.5rem; font-weight: 600; font-size: 1rem; cursor: pointer; transition: background 0.2s; }
    .fb-btn-submit:hover { background: #059669; }

    /* --- FIX TRIỆT ĐỂ: CSS DÀN NGANG VÀ ĐỔI MÀU SAO ĐÁNH GIÁ --- */
    .fb-stars-wrapper {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
        gap: 0.25rem;
        margin-top: 0.25rem;
        margin-bottom: 0.5rem;
    }
    .fb-stars-wrapper input[type="radio"] {
        display: none; /* Ẩn radio button thô kệch đi */
    }
    .fb-stars-wrapper label {
        font-size: 2rem; /* Phóng to kích thước sao */
        color: #cbd5e1; /* Màu xám mặc định khi chưa chọn */
        cursor: pointer;
        transition: color 0.2s ease;
        margin: 0 !important;
        padding: 0 0.1rem;
        display: inline-block;
    }
    /* Hiệu ứng sáng vàng từ trái qua phải khi chọn hoặc hover chuột */
    .fb-stars-wrapper input[type="radio"]:checked ~ label,
    .fb-stars-wrapper label:hover,
    .fb-stars-wrapper label:hover ~ label {
        color: #fbbf24; /* Màu vàng hoàng kim sang xịn mịn */
    }
</style>

<div class="feedback-modal-overlay" id="feedbackModal">
    <div class="feedback-modal-box">
        <span class="feedback-close-btn" onclick="closeFeedbackModal()">&times;</span>
        <h2 style="margin-top: 0; margin-bottom: 0.75rem; font-size: 1.2rem; color: #1e293b;">
            Phản hồi Gia sư: <span id="fbTutorName" style="color:#10b981; font-weight: 600;"></span>
        </h2>

        <div class="feedback-tabs">
            <div class="feedback-tab active" onclick="switchFbTab('review', this)">Đánh giá công khai</div>
            <div class="feedback-tab" onclick="switchFbTab('complaint', this)">Khiếu nại (Ẩn)</div>
        </div>

        <form id="feedbackForm" method="POST" action="${pageContext.request.contextPath}/review">
            <input type="hidden" id="fbType" name="type" value="review">
            <input type="hidden" id="fbBookingId" name="bookingId" value="">
            <input type="hidden" id="fbStudentId" name="studentId" value="">
            <input type="hidden" id="fbTutorId" name="tutorId" value="">
            <input type="hidden" id="fbCourseId" name="courseId" value="">

            <div id="panel-review" class="feedback-panel active">
                <div class="fb-form-group">
                    <label>Chất lượng giảng dạy (Chọn số sao)</label>
                    <div class="fb-stars-wrapper">
                        <input type="radio" id="star5" name="rating" value="5" checked>
                        <label for="star5" title="5 sao - Xuất sắc">&#9733;</label>

                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4" title="4 sao - Tốt">&#9733;</label>

                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3" title="3 sao - Bình thường">&#9733;</label>

                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2" title="2 sao - Yếu">&#9733;</label>

                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1" title="1 sao - Tệ">&#9733;</label>
                    </div>
                </div>
                <div class="fb-form-group">
                    <label>Bình luận chi tiết</label>
                    <textarea name="comment" id="fbComment" class="fb-input" rows="4" placeholder="Chia sẻ trải nghiệm học tập của bạn với gia sư này..." required></textarea>
                </div>
            </div>

            <div id="panel-complaint" class="feedback-panel">
                <p style="font-size: 0.85rem; color: #ef4444; margin-top: 0; margin-bottom: 1rem; line-height: 1.4;">
                    * Lưu ý: Nội dung khiếu nại này sẽ được gửi ẩn danh và xử lý trực tiếp bởi Ban Quản Trị hệ thống, không hiển thị công khai công chúng.
                </p>
                <div class="fb-form-group">
                    <label>Tiêu đề khiếu nại</label>
                    <input type="text" name="title" id="fbTitle" class="fb-input" placeholder="Ví dụ: Gia sư nghỉ dạy không báo trước...">
                </div>
                <div class="fb-form-group">
                    <label>Nội dung sự việc chi tiết</label>
                    <textarea name="description" id="fbDescription" class="fb-input" rows="4" placeholder="Mô tả cụ thể thời gian, diễn biến sự việc để admin hỗ trợ hoàn tiền hoặc xử lý..."></textarea>
                </div>
            </div>

            <button type="submit" class="fb-btn-submit" id="fbSubmitBtn">Gửi Đánh Giá</button>
        </form>
    </div>
</div>

<script>
    function openFeedbackModal(bookingId, studentId, tutorId, courseId, tutorName) {
        document.getElementById('fbBookingId').value = bookingId || '';
        document.getElementById('fbStudentId').value = studentId || '';
        document.getElementById('fbTutorId').value = tutorId || '';
        document.getElementById('fbCourseId').value = courseId || '';
        document.getElementById('fbTutorName').innerText = tutorName || '';

        // Reset form về trạng thái sạch ban đầu
        document.getElementById('feedbackForm').reset();

        // Mặc định luôn mở tab review trước
        switchFbTab('review', document.querySelectorAll('.feedback-tab')[0]);
        document.getElementById('feedbackModal').classList.add('active');
    }

    function closeFeedbackModal() {
        document.getElementById('feedbackModal').classList.remove('active');
    }

    function switchFbTab(type, element) {
        document.getElementById('fbType').value = type;
        const tabs = document.querySelectorAll('.feedback-tab');
        tabs.forEach(t => t.classList.remove('active'));
        if(element) element.classList.add('active');

        document.getElementById('panel-review').style.display = (type === 'review') ? 'block' : 'none';
        document.getElementById('panel-complaint').style.display = (type === 'complaint') ? 'block' : 'none';

        const form = document.getElementById('feedbackForm');
        const btn = document.getElementById('fbSubmitBtn');
        const titleInput = document.getElementById('fbTitle');
        const descInput = document.getElementById('fbDescription');
        const commentInput = document.getElementById('fbComment');

        if (type === 'review') {
            form.action = '${pageContext.request.contextPath}/review';
            btn.innerText = 'Gửi Đánh Giá';
            titleInput.required = false;
            descInput.required = false;
            commentInput.required = true;
        } else {
            form.action = '${pageContext.request.contextPath}/complaint';
            btn.innerText = 'Gửi Khiếu Nại';
            titleInput.required = true;
            descInput.required = true;
            commentInput.required = false;
        }
    }
</script>