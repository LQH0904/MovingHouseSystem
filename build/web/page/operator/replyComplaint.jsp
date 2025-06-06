<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.ComplaintDAO" %>
<%@ page import="model.Complaint" %>

<%
    // Get issueId from request
    String issueIdParam = request.getParameter("issueId");
    int issueId = -1; // Default value
    Complaint currentComplaint = null; // Current complaint object
    ComplaintDAO complaintDAO = new ComplaintDAO(); // Initialize DAO to fetch data

    // Attempt to convert issueId to integer and retrieve complaint information
    try {
        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            issueId = Integer.parseInt(issueIdParam);
            currentComplaint = complaintDAO.getComplaintById(issueId);
        }
    } catch (NumberFormatException e) {
        // Log error and display message to the user if ID is invalid
        System.err.println("Lỗi: ID khiếu nại không hợp lệ trong replyComplaint.jsp. ID nhận được: " + issueIdParam);
        e.printStackTrace();
    }

    // The 'updateStatus' parameter from URL is no longer directly used for display
    // as we will show success/failure via JavaScript modal on submission.
    String updateStatus = request.getParameter("updateStatus");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khiếu nại và Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="p-4 bg-light">
    <div class="container bg-white p-5 rounded shadow-sm">
        <h3 class="mb-4 text-primary border-bottom pb-2">Chi tiết Khiếu nại #<%= (issueId != -1) ? issueId : "Không xác định" %></h3>

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
                        <span id="currentStatusBadge" class="badge rounded-pill p-2
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

        <h4 class="mb-3 text-primary border-bottom pb-2">Trả lời Khiếu nại</h4>
        <form action="${pageContext.request.contextPath}/ReplyComplaintServlet" method="post" class="needs-validation" novalidate>
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

            <div class="mb-3">
                <label for="replyContent" class="form-label fw-bold">Nội dung phản hồi:</label>
                <textarea class="form-control" id="replyContent" name="replyContent" rows="4" placeholder="Nhập nội dung phản hồi của bạn..." **required**></textarea>
                <div class="invalid-feedback">Vui lòng nhập nội dung phản hồi.</div>
            </div>

            <button type="submit" class="btn btn-success me-2" onclick="showSuccessMessage(event)">
                <i class="bi bi-send-fill me-1"></i> Gửi phản hồi
            </button>

            <div id="successModal" class="modal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="successModalLabel">Thông báo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Gửi phản hồi thành công!
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>

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

        // Get parameters from URL (still useful if you have redirects from Servlet for other purposes)
        const urlParams = new URLSearchParams(window.location.search);
        const updateStatus = urlParams.get('updateStatus');
        const issueIdFromUrl = urlParams.get('issueId'); 

        const messageModal = new bootstrap.Modal(document.getElementById('messageModal'));
        const modalTitle = document.getElementById('messageModalLabel');
        const modalBody = document.getElementById('modalBodyContent');
        const currentStatusBadge = document.getElementById('currentStatusBadge'); // For optional UI update
        const statusSelect = document.getElementById('status'); // For optional UI update
        const replyContentTextarea = document.getElementById('replyContent'); // For clearing content

        // Display modal based on updateStatus parameter (from initial page load/redirect)
        window.onload = function() {
            if (updateStatus === 'success') {
                modalTitle.textContent = 'Cập nhật thành công!';
                modalBody.innerHTML = '<i class="bi bi-check-circle-fill text-success fs-3 me-2"></i> Trạng thái khiếu nại #' + issueIdFromUrl + ' đã được cập nhật.';
                messageModal.show();
            } else if (updateStatus === 'error') {
                modalTitle.textContent = 'Lỗi cập nhật!';
                modalBody.innerHTML = '<i class="bi bi-x-circle-fill text-danger fs-3 me-2"></i> Không thể cập nhật trạng thái khiếu nại #' + issueIdFromUrl + '. Vui lòng thử lại.';
                messageModal.show();
            }
            // Clear URL parameters after displaying message to prevent re-showing on refresh
            if (updateStatus) {
                const newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?issueId=' + issueIdFromUrl;
                window.history.replaceState({}, document.title, newUrl);
            }
        };

        // --- Logic for "Gửi phản hồi" button ---
        function showSuccessMessage(event) {
            event.preventDefault(); // Prevent default form submission

            const form = event.target.closest('form');

            // Manually trigger Bootstrap's validation display
            form.classList.add('was-validated');

            // Check if the form is valid (this includes the 'required' textarea)
            if (form.checkValidity()) {
                // If the form is valid, display the success modal
                var successModal = new bootstrap.Modal(document.getElementById('successModal'));
                successModal.show();

                // Optional: Update the displayed status on the page
                const newStatus = statusSelect.value;
                if (currentStatusBadge) {
                    currentStatusBadge.textContent = newStatus;
                    currentStatusBadge.className = 'badge rounded-pill p-2'; // Reset classes
                    if (newStatus === "open") currentStatusBadge.classList.add("bg-secondary");
                    else if (newStatus === "in_progress") currentStatusBadge.classList.add("bg-info", "text-dark");
                    else if (newStatus === "resolved") currentStatusBadge.classList.add("bg-success");
                    else if (newStatus === "escalated") currentStatusBadge.classList.add("bg-danger");
                    else currentStatusBadge.classList.add("bg-light", "text-dark");
                }
                
                // Optional: Clear the reply content and reset form validation state
                replyContentTextarea.value = ''; // Clear the text area
                form.classList.remove('was-validated'); // Reset validation styling
                statusSelect.value = ''; // Optionally reset the status selection to default "-- Chọn trạng thái --"
                
                // IMPORTANT: As per your request, the form data is NOT submitted to the server here.
                // If you need to send data to the server AND stay on the same page,
                // you would need to implement an AJAX call (e.g., using Fetch API) here
                // instead of simply preventing the default form submission and showing a modal.
            } else {
                // If the form is not valid, Bootstrap's built-in validation messages
                // (e.g., "Vui lòng nhập nội dung phản hồi.") will appear automatically.
                // No separate modal is needed for validation errors.
            }
        }
    </script>

    <div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="messageModalLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-flex align-items-center">
                    <div id="modalBodyContent"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>