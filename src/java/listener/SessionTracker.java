package listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.*;
import model.UserSessionInfo;

import java.time.LocalDateTime;
import java.util.*;

@WebListener
public class SessionTracker implements HttpSessionListener {

    // Danh sách lưu các session đã login/logout
    public static final List<UserSessionInfo> sessionLogs = new ArrayList<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Không cần làm gì khi tạo session
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        UserSessionInfo info = (UserSessionInfo) session.getAttribute("sessionInfo");
        if (info != null) {
            info.setLogoutTime(LocalDateTime.now());
            sessionLogs.add(info);
        }
    }
}
