<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gated.model.*,com.gated.dao.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    int totalComplaints = new ComplaintDAO().getComplaintsByUser(user.getId()).size();
    int unreadNotifications = new NotificationDAO().getUnreadCount(user.getId());
    List<Complaint> recent = new ComplaintDAO().getComplaintsByUser(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Gated Community</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #1a3c6e; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.2); }
        .navbar h2 { font-size: 20px; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; opacity: 0.85; }
        .nav-link:hover { opacity: 1; }
        .notif-badge { background: #ff4444; color: white; border-radius: 50%; width: 20px; height: 20px; font-size: 11px; display: inline-flex; align-items: center; justify-content: center; margin-left: 4px; }
        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .welcome { background: linear-gradient(135deg, #1a3c6e, #2d6a9f); color: white; padding: 25px 30px; border-radius: 12px; margin-bottom: 25px; }
        .welcome h3 { font-size: 22px; margin-bottom: 5px; }
        .welcome p { opacity: 0.85; font-size: 14px; }
        .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 25px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-top: 4px solid #1a3c6e; }
        .stat-card .number { font-size: 32px; font-weight: 700; color: #1a3c6e; }
        .stat-card .label { font-size: 13px; color: #666; margin-top: 5px; }
        .actions { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 25px; }
        .action-btn { background: white; padding: 20px; border-radius: 12px; text-align: center; text-decoration: none; color: #1a3c6e; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: all 0.3s; border: 2px solid transparent; }
        .action-btn:hover { border-color: #1a3c6e; transform: translateY(-2px); }
        .action-btn .icon { font-size: 30px; margin-bottom: 8px; }
        .action-btn h4 { font-size: 15px; margin-bottom: 4px; }
        .action-btn p { font-size: 12px; color: #888; }
        .primary-btn { background: #1a3c6e; color: white; }
        .primary-btn:hover { background: #0f2a52; color: white; }
        .recent { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .recent h3 { color: #1a3c6e; margin-bottom: 15px; font-size: 16px; }
        .complaint-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f0f0f0; }
        .complaint-item:last-child { border-bottom: none; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-pending { background: #fff3e0; color: #e65100; }
        .badge-progress { background: #e3f2fd; color: #1565c0; }
        .badge-resolved { background: #e8f5e9; color: #2e7d32; }
    </style>
</head>
<body>
<div class="navbar">
    <h2>🏢 Gated Community</h2>
    <div class="navbar-right">
        <a href="notifications.jsp" class="nav-link">
            🔔 Notifications
            <% if(unreadNotifications > 0) { %>
                <span class="notif-badge"><%= unreadNotifications %></span>
            <% } %>
        </a>
        <a href="profile.jsp" class="nav-link">👤 <%= user.getName() %></a>
        <a href="logoutServlet" class="nav-link">Logout</a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <h3>Welcome back, <%= user.getName() %>! 👋</h3>
        <p>🏠 <%= user.getBlockName() %> | Flat <%= user.getFlatNumber() %> | <%= user.getPhone() %></p>
    </div>

    <div class="stats">
        <div class="stat-card">
            <div class="number"><%= totalComplaints %></div>
            <div class="label">Total Complaints</div>
        </div>
        <div class="stat-card">
            <div class="number" style="color:#e65100">
                <%= recent.stream().filter(c -> "Pending".equals(c.getStatus())).count() %>
            </div>
            <div class="label">Pending</div>
        </div>
        <div class="stat-card">
            <div class="number" style="color:#2e7d32">
                <%= recent.stream().filter(c -> "Resolved".equals(c.getStatus())).count() %>
            </div>
            <div class="label">Resolved</div>
        </div>
    </div>

    <div class="actions">
        <a href="submitComplaint.jsp" class="action-btn primary-btn">
            <div class="icon">📝</div>
            <h4>Submit Complaint</h4>
            <p>Raise a new complaint</p>
        </a>
        <a href="viewComplaints.jsp" class="action-btn">
            <div class="icon">📋</div>
            <h4>View Complaints</h4>
            <p>Track your complaints</p>
        </a>
    </div>

    <div class="recent">
        <h3>📌 Recent Complaints</h3>
        <% if(recent.isEmpty()) { %>
            <p style="color:#888;text-align:center;padding:20px">No complaints yet!</p>
        <% } else {
            int count = 0;
            for(Complaint c : recent) {
                if(count++ >= 5) break; %>
            <div class="complaint-item">
               <div style="font-size:12px;color:#888;margin-top:3px">
    <% String desc = c.getDescription();
       if(desc != null && !desc.isEmpty()) { %>
        <%= desc.length() > 50 ? desc.substring(0,50)+"..." : desc %>
    <% } else { %>
        No description
    <% } %>
</div>
                <span class="badge badge-<%= c.getStatus().toLowerCase().replace(" ","") %>">
                    <%= c.getStatus() %>
                </span>
            </div>
        <% } } %>
    </div>
</div>
</body>
</html>