package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;
import java.util.stream.Collectors;

public class UserListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
        int page = 1;
        int recordsPerPage = 15;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        UserDAO userDAO = new UserDAO();
        int totalRecords = userDAO.countAllUsers();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        int offset = (page - 1) * recordsPerPage;

        List<User> users = userDAO.getUsersByPage(offset, recordsPerPage);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/UserList.jsp");
        dispatcher.forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Có lỗi khi xử lý danh sách người dùng.");
    }
}

}