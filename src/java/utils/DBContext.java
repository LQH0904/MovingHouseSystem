/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
//    conn: quan ly ket noi sql va database, cac cau lenh sql thuc hien thong qua conn.
    public Connection conn=null;
    
//    URl: String connection : chuoi chua serverName, DBName dung ket noi
//    userName, password: account of sql        
    public DBContext(String URL, String userName, String password){
        try {
            //        call driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // connect
            conn = DriverManager.getConnection(URL, userName, password);
            System.out.println("Connected");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public DBContext(){
        this("jdbc:sqlserver://localhost:1433;databaseName=systemhouse1", "sa", "123");
    }
    public ResultSet getData(String sql){
        ResultSet rs = null;
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            rs = state.executeQuery(sql);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    public static void main(String[] args) {
        new DBContext();
    }
}
