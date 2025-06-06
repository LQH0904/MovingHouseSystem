package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
public class DBConnection {
   
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=systemhouse1;encrypt=true;trustServerCertificate=true";
    private static final String USERNAME = "sa"; 
    private static final String PASSWORD = "123";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to load JDBC driver.", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        // Sử dụng DriverManager để kết nối với URL, USERNAME và PASSWORD đã khai báo
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    public static void main(String[] args) {
        try (Connection connection = DBConnection.getConnection()) {
            if (connection != null) {
                System.out.println("Kết nối thành công đến cơ sở dữ liệu!");
            } else {
                System.out.println("Kết nối thất bại!");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi kết nối đến cơ sở dữ liệu:");
            e.printStackTrace(); // In stack trace để xem chi tiết lỗi
        }
    }
}