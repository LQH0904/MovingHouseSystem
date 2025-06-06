<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.ComplaintDAO" %>
<%@ page import="model.Complaint" %>

<%
    // Lấy issueId từ request
    String issueIdParam = request.getParameter("issueId");
    int issueId = -1; // Giá trị mặc định
    Complaint currentComplaint = null; // Đối tượng khiếu nại hiện tại
    ComplaintDAO complaintDAO = new ComplaintDAO(); // Khởi tạo DAO để lấy dữ liệu

    // Cố gắng chuyển đổi issueId sang số nguyên và lấy thông tin khiếu nại
    try {
        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            issueId = Integer.parseInt(issueIdParam);
            currentComplaint = complaintDAO.getComplaintById(issueId);
        }
    } catch (NumberFormatException e) {
        // Log lỗi và hiển thị thông báo cho người dùng nếu ID không hợp lệ
        System.err.println("Lỗi: ID khiếu nại không hợp lệ trong replyComplaint.jsp. ID nhận được: " + issueIdParam);
        out.println("<div class='alert alert-danger'>Lỗi: ID khiếu nại không hợp lệ. Vui lòng kiểm tra lại.</div>");
        e.printStackTrace();
    }

    // Lấy thông báo từ Servlet (nếu có redirect từ ReplyComplaintServlet)
    // Tham số 'updateStatus' được sử dụng để hiển thị thông báo thành công/thất bại
    String updateStatus = request.getParameter("updateStatus");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khiếu nại và Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Có thể thêm các CSS tùy chỉnh khác nếu cần, ví dụ: -->
    <%--
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    --%>
</head>
<body class="p-4 bg-light">
    <div class="container bg-white p-5 rounded shadow-sm">
        <h3 class="mb-4 text-primary border-bottom pb-2">Chi tiết Khiếu nại #<%= (issueId != -1) ? issueId : "Không xác định" %></h3>

        <%-- Hiển thị thông báo phản hồi từ Servlet --%>
        <% if ("success".equals(updateStatus)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Thành công!</strong> Trạng thái khiếu nại đã được cập nhật.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("error".equals(updateStatus)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Lỗi!</strong> Không thể cập nhật trạng thái khiếu nại. Vui lòng thử lại.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% if (currentComplaint != null) { %>
        <div class="card mb-4 border-primary">
            <div class="card-header bg-primary text-white fs-5">
                Thông tin khiếu nại
            </div>
            <div class="card-body">
                <div class="row mb-2">
                    <div class="col-md-3"><strong>ID Khiếu nại:</strong></div>
                    <div class="col-md-9"><%= currentComplaint.getIssueId() %></div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-3"><strong>Người gửi:</strong></div>
                    <div class="col-md-9"><%= currentComplaint.getUsername() %></div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-3"><strong>Mô tả:</strong></div>
                    <div class="col-md-9"><%= currentComplaint.getDescription() %></div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-3"><strong>Trạng thái hiện tại:</strong></div>
                    <div class="col-md-9">
                        <span class="badge rounded-pill p-2
                            <%
                                String status = currentComplaint.getStatus();
                                if ("open".equals(status)) out.print("bg-secondary");
                                else if ("in_progress".equals(status)) out.print("bg-info text-dark");
                                else if ("resolved".equals(status)) out.print("bg-success");
                                else if ("escalated".equals(status)) out.print("bg-danger");
                                else out.print("bg-light text-dark"); // Fallback
                            %>">
                            <%= currentComplaint.getStatus() %>
                        </span>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-3"><strong>Ưu tiên:</strong></div>
                    <div class="col-md-9">
                        <span class="badge rounded-pill p-2
                            <%
                                String priority = currentComplaint.getPriority();
                                if ("high".equals(priority)) out.print("bg-warning text-dark");
                                else if ("normal".equals(priority)) out.print("bg-secondary");
                                else out.print("bg-light text-dark"); // Fallback
                            %>">
                            <%= currentComplaint.getPriority() %>
                        </span>
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-3"><strong>Ngày tạo:</strong></div>
                    <div class="col-md-9">
                        <%
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                            if (currentComplaint.getCreatedAt() != null) {
                                out.print(sdf.format(currentComplaint.getCreatedAt()));
                            } else {
                                out.print("Không có");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mb-3 text-primary border-bottom pb-2">Cập nhật Trạng thái Khiếu nại</h4>
        <form action="${pageContext.request.contextPath}/ReplyComplaintServlet" method="post" class="needs-validation" novalidate>
            <!-- Hidden input để gửi issueId đến Servlet -->
            <input type="hidden" name="issueId" value="<%= issueId %>">

            <div class="mb-3">
                <label for="status" class="form-label fw-bold">Trạng thái mới:</label>
                <select name="status" id="status" class="form-select" required>
                    <option value="">-- Chọn trạng thái --</option>
                    <option value="open" <%= (currentComplaint.getStatus().equals("open")) ? "selected" : "" %>>Mở</option>
                    <option value="in_progress" <%= (currentComplaint.getStatus().equals("in_progress")) ? "selected" : "" %>>Đang xử lý</option>
                    <option value="resolved" <%= (currentComplaint.getStatus().equals("resolved")) ? "selected" : "" %>>Đã xử lý</option>
                    <option value="escalated" <%= (currentComplaint.getStatus().equals("escalated")) ? "selected" : "" %>>Chuyển cấp cao</option>
                </select>
                <div class="invalid-feedback">Vui lòng chọn một trạng thái.</div>
            </div>

            <%-- Bạn có thể thêm trường nội dung phản hồi tại đây nếu cần --%>
            <%--
            <div class="mb-3">
                <label for="replyContent" class="form-label fw-bold">Nội dung phản hồi (Tùy chọn):</label>
                <textarea class="form-control" id="replyContent" name="replyContent" rows="4" placeholder="Nhập nội dung phản hồi của bạn..."></textarea>
            </div>
            --%>

            <button type="submit" class="btn btn-success me-2">
                <i class="bi bi-check-circle me-1"></i> Cập nhật trạng thái
            </button>
            <a href="${pageContext.request.contextPath}/page/operator/complaintList.jsp" class="btn btn-secondary">
                <i class="bi bi-arrow-left-circle me-1"></i> Quay lại danh sách
            </a>
        </form>

        <% } else { %>
        <div class="alert alert-warning text-center" role="alert">
            Không tìm thấy thông tin khiếu nại với ID: <%= (issueIdParam != null && !issueIdParam.isEmpty()) ? issueIdParam : "không xác định" %>.
            <br>Vui lòng kiểm tra lại ID khiếu nại hoặc quay lại <a href="${pageContext.request.contextPath}/page/operator/complaintList.jsp">danh sách khiếu nại</a>.
        </div>
        <% } %>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript for Bootstrap form validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>
