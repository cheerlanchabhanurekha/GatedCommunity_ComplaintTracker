<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gated.model.*,com.gated.dao.*,java.util.*" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null) { response.sendRedirect("login.jsp"); return; }
    if(!"ADMIN".equals(admin.getRole())) { response.sendRedirect("residentDashboard.jsp"); return; }
    List<Complaint> all = new ComplaintDAO().getAllComplaints();
    long pending = all.stream().filter(c -> "Pending".equals(c.getStatus())).count();
    long inprogress = all.stream().filter(c -> "In Progress".equals(c.getStatus())).count();
    long resolved = all.stream().filter(c -> "Resolved".equals(c.getStatus())).count();
    List<MaintenanceStaff> staffList = new StaffDAO().getAllStaff();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #0f2a52; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h2 { font-size: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; opacity: 0.85; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 25px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .stat-card .number { font-size: 36px; font-weight: 700; }
        .stat-card .label { font-size: 13px; color: #666; margin-top: 5px; }
        .total { border-top: 4px solid #1a3c6e; }
        .total .number { color: #1a3c6e; }
        .pend { border-top: 4px solid #e65100; }
        .pend .number { color: #e65100; }
        .prog { border-top: 4px solid #1565c0; }
        .prog .number { color: #1565c0; }
        .res { border-top: 4px solid #2e7d32; }
        .res .number { color: #2e7d32; }
        .filter-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .filter-btn { padding: 8px 16px; border: 2px solid #e0e0e0; border-radius: 20px; background: white; cursor: pointer; font-size: 13px; font-weight: 600; transition: all 0.3s; }
        .filter-btn.active, .filter-btn:hover { border-color: #0f2a52; background: #0f2a52; color: white; }
        .complaint-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .card-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .card-top h4 { color: #0f2a52; font-size: 16px; }
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-pending { background: #fff3e0; color: #e65100; }
        .badge-inprogress { background: #e3f2fd; color: #1565c0; }
        .badge-resolved { background: #e8f5e9; color: #2e7d32; }
        .card-desc { color: #555; font-size: 14px; margin-bottom: 12px; }
        .card-meta { display: flex; gap: 15px; font-size: 12px; color: #888; margin-bottom: 15px; flex-wrap: wrap; }
        .complaint-photo { max-width: 200px; max-height: 150px; border-radius: 8px; border: 2px solid #e0e0e0; cursor: pointer; transition: transform 0.2s; }
        .complaint-photo:hover { transform: scale(1.05); }
        .update-form { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-top: 12px; border-top: 1px solid #f0f0f0; padding-top: 12px; }
        .update-form select, .update-form input { padding: 8px 12px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 13px; }
        .update-form input { flex: 1; min-width: 200px; }
        .update-btn { padding: 8px 18px; background: #0f2a52; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .update-btn:hover { background: #1a3c6e; }
        .success-msg { background: #e8f5e9; border: 1px solid #b3ffcc; color: #2e7d32; padding: 12px; border-radius: 8px; margin-bottom: 15px; text-align: center; }
        .photo-modal { display: none; position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.8); z-index: 1000; justify-content: center; align-items: center; }
        .photo-modal img { max-width: 90%; max-height: 90%; border-radius: 12px; }
        .photo-modal.active { display: flex; }
    </style>
</head>
<body>

<%-- Photo Modal --%>
<div class="photo-modal" id="photoModal" onclick="closePhoto()">
    <img id="modalPhoto" src="" alt="Complaint Photo"/>
</div>
<div class="navbar">
    <h2>⚙️ Admin Dashboard</h2>
    <div style="display:flex;gap:15px;align-items:center;">
        <a href="PdfReportServlet"
           style="background:white;color:#0f2a52;padding:8px 16px;
                  border-radius:8px;text-decoration:none;font-size:13px;
                  font-weight:600;display:flex;align-items:center;gap:6px;">
            📄 Download PDF Report
        </a>
        <a href="LogoutServlet" class="nav-link">Logout</a>
    </div>
</div>

<div class="container">
    <% if("1".equals(request.getParameter("success"))) { %>
        <div class="success-msg">✅ Complaint status updated successfully!</div>
    <% } %>

    <%-- Stats --%>
    <div class="stats">
        <div class="stat-card total">
            <div class="number"><%= all.size() %></div>
            <div class="label">Total Complaints</div>
        </div>
        <div class="stat-card pend">
            <div class="number"><%= pending %></div>
            <div class="label">🟠 Pending</div>
        </div>
        <div class="stat-card prog">
            <div class="number"><%= inprogress %></div>
            <div class="label">🔵 In Progress</div>
        </div>
        <div class="stat-card res">
            <div class="number"><%= resolved %></div>
            <div class="label">🟢 Resolved</div>
        </div>
    </div>

    <%-- Filter --%>
    <div class="filter-bar">
        <button class="filter-btn active" onclick="filterComplaints('all',this)">All (<%= all.size() %>)</button>
        <button class="filter-btn" onclick="filterComplaints('pending',this)">🟠 Pending (<%= pending %>)</button>
        <button class="filter-btn" onclick="filterComplaints('inprogress',this)">🔵 In Progress (<%= inprogress %>)</button>
        <button class="filter-btn" onclick="filterComplaints('resolved',this)">🟢 Resolved (<%= resolved %>)</button>
    </div>

    <%-- Complaints --%>
    <% if(all.isEmpty()) { %>
        <div style="text-align:center;padding:60px;color:#888;background:white;border-radius:12px;">
            <div style="font-size:60px">📭</div>
            <p style="margin-top:15px">No complaints yet!</p>
        </div>
    <% } else {
        for(Complaint c : all) {
            String statusClass = c.getStatus().toLowerCase().replace(" ",""); %>

        <div class="complaint-card" data-status="<%= statusClass %>">
            <div class="card-top">
                <h4>📋 <%= c.getCategory() %> &nbsp;
                    <span style="font-size:12px;color:#888;font-weight:400">
                        #<%= c.getId() %>
                    </span>
                </h4>
                <span class="badge badge-<%= statusClass %>"><%= c.getStatus() %></span>
            </div>

            <%-- Description --%>
            <div class="card-desc">
                <%= c.getDescription() != null ? c.getDescription() : "No description" %>
            </div>

            <%-- Photo --%>
            <% if(c.getPhoto() != null && !c.getPhoto().isEmpty()) { %>
                <div style="margin-bottom:12px;">
                    <img class="complaint-photo"
                         src="<%= request.getContextPath() + "/" + c.getPhoto() %>"
                         alt="Complaint Photo"
                         onclick="openPhoto('<%= request.getContextPath() + "/" + c.getPhoto() %>')"/>
                    <div style="font-size:11px;color:#1a3c6e;margin-top:4px;font-weight:600;">
                        📸 Photo attached — click to enlarge
                    </div>
                </div>
            <% } %>

            <%-- Meta --%>
            <div class="card-meta">
                <span>⚠️ Urgency: <%= c.getUrgency() %></span>
                <span>📅 Date: <%= c.getCreatedDate() %></span>
                <% if(c.getResolvedDate() != null) { %>
                    <span>✅ Resolved: <%= c.getResolvedDate() %></span>
                <% } %>
            </div>

            <%-- Admin Comment --%>
            <% if(c.getAdminComment() != null && !c.getAdminComment().isEmpty()) { %>
                <div style="background:#f8f9fa;border-left:3px solid #1a3c6e;
                            padding:10px;border-radius:0 8px 8px 0;
                            font-size:13px;color:#444;margin-bottom:12px;">
                    💬 Admin Comment: <%= c.getAdminComment() %>
                </div>
            <% } %>

            <%-- Update Form --%>
            <form action="AdminServlet" method="post" class="update-form">
                <input type="hidden" name="complaintId" value="<%= c.getId() %>"/>
                <select name="status">
                    <option <%= "Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                    <option <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                    <option <%= "Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                </select>
                <input type="text" name="adminComment"
                    placeholder="Add comment for resident..."
                    value="<%= c.getAdminComment() != null ? c.getAdminComment() : "" %>"/>
                <button type="submit" class="update-btn">Update →</button>
                <select name="staffId" style="padding:8px 12px;border:1.5px solid #e0e0e0;border-radius:8px;font-size:13px;">
    <option value="">-- Assign Staff --</option>
    <% for(MaintenanceStaff staff : staffList) { %>
        <option value="<%= staff.getId() %>"
            <%= (c.getAssignedStaffId() != null && c.getAssignedStaffId() == staff.getId()) ? "selected" : "" %>>
            <%= staff.getName() %> (<%= staff.getSpecialization() %>)
        </option>
    <% } %>
</select>
            </form>
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
    document.getElementById('modalPhoto').src = src;
    document.getElementById('photoModal').classList.add('active');
}

function closePhoto() {
    document.getElementById('photoModal').classList.remove('active');
}
</script>
</body>
</html>