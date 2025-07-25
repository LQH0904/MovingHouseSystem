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

@WebServlet("/test-payment-option") 
public class TestPaymentOptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DBConnection.getConnection()) {
            BankConfigDAO dao = new BankConfigDAO(conn);
            List<BankConfig> bankList = dao.getAllConfigs(); // lấy danh sách từ DB
            request.setAttribute("bankList", bankList);
        } catch (Exception e) {
            e.printStackTrace();
        }


        request.getRequestDispatcher("/page/operator/TestPaymentOption.jsp").forward(request, response);
    }
}
