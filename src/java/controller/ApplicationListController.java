package controller;

import dao.UnitRegistrationDAO;
import model.UnitInfo;
import model.UnitStatistics;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/operator/listApplication")
public class ApplicationListController extends HttpServlet {
    private static final int RECORDS_PER_PAGE = 5;
    private UnitRegistrationDAO unitDAO;

    @Override
    public void init() throws ServletException {
        unitDAO = new UnitRegistrationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String pageParam = request.getParameter("page");
        
        // Set default values
        if (keyword == null) keyword = "";
        if (status == null) status = "all";
        
        int currentPage = 1;
        try {
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        // Get statistics
        UnitStatistics stats = unitDAO.getUnitStatistics();
        
        // Get all units
        List<UnitInfo> allUnits = unitDAO.getAllUnits();
        
        // Filter by keyword
        List<UnitInfo> filteredUnits = filterByKeyword(allUnits, keyword);
        
        // Filter by status
        filteredUnits = filterByStatus(filteredUnits, status);
        
        // Calculate pagination
        int totalRecords = filteredUnits.size();
        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);
        
        // Get records for current page
        List<ApplicationInfo> applications = getPaginatedApplications(filteredUnits, currentPage);
        
        // Set attributes for JSP
        request.setAttribute("total", stats.getTotalUnits());
        request.setAttribute("pending", stats.getTotalPending());
        request.setAttribute("approved", stats.getTotalApproved());
        request.setAttribute("rejected", stats.getTotalRejected());
        
        request.setAttribute("applications", applications);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        // Forward to JSP
        request.getRequestDispatcher("/page/operator/ListApplicationRegistration.jsp").forward(request, response);
    }

    private List<UnitInfo> filterByKeyword(List<UnitInfo> units, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return units;
        }
        
        return units.stream()
                .filter(unit -> unit.getName().toLowerCase().contains(keyword.toLowerCase()))
                .collect(Collectors.toList());
    }

    private List<UnitInfo> filterByStatus(List<UnitInfo> units, String status) {
        if ("all".equals(status)) {
            return units;
        }
        
        return units.stream()
                .filter(unit -> unit.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    private List<ApplicationInfo> getPaginatedApplications(List<UnitInfo> units, int currentPage) {
        List<ApplicationInfo> applications = new ArrayList<>();
        
        int startIndex = (currentPage - 1) * RECORDS_PER_PAGE;
        int endIndex = Math.min(startIndex + RECORDS_PER_PAGE, units.size());
        
        for (int i = startIndex; i < endIndex; i++) {
            UnitInfo unit = units.get(i);
            ApplicationInfo app = new ApplicationInfo();
            
            // Map UnitInfo to ApplicationInfo for JSP compatibility
            app.setApplication_id(unit.getUnitId());
            app.setUsername(unit.getName());
            
            // Map type to role_id
            if ("storage".equals(unit.getType())) {
                app.setRole_id(5); // Storage role
            } else if ("transport".equals(unit.getType())) {
                app.setRole_id(4); // Transport role
            } else {
                app.setRole_id(3); // Default to Staff
            }
            
            // Map status to status_id
            switch (unit.getStatus().toLowerCase()) {
                case "pending":
                    app.setStatus_id(1);
                    break;
                case "approved":
                    app.setStatus_id(2);
                    break;
                case "rejected":
                    app.setStatus_id(3);
                    break;
                default:
                    app.setStatus_id(1); // Default to pending
            }
            
            applications.add(app);
        }
        
        return applications;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Inner class to match JSP expectations
    public static class ApplicationInfo {
        private int application_id;
        private String username;
        private int role_id;
        private int status_id;

        // Getters and setters
        public int getApplication_id() {
            return application_id;
        }

        public void setApplication_id(int application_id) {
            this.application_id = application_id;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public int getRole_id() {
            return role_id;
        }

        public void setRole_id(int role_id) {
            this.role_id = role_id;
        }

        public int getStatus_id() {
            return status_id;
        }

        public void setStatus_id(int status_id) {
            this.status_id = status_id;
        }
    }
}
