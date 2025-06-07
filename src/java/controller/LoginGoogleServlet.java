
package controller;

import dao.UserDAO;
import model.Constants;
import model.Users;
import model.Roles;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/LoginGoogleServlet"})
public class LoginGoogleServlet extends HttpServlet {

    /**
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");
            HttpSession session = request.getSession();
            String code = request.getParameter("code");
            Users a = null;

            if (code == null || code.isEmpty()) {
                response.sendRedirect("LoginServlet");
            } else {
                String accessToken = getToken(code);
                model.LoginGoogle user = getUserInfo(accessToken);
                String email = user.getEmail();

                UserDAO adao = new UserDAO();
                Users aemail = adao.checkUserByEmail(email);

                if (aemail == null) {
                    // Tạo user mới
                    a = new Users(
                            -1,
                            user.getName(),
                            email,
                            "google_oauth",
                            6,
                            null,
                            null,
                            "active"
                    );

                    boolean success = adao.signupAccount(a);
                    if (!success) {
                        request.setAttribute("error", "Không thể tạo tài khoản mới.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }

                    a = adao.getUserbyEmail(email);
                } else {
                    a = aemail;
                }

                // Tạo session mới để tránh session fixation
                session.invalidate();
                session = request.getSession(true);
                session.setAttribute("acc", a);

                // Redirect thay vì forward để ẩn URL tham số code
                response.sendRedirect("loginSuccess.jsp");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Đăng nhập bằng Google gặp lỗi, vui lòng thử lại.");
            //  redirect về login.jsp 
            response.sendRedirect("login.jsp");
        }
    }

    // Lấy token access từ google
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

    // Lấy thông tin người dùng từ Google bằng accessToken
    public static model.LoginGoogle getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Constants.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, model.LoginGoogle.class);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
