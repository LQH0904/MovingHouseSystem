package controller;

import dao.AlertComplaintDAO;
import model.AlertComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlertComplaintController", urlPatterns = {"/operator/alert-complaint"})
public class AlertComplaintController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AlertComplaintDAO dao = new AlertComplaintDAO();
        List<AlertComplaint> complaints = dao.getAllUnitComplaints();

        request.setAttribute("complaints", complaints);
        request.getRequestDispatcher("/page/operator/AlertComplaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
