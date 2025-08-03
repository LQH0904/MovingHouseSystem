// controller/SubmitQuestionServlet.java
package controller;

import com.google.gson.Gson;
import dao.ChatbotLogDAO;
import dao.FAQQuestionDAO;
import model.ChatbotLog;
import model.Users;
import utils.DBConnection; // Import lớp kết nối DB của bạn

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;

// Đảm bảo annotation này chính xác
@WebServlet("/customer/submit-question")
public class SubmitQuestionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false); // false: không tạo session mới nếu chưa có
        if (session == null || session.getAttribute("acc") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Lỗi 401: Chưa đăng nhập
            response.getWriter().write("{\"error\": \"Người dùng chưa đăng nhập.\"}");
            return;
        }

        Users customer = (Users) session.getAttribute("acc");
        String message = request.getParameter("message");
        Connection conn = null;

        try {
            // LẤY KẾT NỐI DATABASE MỘT CÁCH AN TOÀN
            conn = DBConnection.getConnection();
            FAQQuestionDAO faqDAO = new FAQQuestionDAO(conn);
            ChatbotLogDAO logDAO = new ChatbotLogDAO(conn);

            // 1. Tìm câu trả lời tự động từ FAQ
            String reply = faqDAO.findAnswerByQuestion(message);
            if (reply == null || reply.trim().isEmpty()) {
                reply = "Cảm ơn bạn đã đặt câu hỏi. Chúng tôi đã ghi nhận và sẽ phản hồi trong thời gian sớm nhất.";
            }

            // 2. Tạo và lưu lại log chat
            ChatbotLog log = new ChatbotLog();
            log.setUserId(customer.getUserId());
            log.setMessage(message);
            log.setResponse(reply);
            log.setCreatedAt(new Date());
            logDAO.addLog(log);

            // 3. Gửi lại câu trả lời dưới dạng JSON cho JavaScript
            response.getWriter().write(new Gson().toJson(log));

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi đầy đủ ra log server để debug
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Lỗi 500
            response.getWriter().write("{\"error\": \"Lỗi phía server, không thể xử lý yêu cầu.\"}");
        } finally {
            // LUÔN LUÔN ĐÓNG KẾT NỐI
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}