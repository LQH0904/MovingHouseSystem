package controller;

import dao.OperatorComplaintDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AssignComplaintServlet", urlPatterns = {"/assignComplaint"})
public class AssignComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");
        String operatorUserIdParam = request.getParameter("operatorUserId");

        if (issueIdParam != null && !issueIdParam.isEmpty() &&
            operatorUserIdParam != null && !operatorUserIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                int operatorUserId = Integer.parseInt(operatorUserIdParam);

                boolean success = complaintDAO.assignComplaintToOperator(issueId, operatorUserId);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=success&message=Gán_người_phụ_trách_thành_công!");
                } else {
                    response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=Không_thể_gán_người_phụ_trách.");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=ID_không_hợp_lệ.");
            }
        } else {
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=Thiếu_thông_tin_gán.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}