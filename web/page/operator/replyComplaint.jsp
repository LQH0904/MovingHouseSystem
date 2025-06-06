<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String issueId = request.getParameter("issueId");
    String status = request.getParameter("status");
    String reply = request.getParameter("reply");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=systemhouse1;user=sa;password=123456;";
            conn = DriverManager.getConnection(dbURL);

            String sql = "UPDATE Issues SET status = ?, resolved_at = GETDATE() WHERE issue_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(issueId));
            ps.executeUpdate();

            response.sendRedirect("complaintDetail.jsp?issueId=" + issueId);
            return;
        } catch (Exception e) {
            out.println("<div class='text-danger'>Lỗi: " + e.getMessage() + "</div>");
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
%>
<html>
<head>
    <title>Trả lời khiếu nại</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">
    <h3>Trả lời / Cập nhật Khiếu nại #<%= issueId %></h3>
    <form method="post">
        <div class="mb-3">
            <label for="status" class="form-label">Trạng thái mới</label>
            <select name="status" class="form-select" required>
                <option value="">-- Chọn --</option>
                <option value="in_progress">Đang xử lý</option>
                <option value="resolved">Đã xử lý</option>
                <option value="escalated">Chuyển cấp cao</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Cập nhật</button>
        <a href="complaintDetail.jsp?issueId=<%= issueId %>" class="btn btn-secondary">Hủy</a>
    </form>
</body>
</html>
