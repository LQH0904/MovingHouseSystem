/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.FAQQuestionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.FAQQuestion;
import utils.DBConnection;

/**
 *
 * @author admin
 */
@WebServlet("/operator/faq-review")
public class FAQReviewListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            FAQQuestionDAO dao = new FAQQuestionDAO(DBConnection.getConnection());
            List<FAQQuestion> faqs = dao.getAllQuestions();
            req.setAttribute("faqs", faqs);
            req.getRequestDispatcher("/page/operator/FAQReview.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi lấy danh sách câu hỏi");
        }
    }
}
