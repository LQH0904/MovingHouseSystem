package controller;

import dao.OperationProcedureDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.OperationProcedure;

@WebServlet("/export-procedures-to-excel")
public class ExportProcedureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"QuyTrinhVanHanh.csv\"");

        OperationProcedureDAO dao = new OperationProcedureDAO();
        List<OperationProcedure> list = dao.getAllProcedures();

        ServletOutputStream out = response.getOutputStream();

        out.write(0xEF);
        out.write(0xBB);
        out.write(0xBF);

        StringBuilder sb = new StringBuilder();
        sb.append("STT,Tiêu đề,Mô tả\n");

        for (OperationProcedure p : list) {
            String stt = String.valueOf(p.getStepNumber());
            String title = p.getStepTitle().replace("\"", "\"\"");

            String desc = p.getStepDescription()
                    .replaceAll("^[\\s\\r\\n]+", "") 
                    .replace("\"", "\"\"") 
                    .replace("\r", "") 
                    .replace("\n", "\r\n");                  

            sb.append(String.format("%s,\"%s\",\"%s\"\n", stt, title, desc));
        }

        out.write(sb.toString().getBytes("UTF-8"));
        out.flush();
        out.close();
    }
}
