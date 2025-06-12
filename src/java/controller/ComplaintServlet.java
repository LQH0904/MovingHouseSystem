package controller;

import dao.ComplaintDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Complaint;

@WebServlet(name="ComplaintServlet", urlPatterns={"/ComplaintServlet"})
public class ComplaintServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ComplaintServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ComplaintServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ComplaintDAO complaintDAO = new ComplaintDAO();

        int page = 1;
        int recordsPerPage = 20;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String searchTerm = request.getParameter("searchTerm");
        String statusFilter = request.getParameter("statusFilter");
        String priorityFilter = request.getParameter("priorityFilter");

        int offset = (page - 1) * recordsPerPage;

        int totalComplaints = complaintDAO.getTotalComplaintCount(searchTerm, statusFilter, priorityFilter);
        int totalPages = (int) Math.ceil(totalComplaints * 1.0 / recordsPerPage);

        List<Complaint> complaintList = complaintDAO.getAllComplaints(searchTerm, statusFilter, priorityFilter, offset, recordsPerPage);

        request.setAttribute("complaintList", complaintList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);

        // This path must be correct relative to your web app's root.
        request.getRequestDispatcher("/page/operator/complaintList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Complaint Management Servlet";
    }
}