package controller;

import dao.OperationProcedureDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OperationProcedure;
import java.io.IOException;
import java.util.*;

@WebServlet("/edit-procedure")
public class EditProcedureServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        OperationProcedureDAO dao = new OperationProcedureDAO();
        OperationProcedure p = dao.getById(id);

        if (p != null) {
            request.setAttribute("id", p.getId());
            request.setAttribute("stepTitle", p.getStepTitle());
            request.setAttribute("stepDescription", p.getStepDescription());
            request.getRequestDispatcher("/page/operator/EditOperationProcedure.jsp").forward(request, response);
        } else {
            response.sendRedirect("operation-procedure");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String stepTitle = request.getParameter("stepTitle");

        List<String> descriptions = new ArrayList<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (name.startsWith("desc")) {
                String value = request.getParameter(name).trim();
                if (!value.isEmpty()) {
                    descriptions.add(value);
                }
            }
        }

        StringBuilder fullDesc = new StringBuilder();
        for (String desc : descriptions) {
            fullDesc.append(". ").append(desc).append("\n");
        }

        OperationProcedureDAO dao = new OperationProcedureDAO();
        OperationProcedure p = dao.getById(id); // Lấy stepNumber cũ

        OperationProcedure updated = new OperationProcedure(
                id,
                p.getStepNumber(),
                stepTitle.trim(),
                fullDesc.toString().trim()
        );

        dao.updateProcedure(updated);
        response.sendRedirect("operation-procedure");
    }
}
