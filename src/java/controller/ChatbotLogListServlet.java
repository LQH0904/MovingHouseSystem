// controller/ChatbotLogListServlet.java
package controller;

import dao.ChatbotLogDAO;
import model.ChatbotLog;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/chat-bot-log")
public class ChatbotLogListServlet extends HttpServlet {
    private static final int PAGE_SIZE = 15; // 15 mục mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ChatbotLogDAO dao = new ChatbotLogDAO(conn);

            // Xử lý phân trang
            String pageStr = request.getParameter("page");
            int currentPage = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

            int totalLogs = dao.getTotalLogCount();
            int totalPages = (int) Math.ceil((double) totalLogs / PAGE_SIZE);

            List<ChatbotLog> logs = dao.getLogsByPage(currentPage, PAGE_SIZE);

            request.setAttribute("logs", logs);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", PAGE_SIZE);

            request.getRequestDispatcher("/page/staff/ChatbotLogList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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