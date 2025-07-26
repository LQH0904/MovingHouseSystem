// 1. Fixed transportReportController.java
package controller.reportSummary;

import dao.DAOTransportReport;
import dao.DAOTransportUnit;
import model.TransportReport;
import model.TransportUnit;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.util.Vector;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet(name = "transportReport", urlPatterns = {"/transportReport"})
public class transportReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAOTransportReport dao = new DAOTransportReport();
        DAOTransportUnit daoTransportUnit = new DAOTransportUnit();
        HttpSession session = request.getSession(true);

        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = "listTransportReports";
            }

            if (service.equals("listTransportReports")) {
                Vector<TransportReport> vector;
                Vector<TransportUnit> transportUnits;

                // Get filter parameters
                String transportUnitId = request.getParameter("transportUnitId");
                String year = request.getParameter("year");
                String submit = request.getParameter("submit");

                // Build SQL query - FIXED: Properly join tables and get company names
                StringBuilder sqlQuery = new StringBuilder();
                sqlQuery.append("SELECT tp.*, tu.company_name FROM dbo.TransportReport tp ");
                sqlQuery.append("JOIN dbo.TransportUnits tu ON tp.transport_unit_id = tu.transport_unit_id ");

                boolean hasWhere = false;

                // Add transport unit filter
                if (transportUnitId != null && !transportUnitId.isEmpty()) {
                    sqlQuery.append(" WHERE tp.transport_unit_id = ").append(transportUnitId);
                    hasWhere = true;
                }

                // Add year filter
                if (year != null && !year.isEmpty()) {
                    if (hasWhere) {
                        sqlQuery.append(" AND");
                    } else {
                        sqlQuery.append(" WHERE");
                        hasWhere = true;
                    }
                    sqlQuery.append(" tp.report_year = ").append(year);
                }

                // Add search filter if exists
                if (submit != null) {
                    String invRTitle = request.getParameter("year");
                    if (invRTitle != null && !invRTitle.isEmpty()) {
                        if (hasWhere) {
                            sqlQuery.append(" AND");
                        } else {
                            sqlQuery.append(" WHERE");
                        }
                        sqlQuery.append(" tu.company_name LIKE '%").append(invRTitle).append("%'");
                    }
                }

                // Order by year and month descending
                sqlQuery.append(" ORDER BY tp.report_year DESC, tp.report_month DESC");

                try {
                    // Get transport reports with company names
                    vector = dao.getTransportReportWithCompanyName(sqlQuery.toString());
                    
                    // Get all approved transport units for dropdown
                    transportUnits = daoTransportUnit.getReports("SELECT * FROM TransportUnits WHERE registration_status = 'approved'");

                    // Debug: Print to console
                    System.out.println("=== DEBUG CONTROLLER ===");
                    System.out.println("SQL Query: " + sqlQuery.toString());
                    System.out.println("Transport Reports found: " + (vector != null ? vector.size() : "NULL"));
                    System.out.println("Transport Units found: " + (transportUnits != null ? transportUnits.size() : "NULL"));
                    
                    if (vector != null && !vector.isEmpty()) {
                        System.out.println("First report: " + vector.get(0).toString());
                    }

                    // Set attributes for JSP
                    request.setAttribute("transportReportsData", vector);
                    request.setAttribute("transportUnitData", transportUnits);
                    
                    // Also set as JSON for JavaScript usage
                    Gson gson = new Gson();
                    request.setAttribute("transportReportsJSON", gson.toJson(vector));
                    request.setAttribute("transportUnitsJSON", gson.toJson(transportUnits));

                } catch (Exception e) {
                    System.err.println("Error in transportReportController: " + e.getMessage());
                    e.printStackTrace();
                    
                    // Set empty vectors to prevent null pointer exceptions
                    request.setAttribute("transportReportsData", new Vector<TransportReport>());
                    request.setAttribute("transportUnitData", new Vector<TransportUnit>());
                    request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
                }

                // Forward to JSP
                RequestDispatcher dis = request.getRequestDispatcher("page/operator/reportSummary/listTransportReport.jsp");
                dis.forward(request, response);
                
            } else if (service.equals("getDataAsJSON")) {
                // API endpoint to return JSON data for AJAX calls
                response.setContentType("application/json;charset=UTF-8");
                
                try {
                    Vector<TransportReport> reports = dao.getTransportReportWithCompanyName(
                        "SELECT tp.*, tu.company_name FROM dbo.TransportReport tp " +
                        "JOIN dbo.TransportUnits tu ON tp.transport_unit_id = tu.transport_unit_id " +
                        "ORDER BY tp.report_year DESC, tp.report_month DESC"
                    );
                    
                    Vector<TransportUnit> units = daoTransportUnit.getReports(
                        "SELECT * FROM TransportUnits WHERE registration_status = 'approved'"
                    );
                    
                    Gson gson = new Gson();
                    String jsonResponse = "{"
                        + "\"reports\":" + gson.toJson(reports) + ","
                        + "\"units\":" + gson.toJson(units) + ","
                        + "\"success\":true"
                        + "}";
                    
                    out.print(jsonResponse);
                    
                } catch (Exception e) {
                    String errorResponse = "{\"success\":false,\"error\":\"" + e.getMessage() + "\"}";
                    out.print(errorResponse);
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Transport Report Controller - Updated";
    }
}