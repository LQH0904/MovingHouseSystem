package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.OperationPolicy;
import dao.OperationPolicyDAO;
import java.util.List;

@WebServlet("/operation-policy")
public class OperationPolicyServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OperationPolicyDAO dao = new OperationPolicyDAO();
        List<OperationPolicy> policies = dao.getAllPolicies();

        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/page/operator/OperationalPolicies.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String content = request.getParameter("content");
        OperationPolicyDAO dao = new OperationPolicyDAO();
        dao.updatePolicy(content);
        response.sendRedirect("policy");
    }
}
