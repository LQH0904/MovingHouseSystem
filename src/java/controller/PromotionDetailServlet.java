package controller;

import dao.PromotionSuggestionDAO;
import dao.UserDAO;
import model.PromotionSuggestion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet("/promotion-detail")
public class PromotionDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
        PromotionSuggestion suggestion = dao.getSuggestionById(id);
        UserDAO userDAO = new UserDAO(); // thêm dòng này
        User user = userDAO.getUserById(suggestion.getUserId());
suggestion.setUser(user); // thêm dòng này
        req.setAttribute("suggestion", suggestion);
        req.getRequestDispatcher("/page/operator/PromotionDetail.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String reply = req.getParameter("reply");

        PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
        dao.updateReply(id, reply);

        resp.sendRedirect("promotion-review");
    }
}