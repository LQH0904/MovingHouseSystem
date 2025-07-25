package controller;

import dao.TransportUnitDAO;
import dao.StorageUnitDAO;
import dao.UserDAO;
import model.TransportUnit;
import model.StorageUnit;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DetailUserServlet")
public class DetailUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        UserDAO userDAO = new UserDAO();

        try {
            User user = userDAO.getUserById(userId);

            if (user == null || user.getRole().getRoleId() == 1) {
                request.setAttribute("error", "Không thể xem chi tiết Admin.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int roleId = user.getRole().getRoleId();

            if (roleId == 2 || roleId == 3 || roleId == 6) {
                request.setAttribute("user", user);
            } else if (roleId == 4) {
                TransportUnitDAO tDao = new TransportUnitDAO();
                TransportUnit unit = tDao.getByUserId(userId);
                request.setAttribute("transportUnit", unit);
            } else if (roleId == 5) {
                StorageUnitDAO sDao = new StorageUnitDAO();
                StorageUnit unit = sDao.getByUserId(userId);
                request.setAttribute("storageUnit", unit);
            }

            request.setAttribute("roleId", roleId);
            request.getRequestDispatcher("/page/operator/UserDetail.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
