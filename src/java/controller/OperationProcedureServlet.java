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
    request.setAttribute("procedures", procedures); // Gán vào request
    request.getRequestDispatcher("/page/operator/OperationalProcedures.jsp").forward(request, response);
}


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String content = request.getParameter("content");
        OperationProcedureDAO dao = new OperationProcedureDAO();
        dao.updateProcedure(content);
        response.sendRedirect("procedure");
    }
}
