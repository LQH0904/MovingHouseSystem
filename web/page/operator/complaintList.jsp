<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, dao.ComplaintDAO, model.Complaint" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    <style>
        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        .table th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
        }

        .table td {
            vertical-align: middle;
        }

        .table a {
            color: #0d6efd;
            font-weight: 500;
        }

        .table a:hover {
            text-decoration: underline;
        }

        .badge {
            font-size: 0.9em;
            padding: 0.5em 0.75em;
            border-radius: 0.5rem;
            text-transform: capitalize;
        }

        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #f2f6f9;
        }

        h3.mb-4.text-primary {
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 0.5rem;
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-light">
<div class="parent">
    <div class="div1"><jsp:include page="../../Layout/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="../../Layout/Header.jsp"/></div>
    <div class="div3 px-4 pt-4">
        <h3 class="mb-4 text-primary">Danh sách khiếu nại</h3>

        <%
            ComplaintDAO dao = new ComplaintDAO();
            List<Complaint> list = dao.getAllComplaints();
        %>

        <div class="table-responsive">
            <table class="table table-bordered table-hover table-striped bg-white">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Người gửi</th>
                    <th>Mô tả</th>
                    <th>Trạng thái</th>
                    <th>Ưu tiên</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (list != null && !list.isEmpty()) {
                        for (Complaint c : list) {
                %>
                <tr>
                    <td><a href="complaintDetail.jsp?issueId=<%= c.getIssueId() %>" class="text-decoration-none"><%= c.getIssueId() %></a></td>
                    <td><%= c.getUsername() %></td>
                    <td><%= c.getDescription() %></td>
                    <td>
                        <span class="badge
                            <%
                                String status = c.getStatus();
                                if ("resolved".equals(status)) out.print("bg-success");
                                else if ("in_progress".equals(status)) out.print("bg-warning text-dark");
                                else if ("escalated".equals(status)) out.print("bg-danger");
                                else if ("open".equals(status)) out.print("bg-secondary");
                                else out.print("bg-secondary");
                            %>">
                            <%
                                if ("resolved".equals(status)) out.print("Đã xử lý");
                                else if ("in_progress".equals(status)) out.print("Đang xử lý");
                                else if ("escalated".equals(status)) out.print("Chuyển cấp cao");
                                else if ("open".equals(status)) out.print("Mở");
                                else out.print(status);
                            %>
                        </span>
                    </td>
                    <td>
                        <span class="badge
                            <%
                                String priority = c.getPriority();
                                if ("high".equals(priority)) out.print("bg-warning text-dark");
                                else if ("normal".equals(priority)) out.print("bg-secondary");
                                else if ("low".equals(priority)) out.print("bg-info text-dark");
                                else out.print("bg-light text-dark");
                            %>">
                            <%
                                if ("high".equals(priority)) out.print("Cao");
                                else if ("normal".equals(priority)) out.print("Bình thường");
                                else if ("low".equals(priority)) out.print("Thấp");
                                else out.print(priority);
                            %>
                        </span>
                    </td>
                    <td><%= c.getCreatedAt() != null ? c.getCreatedAt() : "N/A" %></td>
                    <td>
                        <a href="replyComplaint.jsp?issueId=<%= c.getIssueId() %>" class="btn btn-sm btn-info text-white">
                            <i class="bi bi-info-circle"></i> Chi tiết
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="text-center text-muted">Không có khiếu nại nào để hiển thị.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>