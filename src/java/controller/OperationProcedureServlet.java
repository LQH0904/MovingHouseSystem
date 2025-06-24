package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.OperationProcedure;
import dao.OperationProcedureDAO;
import java.util.List;

@WebServlet("/operation-procedure")
public class OperationProcedureServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OperationProcedureDAO dao = new OperationProcedureDAO();
        List<OperationProcedure> procedures = dao.getAllProcedures();

        // DÒNG DEBUG — in ra số bản ghi
        System.out.println("Số lượng bản ghi quy trình lấy được: " + procedures.size());

        request.setAttribute("procedures", procedures);
        request.getRequestDispatcher("/page/operator/OperationalProcedures.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int stepNumber = Integer.parseInt(request.getParameter("stepNumber"));
        String stepTitle = request.getParameter("stepTitle");
        String stepDescription = request.getParameter("stepDescription");

        OperationProcedure p = new OperationProcedure(id, stepNumber, stepTitle, stepDescription);

        OperationProcedureDAO dao = new OperationProcedureDAO();
        dao.updateProcedure(p);

        response.sendRedirect("operation-procedure");
    }

}
