<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String issueId = request.getParameter("issueId");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>Chi tiết khiếu nại</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body class="p-4">
<%
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=systemhouse1;user=sa;password=123456;";
        conn = DriverManager.getConnection(dbURL);

        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at " +
                     "FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE i.issue_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(issueId));
        rs = ps.executeQuery();

        if (rs.next()) {
%>
    <h3>Chi tiết Khiếu nại #<%= rs.getInt("issue_id") %></h3>
    <ul class="list-group mb-4">
        <li class="list-group-item"><strong>Người gửi:</strong> <%= rs.getString("username") %></li>
        <li class="list-group-item"><strong>Mô tả:</strong> <%= rs.getString("description") %></li>
        <li class="list-group-item"><strong>Trạng thái:</strong> <%= rs.getString("status") %></li>
        <li class="list-group-item"><strong>Ưu tiên:</strong> <%= rs.getString("priority") %></li>
        <li class="list-group-item"><strong>Ngày tạo:</strong> <%= rs.getTimestamp("created_at") %></li>
        <li class="list-group-item"><strong>Ngày xử lý:</strong> <%= rs.getTimestamp("resolved_at") != null ? rs.getTimestamp("resolved_at") : "Chưa xử lý" %></li>
    </ul>

    <a href="replyComplaint.jsp?issueId=<%= rs.getInt("issue_id") %>" class="btn btn-primary">Trả lời / Cập nhật</a>
<%
        } else {
            out.println("<div class='alert alert-danger'>Không tìm thấy khiếu nại!</div>");
        }
    } catch (Exception e) {
        out.println("<div class='text-danger'>Lỗi: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>
