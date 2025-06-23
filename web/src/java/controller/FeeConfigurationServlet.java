package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import dao.FeeConfigurationDAO;
import model.FeeConfiguration;

@WebServlet("/config-fee")
public class FeeConfigurationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        List<FeeConfiguration> feeConfigs = dao.getAllFeeConfigurations();  // ✅ lấy danh sách

        request.setAttribute("feeConfigs", feeConfigs);  // ✅ gán đúng tên
        request.getRequestDispatcher("/page/operator/ConfigFees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện chưa xử lý cập nhật từng phí nên chỉ load lại
        response.sendRedirect("config-fee");
    }
}
