package controller.reportSummary;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SurveyConfigController", urlPatterns = {"/survey-update"})
public class SurveyConfigController extends HttpServlet {

    private Gson gson;

    @Override
    public void init() throws ServletException {
        gson = new Gson();
        System.out.println("=== SurveyConfigController khởi tạo thành công ===");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== SurveyConfigController được gọi ===");
        System.out.println("URI: " + request.getRequestURI());
        System.out.println("PathInfo: " + request.getPathInfo());

        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.startsWith("/file/")) {
                String fileName = pathInfo.substring(6); // Bỏ "/file/" và thêm .txt
                // Sau đó kiểm tra và thêm .txt nếu cần
                if (!fileName.endsWith(".txt")) {
                    fileName += ".txt";
                }
                System.out.println("Đọc file: " + fileName);
                handleFileRead(fileName, out);
            } else {
                System.out.println("PathInfo không hợp lệ: " + pathInfo);
                sendErrorResponse(out, "Đường dẫn không hợp lệ", 400);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong doGet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, "Lỗi server: " + e.getMessage(), 500);
        }
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== SurveyConfigController POST được gọi ===");

        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.startsWith("/file/")) {
                String fileName = pathInfo.substring(6);
                String optionsParam = request.getParameter("options");

                if (optionsParam != null) {
                    handleFileWrite(fileName, optionsParam, out);
                } else {
                    sendErrorResponse(out, "Thiếu dữ liệu options", 400);
                }
            } else {
                sendErrorResponse(out, "Đường dẫn không hợp lệ", 400);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong doPost: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, "Lỗi server: " + e.getMessage(), 500);
        }
    }

    /**
     * Đọc file và trả về danh sách options
     */
    private void handleFileRead(String fileName, PrintWriter out) {
        try {
            // Lấy đường dẫn thực tế đến file trong web application
            String filePath = getServletContext().getRealPath("/page/survey/" + fileName);
            System.out.println("Đường dẫn file: " + filePath);

            if (filePath == null) {
                System.err.println("Không thể xác định đường dẫn file");
                sendErrorResponse(out, "Không thể xác định đường dẫn file", 500);
                return;
            }

            // Kiểm tra file có tồn tại không
            if (!Files.exists(Paths.get(filePath))) {
                System.err.println("File không tồn tại: " + filePath);
                sendErrorResponse(out, "File không tồn tại: " + filePath, 404);
                return;
            }

            // Đọc file
            List<String> lines = Files.readAllLines(Paths.get(filePath), StandardCharsets.UTF_8);
            System.out.println("Đọc được " + lines.size() + " dòng từ file " + fileName);

            // Lọc bỏ các dòng trống
            lines.removeIf(line -> line.trim().isEmpty());

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("data", lines);
            result.put("fileName", fileName);

            String jsonResponse = gson.toJson(result);
            System.out.println("Response JSON: " + jsonResponse);
            out.print(jsonResponse);

        } catch (IOException e) {
            System.err.println("Lỗi đọc file " + fileName + ": " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, "Lỗi đọc file " + fileName + ": " + e.getMessage(), 500);
        }
    }

    /**
     * Ghi file với danh sách options mới
     */
    private void handleFileWrite(String fileName, String optionsJson, PrintWriter out) {
        try {
            System.out.println("Ghi file: " + fileName);
            System.out.println("Options JSON: " + optionsJson);

            // Parse JSON options
            String[] options = gson.fromJson(optionsJson, String[].class);

            if (options == null || options.length == 0) {
                sendErrorResponse(out, "Danh sách options không được để trống", 400);
                return;
            }

            // Lấy đường dẫn thực tế đến file
            String filePath = getServletContext().getRealPath("/page/survey/" + fileName);
            System.out.println("Ghi vào đường dẫn: " + filePath);

            if (filePath == null) {
                sendErrorResponse(out, "Không thể xác định đường dẫn file", 500);
                return;
            }

            // Ghi file
            Files.write(Paths.get(filePath), List.of(options), StandardCharsets.UTF_8);
            System.out.println("Ghi file thành công: " + fileName);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Cập nhật file " + fileName + " thành công");
            result.put("data", List.of(options));

            out.print(gson.toJson(result));

        } catch (Exception e) {
            System.err.println("Lỗi ghi file " + fileName + ": " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(out, "Lỗi ghi file " + fileName + ": " + e.getMessage(), 500);
        }
    }

    /**
     * Gửi response lỗi
     */
    private void sendErrorResponse(PrintWriter out, String message, int statusCode) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        error.put("statusCode", statusCode);

        String jsonError = gson.toJson(error);
        System.err.println("Error response: " + jsonError);
        out.print(jsonError);
    }
    
    
}
