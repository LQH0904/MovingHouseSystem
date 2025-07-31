package model;

import java.sql.Timestamp;

public class IssueReply {

    private int replyId;           // ID phản hồi
    private int issueId;           // ID khiếu nại
    private int replierId;         // ID người trả lời
    private String replyContent;   // Nội dung phản hồi
    private Timestamp repliedAt;   // Thời gian phản hồi

    // --- Constructors ---
    public IssueReply() {
    }

    public IssueReply(int replyId, int issueId, int replierId, String replyContent, Timestamp repliedAt) {
        this.replyId = replyId;
        this.issueId = issueId;
        this.replierId = replierId;
        this.replyContent = replyContent;
        this.repliedAt = repliedAt;
    }

    // --- Getters & Setters ---
    public int getReplyId() {
        return replyId;
    }

    public void setReplyId(int replyId) {
        this.replyId = replyId;
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    public int getReplierId() {
        return replierId;
    }

    public void setReplierId(int replierId) {
        this.replierId = replierId;
    }



    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public Timestamp getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Timestamp repliedAt) {
        this.repliedAt = repliedAt;
    }

    // --- Optional compatibility method ---
    public String getContent() {
        return replyContent;
    }

    public void setContent(String content) {
        this.replyContent = content;
    }

    public Timestamp getCreatedAt() {
        return repliedAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.repliedAt = createdAt;
    }
}
