/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import model.Constants;
import model.Users;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.PasswordUtils;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/LoginGoogleServlet"})
public class LoginGoogleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("acc") != null) {
                Users user = (Users) session.getAttribute("acc");
                switch (user.getRoleId()) {
                    case 1:
                        response.sendRedirect(request.getContextPath() + "/admin/registrations");
                        break;
                    case 2:
                        response.sendRedirect(request.getContextPath() + "/homeOperator");
                        break;
                    case 3:
                        response.sendRedirect(request.getContextPath() + "/homeStaff");
                        break;
                    case 4:
                        response.sendRedirect(request.getContextPath() + "/transport/dashboard");
                        break;
                    case 5:
                        response.sendRedirect(request.getContextPath() + "/storage/dashboard");
                        break;
                    case 6:
                        response.sendRedirect(request.getContextPath() + "/customer/dashboard");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/orderList");
                        break;
                }
                return;
            }

            String code = request.getParameter("code");
            String state = request.getParameter("state");
            String roleIdStr = null;

            if (state != null && state.startsWith("role_id=")) {
                roleIdStr = state.substring("role_id=".length());
            }

            int roleId;
            try {
                roleId = Integer.parseInt(roleIdStr);
                if (roleId < 1 || roleId > 6) {
                    session = request.getSession(true);
                    session.setAttribute("error", "Vai trò không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
            } catch (NumberFormatException e) {
                session = request.getSession(true);
                session.setAttribute("error", "Vai trò không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (code == null || code.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String accessToken = getToken(code);
            model.LoginGoogle googleUser = getUserInfo(accessToken);
            String email = googleUser.getEmail();

            UserDAO dao = UserDAO.INSTANCE;
            Users user = dao.checkUserByEmail(email, roleId);

            if (user == null) {
                // Nếu email chưa tồn tại, tạo tài khoản mới với role_id = 6 (Customer)
                String hashedPassword = PasswordUtils.hashPassword("123");
                user = new Users(
                        -1,
                        googleUser.getName(),
                        email,
                        hashedPassword,
                        6, 
                        null,
                        null,
                        "active"
                );

                boolean success = dao.signupAccount(user);
                if (!success) {
                    session = request.getSession(true);
                    session.setAttribute("error", "Không thể tạo tài khoản mới");
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                user = dao.checkUserByEmail(email, 6);
            }

            if (!"active".equalsIgnoreCase(user.getStatus())) {
                session = request.getSession(true);
                session.setAttribute("error", "Tài khoản chưa được kích hoạt hoặc bị khóa");
                response.sendRedirect(request.getContextPath() + "/not_activite.jsp");
                return;
            }

            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("acc", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());

            switch (user.getRoleId()) {
                case 1:
                    response.sendRedirect(request.getContextPath() + "/admin/registrations");
                    break;
                case 2:
                    response.sendRedirect(request.getContextPath() + "/homeOperator");
                    break;
                case 3:
                    response.sendRedirect(request.getContextPath() + "/homeStaff");
                    break;
                case 4:
                    response.sendRedirect(request.getContextPath() + "/transport/dashboard");
                    break;
                case 5:
                    response.sendRedirect(request.getContextPath() + "/storage/dashboard");
                    break;
                case 6:
                    response.sendRedirect(request.getContextPath() + "/customer/dashboard");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/orderList");
                    break;
            }
        } catch (Exception ex) {
            HttpSession session = request.getSession(true);
            session.setAttribute("error", "Đăng nhập bằng Google gặp lỗi, vui lòng thử lại");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(Constants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", Constants.GOOGLE_CLIENT_ID)
                        .add("client_secret", Constants.GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", Constants.GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", Constants.GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static model.LoginGoogle getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Constants.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, model.LoginGoogle.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Google OAuth login servlet";
    }
}
