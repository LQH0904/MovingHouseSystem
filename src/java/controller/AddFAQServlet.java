// controller/AddFAQServlet.java (PHIÊN BẢN ĐÃ SỬA ĐÚNG)
package controller;

import dao.FAQQuestionDAO;
import model.FAQQuestion;
import model.Users; // THAY ĐỔI 1: Import đúng model Users của bạn
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/staff/add-faq")
public class AddFAQServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String questionText = request.getParameter("question");

        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới

        // THAY ĐỔI 2: Lấy đúng key "acc" và đúng kiểu "Users"
        Users loggedInUser = null;
        if (session != null) {
            loggedInUser = (Users) session.getAttribute("acc");
        }

        // THAY ĐỔI 3: Kiểm tra xem user có tồn tại và có phải là Staff (roleId = 3) không
        // Dựa theo LoginServlet, roleId của Staff là 3
        if (loggedInUser == null || loggedInUser.getRoleId() != 3) {
            // Nếu chưa đăng nhập hoặc không phải staff, chuyển hướng đến trang login
            response.sendRedirect(request.getContextPath() + "/login"); // THAY ĐỔI 4: Chuyển hướng đến servlet /login
            return;
        }

        if (questionText != null && !questionText.trim().isEmpty()) {
            try (var conn = DBConnection.getConnection()) {
                FAQQuestionDAO dao = new FAQQuestionDAO(conn);
                FAQQuestion newFaq = new FAQQuestion();
                newFaq.setQuestion(questionText);
                
                // THAY ĐỔI 5: Lấy ID của staff từ đối tượng Users đã đăng nhập
                newFaq.setStaffId(loggedInUser.getUserId()); 
                
                // Đặt giá trị mặc định cho log_id và customer_id vì staff tự tạo
                newFaq.setLogId(-1);
                newFaq.setCustomerId(-1);

                dao.addQuestionByStaff(newFaq);

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Lỗi khi tạo câu hỏi: " + e.getMessage());
            }
        } else {
            session.setAttribute("errorMessage", "Nội dung câu hỏi không được để trống.");
        }
        
        // Chuyển hướng trở lại trang danh sách FAQ
        response.sendRedirect(request.getContextPath() + "/staff/faq-list");
    }
}