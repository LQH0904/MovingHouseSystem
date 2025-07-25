// model/FAQQuestion.java
package model;

import java.util.Date;

public class FAQQuestion {
    private int faqId;
    private String question;
    private String reply;
    private String review;
    private int staffId;
    private Date createdAt;
    private Date updatedAt;

    public FAQQuestion(int faqId, String question, String reply, String review, int staffId, Date createdAt, Date updatedAt) {
        this.faqId = faqId;
        this.question = question;
        this.reply = reply;
        this.review = review;
        this.staffId = staffId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public FAQQuestion() {
    }
    

    public int getFaqId() {
        return faqId;
    }

    public void setFaqId(int faqId) {
        this.faqId = faqId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getReview() {
        return review;
    }

    public void setReview(String review) {
        this.review = review;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    
}
