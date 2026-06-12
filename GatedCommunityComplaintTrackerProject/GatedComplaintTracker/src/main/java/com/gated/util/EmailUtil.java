package com.gated.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {

    private static final String FROM_EMAIL = "bhanurekhacheerlancha9@gmail.com";
    private static final String PASSWORD = "vpbo wedz emti vkzh";

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        return Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });
    }

    public static String generateOTP() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }

    public static void sendOTP(String toEmail, String otp) throws Exception {
        Session session = getSession();
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        msg.setSubject("Gated Community - OTP Verification");
        msg.setContent(
            "<div style='font-family:Arial;padding:20px'>" +
            "<h2 style='color:#1a3c6e'>🏢 Gated Community</h2>" +
            "<p>Your OTP is:</p>" +
            "<h1 style='color:#1a3c6e;letter-spacing:10px'>" + otp + "</h1>" +
            "<p style='color:red'>Valid for 5 minutes only!</p>" +
            "</div>",
            "text/html"
        );
        Transport.send(msg);
    }

    public static void sendStatusUpdate(String toEmail,
            String name, String category, String status) throws Exception {
        Session session = getSession();
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        msg.setSubject("Complaint Status Updated - Gated Community");
        msg.setContent(
            "<div style='font-family:Arial;padding:20px'>" +
            "<h2 style='color:#1a3c6e'>🏢 Gated Community</h2>" +
            "<p>Hello <b>" + name + "</b>!</p>" +
            "<p>Your complaint about <b>" + category + "</b> " +
            "status updated to: " +
            "<b style='color:green'>" + status + "</b></p>" +
            "</div>",
            "text/html"
        );
        Transport.send(msg);
    }
}