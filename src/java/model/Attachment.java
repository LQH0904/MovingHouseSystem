package model;

import java.time.LocalDateTime;

public class Attachment {

    private int attachmentId;
    private int issueId;
    private int uploadedById;
    private String fileName;
    private String filePath;
    private String fileType;
    private LocalDateTime uploadedAt;

    public Attachment() {
    }

    public Attachment(int issueId, int uploadedById, String fileName, String filePath, String fileType) {
        this.issueId = issueId;
        this.uploadedById = uploadedById;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileType = fileType;
        this.uploadedAt = LocalDateTime.now();
    }

    public int getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(int attachmentId) {
        this.attachmentId = attachmentId;
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    public int getUploadedById() {
        return uploadedById;
    }

    public void setUploadedById(int uploadedById) {
        this.uploadedById = uploadedById;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
