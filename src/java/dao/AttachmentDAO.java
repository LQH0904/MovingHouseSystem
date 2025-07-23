package dao;

import model.Attachment;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AttachmentDAO {

    public int createAttachment(Attachment attachment) throws SQLException {
        String SQL = "INSERT INTO [dbo].[Attachments] (issue_id, uploaded_by_id, file_name, file_path, file_type, uploaded_at) VALUES (?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, attachment.getIssueId());
            pstmt.setInt(2, attachment.getUploadedById());
            pstmt.setString(3, attachment.getFileName());
            pstmt.setString(4, attachment.getFilePath());
            pstmt.setString(5, attachment.getFileType());
            pstmt.setTimestamp(6, Timestamp.valueOf(attachment.getUploadedAt()));

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }

    public List<Attachment> getAttachmentsByIssueId(int issueId) throws SQLException {
        List<Attachment> attachments = new ArrayList<>();
        String SQL = "SELECT attachment_id, issue_id, uploaded_by_id, file_name, file_path, file_type, uploaded_at FROM [dbo].[Attachments] WHERE issue_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, issueId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Attachment attachment = new Attachment();
                    attachment.setAttachmentId(rs.getInt("attachment_id"));
                    attachment.setIssueId(rs.getInt("issue_id"));
                    attachment.setUploadedById(rs.getInt("uploaded_by_id"));
                    attachment.setFileName(rs.getString("file_name"));
                    attachment.setFilePath(rs.getString("file_path"));
                    attachment.setFileType(rs.getString("file_type"));
                    attachment.setUploadedAt(rs.getTimestamp("uploaded_at").toLocalDateTime());
                    attachments.add(attachment);
                }
            }
        }
        return attachments;
    }
}
