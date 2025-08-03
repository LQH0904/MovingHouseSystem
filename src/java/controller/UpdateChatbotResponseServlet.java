// controller/UpdateChatbotResponseServlet.java (PHIÊN BẢN HOÀN CHỈNH)
package controller;

import dao.ChatbotLogDAO;
import utils.DBConnection; // Đảm bảo bạn đã import lớp kết nối DB

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

// Đảm bảo annotation này chính xác 100%
@WebServlet("/staff/update-chatbot-response")
public class UpdateChatbotResponseServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Connection conn = null; 
        try {
            int logId = Integer.parseInt(request.getParameter("logId"));
            String newResponse = request.getParameter("response");

            // Lấy kết nối DB một cách an toàn
            conn = DBConnection.getConnection(); 
            ChatbotLogDAO dao = new ChatbotLogDAO(conn);
            boolean success = dao.updateResponse(logId, newResponse);

            if (success) {
                // Nếu thành công, trả về JSON status success
                response.getWriter().write("{\"status\": \"success\"}");
            } else {
                // Nếu không thành công (không có dòng nào được cập nhật)
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Không tìm thấy log ID để cập nhật.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra log server để debug
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Lỗi server: " + e.getMessage() + "\"}");
        } finally {
            // Luôn đóng connection
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