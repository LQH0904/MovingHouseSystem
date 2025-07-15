package controller;

import dao.UserDAOStaff;
import dao.StaffDAO;
import model.UserStaff;
import model.Staff;
import utils.HashUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import model.Users;

@WebServlet("/updateProfile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        HttpSession session = request.getSession();
        Users user1 = (Users) session.getAttribute("acc");

        if (user1 == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id parameter");
            return;
        }

        int id = user1.getUserId();

        try {
            if ("staff".equals(type)) {
                StaffDAO dao = new StaffDAO();
                Staff staff = dao.getStaffById(id);
                request.setAttribute("staff", staff);
            } else {
                UserDAOStaff dao = new UserDAOStaff();
                UserStaff user = dao.getUserById(id);
                request.setAttribute("user", user);
            }
            request.setAttribute("type", type);
            request.getRequestDispatcher("/page/staff/updateProfile.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id parameter");
            return;
        }

        int id = Integer.parseInt(idStr);

        try {
            String avatarUrl = null;
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
                avatarUrl = "uploads/" + fileName;
            }

            if ("staff".equals(type)) {
                String fullName = request.getParameter("fullName");
                String department = request.getParameter("department");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String status = request.getParameter("status");
                String address = request.getParameter("address");
                String currentAvatar = request.getParameter("currentAvatar");
                if (avatarUrl == null) avatarUrl = currentAvatar;

                Staff staff = new Staff(id, fullName, department, avatarUrl, status, email, phone, address);
                StaffDAO dao = new StaffDAO();
                dao.updateStaff(staff);
                response.sendRedirect("updateProfile?success=1&type=staff");
            } else {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String status = request.getParameter("status");
                String currentAvatar = request.getParameter("currentAvatar");
                if (avatarUrl == null) avatarUrl = currentAvatar;

                UserDAOStaff dao = new UserDAOStaff();
                UserStaff user = new UserStaff(id, username, email, status, avatarUrl, phone, address);
                dao.updateUser(user);

                String oldPass = request.getParameter("oldPassword");
                String newPass = request.getParameter("newPassword");
                String confirmPass = request.getParameter("confirmPassword");

                if (oldPass != null && !oldPass.isEmpty() && newPass != null && !newPass.isEmpty() && confirmPass != null && !confirmPass.isEmpty()) {
                    String currentHashedPass = dao.getPasswordHashById(id);
                    if (!HashUtil.checkPassword(oldPass, currentHashedPass)) {
                        response.sendRedirect("updateProfile?type=user&error=wrongOldPass");
                        return;
                    }
                    if (!newPass.equals(confirmPass)) {
                        response.sendRedirect("updateProfile?type=user&error=notMatch");
                        return;
                    }
                    String hashed = HashUtil.hashPassword(newPass);
                    dao.updatePassword(id, hashed);
                }
                response.sendRedirect("updateProfile?success=1&type=user");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
