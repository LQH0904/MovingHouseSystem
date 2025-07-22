package controller;

import dao.QueryCounter;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import listener.SessionCounterListener;

import java.io.IOException;

@WebServlet("/admin/system-performance")
public class SystemPerformanceController extends HttpServlet {

    private static int requestCount = 0;
    private static long totalResponseTime = 0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.nanoTime();

        requestCount++;

        // Lấy thông tin JVM
        Runtime runtime = Runtime.getRuntime();
        long usedMemory = runtime.totalMemory() - runtime.freeMemory();
        long freeMemory = runtime.freeMemory();
        long totalMemory = runtime.totalMemory();
        long maxMemory = runtime.maxMemory();

        // Tính thời gian trung bình xử lý
        long endTime = System.nanoTime();
        long currentResponseTime = endTime - startTime/1_000_000;
        totalResponseTime += currentResponseTime;
        long avgResponseTime = totalResponseTime / requestCount;

        // Gửi sang JSP
        request.setAttribute("usedMemory", usedMemory / (1024 * 1024));
        request.setAttribute("freeMemory", freeMemory / (1024 * 1024));
        request.setAttribute("totalMemory", totalMemory / (1024 * 1024));
        request.setAttribute("maxMemory", maxMemory / (1024 * 1024));
        request.setAttribute("activeSessions", SessionCounterListener.activeSessions);
        request.setAttribute("totalQueries", QueryCounter.getQueryCount());
        request.setAttribute("requestCount", requestCount);
        request.setAttribute("avgResponseTime", avgResponseTime);

        request.getRequestDispatcher("/page/admin/system-performance.jsp").forward(request, response);
    }
}
