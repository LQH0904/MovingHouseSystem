package controller;

import dao.OperationPolicyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.OperationPolicy;

import java.io.IOException;
import java.util.List;

@WebServlet("/export-policies-to-excel")
public class ExportPolicyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"ChinhSachVanHanh.csv\"");

        OperationPolicyDAO dao = new OperationPolicyDAO();
        List<OperationPolicy> list = dao.getAllPolicies();

        ServletOutputStream out = response.getOutputStream();

        // Ghi BOM UTF-8 để Excel nhận đúng encoding
        out.write(0xEF);
        out.write(0xBB);
        out.write(0xBF);

        StringBuilder sb = new StringBuilder();
        sb.append("STT,Tiêu đề,Nội dung\n");

        for (OperationPolicy p : list) {
            String stt = String.valueOf(p.getPolicyNumber());
            String title = p.getPolicyTitle().replace("\"", "\"\"");
            String content = p.getPolicyContent()
                    .replaceAll("^[\\s\\r\\n]+", "") // bỏ khoảng trắng đầu
                    .replace("\"", "\"\"")
                    .replace("\r", "")
                    .replace("\n", "\r\n"); // chuẩn xuống dòng Windows

            sb.append(String.format("%s,\"%s\",\"%s\"\n", stt, title, content));
        }

        out.write(sb.toString().getBytes("UTF-8"));
        out.flush();
        out.close();
    }
}
