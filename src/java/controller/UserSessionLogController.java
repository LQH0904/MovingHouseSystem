package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/session-logs")
public class UserSessionLogController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        // Không cần setAttribute vì bạn dùng trực tiếp SessionTracker.sessionLogs trong JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/page/admin/login-history.jsp");
        dispatcher.forward(request, response);
    }
}
