package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class CustomerListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<User> allUsers = null;
        try {
            allUsers = userDAO.getAllUsers();
        } catch (SQLException ex) {
            Logger.getLogger(CustomerListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Lọc chỉ những user có roleId = 6 (Customer)
        List<User> customers = allUsers.stream()
                                       .filter(user -> user.getRole().getRoleId() == 6)
                                       .collect(Collectors.toList());

        request.setAttribute("users", customers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/page/staff/CustomerList.jsp");
        dispatcher.forward(request, response);
    }
}
