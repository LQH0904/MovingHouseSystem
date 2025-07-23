package controller;

import dao.FAQQuestionDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.DBConnection;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/review-faq")
public class ReviewFAQServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int faqId = Integer.parseInt(request.getParameter("faqId"));
        String review = request.getParameter("review").trim();

        if (review.length() > 500) {
            response.sendRedirect("operator/faq-review?error=too-long");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            FAQQuestionDAO dao = new FAQQuestionDAO(conn);
            dao.updateReview(faqId, review);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("operator/faq-review?error=fail");
            return;
        }

        response.sendRedirect("operator/faq-review?success=1");
    }
}
