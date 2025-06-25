<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.OperationProcedure"%>
<%@page import="model.OperationPolicy"%>
<%@page import="model.FeeConfiguration"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chính sách</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login/CheckProPoliFee.css">
</head>
<body>

<div class="policy-box">
    <label>
        <input type="checkbox" id="agreeCheck" onchange="toggleButton()"> Tôi đồng ý với 
        <span class="policy-link" onclick="showModal()">các chính sách</span> của nhà phát triển.
    </label>
    <br>
    <button id="confirmBtn" disabled>Xác nhận</button>
</div>

<!-- Modal -->
<div class="overlay" id="overlay" onclick="hideModal()"></div>
<div class="modal" id="policyModal">
    <span class="modal-close" onclick="hideModal()">×</span>
    <h3>Thông tin Chính sách</h3>

    <h4>1. Quy trình hoạt động</h4>
<%
    List<OperationProcedure> procedures = (List<OperationProcedure>) request.getAttribute("procedureList");
    if (procedures != null) {
        for (OperationProcedure p : procedures) {
%>
<div class="policy-item">
    <div class="title"><%= p.getStepNumber() %>. <%= p.getStepTitle() %></div>
    <div class="content"><%= p.getStepDescription().replaceFirst("^[\\n\\r]+", "") %></div>
</div>
<%
        }
    } else {
%>
<div class="policy-item">
    <div class="content">Không có dữ liệu Quy trình hoạt động.</div>
</div>
<%
    }
%>

<h4>2. Chính sách hoạt động</h4>
<%
    List<OperationPolicy> policies = (List<OperationPolicy>) request.getAttribute("policyList");
    if (policies != null) {
        for (OperationPolicy p : policies) {
%>
<div class="policy-item">
    <div class="title"><%= p.getPolicyNumber() %>. <%= p.getPolicyTitle() %></div>
    <div class="content"><%= p.getPolicyContent() %></div>
</div>
<%
        }
    } else {
%>
<div class="policy-item">
    <div class="content">Không có dữ liệu Chính sách hoạt động.</div>
</div>
<%
    }
%>

<h4>3. Cấu hình phí</h4>
<%
    List<FeeConfiguration> fees = (List<FeeConfiguration>) request.getAttribute("feeList");
    if (fees != null) {
        for (FeeConfiguration f : fees) {
%>
<div class="policy-item">
    <div class="title"><%= f.getFeeNumber() %>. <%= f.getFeeType() %></div>
    <div class="content"><%= f.getDescription() %></div>
</div>
<%
        }
    } else {
%>
<div class="policy-item">
    <div class="content">Không có dữ liệu Cấu hình phí.</div>
</div>
<%
    }
%>


<script>
    function toggleButton() {
        const checkbox = document.getElementById("agreeCheck");
        const button = document.getElementById("confirmBtn");
        button.disabled = !checkbox.checked;
    }

    function showModal() {
        document.getElementById("overlay").style.display = "block";
        document.getElementById("policyModal").style.display = "block";
    }

    function hideModal() {
        document.getElementById("overlay").style.display = "none";
        document.getElementById("policyModal").style.display = "none";
    }
</script>

</body>
</html>
