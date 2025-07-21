package controller;

import model.*;
import dao.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.apache.commons.io.output.UnsynchronizedByteArrayOutputStream;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;

@WebServlet(name = "exportDataServlet", urlPatterns = {"/exportData"})
public class ExportDataServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private Email emailSender;
    private static final Logger logger = LogManager.getLogger(ExportDataServlet.class);
    private static final ObjectMapper mapper = new ObjectMapper()
            .configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false)
            .setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY)
            .setVisibility(PropertyAccessor.GETTER, JsonAutoDetect.Visibility.NONE);

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        emailSender = new Email();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users userAccount = (Users) session.getAttribute("acc");
        if (userAccount.getRoleId() != 1 && userAccount.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/page/staff/exportData.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users userAccount = (Users) session.getAttribute("acc");
        if (userAccount.getRoleId() != 1 && userAccount.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String table = request.getParameter("table");
        String format = request.getParameter("format");
        String email = request.getParameter("email");
        String[] columns = request.getParameterValues("columns");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String keyword = request.getParameter("keyword");
        String transportUnitName = request.getParameter("transportUnitName");
        String warehouseName = request.getParameter("warehouseName");
        String action = request.getParameter("action");

        logger.info("Processing request for table: " + table + ", action: " + action + ", columns: "
                + (columns != null ? String.join(",", columns) : "null") + ", format: " + format
                + ", startDate: " + startDate + ", endDate: " + endDate + ", keyword: " + keyword
                + ", transportUnitName: " + transportUnitName + ", warehouseName: " + warehouseName);

        if ("preview".equals(action)) {
            try {
                List<?> data = getDataForPreview(table, status, startDate, endDate, keyword, transportUnitName, warehouseName);
                logger.info("Preview data size: " + (data != null ? data.size() : 0));
                if (data != null && !data.isEmpty()) {
                    logger.info("Sample preview data: " + data.get(0).toString());
                } else {
                    logger.info("No preview data available");
                }
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                mapper.writeValue(response.getOutputStream(), data);
            } catch (Exception e) {
                logger.error("Error fetching preview data", e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy dữ liệu xem trước: " + e.getMessage());
            }
            return;
        }

        if (format == null || format.trim().isEmpty()) {
            logger.error("Format is null or empty, cannot export file");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng file không được cung cấp");
            return;
        }

        if (columns == null || columns.length == 0) {
            logger.error("No columns selected for export");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Vui lòng chọn ít nhất một cột để xuất");
            return;
        }

        File file = null;
        try {
            if ("orders".equals(table)) {
                List<Orders> orders = orderDAO.getFilteredOrders(status, startDate, endDate, keyword, transportUnitName, warehouseName);
                logger.info("Fetched " + (orders != null ? orders.size() : 0) + " orders");
                file = exportToFile(orders, columns, format, "orders");
            } else if ("customerSurvey".equals(table)) {
                List<CustomerSurvey> surveys = orderDAO.getFilteredSurveys(startDate, endDate, keyword);
                logger.info("Fetched " + (surveys != null ? surveys.size() : 0) + " surveys");
                file = exportToFile(surveys, columns, format, "customerSurvey");
            } else if ("transportReport".equals(table)) {
                List<TransportReport1> reports = orderDAO.getFilteredTransportReports(startDate, endDate, keyword);
                logger.info("Fetched " + (reports != null ? reports.size() : 0) + " transport reports");
                file = exportToFile(reports, columns, format, "transportReport");
            } else if ("storageReport".equals(table)) {
                List<StorageReport> reports = orderDAO.getFilteredStorageReports(startDate, endDate, keyword);
                logger.info("Fetched " + (reports != null ? reports.size() : 0) + " storage reports");
                file = exportToFile(reports, columns, format, "storageReport");
            }

            if (file != null && email != null && emailSender.isValidEmail(email)) {
                String emailSubject = emailSender.subjectExportData(table);
                String emailMessage = emailSender.messageExportData(table, format);
                emailSender.sendEmailWithAttachment(emailSubject, emailMessage, email, file);
            }

            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=" + file.getName());
            try (FileInputStream fis = new FileInputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    response.getOutputStream().write(buffer, 0, bytesRead);
                }
            }
        } catch (Exception e) {
            logger.error("Lỗi khi xuất dữ liệu", e);
            request.setAttribute("error", "Lỗi khi xuất dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/page/staff/exportData.jsp").forward(request, response);
        }
    }

    private List<?> getDataForPreview(String table, String status, String startDate, String endDate, String keyword, String transportUnitName, String warehouseName) throws Exception {
        logger.info("Fetching preview data for table: " + table);
        if ("orders".equals(table)) {
            return orderDAO.getFilteredOrders(status, startDate, endDate, keyword, transportUnitName, warehouseName);
        } else if ("customerSurvey".equals(table)) {
            return orderDAO.getFilteredSurveys(startDate, endDate, keyword);
        } else if ("transportReport".equals(table)) {
            return orderDAO.getFilteredTransportReports(startDate, endDate, keyword);
        } else if ("storageReport".equals(table)) {
            return orderDAO.getFilteredStorageReports(startDate, endDate, keyword);
        }
        return new ArrayList<>();
    }

    private File exportToFile(List<?> data, String[] columns, String format, String tableName) throws Exception {
        logger.info("Exporting " + (data != null ? data.size() : 0) + " records for table: " + tableName + ", format: " + format + ", columns: " + String.join(",", columns));
        File file;
        if ("excel".equals(format)) {
            file = new File(System.getProperty("java.io.tmpdir") + "/" + tableName + "_" + System.currentTimeMillis() + ".xlsx");
            try (XSSFWorkbook workbook = new XSSFWorkbook()) {
                Sheet sheet = workbook.createSheet(tableName);
                Row headerRow = sheet.createRow(0);
                for (int i = 0; i < columns.length; i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellValue(columns[i]);
                }
                int rowNum = 1;
                if (data != null) {
                    for (Object item : data) {
                        Row row = sheet.createRow(rowNum++);
                        for (int i = 0; i < columns.length; i++) {
                            Cell cell = row.createCell(i);
                            cell.setCellValue(getFieldValue(item, columns[i]));
                        }
                    }
                }
                try (FileOutputStream fos = new FileOutputStream(file)) {
                    workbook.write(fos);
                }
            }
        } else if ("pdf".equals(format)) {
            file = new File(System.getProperty("java.io.tmpdir") + "/" + tableName + "_" + System.currentTimeMillis() + ".pdf");
            if (file.exists()) {
                file.delete();
            }
            try (FileOutputStream fos = new FileOutputStream(file)) {
                Document document = new Document();
                PdfWriter writer = PdfWriter.getInstance(document, fos);
                document.open();
                PdfPTable table = new PdfPTable(columns.length);
                for (String column : columns) {
                    table.addCell(new PdfPCell(new Phrase(column)));
                }
                if (data != null) {
                    for (Object item : data) {
                        for (String column : columns) {
                            table.addCell(new PdfPCell(new Phrase(getFieldValue(item, column))));
                        }
                    }
                }
                document.add(table);
                document.close();
            }

        } else if ("word".equals(format)) {
            file = new File(System.getProperty("java.io.tmpdir") + "/" + tableName + "_" + System.currentTimeMillis() + ".docx");
            try (XWPFDocument document = new XWPFDocument()) {
                XWPFTable table = document.createTable();
                XWPFTableRow headerRow = table.getRow(0);
                for (int i = 0; i < columns.length; i++) {
                    if (i > 0) {
                        headerRow.createCell();
                    }
                    headerRow.getCell(i).setText(columns[i]);
                }
                if (data != null) {
                    for (Object item : data) {
                        XWPFTableRow row = table.createRow();
                        for (int i = 0; i < columns.length; i++) {
                            row.getCell(i).setText(getFieldValue(item, columns[i]));
                        }
                    }
                }
                try (FileOutputStream fos = new FileOutputStream(file)) {
                    document.write(fos);
                }
            }
        } else {
            throw new IllegalArgumentException("Định dạng không hỗ trợ: " + format);
        }
        return file;
    }

    private String getFieldValue(Object item, String field) {
        try {
            if (item instanceof Orders) {
                Orders order = (Orders) item;
                switch (field) {
                    case "order_id":
                        return String.valueOf(order.getOrderId());
                    case "customer_id":
                        return String.valueOf(order.getCustomerId());
                    case "customer_name":
                        return order.getCustomerName() != null ? order.getCustomerName() : "N/A";
                    case "transport_unit_id":
                        return order.getTransportUnitId() != null ? String.valueOf(order.getTransportUnitId()) : "N/A";
                    case "transport_unit_name":
                        return order.getTransportUnitName() != null ? order.getTransportUnitName() : "N/A";
                    case "storage_unit_id":
                        return order.getStorageUnitId() != null ? String.valueOf(order.getStorageUnitId()) : "N/A";
                    case "storage_unit_name":
                        return order.getStorageUnitName() != null ? order.getStorageUnitName() : "N/A";
                    case "order_status":
                        return order.getOrderStatus() != null ? order.getOrderStatus() : "N/A";
                    case "created_at":
                        return order.getCreatedAt() != null ? order.getCreatedAt().toString() : "N/A";
                    case "total_fee":
                        return order.getTotalFee() != null ? order.getTotalFee().toString() : "N/A";
                    case "delivered_at":
                        return order.getDeliveredAt() != null ? order.getDeliveredAt().toString() : "N/A";
                    case "updated_at":
                        return order.getUpdatedAt() != null ? order.getUpdatedAt().toString() : "N/A";
                    case "delivery_schedule":
                        return order.getDeliverySchedule() != null ? order.getDeliverySchedule().toString() : "N/A";
                    case "accepted_at":
                        return order.getAcceptedAt() != null ? order.getAcceptedAt().toString() : "N/A";
                    default:
                        return "N/A";
                }
            } else if (item instanceof CustomerSurvey) {
                CustomerSurvey survey = (CustomerSurvey) item;
                switch (field) {
                    case "survey_id":
                        return String.valueOf(survey.getSurveyId());
                    case "survey_date":
                        return survey.getSurveyDate() != null ? survey.getSurveyDate() : "N/A";
                    case "user_id":
                        return String.valueOf(survey.getUserId());
                    case "overall_satisfaction":
                        return String.valueOf(survey.getOverall_satisfaction());
                    case "recommend_score":
                        return String.valueOf(survey.getRecommend_score());
                    case "transport_care":
                        return String.valueOf(survey.getTransport_care());
                    case "consultant_professionalism":
                        return String.valueOf(survey.getConsultant_professionalism());
                    case "expectation":
                        return survey.getExpectation() != null ? survey.getExpectation() : "N/A";
                    case "packing_quality":
                        return survey.getPacking_quality() != null ? survey.getPacking_quality() : "N/A";
                    case "item_condition":
                        return survey.getItem_condition() != null ? survey.getItem_condition() : "N/A";
                    case "delivery_timeliness":
                        return survey.getDelivery_timeliness() != null ? survey.getDelivery_timeliness() : "N/A";
                    case "booking_process":
                        return survey.getBooking_process() != null ? survey.getBooking_process() : "N/A";
                    case "response_time":
                        return survey.getResponse_time() != null ? survey.getResponse_time() : "N/A";
                    case "price_transparency":
                        return survey.getPrice_transparency() != null ? survey.getPrice_transparency() : "N/A";
                    case "age_group":
                        return survey.getAge_group() != null ? survey.getAge_group() : "N/A";
                    case "area":
                        return survey.getArea() != null ? survey.getArea() : "N/A";
                    case "housing_type":
                        return survey.getHousing_type() != null ? survey.getHousing_type() : "N/A";
                    case "usage_frequency":
                        return survey.getUsage_frequency() != null ? survey.getUsage_frequency() : "N/A";
                    case "important_factor":
                        return survey.getImportant_factor() != null ? survey.getImportant_factor() : "N/A";
                    case "additional_service":
                        return survey.getAdditional_service() != null ? survey.getAdditional_service() : "N/A";
                    case "feedback":
                        return survey.getFeedback() != null ? survey.getFeedback() : "N/A";
                    default:
                        return "N/A";
                }
            } else if (item instanceof TransportReport1) {
                TransportReport1 report = (TransportReport1) item;
                switch (field) {
                    case "report_id":
                        return String.valueOf(report.getReportId());
                    case "transport_unit_id":
                        return String.valueOf(report.getTransportUnitId());
                    case "company_name":
                        return report.getCompanyName() != null ? report.getCompanyName() : "N/A";
                    case "report_year":
                        return String.valueOf(report.getReportYear());
                    case "report_month":
                        return String.valueOf(report.getReportMonth());
                    case "total_shipments":
                        return String.valueOf(report.getTotalShipments());
                    case "total_revenue":
                        return report.getTotalRevenue() != null ? report.getTotalRevenue().toString() : "N/A";
                    default:
                        return "N/A";
                }
            } else if (item instanceof StorageReport) {
                StorageReport report = (StorageReport) item;
                switch (field) {
                    case "report_date":
                        return report.getReportDate() != null ? report.getReportDate() : "N/A";
                    case "storage_unit_id":
                        return String.valueOf(report.getStorageUnitId());
                    case "warehouse_name":
                        return report.getWarehouseName() != null ? report.getWarehouseName() : "N/A";
                    case "quantity_on_hand":
                        return String.valueOf(report.getQuantityOnHand());
                    case "used_area":
                        return String.valueOf(report.getUsedArea());
                    case "total_area":
                        return String.valueOf(report.getTotalArea());
                    case "profit":
                        return String.valueOf(report.getProfit());
                    default:
                        return "N/A";
                }
            }
        } catch (Exception e) {
            logger.error("Error getting field value for field: " + field, e);
            return "N/A";
        }
        return "N/A";
    }
}
