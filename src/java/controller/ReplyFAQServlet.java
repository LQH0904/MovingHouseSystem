package controller;

import dao.FAQQuestionDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.FAQQuestion;
import utils.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/reply-faq")
public class ReplyFAQServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int faqId = Integer.parseInt(request.getParameter("faqId"));
        String reply = request.getParameter("reply").trim();

        // Lấy staffId từ session hoặc tạm thời gán cứng
        HttpSession session = request.getSession();
        int staffId = 22; // hoặc ((User) session.getAttribute("acc")).getUserId();

        // Validate độ dài
        if (reply.length() > 500) {
            response.sendRedirect("faq-list?error=reply-too-long");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            FAQQuestionDAO dao = new FAQQuestionDAO(conn);
            dao.replyToFAQ(faqId, reply, staffId);
        } catch (SQLException e) {
            e.printStackTrace();
            Logger.getLogger(ReplyFAQServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendRedirect("faq-list?error=db-error");
            return;
        }

        response.sendRedirect("staff/faq-list?success=1");

    }
}
