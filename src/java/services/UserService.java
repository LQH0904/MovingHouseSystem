package services;

import dao.UserDAO;
import model.User;

import at.favre.lib.crypto.bcrypt.BCrypt;

import java.sql.SQLException;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User registerUser(String username, String password, String email, String role) throws SQLException {
        // Check if username or email already exists
        if (userDAO.getUserByUsername(username) != null) {
            return null; // Username already taken
        }

        // Hash password
        String hashedPassword = hashPassword(password);

        User newUser = new User(username, hashedPassword, email, role);
        int userId = userDAO.createUser(newUser);

        if (userId > 0) {
            newUser.setUserId(userId);
            return newUser;
        }
        return null;
    }

    public User loginUser(String username, String password) throws SQLException {
        User user = userDAO.getUserByUsername(username);
        if (user != null && verifyPassword(password, user.getPasswordHash())) {
            // Update last login time
            userDAO.updateLastLoginTime(user.getUserId());
            return user;
        }
        return null;
    }

    // Helper method to hash password
    private String hashPassword(String password) {
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }

    // Helper method to verify password
    private boolean verifyPassword(String password, String hashedPassword) {
        return BCrypt.verifyer().verify(password.toCharArray(), hashedPassword).verified;
    }

    public User getUserById(int userId) throws SQLException {
        return userDAO.getUserById(userId);
    }
}