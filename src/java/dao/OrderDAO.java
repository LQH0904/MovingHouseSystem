/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Orders;
import model.CustomerSurvey;
import model.TransportReport1;
import model.StorageReport;
import model.Issue;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    public static final OrderDAO INSTANCE = new OrderDAO();

    public List<Orders> getOrderList(String status, String startDate, String endDate, String transportUnitName,
            String warehouseName, String orderId, String sortBy, String sortOrder) {
        List<Orders> orders = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT o.order_id, o.customer_id, c.full_name, o.transport_unit_id, t.company_name, "
                + "o.storage_unit_id, s.warehouse_name, o.order_status, o.created_at, o.updated_at, "
                + "o.delivery_schedule, o.total_fee, o.accepted_at, o.delivered_at "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.customer_id = c.customer_id "
                + "LEFT JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id "
                + "LEFT JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id WHERE 1=1");

        // Thêm điều kiện lọc
        List<Object> params = new ArrayList<>();
        try {
            if (orderId != null && !orderId.isEmpty()) {
                query.append(" AND o.order_id = ?");
                params.add(Integer.parseInt(orderId));
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid orderId format: " + orderId, e);
        }

        if (status != null && !status.isEmpty()) {
            query.append(" AND o.order_status = ?");
            params.add(status);
        }
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND o.delivery_schedule >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND o.delivery_schedule <= ?");
            params.add(endDate);
        }
        if (transportUnitName != null && !transportUnitName.isEmpty()) {
            query.append(" AND t.company_name LIKE ?");
            params.add("%" + transportUnitName + "%");
        }
        if (warehouseName != null && !warehouseName.isEmpty()) {
            query.append(" AND s.warehouse_name LIKE ?");
            params.add("%" + warehouseName + "%");
        }

        if (sortBy != null && (sortBy.equals("created_at") || sortBy.equals("updated_at"))) {
            query.append(" ORDER BY o.").append(sortBy);
            if (sortOrder != null && sortOrder.equals("desc")) {
                query.append(" DESC");
            } else {
                query.append(" ASC");
            }
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setCustomerName(rs.getString("full_name"));
                order.setTransportUnitId(rs.getObject("transport_unit_id") != null ? rs.getInt("transport_unit_id") : null);
                String companyName = rs.getString("company_name");
                order.setTransportUnitName(companyName != null ? companyName : "Chưa chỉ định");
                order.setStorageUnitId(rs.getObject("storage_unit_id") != null ? rs.getInt("storage_unit_id") : null);
                order.setStorageUnitName(rs.getString("warehouse_name"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
                order.setTotalFee(rs.getBigDecimal("total_fee"));
                order.setAcceptedAt(rs.getTimestamp("accepted_at"));
                order.setDeliveredAt(rs.getTimestamp("delivered_at"));
                LOGGER.info("Order ID: " + order.getOrderId() + ", Transport Unit ID: " + order.getTransportUnitId()
                        + ", Company Name: " + (companyName != null ? companyName : "NULL"));
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error: " + e.getMessage(), e);
        }
        return orders;
    }

    public List<Issue> getIssuesByOrderId(int orderId) throws SQLException {
        String query = "SELECT * FROM Issues WHERE order_id = ?";
        List<Issue> issues = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Issue issue = new Issue();
                issue.setIssueId(rs.getInt("issue_id"));
                issue.setDescription(rs.getString("description"));
                issues.add(issue);
                LOGGER.info("Fetched Issue ID: " + issue.getIssueId() + " for Order ID: " + orderId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching issues for Order ID: " + orderId, e);
            throw e;
        }
        return issues;
    }

    public List<Orders> getOrderListNotification(String status, String customerId, String transportUnitId, String startDate, String endDate, String orderBy, String sortOrder, String limit) throws SQLException {
        List<Orders> orders = new ArrayList<>();
        String query = "SELECT o.* FROM Orders o "
                + "LEFT JOIN Notifications n ON n.order_id = o.order_id AND n.created_at >= DATEADD(hour, -24, GETDATE()) "
                + "WHERE n.notification_id IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setTransportUnitId(rs.getInt("transport_unit_id"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
                order.setDeliveredAt(rs.getTimestamp("delivered_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn danh sách đơn hàng: " + e.getMessage());
            throw e;
        }
        return orders;
    }

    public List<Issue> getIssuesByOrderIdNotification(int orderId) throws SQLException {
        List<Issue> issues = new ArrayList<>();
        String query = "SELECT * FROM Issues WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Issue issue = new Issue();
                issue.setOrderId(rs.getInt("order_id"));
                issue.setDescription(rs.getString("description"));
                issues.add(issue);
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn vấn đề đơn hàng ID " + orderId + ": " + e.getMessage());
            throw e;
        }
        return issues;
    }

    public List<Orders> getFilteredOrders(String status, String startDate, String endDate, String keyword, String transportUnitName, String warehouseName) throws SQLException {
        List<Orders> orders = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT o.order_id, o.customer_id, c.full_name AS customer_name, o.transport_unit_id, t.company_name AS transport_unit_name, "
                + "o.storage_unit_id, s.warehouse_name AS storage_unit_name, o.order_status, o.created_at, o.total_fee, o.delivered_at, "
                + "o.updated_at, o.delivery_schedule, o.accepted_at "
                + // Thêm các cột khác từ Orders
                "FROM Orders o "
                + "LEFT JOIN Customers c ON o.customer_id = c.customer_id "
                + "LEFT JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id "
                + "LEFT JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id"
        );

        List<Object> params = new ArrayList<>();
        boolean hasFilter = false;

        if (status != null && !status.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("o.order_status = ?");
            params.add(status);
            hasFilter = true;
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(o.created_at AS DATE) >= ?");
            params.add(startDate);
            hasFilter = true;
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(o.created_at AS DATE) <= ?");
            params.add(endDate);
            hasFilter = true;
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("(c.full_name LIKE ? OR CAST(o.order_id AS NVARCHAR) LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            hasFilter = true;
        }
        if (transportUnitName != null && !transportUnitName.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("t.company_name LIKE ?");
            params.add("%" + transportUnitName + "%");
            hasFilter = true;
        }
        if (warehouseName != null && !warehouseName.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("s.warehouse_name LIKE ?");
            params.add("%" + warehouseName + "%");
            hasFilter = true;
        }

        LOGGER.info("Executing query: " + query.toString());
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
                LOGGER.info("Setting param " + (i + 1) + ": " + params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setCustomerName(rs.getString("customer_name"));
                order.setTransportUnitId(rs.getObject("transport_unit_id") != null ? rs.getInt("transport_unit_id") : null);
                order.setTransportUnitName(rs.getString("transport_unit_name"));
                order.setStorageUnitId(rs.getObject("storage_unit_id") != null ? rs.getInt("storage_unit_id") : null);
                order.setStorageUnitName(rs.getString("storage_unit_name"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setTotalFee(rs.getBigDecimal("total_fee"));
                order.setDeliveredAt(rs.getTimestamp("delivered_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
                order.setAcceptedAt(rs.getTimestamp("accepted_at"));
                orders.add(order);
                LOGGER.info("Added order: " + order.getOrderId() + ", customer_name: " + order.getCustomerName());
            }
            LOGGER.info("Fetched " + count + " orders");
        } catch (SQLException e) {
            throw e;
        }
        return orders;
    }

    public List<CustomerSurvey> getFilteredSurveys(String startDate, String endDate, String keyword) throws SQLException {
        List<CustomerSurvey> surveys = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT survey_id, survey_date, user_id, overall_satisfaction, recommend_score, transport_care, "
                + "consultant_professionalism, expectation, packing_quality, item_condition, delivery_timeliness, booking_process, "
                + "response_time, price_transparency, age_group, area, housing_type, usage_frequency, important_factor, "
                + "additional_service, feedback FROM CustomerSurvey"
        );

        List<Object> params = new ArrayList<>();
        boolean hasFilter = false;

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(survey_date AS DATE) >= ?");
            params.add(startDate);
            hasFilter = true;
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(survey_date AS DATE) <= ?");
            params.add(endDate);
            hasFilter = true;
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("feedback LIKE ?");
            params.add("%" + keyword + "%");
            hasFilter = true;
        }

        LOGGER.info("Executing query: " + query.toString());
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
                LOGGER.info("Setting param " + (i + 1) + ": " + params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                CustomerSurvey survey = new CustomerSurvey();
                survey.setSurveyId(rs.getInt("survey_id"));
                survey.setSurveyDate(rs.getString("survey_date"));
                survey.setUserId(rs.getInt("user_id"));
                survey.setOverall_satisfaction(rs.getInt("overall_satisfaction"));
                survey.setRecommend_score(rs.getInt("recommend_score"));
                survey.setTransport_care(rs.getInt("transport_care"));
                survey.setConsultant_professionalism(rs.getInt("consultant_professionalism"));
                survey.setExpectation(rs.getString("expectation"));
                survey.setPacking_quality(rs.getString("packing_quality"));
                survey.setItem_condition(rs.getString("item_condition"));
                survey.setDelivery_timeliness(rs.getString("delivery_timeliness"));
                survey.setBooking_process(rs.getString("booking_process"));
                survey.setResponse_time(rs.getString("response_time"));
                survey.setPrice_transparency(rs.getString("price_transparency"));
                survey.setAge_group(rs.getString("age_group"));
                survey.setArea(rs.getString("area"));
                survey.setHousing_type(rs.getString("housing_type"));
                survey.setUsage_frequency(rs.getString("usage_frequency"));
                survey.setImportant_factor(rs.getString("important_factor"));
                survey.setAdditional_service(rs.getString("additional_service"));
                survey.setFeedback(rs.getString("feedback"));
                surveys.add(survey);
                LOGGER.info("Added survey: " + survey.getSurveyId() + ", feedback: " + survey.getFeedback());
            }
            LOGGER.info("Fetched " + count + " surveys");
        } catch (SQLException e) {
            throw e;
        }
        return surveys;
    }

    public List<TransportReport1> getFilteredTransportReports(String startDate, String endDate, String keyword) throws SQLException {
        List<TransportReport1> reports = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT r.report_id, r.transport_unit_id, r.report_year, r.report_month, r.total_shipments, r.total_revenue, "
                + "r.planned_revenue, r.total_weight, r.on_time_count, r.cancel_count, r.delay_count, r.created_at, t.company_name "
                + "FROM TransportReport r LEFT JOIN TransportUnits t ON r.transport_unit_id = t.transport_unit_id"
        );

        List<Object> params = new ArrayList<>();
        boolean hasFilter = false;

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(r.created_at AS DATE) >= ?");
            params.add(startDate);
            hasFilter = true;
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("CAST(r.created_at AS DATE) <= ?");
            params.add(endDate);
            hasFilter = true;
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("t.company_name LIKE ?");
            params.add("%" + keyword + "%");
            hasFilter = true;
        }

        LOGGER.info("Executing query: " + query.toString());
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
                LOGGER.info("Setting param " + (i + 1) + ": " + params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                TransportReport1 report = new TransportReport1();
                report.setReportId(rs.getInt("report_id"));
                report.setTransportUnitId(rs.getInt("transport_unit_id"));
                report.setReportYear(rs.getInt("report_year"));
                report.setReportMonth(rs.getInt("report_month"));
                report.setTotalShipments(rs.getInt("total_shipments"));
                report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                report.setPlannedRevenue(rs.getBigDecimal("planned_revenue"));
                report.setTotalWeight(rs.getBigDecimal("total_weight"));
                report.setOnTimeCount(rs.getInt("on_time_count"));
                report.setCancelCount(rs.getInt("cancel_count"));
                report.setDelayCount(rs.getInt("delay_count"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setCompanyName(rs.getString("company_name"));
                reports.add(report);
                LOGGER.info("Added report: " + report.getReportId() + ", company_name: " + report.getCompanyName());
            }
            LOGGER.info("Fetched " + count + " transport reports");
        } catch (SQLException e) {
            throw e;
        }
        return reports;
    }

    public List<StorageReport> getFilteredStorageReports(String startDate, String endDate, String keyword) throws SQLException {
        List<StorageReport> reports = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT r.report_date, r.storage_unit_id, r.quantity_on_hand, r.used_area, r.total_area, r.order_count, "
                + "r.inbound_count, r.outbound_count, r.returned_orders, r.personnel_cost, r.maintenance_cost, "
                + "r.storage_cost_per_unit, r.profit, r.average_storage_duration, r.insurance_cost, s.warehouse_name "
                + "FROM StorageReport r LEFT JOIN StorageUnits s ON r.storage_unit_id = s.storage_unit_id"
        );

        List<Object> params = new ArrayList<>();
        boolean hasFilter = false;

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("r.report_date >= ?");
            params.add(startDate);
            hasFilter = true;
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("r.report_date <= ?");
            params.add(endDate);
            hasFilter = true;
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(hasFilter ? " AND " : " WHERE ").append("s.warehouse_name LIKE ?");
            params.add("%" + keyword + "%");
            hasFilter = true;
        }

        LOGGER.info("Executing query: " + query.toString());
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
                LOGGER.info("Setting param " + (i + 1) + ": " + params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                StorageReport report = new StorageReport();
                report.setReportDate(rs.getString("report_date"));
                report.setStorageUnitId(rs.getInt("storage_unit_id"));
                report.setQuantityOnHand(rs.getInt("quantity_on_hand"));
                report.setUsedArea(rs.getDouble("used_area"));
                report.setTotalArea(rs.getDouble("total_area"));
                report.setOrderCount(rs.getInt("order_count"));
                report.setInboundCount(rs.getInt("inbound_count"));
                report.setOutboundCount(rs.getInt("outbound_count"));
                report.setReturnedOrders(rs.getInt("returned_orders"));
                report.setPersonnelCost(rs.getDouble("personnel_cost"));
                report.setMaintenanceCost(rs.getDouble("maintenance_cost"));
                report.setStorageCostPerUnit(rs.getDouble("storage_cost_per_unit"));
                report.setProfit(rs.getDouble("profit"));
                report.setAverageStorageDuration(rs.getInt("average_storage_duration"));
                report.setInsuranceCost(rs.getDouble("insurance_cost"));
                report.setWarehouseName(rs.getString("warehouse_name"));
                reports.add(report);
                LOGGER.info("Added report: " + report.getReportDate() + ", storage_unit_id: " + report.getStorageUnitId()
                        + ", warehouse_name: " + report.getWarehouseName() + ", profit: " + report.getProfit());
            }
            LOGGER.info("Fetched " + count + " storage reports");
        } catch (SQLException e) {
            throw e;
        }
        return reports;
    }

}
