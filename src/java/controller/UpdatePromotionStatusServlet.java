package controller;

import dao.PromotionSuggestionDAO;
import model.PromotionSuggestion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-promotion-status")
public class UpdatePromotionStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String reply = request.getParameter("reply");

        PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
        dao.updateStatusAndReply(id, status, reply);

        response.sendRedirect(request.getContextPath() + "/promotion-detail?id=" + id);
    }
}
