//package controller;
//
//import dao.AlertComplaintDAO;
//import model.AlertComplaint;
//import utils.MailUtil;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/send-warning")
//public class SendWarningServlet extends HttpServlet {
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//        try {
//            // Bước 1: Lấy dữ liệu từ request
//            int unitId = Integer.parseInt(request.getParameter("unitId"));
//            String unitType = request.getParameter("unitType");
//
//            // Bước 2: Lấy thông tin đơn vị
//            AlertComplaintDAO dao = new AlertComplaintDAO();
//            AlertComplaint unit = dao.getUnitById(unitId, unitType);
//
//            if (unit != null && unit.getEmail() != null) {
//                // Bước 3: Gửi email cảnh báo
//                String subject = "[Cảnh báo] Phản ánh tiêu cực từ khách hàng";
//                String content = String.format("""
//                    Xin chào %s,
//
//                    Hệ thống ghi nhận rằng đơn vị của bạn đã nhận được %d phản ánh từ khách hàng.
//
//                    Trạng thái hiện tại: %s
//
//                    Vui lòng kiểm tra và cải thiện chất lượng dịch vụ để tránh bị xử lý theo quy định.
//
//                    Trân trọng,
//                    Hệ thống quản lý vận hành
//                    """, unit.getUnitName(), unit.getIssueCount(), unit.getIssueStatus());
//
//                boolean sent = MailUtil.sendWarningEmail(unit.getEmail(), subject, content);
//
//                // Bước 4: Đánh dấu đã gửi cảnh báo nếu email gửi thành công
//                if (sent) {
//                    dao.markWarningSent(unitId, unitType);
//                    request.getSession().setAttribute("successMessage", "Email cảnh báo đã được gửi thành công.");
//                } else {
//                    request.getSession().setAttribute("errorMessage", "Gửi email thất bại.");
//                }
//
//            } else {
//                request.getSession().setAttribute("errorMessage", "Không tìm thấy đơn vị hoặc email.");
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.getSession().setAttribute("errorMessage", "Đã xảy ra lỗi khi gửi email.");
//        }
//
//        // Bước 5: Redirect về lại trang danh sách
//        response.sendRedirect(request.getContextPath() + "/operator/alert-complaint");
//
//    }
//}
