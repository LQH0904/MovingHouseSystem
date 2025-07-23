package controller;

import dao.PromotionSuggestionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/submit-review")
public class PromotionReviewSubmitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status");
            String reply = req.getParameter("reply");

            PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
            dao.updateReview(id, status, reply);

            // ✅ Redirect về trang danh sách sau khi gửi đánh giá
            resp.sendRedirect(req.getContextPath() + "/promotion-review");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp");
        }
    }
}
