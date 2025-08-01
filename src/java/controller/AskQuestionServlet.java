package controller;

import dao.ChatbotLogDAO;
import dao.FAQQuestionDAO;
import model.FAQQuestion;
import utils.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/customer/faq")
public class AskQuestionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            FAQQuestionDAO faqDAO = new FAQQuestionDAO(conn);
            List<FAQQuestion> faqList = faqDAO.getAllQuestions();
            request.setAttribute("faqList", faqList);
            request.getRequestDispatcher("/page/customer/FAQ.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Không thể tải câu hỏi thường gặp.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = request.getParameter("question");

        HttpSession session = request.getSession(false);
        Integer userId = (session != null && session.getAttribute("userId") != null)
                ? (Integer) session.getAttribute("userId") : null;

        if (userId == null || message == null || message.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/faq");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            ChatbotLogDAO logDAO = new ChatbotLogDAO(conn);
            logDAO.insertLog(userId, message.trim());
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/customer/faq");
    }
}
