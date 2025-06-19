/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.PasswordUtils;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ConfirmPassServlet", urlPatterns = {"/confirmpass"})
public class ConfirmPassServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy username từ session để truyền ra JSP
        HttpSession session = request.getSession();
        String resetUsername = (String) session.getAttribute("resetUsername");

        if (resetUsername == null) {
            // Chưa có username reset -> chuyển về trang reset code hoặc login
            response.sendRedirect("resetcode.jsp");
            return;
        }
        request.setAttribute("resetUsername", resetUsername);
        request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetUsername = (String) session.getAttribute("resetUsername");
        if (resetUsername == null) {
            request.setAttribute("error", "Session expired. Please start over.");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            return;
        }
        String newpass = request.getParameter("password");
        String cfnewpass = request.getParameter("cfpassword");
        String msg;

        UserDAO dao = new UserDAO();
        Users user = dao.getUserByEmail(resetUsername);

        if (user == null) {
            msg = "User not found!";
            request.setAttribute("error", msg);
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        if (!newpass.equals(cfnewpass)) {
            msg = "Password confirmation does not match!";
            request.setAttribute("error", msg);
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        if (newpass.length() < 6) {
            msg = "Password must be at least 6 characters.";
            request.setAttribute("error", msg);
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(newpass);
        boolean updated = dao.updatePassByEmail(hashedPassword, resetUsername);
        if (updated) {
            msg = "Change password successfully!";
            session.removeAttribute("resetUsername");
            request.setAttribute("mess", msg);
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
        } else {
            msg = "Failed to change password!";
            request.setAttribute("error", msg);
            request.setAttribute("resetUsername", resetUsername);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
        }
    }

}
