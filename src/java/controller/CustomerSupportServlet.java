// controller/CustomerSupportServlet.java
package controller;

import dao.ChatbotLogDAO;
import dao.FAQQuestionDAO;
import model.ChatbotLog;
import model.FAQQuestion;
import model.Users;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/customer/ask-question")
public class CustomerSupportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users customer = (Users) session.getAttribute("acc");

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            FAQQuestionDAO faqDAO = new FAQQuestionDAO(conn);
            ChatbotLogDAO logDAO = new ChatbotLogDAO(conn);

            // Lấy danh sách câu hỏi thường gặp
            List<FAQQuestion> faqList = faqDAO.getAllQuestions();

            // Lấy lịch sử chat của khách hàng
            List<ChatbotLog> chatHistory = logDAO.getLogsByUserId(customer.getUserId());

            request.setAttribute("faqList", faqList);
            request.setAttribute("chatHistory", chatHistory);

            request.getRequestDispatcher("/AskQuestion.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi
        } finally {
            if (conn != null) try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
