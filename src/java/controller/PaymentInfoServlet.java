package controller;

import dao.BankConfigDAO;
import model.BankConfig;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/payment-info")
public class PaymentInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String amount = request.getParameter("amount");
        String bankName = request.getParameter("bankName");

        try (Connection conn = DBConnection.getConnection()) {
            BankConfigDAO dao = new BankConfigDAO(conn);

            List<BankConfig> bankList = dao.getAllConfigs();
            request.setAttribute("bankList", bankList);

            BankConfig selectedConfig = (bankName != null && !bankName.isEmpty())
                ? dao.getConfigByBankName(bankName)
                : dao.getConfig();

            request.setAttribute("config", selectedConfig);
            request.setAttribute("username", username);
            request.setAttribute("amount", amount);

            // Map bank name → VietQR bank code
            String bankCode = switch (selectedConfig.getBankName()) {
                case "MB Bank" -> "970422";
                case "Vietcombank" -> "970436";
                case "TPBank" -> "970423";
                case "BIDV" -> "970418";
                case "VietinBank" -> "970415";
                case "ACB" -> "970416";
                default -> "000000";
            };
            request.setAttribute("bankCode", bankCode);

            request.getRequestDispatcher("/page/operator/PaymentInfo.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Không lấy được thông tin thanh toán.");
        }
    }
}
