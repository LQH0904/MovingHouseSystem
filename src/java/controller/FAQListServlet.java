// controller/FAQListServlet.java
package controller;

import dao.FAQQuestionDAO;
import model.FAQQuestion;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/faq-list")
public class FAQListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            FAQQuestionDAO dao = new FAQQuestionDAO(DBConnection.getConnection());
            List<FAQQuestion> faqs = dao.getAllQuestions();
            req.setAttribute("faqs", faqs);
            req.getRequestDispatcher("/page/staff/FAQList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi lấy dữ liệu FAQ");
        }
    }
}
