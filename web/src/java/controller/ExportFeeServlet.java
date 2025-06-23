package controller;

import dao.FeeConfigurationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.FeeConfiguration;

import java.io.IOException;
import java.util.List;

@WebServlet("/export-fees-to-excel")
public class ExportFeeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"CauHinhPhi.csv\"");

        FeeConfigurationDAO dao = new FeeConfigurationDAO();
List<FeeConfiguration> list = dao.getAllFeeConfigurations();

        ServletOutputStream out = response.getOutputStream();

        // Ghi BOM UTF-8
        out.write(0xEF); out.write(0xBB); out.write(0xBF);

        StringBuilder sb = new StringBuilder();
        sb.append("STT,Loại phí,Mô tả\n");

        for (FeeConfiguration f : list) {
            String number = String.valueOf(f.getFeeNumber());
            String type = f.getFeeType().replace("\"", "\"\"");
            String desc = f.getDescription()
                .replaceAll("^[\\s\\r\\n]+", "")
                .replace("\"", "\"\"")
                .replace("\r", "")
                .replace("\n", "\r\n");

            sb.append(String.format("%s,\"%s\",\"%s\"\n", number, type, desc));
        }

        out.write(sb.toString().getBytes("UTF-8"));
        out.flush();
        out.close();
    }
}
