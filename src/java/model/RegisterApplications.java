
package model;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class RegisterApplications {
    private int application_id;
    private int user_id;
    private int status_id;
    private Date reviewed_at;
    private String note;

    public RegisterApplications() {
    }

    public RegisterApplications(int application_id, int user_id, int status_id, Date reviewed_at, String note) {
        this.application_id = application_id;
        this.user_id = user_id;
        this.status_id = status_id;
        this.reviewed_at = reviewed_at;
        this.note = note;
    }

    public int getApplication_id() {
        return application_id;
    }

    public void setApplication_id(int application_id) {
        this.application_id = application_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getStatus_id() {
        return status_id;
    }

    public void setStatus_id(int status_id) {
        this.status_id = status_id;
    }

    public Date getReviewed_at() {
        return reviewed_at;
    }

    public void setReviewed_at(Date reviewed_at) {
        this.reviewed_at = reviewed_at;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    
}
