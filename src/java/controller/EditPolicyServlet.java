/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.OperationPolicyDAO;
import dao.OperationPolicyDAO;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;
import model.OperationPolicy;

/**
 *
 * @author admin
 */
@WebServlet("/edit-policy")

public class EditPolicyServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
    System.out.println(">> ✅ Đã vào EditPolicyServlet với id = " + request.getParameter("id")); // Thêm dòng này

    int id = Integer.parseInt(request.getParameter("id"));
    OperationPolicyDAO dao = new OperationPolicyDAO();
    OperationPolicy p = dao.getById(id);

    if (p != null) {
        request.setAttribute("id", p.getId());
        request.setAttribute("policyTitle", p.getPolicyTitle());
        request.setAttribute("policyContent", p.getPolicyContent());
        request.getRequestDispatcher("/page/operator/EditOperationPolicy.jsp").forward(request, response);
    } else {
        response.sendRedirect("operation-policy");
    }
}


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // Trong file controller/EditPolicyServlet.java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    String policyTitle = request.getParameter("policyTitle");

    // Logic lấy nội dung của bạn đã đúng
    List<String> contents = new ArrayList<>();
    Enumeration<String> paramNames = request.getParameterNames();
    while (paramNames.hasMoreElements()) {
        String name = paramNames.nextElement();
        if (name.startsWith("content")) {
            String value = request.getParameter(name).trim();
            if (!value.isEmpty()) {
                contents.add(value);
            }
        }
    }

    StringBuilder fullContent = new StringBuilder();
    for (String c : contents) {
        fullContent.append(". ").append(c).append("\n");
    }

    OperationPolicyDAO dao = new OperationPolicyDAO();
    
    // ✅ THÊM DÒNG NÀY: Lấy policy cũ để có được policy_number
    OperationPolicy oldPolicy = dao.getById(id);

    // Sử dụng oldPolicy.getPolicyNumber() thay vì số 0
    OperationPolicy updated = new OperationPolicy(
            id, 
            oldPolicy.getPolicyNumber(), // Giữ lại số thứ tự cũ
            policyTitle.trim(), 
            fullContent.toString().trim()
    );
    
    // Hàm update của bạn trong DAO không cập nhật policy_number, nên cách này là đúng
    dao.updatePolicy(updated);

    response.sendRedirect("operation-policy");
}
}

/**
 * Returns a short description of the servlet.
 *
 * @return a String containing servlet description
 */
