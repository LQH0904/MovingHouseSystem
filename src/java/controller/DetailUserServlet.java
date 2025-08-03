// controller/DetailUserServlet.java (PHIÊN BẢN ĐÚNG VÀ HOÀN CHỈNH)
package controller;

import dao.TransportUnitDAO;
import dao.StorageUnitDAO;
import dao.UserDAO;
import model.TransportUnit4; // Đảm bảo import đúng model
import model.StorageUnit;
import model.User;          // Model User này có vẻ khác với model Users trong LoginServlet, hãy chắc chắn bạn đang dùng đúng model ở đây

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DetailUserServlet") // Giữ nguyên URL pattern của bạn
public class DetailUserServlet extends HttpServlet {

    // CHUYỂN TOÀN BỘ LOGIC SANG doGet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = 0;
        try {
            userId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ.");
            request.getRequestDispatcher("/page/error.jsp").forward(request, response);
            return;
        }
        
        // Khởi tạo các DAO
        UserDAO userDAO = new UserDAO();
        TransportUnitDAO tDao = new TransportUnitDAO();
        StorageUnitDAO sDao = new StorageUnitDAO();

        try {
            // Lấy thông tin User cơ bản để xác định vai trò
            User user = userDAO.getUserById(userId);

            if (user == null) {
                request.setAttribute("error", "Không tìm thấy người dùng với ID=" + userId);
                request.getRequestDispatcher("/page/error.jsp").forward(request, response);
                return;
            }

            // Dựa vào code bạn cung cấp, roleId=1 là Admin
            if (user.getRole().getRoleId() == 1) {
                request.setAttribute("error", "Không thể xem chi tiết Admin.");
                request.getRequestDispatcher("/page/error.jsp").forward(request, response);
                return;
            }

            int roleId = user.getRole().getRoleId();
            
            // Giữ nguyên logic xử lý đa vai trò của bạn
            if (roleId == 2 || roleId == 3 || roleId == 6) {
                // Đối với các vai trò này, chỉ cần thông tin user cơ bản
                request.setAttribute("user", user);
                
            } else if (roleId == 4) {
                // Nếu là Transport Unit, lấy thêm thông tin chi tiết
                TransportUnit4 unit = tDao.getByUserId(userId);
                request.setAttribute("transportUnit", unit); // Đặt tên là "transportUnit"
                
            } else if (roleId == 5) {
                // Nếu là Storage Unit, lấy thêm thông tin chi tiết
                StorageUnit unit = sDao.getByUserId(userId);
                request.setAttribute("storageUnit", unit); // Đặt tên là "storageUnit"
            }
            
            // Luôn đặt roleId để JSP có thể dùng để kiểm tra và hiển thị đúng phần
            request.setAttribute("roleId", roleId); 
            
            // Chuyển tiếp đến cùng một trang JSP
            request.getRequestDispatcher("/page/operator/UserDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/page/error.jsp").forward(request, response);
        }
    }

    // (Tùy chọn) Bạn có thể để doPost gọi doGet để nó hoạt động trong cả 2 trường hợp
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}