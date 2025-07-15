package utils;

import java.security.MessageDigest;

public class HashUtil {

    public static String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashed = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hashed) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public static boolean checkPassword(String inputPassword, String storedHash) throws Exception {
        String hashedInput = hashPassword(inputPassword);
        return hashedInput.equals(storedHash);
    }
}
