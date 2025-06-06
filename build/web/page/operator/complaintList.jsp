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

    <!-- ✅ Thêm CSS tùy chỉnh vào đây -->
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
                </tr>
                </thead>
                <tbody>
                <%
                    for (Complaint c : list) {
                %>
                <tr>
                    <td><a href="complaintDetail.jsp?issueId=<%= c.getIssueId() %>" class="text-decoration-none"><%= c.getIssueId() %></a></td>
                    <td><%= c.getUsername() %></td>
                    <td><%= c.getDescription() %></td>
                    <td>
                        <span class="badge 
                            <%= c.getStatus().equals("resolved") ? "bg-success" :
                                 c.getStatus().equals("in_progress") ? "bg-warning text-dark" :
                                 c.getStatus().equals("escalated") ? "bg-danger" :
                                 "bg-secondary" %>">
                            <%= c.getStatus() %>
                        </span>
                    </td>
                    <td><%= c.getPriority() %></td>
                    <td><%= c.getCreatedAt() %></td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
