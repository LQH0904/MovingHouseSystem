package utils;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {

    private static final String FROM_EMAIL = "hethongchuyennhag5@gmail.com"; // Email gửi đi
    private static final String PASSWORD = "namdxbxtmvivmntr"; // Mật khẩu ứng dụng

    public static boolean sendWarningEmail(String toEmail, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            // Tạo message với UTF-8
            MimeMessage message = new MimeMessage(session);

            // Đặt người gửi với tên hiển thị hỗ trợ UTF-8
            message.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống Dịch Vụ Chuyển Nhà - Moving House", "UTF-8"));

            // Đặt người nhận
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            // Đặt tiêu đề có mã hóa UTF-8
            message.setSubject(subject, "UTF-8");

            // Tạo phần thân email với mã hóa UTF-8
            MimeBodyPart bodyPart = new MimeBodyPart();
            bodyPart.setContent(content, "text/plain; charset=UTF-8");

            // Tạo multipart và gắn body vào
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(bodyPart);

            // Gắn multipart vào nội dung mail
            message.setContent(multipart);

            // Gửi mail
            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
