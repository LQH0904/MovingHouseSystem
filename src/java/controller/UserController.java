package controller;

import dao.UserDAO;
import model.User;
import java.sql.*;
import java.util.List;

public class UserController {
    private UserDAO userDAO;

    public UserController() {
        this.userDAO = new UserDAO();  
    }

    public List<User> showUserList() throws SQLException {
        return userDAO.getAllUsers();  
    }
}
