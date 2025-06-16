package model;

import java.sql.Timestamp;

public class IssueReplyStaff {
    private int replyId;
    private int issueId;
    private int staffId;
    private String staffUsername;
    private String replyContent;
    private Timestamp repliedAt;

    public IssueReplyStaff() {
    }

    public IssueReplyStaff(int replyId, int issueId, int staffId, String staffUsername, String replyContent, Timestamp repliedAt) {
        this.replyId = replyId;
        this.issueId = issueId;
        this.staffId = staffId;
        this.staffUsername = staffUsername;
        this.replyContent = replyContent;
        this.repliedAt = repliedAt;
    }

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

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffUsername() {
        return staffUsername;
    }

    public void setStaffUsername(String staffUsername) {
        this.staffUsername = staffUsername;
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

    @Override
    public String toString() {
        return "IssueReplyStaff{" +
               "replyId=" + replyId +
               ", issueId=" + issueId +
               ", staffId=" + staffId +
               ", staffUsername='" + staffUsername + '\'' +
               ", replyContent='" + replyContent + '\'' +
               ", repliedAt=" + repliedAt +
               '}';
    }
}