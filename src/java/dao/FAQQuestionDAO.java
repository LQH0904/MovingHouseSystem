package dao;

import model.FAQQuestion;
import java.sql.*;
import java.util.*;

public class FAQQuestionDAO {

    private Connection conn;

    // Constructor: truyền connection từ ngoài
    public FAQQuestionDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy toàn bộ danh sách câu hỏi
    public List<FAQQuestion> getAllQuestions() throws SQLException {
        List<FAQQuestion> list = new ArrayList<>();
        String sql = "SELECT faq_id, question, reply, review FROM FAQQuestions";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                FAQQuestion q = new FAQQuestion();
                q.setFaqId(rs.getInt("faq_id"));
                q.setQuestion(rs.getString("question"));
                q.setReply(rs.getString("reply"));
                q.setReview(rs.getString("review"));
                list.add(q);
            }
        }
        return list;
    }

    // Trả lời câu hỏi (staff)
    public void replyToFAQ(int faqId, String reply, int staffId) throws SQLException {
        String sql = "UPDATE FAQQuestions SET reply = ?, staff_id = ?, updated_at = GETDATE() WHERE faq_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, staffId);
            ps.setInt(3, faqId);
            ps.executeUpdate();
        }
    }

    // (Optional) đánh giá từ operator nếu muốn mở rộng
    public void updateReview(int faqId, String review) throws SQLException {
        String sql = "UPDATE FAQQuestions SET review = ?, updated_at = GETDATE() WHERE faq_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review);
            ps.setInt(2, faqId);
            ps.executeUpdate();
        }
    }

    public void addQuestionByStaff(FAQQuestion faq) throws SQLException {
        String sql = "INSERT INTO FAQQuestions (log_id, question, customer_id, staff_id, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            // Nếu logId không hợp lệ (<=0), chèn NULL. Ngược lại chèn giá trị đó.
            if (faq.getLogId() > 0) {
                ps.setInt(1, faq.getLogId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER); // Chèn giá trị NULL
            }

            ps.setString(2, faq.getQuestion());

            // Tương tự với customerId
            if (faq.getCustomerId() > 0) {
                ps.setInt(3, faq.getCustomerId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER); // Chèn giá trị NULL
            }

            if (faq.getStaffId() > 0) {
                ps.setInt(4, faq.getStaffId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();
        }
    }
public void deleteQuestion(int faqId) throws SQLException {
    String sql = "DELETE FROM FAQQuestions WHERE faq_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, faqId);
        ps.executeUpdate();
    }
}
}
