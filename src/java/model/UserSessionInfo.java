package model;

import java.time.LocalDateTime;

public class UserSessionInfo {
    private String username;
    private LocalDateTime loginTime;
    private LocalDateTime logoutTime;

    public UserSessionInfo(String username, LocalDateTime loginTime) {
        this.username = username;
        this.loginTime = loginTime;
    }

    public String getUsername() {
        return username;
    }

    public LocalDateTime getLoginTime() {
        return loginTime;
    }

    public LocalDateTime getLogoutTime() {
        return logoutTime;
    }

    public void setLogoutTime(LocalDateTime logoutTime) {
        this.logoutTime = logoutTime;
    }
}
