package controller;

import dao.PromotionSuggestionDAO;
import model.PromotionSuggestion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/staff-promotions")
public class StaffPromotionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Tạm thời hardcode userId (nếu cần test)
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            userId = 22; // test cứng hoặc redirect về login
        }

        PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
        List<PromotionSuggestion> list = dao.getSuggestionsByUser(userId);

        req.setAttribute("suggestions", list);
        req.getRequestDispatcher("/page/staff/PromotionSuggestion.jsp").forward(req, resp);
    }

    // fallback nếu dùng POST
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
