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

        // ✅ In ra số bản ghi để kiểm tra
        System.out.println("Số lượng chính sách lấy được: " + policies.size());
        for (OperationPolicy p : policies) {
            System.out.println(p.getPolicyTitle() + " - " + p.getPolicyContent());
        }

        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/page/operator/OperationalPolicies.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int number = Integer.parseInt(request.getParameter("number")); // bạn cần thêm input hidden này từ form
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        OperationPolicy p = new OperationPolicy(id, number, title, content);

        OperationPolicyDAO dao = new OperationPolicyDAO();
        dao.updatePolicy(p);

        response.sendRedirect("operation-policy");
    }

}
