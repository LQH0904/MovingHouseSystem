package dao;

import model.BankConfig;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BankConfigDAO {

    private Connection conn;

    public BankConfigDAO(Connection conn) {
        this.conn = conn;
    }

    public BankConfig getConfig() throws SQLException {
        String sql = "SELECT TOP 1 * FROM BankConfig ORDER BY updated_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BankConfig config = new BankConfig();
                config.setConfigId(rs.getInt("config_id"));
                config.setBankName(rs.getString("bank_name"));
                config.setAccountNumber(rs.getString("account_number"));
                config.setAccountName(rs.getString("account_name"));
                config.setUpdatedAt(rs.getTimestamp("updated_at"));
                return config;
            }
        }
        return null;
    }

    public void updateOrInsert(BankConfig config) throws SQLException {
        String sql = "INSERT INTO BankConfig (bank_name, account_number, account_name, updated_at) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, config.getBankName());
            ps.setString(2, config.getAccountNumber());
            ps.setString(3, config.getAccountName());
            int rows = ps.executeUpdate(); // Log dòng đã thêm
            System.out.println("Số dòng đã thêm: " + rows);
        }
    }

    public List<BankConfig> getAllConfigs() throws SQLException {
        List<BankConfig> list = new ArrayList<>();
        String sql = "SELECT * FROM BankConfig ORDER BY updated_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BankConfig config = new BankConfig();
                config.setConfigId(rs.getInt("config_id"));
                config.setBankName(rs.getString("bank_name"));
                config.setAccountNumber(rs.getString("account_number"));
                config.setAccountName(rs.getString("account_name"));
                config.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(config);
            }
        }
        return list;
    }
    

    public void deleteConfig(int id) throws SQLException {
        String sql = "DELETE FROM BankConfig WHERE config_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    public BankConfig getByBankName(String bankName) throws SQLException {
    String sql = "SELECT TOP 1 * FROM BankConfig WHERE bank_name = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, bankName);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            BankConfig b = new BankConfig();
            b.setBankName(rs.getString("bank_name"));
            b.setAccountNumber(rs.getString("account_number"));
            b.setAccountName(rs.getString("account_name"));
            b.setUpdatedAt(rs.getTimestamp("updated_at"));
            return b;
        }
    }
    return null;
}
    public BankConfig getConfigById(int id) throws SQLException {
    String sql = "SELECT * FROM BankConfig WHERE config_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BankConfig b = new BankConfig();
                b.setConfigId(rs.getInt("config_id"));
                b.setBankName(rs.getString("bank_name"));
                b.setAccountNumber(rs.getString("account_number"));
                b.setAccountName(rs.getString("account_name"));
                b.setUpdatedAt(rs.getTimestamp("updated_at"));
                return b;
            }
        }
    }
    return null;
}
public BankConfig getConfigByBankName(String bankName) throws SQLException {
    String sql = "SELECT TOP 1 * FROM BankConfig WHERE bank_name = ? ORDER BY updated_at DESC";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, bankName);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BankConfig config = new BankConfig();
                config.setConfigId(rs.getInt("config_id"));
                config.setBankName(rs.getString("bank_name"));
                config.setAccountNumber(rs.getString("account_number"));
                config.setAccountName(rs.getString("account_name"));
                config.setUpdatedAt(rs.getTimestamp("updated_at"));
                return config;
            }
        }
    }
    return null;
}


}
