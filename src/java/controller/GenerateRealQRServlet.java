package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/generate-real-qr")
public class GenerateRealQRServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        String accountName = request.getParameter("accountName");
        String bankCode = request.getParameter("bankCode");
        String amount = request.getParameter("amount");
        String note = request.getParameter("note");

        String base = "https://img.vietqr.io/image/" + bankCode + "-" + accountNumber + "-print.png";
        String query = "?amount=" + URLEncoder.encode(amount, "UTF-8") +
                       "&addInfo=" + URLEncoder.encode(note, "UTF-8") +
                       "&accountName=" + URLEncoder.encode(accountName, "UTF-8");

        String qrURL = base + query;

        request.setAttribute("qrURL", qrURL);
        request.getRequestDispatcher("/page/operator/ShowQR.jsp").forward(request, response);
    }
}



