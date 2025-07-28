package controller;

import dao.PromotionSuggestionDAO;
import model.PromotionSuggestion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/promotion-review")
public class PromotionReviewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy danh sách tất cả các gợi ý khuyến mãi
        PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
        List<PromotionSuggestion> list = dao.getAllSuggestions();

        // Truyền dữ liệu sang JSP
        req.setAttribute("suggestions", list);

        // Chuyển hướng tới trang JSP của operator
        req.getRequestDispatcher("/page/operator/PromotionReviewList.jsp").forward(req, resp);
    }
}
