// controller/ChatbotLogServlet.java
package controller;

import dao.ChatbotLogDAO;
import model.ChatbotLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import utils.DBConnection;

@WebServlet("/staff/chat-bot-log")
public class ChatbotLogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            ChatbotLogDAO dao = new ChatbotLogDAO(conn);
            List<ChatbotLog> logs = dao.getAllLogsWithUserName();
            request.setAttribute("logList", logs);
            request.getRequestDispatcher("/page/staff/chatBotLog.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi server");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            ChatbotLogDAO dao = new ChatbotLogDAO(conn);

            if ("update".equals(action)) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                String reply = request.getParameter("reply");
                // Có thể lấy staffId từ session nếu cần ghi nhận
                dao.updateReply(logId, reply, 0);
            } else if ("delete".equals(action)) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                dao.deleteLog(logId);
            }

            response.sendRedirect(request.getContextPath() + "/staff/chat-bot-log");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý dữ liệu");
        }
    }
}
