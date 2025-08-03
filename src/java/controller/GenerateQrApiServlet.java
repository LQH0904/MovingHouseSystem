// controller/GenerateQrApiServlet.java
package controller;

import com.google.gson.Gson;
import model.Users;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet("/generate-qr-api")
public class GenerateQrApiServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Chưa đăng nhập\"}");
            return;
        }

        Users currentUser = (Users) session.getAttribute("acc");
        String username = currentUser.getUsername();
        double totalAmount;
        try {
            totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            if (totalAmount <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"Tổng số tiền không hợp lệ\"}");
            return;
        }

        double depositAmount = Math.round(totalAmount * 0.3);
        NumberFormat formatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        String totalText = "Dịch vụ bạn đăng ký cần thanh toán : " + formatter.format(totalAmount);
        String depositText = "Bạn cần đặt cọc trước 30% số tiền : " + formatter.format(depositAmount);

        String memo = URLEncoder.encode(username + " chuyen khoan tien dat coc", StandardCharsets.UTF_8);
        String qrUrl = "https://img.vietqr.io/image/970423-00000119443-print.png"
                     + "?amount=" + depositAmount
                     + "&addInfo=" + memo
                     + "&accountName=" + URLEncoder.encode("TEN CHU TAI KHOAN", "UTF-8");

        Map<String, String> data = new HashMap<>();
        data.put("totalInfoText", totalText);
        data.put("depositInfoText", depositText);
        data.put("qrUrl", qrUrl);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(data, response.getWriter());
    }
}

