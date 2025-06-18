package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.FeeConfiguration;
import dao.FeeConfigurationDAO;

@WebServlet("/config-fee")
public class FeeConfigurationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        FeeConfiguration config = dao.getFeeConfiguration();

        request.setAttribute("feeConfig", config);
        request.getRequestDispatcher("/page/operator/ConfigFees.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String content = request.getParameter("content");
        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        dao.updateFeeConfiguration(content);
        response.sendRedirect("fee");
    }
}
