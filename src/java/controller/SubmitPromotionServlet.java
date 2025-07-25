package controller;

import dao.PromotionSuggestionDAO;
import model.PromotionSuggestion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;


import dao.PromotionSuggestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.PromotionSuggestion;

@WebServlet("/submit-promotion")
public class SubmitPromotionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        System.out.println("SubmitPromotionServlet called");

        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            System.out.println("Session không có userId");
            userId = 22; // test cứng
        }

        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String reason = req.getParameter("reason");
        String startDateStr = req.getParameter("startDate");
        String endDateStr = req.getParameter("endDate");

        try {
            PromotionSuggestion suggestion = new PromotionSuggestion();
            suggestion.setUserId(userId);
            suggestion.setTitle(title);
            suggestion.setContent(content);
            suggestion.setReason(reason);
            suggestion.setStartDate(Date.valueOf(startDateStr));
            suggestion.setEndDate(Date.valueOf(endDateStr));
            suggestion.setStatus("Chờ duyệt");

            PromotionSuggestionDAO dao = new PromotionSuggestionDAO();
            dao.insertSuggestion(suggestion);

            System.out.println("Insert success, redirecting...");
            resp.sendRedirect("staff-promotions");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Có lỗi xảy ra khi xử lý form: " + e.getMessage());
        }
    }
}

