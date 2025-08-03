// controller/DeleteFAQServlet.java
package controller;

import dao.FAQQuestionDAO;
import model.Users;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/staff/delete-faq")
public class DeleteFAQServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Bước 1: Kiểm tra quyền truy cập, đảm bảo chỉ staff mới được xóa
        Users loggedInUser = null;
        if (session != null) {
            loggedInUser = (Users) session.getAttribute("acc");
        }

        if (loggedInUser == null || loggedInUser.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Bước 2: Lấy ID của câu hỏi từ form
        int faqId = 0;
        try {
            faqId = Integer.parseInt(request.getParameter("faqId"));
        } catch (NumberFormatException e) {
            // Nếu ID không phải là số, không làm gì và quay về trang list
            response.sendRedirect(request.getContextPath() + "/staff/faq-list");
            return;
        }

        // Bước 3: Gọi DAO để xóa
        if (faqId > 0) {
            try (var conn = DBConnection.getConnection()) {
                FAQQuestionDAO dao = new FAQQuestionDAO(conn);
                dao.deleteQuestion(faqId);
            } catch (Exception e) {
                e.printStackTrace();
                // Nếu có lỗi, có thể lưu thông báo lỗi vào session để hiển thị
                session.setAttribute("errorMessage", "Lỗi khi xóa câu hỏi: " + e.getMessage());
            }
        }

        // Bước 4: Chuyển hướng về trang danh sách
        response.sendRedirect(request.getContextPath() + "/staff/faq-list");
    }
}