/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PasswordUtils;

@WebServlet(name = "ConfirmPassServlet", urlPatterns = {"/confirmpass"})
public class ConfirmPassServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ConfirmPassServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetUsername");
        Integer roleId = (Integer) session.getAttribute("resetRoleId");

        if (email == null || roleId == null) {
            request.setAttribute("message", "Phiên đã hết hạn. Vui lòng bắt đầu lại.");
            request.setAttribute("step", "enterEmail");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            return;
        }

        request.setAttribute("resetUsername", email);
        request.setAttribute("resetRoleId", roleId);
        request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetUsername");
        Integer roleId = (Integer) session.getAttribute("resetRoleId");

        if (email == null || roleId == null) {
            request.setAttribute("message", "Phiên đã hết hạn. Vui lòng bắt đầu lại.");
            request.setAttribute("step", "enterEmail");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            return;
        }

        String newPass = request.getParameter("password");
        String cfNewPass = request.getParameter("cfpassword");

        UserDAO dao = UserDAO.INSTANCE;
        Users user = dao.getUser(email, roleId);

        if (user == null) {
            request.setAttribute("error", "Tài khoản không tồn tại");
            request.setAttribute("resetUsername", email);
            request.setAttribute("resetRoleId", roleId);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        if (!newPass.equals(cfNewPass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("resetUsername", email);
            request.setAttribute("resetRoleId", roleId);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        if (newPass.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.setAttribute("resetUsername", email);
            request.setAttribute("resetRoleId", roleId);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(newPass);
        boolean updated = dao.updatePassByEmail(hashedPassword, email, roleId);

        if (updated) {
            session.removeAttribute("resetUsername");
            session.removeAttribute("resetRoleId");
            request.setAttribute("mess", "Thay đổi mật khẩu thành công!");
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không thể thay đổi mật khẩu!");
            request.setAttribute("resetUsername", email);
            request.setAttribute("resetRoleId", roleId);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Confirm Password Servlet";
    }
}
