package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import utils.QRCodeGenerator;

import java.io.*;
import com.google.zxing.WriterException;

@WebServlet("/generate-qr")
public class QRPaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form (PaymentInfo.jsp)
        String username = request.getParameter("username");
        String amount = request.getParameter("amount");
        String bank = request.getParameter("bankName");
        String accountNumber = request.getParameter("accountNumber");
        String accountName = request.getParameter("accountName");

        // Nội dung mã QR
        String content = "Chuyển khoản cho:\n" +
                         "Ngân hàng: " + bank + "\n" +
                         "STK: " + accountNumber + "\n" +
                         "Tên: " + accountName + "\n" +
                         "Số tiền: " + amount + " VND\n" +
                         "Ghi chú: " + username + " thanh toán";

        // Đường dẫn lưu mã QR
        String qrPath = getServletContext().getRealPath("/") + "qr/" + username + ".png";
        File qrFolder = new File(getServletContext().getRealPath("/") + "qr");
        if (!qrFolder.exists()) qrFolder.mkdirs();

        try {
            QRCodeGenerator.generateQRCodeImage(content, 300, 300, qrPath);
            request.setAttribute("qrImage", "qr/" + username + ".png");
        } catch (WriterException e) {
            throw new ServletException("Lỗi khi tạo mã QR", e);
        }

        // Trả về trang hiển thị mã QR
        request.getRequestDispatcher("/page/operator/ShowQR.jsp").forward(request, response);
    }
}
