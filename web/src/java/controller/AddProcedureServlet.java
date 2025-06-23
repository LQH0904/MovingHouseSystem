package controller;

import dao.OperationProcedureDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OperationProcedure;

import java.io.IOException;

@WebServlet("/add-procedure")
public class AddProcedureServlet extends HttpServlet {

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/page/operator/AddOperationProcedures.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String stepTitle = request.getParameter("stepTitle");
        String[] descriptions = request.getParameterValues("descriptions");

        StringBuilder fullDesc = new StringBuilder();
        for (String desc : descriptions) {
            if (!desc.trim().isEmpty()) {
                fullDesc.append(". ").append(desc.trim()).append("\n");
            }
        }

        OperationProcedureDAO dao = new OperationProcedureDAO();
        int nextStepNumber = dao.getNextStepNumber();

        OperationProcedure p = new OperationProcedure(0, nextStepNumber, stepTitle.trim(), fullDesc.toString().trim());
        dao.insertProcedure(p);

        response.sendRedirect("operation-procedure");
    }
}
