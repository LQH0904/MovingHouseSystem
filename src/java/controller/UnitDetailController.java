package controller;

import dao.AlertComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.AlertComplaint;
import model.ChartDataPoint;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.time.temporal.WeekFields;

@WebServlet(name = "UnitDetailController", urlPatterns = {"/operator/unit-detail/*"})
public class UnitDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        System.out.println("UnitDetailController: Received request for unit-detail.");
        System.out.println("UnitDetailController: PathInfo received: " + pathInfo);

        int unitId = -1;
        if (pathInfo != null && pathInfo.length() > 1) {
            try {
                unitId = Integer.parseInt(pathInfo.substring(1));
                System.out.println("UnitDetailController: Parsed unitId from pathInfo: " + unitId);
            } catch (NumberFormatException e) {
                System.err.println("UnitDetailController: Invalid Unit ID format in pathInfo: " + pathInfo);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Unit ID format");
                return;
            }
        } else {
            System.err.println("UnitDetailController: Unit ID is missing in path.");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unit ID is required in URL path");
            return;
        }

        AlertComplaintDAO dao = new AlertComplaintDAO();
        Gson gson = new GsonBuilder().create();

        String chartPeriodParam = request.getParameter("chartPeriodAjax");
        if (chartPeriodParam != null && !chartPeriodParam.isEmpty()) {
            try {
                System.out.println("UnitDetailController: Handling AJAX request for chart data, period: " + chartPeriodParam);

                // Get dropdown parameters, default to 0 if not provided or empty (meaning "Không chọn")
                int selectedYear = (request.getParameter("selectedYear") != null && !request.getParameter("selectedYear").isEmpty()) ? Integer.parseInt(request.getParameter("selectedYear")) : LocalDate.now().getYear();
                int selectedMonth = (request.getParameter("selectedMonth") != null && !request.getParameter("selectedMonth").isEmpty()) ? Integer.parseInt(request.getParameter("selectedMonth")) : 0; // Default to 0 ("Không chọn")
                int selectedWeek = (request.getParameter("selectedWeek") != null && !request.getParameter("selectedWeek").isEmpty()) ? Integer.parseInt(request.getParameter("selectedWeek")) : 0;   // Default to 0 ("Không chọn")

                List<ChartDataPoint> chartDataPoints = dao.getComplaintChartData(unitId, chartPeriodParam, selectedYear, selectedMonth, selectedWeek);
                String chartDataJson = gson.toJson(chartDataPoints);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(chartDataJson);
                System.out.println("UnitDetailController: Sent chart data JSON for unitId " + unitId + ", period " + chartPeriodParam);
            } catch (NumberFormatException e) {
                System.err.println("UnitDetailController: Invalid number format for chart parameters: " + e.getMessage());
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid number format for chart parameters.\"}");
            } catch (Exception e) {
                System.err.println("UnitDetailController: Error processing AJAX chart request: " + e.getMessage());
                e.printStackTrace();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Internal server error fetching chart data.\"}");
            }
            return;
        }

        // --- Initial page load logic ---
        AlertComplaint unitDetails = dao.getUnitDetailsById(unitId);

        if (unitDetails != null) {
            System.out.println("UnitDetailController: Successfully retrieved unit details for unitId: " + unitId);
            int issueCount = unitDetails.getIssueCount();
            String warningLevel;
            if (issueCount < 2) {
                warningLevel = "Normal";
            } else if (issueCount >= 2 && issueCount <= 3) {
                warningLevel = "Warning";
            } else {
                warningLevel = "Danger";
            }
            unitDetails.setWarningLevel(warningLevel);

            request.setAttribute("unitDetails", unitDetails);
            request.setAttribute("unitId", unitDetails.getUnitId());
            request.setAttribute("unitName", unitDetails.getUnitName());
            request.setAttribute("unitEmail", unitDetails.getEmail());
            request.setAttribute("unitType", unitDetails.getUnitType());
            request.setAttribute("issueCount", unitDetails.getIssueCount());
            request.setAttribute("warningLevel", unitDetails.getWarningLevel());

            // Set initial values for dropdowns for JSP
            int initialYear = 2025; // Default to 2025
            int initialMonth = 0;   // Default to "Không chọn" for month
            int initialWeek = 0;    // Default to "Không chọn" for week

            // Initial chart period will be "year" if month and week are "Không chọn"
            String initialChartPeriod = "year";

            List<ChartDataPoint> initialChartDataPoints = dao.getComplaintChartData(unitId, initialChartPeriod, initialYear, initialMonth, initialWeek);
            String initialChartDataJson = gson.toJson(initialChartDataPoints);
            request.setAttribute("chartDataJson", initialChartDataJson);
            request.setAttribute("initialChartPeriod", initialChartPeriod);
            request.setAttribute("initialChartYear", initialYear);
            request.setAttribute("initialChartMonth", initialMonth);
            request.setAttribute("initialChartWeek", initialWeek);

            request.getRequestDispatcher("/page/operator/DetailUnitIssue.jsp").forward(request, response);
        } else {
            System.err.println("UnitDetailController: Unit details not found in DAO for unitId: " + unitId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unit not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
