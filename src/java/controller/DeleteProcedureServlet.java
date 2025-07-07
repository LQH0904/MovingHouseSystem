package controller;

import dao.OperationProcedureDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/delete-procedure")
public class DeleteProcedureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        OperationProcedureDAO dao = new OperationProcedureDAO();
        dao.deleteById(id);

        response.sendRedirect("operation-procedure");
    }
}
