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
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

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
    
}
