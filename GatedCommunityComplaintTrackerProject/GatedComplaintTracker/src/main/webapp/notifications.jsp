<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gated.model.*,com.gated.dao.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    NotificationDAO nDao = new NotificationDAO();
    List<Notification> notifications = nDao.getNotificationsByUser(user.getId());
    nDao.markAllRead(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #1a3c6e; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h2 { font-size: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; }
        .container { max-width: 700px; margin: 30px auto; padding: 0 20px; }
        .notif-card { background: white; padding: 15px 20px; border-radius: 10px; margin-bottom: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); display: flex; align-items: center; gap: 15px; border-left: 4px solid #1a3c6e; }
        .notif-icon { font-size: 24px; }
        .notif-msg { font-size: 14px; color: #333; }
        .notif-date { font-size: 12px; color: #aaa; margin-top: 4px; }
        .empty { text-align: center; padding: 40px; color: #888; }
    </style>
</head>
<body>
<div class="navbar">
    <h2>🔔 Notifications</h2>
    <a href="residentDashboard.jsp" class="nav-link">← Back</a>
</div>
<div class="container">
    <% if(notifications.isEmpty()) { %>
        <div class="empty">
            <div style="font-size:50px">🔔</div>
            <p>No notifications yet!</p>
        </div>
    <% } else {
        for(Notification n : notifications) { %>
        <div class="notif-card">
            <div class="notif-icon">📢</div>
            <div>
                <div class="notif-msg"><%= n.getMessage() %></div>
                <div class="notif-date"><%= n.getCreatedDate() %></div>
            </div>
        </div>
    <% } } %>
</div>
</body>
</html>