<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gated.model.*,com.gated.dao.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    if("ADMIN".equals(user.getRole())) { response.sendRedirect("adminDashboard.jsp"); return; }
    List<Complaint> complaints = new ComplaintDAO().getComplaintsByUser(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Complaints</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #1a3c6e; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h2 { font-size: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; }
        .container { max-width: 900px; margin: 30px auto; padding: 0 20px; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
        .filter-btn { padding: 8px 16px; border: 2px solid #e0e0e0; border-radius: 20px; background: white; cursor: pointer; font-size: 13px; font-weight: 600; transition: all 0.3s; }
        .filter-btn.active, .filter-btn:hover { border-color: #1a3c6e; background: #1a3c6e; color: white; }
        .complaint-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); border-left: 5px solid #1a3c6e; transition: transform 0.2s; }
        .complaint-card:hover { transform: translateY(-2px); }
        .complaint-card.pending { border-left-color: #e65100; }
        .complaint-card.inprogress { border-left-color: #1565c0; }
        .complaint-card.resolved { border-left-color: #2e7d32; }
        .complaint-card.cancelled { border-left-color: #888; opacity: 0.7; }
.badge-cancelled { background: #f0f0f0; color: #888; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .card-header h4 { color: #1a3c6e; font-size: 16px; }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-pending { background: #fff3e0; color: #e65100; }
        .badge-inprogress { background: #e3f2fd; color: #1565c0; }
        .badge-resolved { background: #e8f5e9; color: #2e7d32; }
        .card-desc { color: #555; font-size: 14px; margin-bottom: 10px; }
        .card-footer { display: flex; gap: 15px; font-size: 12px; color: #888; flex-wrap: wrap; }
        .admin-comment { background: #f8f9fa; border-left: 3px solid #1a3c6e; padding: 10px; border-radius: 0 8px 8px 0; margin-top: 10px; font-size: 13px; color: #444; }
        .empty { text-align: center; padding: 60px; color: #888; }
        .success-msg { background: #e8f5e9; border: 1px solid #b3ffcc; color: #2e7d32; padding: 12px; border-radius: 8px; margin-bottom: 15px; text-align: center; }
        .new-btn { background: #1a3c6e; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; }
        .complaint-photo { max-width: 100%; max-height: 200px; border-radius: 8px; border: 2px solid #e0e0e0; cursor: pointer; margin-top: 10px; transition: transform 0.2s; }
        .complaint-photo:hover { transform: scale(1.02); }
        .photo-modal { display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.85); z-index: 1000; justify-content: center; align-items: center; }
        .photo-modal.active { display: flex; }
        .photo-modal img { max-width: 90%; max-height: 90%; border-radius: 12px; }
    </style>
</head>
<body>

<%-- Photo Modal --%>
<div class="photo-modal" id="photoModal" onclick="closePhoto()">
    <img id="modalImg" src="" alt="Complaint Photo"/>
</div>

<div class="navbar">
    <h2>📋 My Complaints</h2>
    <div style="display:flex;gap:15px;align-items:center">
        <a href="submitComplaint.jsp" class="new-btn">+ New Complaint</a>
        <a href="residentDashboard.jsp" class="nav-link">← Dashboard</a>
        <a href="LogoutServlet" class="nav-link">Logout</a>
    </div>
</div>

<div class="container">
    <% if("1".equals(request.getParameter("success"))) { %>
        <div class="success-msg">✅ Complaint submitted successfully!</div>
    <% } %>
    <% if("1".equals(request.getParameter("updated"))) { %>
    <div class="success-msg">✅ Complaint updated successfully!</div>
<% } %>
<% if("1".equals(request.getParameter("cancelled"))) { %>
    <div class="success-msg" style="background:#fff3e0;border-color:#ffcc80;color:#e65100;">
        ⚠️ Complaint cancelled successfully!
    </div>
<% } %>
<% if("1".equals(request.getParameter("deleted"))) { %>
    <div class="success-msg" style="background:#ffebee;border-color:#ffcdd2;color:#c62828;">
        🗑️ Complaint deleted successfully!
    </div>
<% } %>
<% String err = request.getParameter("error");
   if(err != null) { %>
    <div class="success-msg" style="background:#ffebee;border-color:#ffcdd2;color:#c62828;">
        ❌ <% if("cannotedit".equals(err)) { %>
                Cannot edit — complaint already being processed!
           <% } else if("cannotcancel".equals(err)) { %>
                Cannot cancel — complaint already resolved!
           <% } else { %>
                Unauthorized action!
           <% } %>
    </div>
<% } %>

    <div class="filter-bar">
        <button class="filter-btn active" onclick="filterComplaints('all',this)">
            All (<%= complaints.size() %>)
        </button>
        <button class="filter-btn" onclick="filterComplaints('pending',this)">🟠 Pending</button>
        <button class="filter-btn" onclick="filterComplaints('inprogress',this)">🔵 In Progress</button>
        <button class="filter-btn" onclick="filterComplaints('resolved',this)">🟢 Resolved</button>
    </div>

    <% if(complaints.isEmpty()) { %>
        <div class="empty">
            <div style="font-size:60px">📭</div>
            <p style="margin:15px 0">No complaints yet!</p>
            <a href="submitComplaint.jsp" class="new-btn">Submit First Complaint</a>
        </div>
    <% } else {
        for(Complaint c : complaints) {
            String statusClass = c.getStatus() != null ?
                c.getStatus().toLowerCase().replace(" ","") : "pending"; %>

        <div class="complaint-card <%= statusClass %>" data-status="<%= statusClass %>">

            <%-- Header --%>
            <div class="card-header">
                <h4><%= c.getCategory() != null ? c.getCategory() : "Unknown" %></h4>
                <span class="badge badge-<%= statusClass %>">
                    <%= c.getStatus() != null ? c.getStatus() : "Pending" %>
                </span>
            </div>

            <%-- Description --%>
            <div class="card-desc">
                <%= c.getDescription() != null ? c.getDescription() : "No description" %>
            </div>

            <%-- Photo --%>
            <% if(c.getPhoto() != null && !c.getPhoto().isEmpty()) { %>
                <div>
                    <div style="font-size:12px;color:#1a3c6e;font-weight:600;margin-bottom:5px;">
                        📸 Attached Photo:
                    </div>
                    <img class="complaint-photo"
                         src="<%= request.getContextPath() + "/" + c.getPhoto() %>"
                         alt="Complaint Photo"
                         onclick="openPhoto('<%= request.getContextPath() + "/" + c.getPhoto() %>')"/>
                </div>
            <% } %>

            <%-- Footer --%>
            <div class="card-footer" style="margin-top:10px;">
                <span>⚠️ Urgency: <%= c.getUrgency() != null ? c.getUrgency() : "N/A" %></span>
                <span>📅 <%= c.getCreatedDate() %></span>
                <% if(c.getResolvedDate() != null) { %>
                    <span>✅ Resolved: <%= c.getResolvedDate() %></span>
                <% } %>
            </div>
            <%-- Action Buttons — Pending complaints matrame edit/cancel cheyyagalavu --%>
<% if("Pending".equals(c.getStatus())) { %>
    <div style="display:flex;gap:10px;margin-top:12px;">
        <a href="editComplaint.jsp?id=<%= c.getId() %>"
           style="flex:1;text-align:center;padding:8px;background:#1565c0;
                  color:white;border-radius:8px;text-decoration:none;
                  font-size:13px;font-weight:600;">
            ✏️ Edit
        </a>
        <form action="ComplaintActionServlet" method="post" style="flex:1;"
              onsubmit="return confirm('Cancel this complaint?')">
            <input type="hidden" name="action" value="cancel"/>
            <input type="hidden" name="complaintId" value="<%= c.getId() %>"/>
            <button type="submit"
                style="width:100%;padding:8px;background:#e65100;
                       color:white;border:none;border-radius:8px;
                       font-size:13px;font-weight:600;cursor:pointer;">
                ❌ Cancel
            </button>
        </form>
        <form action="ComplaintActionServlet" method="post" style="flex:1;"
              onsubmit="return confirm('Delete this complaint permanently?')">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="complaintId" value="<%= c.getId() %>"/>
            <button type="submit"
                style="width:100%;padding:8px;background:#c62828;
                       color:white;border:none;border-radius:8px;
                       font-size:13px;font-weight:600;cursor:pointer;">
                🗑️ Delete
            </button>
        </form>
    </div>
<% } %><% if(c.getAssignedStaffId() != null) {
    com.gated.model.MaintenanceStaff staff =
        new com.gated.dao.StaffDAO().getStaffById(c.getAssignedStaffId());
    if(staff != null) { %>
    <div style="background:#e8f5e9;border-left:3px solid #2e7d32;
                padding:10px;border-radius:0 8px 8px 0;
                font-size:13px;color:#2e7d32;margin-top:10px;">
        👨‍🔧 Staff Assigned: <b><%= staff.getName() %></b> (<%= staff.getSpecialization() %>)
        — 📞 <%= staff.getPhone() %>
    </div>
<%  } } %>

            <%-- Admin Comment --%>
            <% if(c.getAdminComment() != null && !c.getAdminComment().isEmpty()) { %>
                <div class="admin-comment">
                    💬 Admin Comment: <%= c.getAdminComment() %>
                </div>
            <% } %>

        </div>
    <% } } %>
</div>

<script>
function filterComplaints(status, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('.complaint-card').forEach(card => {
        card.style.display = (status === 'all' ||
            card.dataset.status === status) ? 'block' : 'none';
    });
}
function openPhoto(src) {
    document.getElementById('modalImg').src = src;
    document.getElementById('photoModal').classList.add('active');
}
function closePhoto() {
    document.getElementById('photoModal').classList.remove('active');
}
</script>
</body>
</html>