<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.gated.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) { response.sendRedirect("login.jsp"); return; }
    if("ADMIN".equals(user.getRole())) { response.sendRedirect("adminDashboard.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #1a3c6e; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h2 { font-size: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; opacity: 0.85; }
        .container { max-width: 700px; margin: 30px auto; padding: 0 20px; }
        .profile-card { background: white; border-radius: 16px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); overflow: hidden; }
        .profile-header { background: linear-gradient(135deg, #1a3c6e, #2d6a9f); padding: 30px; text-align: center; color: white; }
        .profile-pic-container { position: relative; display: inline-block; margin-bottom: 15px; }
        .profile-pic { width: 100px; height: 100px; border-radius: 50%; border: 4px solid white; object-fit: cover; background: #e8f0fe; display: flex; align-items: center; justify-content: center; font-size: 40px; overflow: hidden; }
        .profile-pic img { width: 100%; height: 100%; object-fit: cover; }
        .profile-name { font-size: 22px; font-weight: 700; margin-bottom: 5px; }
        .profile-role { font-size: 13px; opacity: 0.85; background: rgba(255,255,255,0.2); padding: 4px 12px; border-radius: 20px; display: inline-block; }
        .profile-body { padding: 30px; }
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 25px; }
        .info-item { background: #f8f9fa; padding: 15px; border-radius: 10px; border-left: 4px solid #1a3c6e; }
        .info-label { font-size: 11px; color: #888; font-weight: 600; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { font-size: 15px; color: #333; font-weight: 600; }
        .upload-section { border-top: 1px solid #f0f0f0; padding-top: 20px; }
        .upload-section h3 { color: #1a3c6e; margin-bottom: 15px; font-size: 16px; }
        .upload-box { border: 2px dashed #1a3c6e; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .upload-box:hover { background: #e8f0fe; }
        .upload-box input[type="file"] { display: none; }
        .upload-preview { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; margin: 10px auto; display: none; }
        .btn { width: 100%; padding: 12px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 15px; transition: background 0.3s; }
        .btn:hover { background: #0f2a52; }
        .success { background: #e8f5e9; border: 1px solid #b3ffcc; color: #2e7d32; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="navbar">
    <h2>🏢 Gated Community</h2>
    <div style="display:flex;gap:20px">
        <a href="residentDashboard.jsp" class="nav-link">← Dashboard</a>
        <a href="LogoutServlet" class="nav-link">Logout</a>
    </div>
</div>

<div class="container">
    <% if("1".equals(request.getParameter("success"))) { %>
        <div class="success">✅ Profile updated successfully!</div>
    <% } %>

    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-pic-container">
                <div class="profile-pic">
                    <% if(user.getProfilePic() != null && !user.getProfilePic().isEmpty()) { %>
                        <img src="<%= user.getProfilePic() %>" alt="Profile"/>
                    <% } else { %>
                        👤
                    <% } %>
                </div>
            </div>
            <div class="profile-name"><%= user.getName() %></div>
            <div class="profile-role"><%= user.getRole() %></div>
        </div>

        <div class="profile-body">
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">📧 Email</div>
                    <div class="info-value"><%= user.getEmail() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">📱 Phone</div>
                    <div class="info-value"><%= user.getPhone() != null ? user.getPhone() : "N/A" %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">🏢 Block</div>
                    <div class="info-value"><%= user.getBlockName() != null ? user.getBlockName() : "N/A" %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">🏠 Flat Number</div>
                    <div class="info-value"><%= user.getFlatNumber() != null ? user.getFlatNumber() : "N/A" %></div>
                </div>
            </div>

            <div class="upload-section">
                <h3>📸 Update Profile Picture</h3>
                <form action="ProfileServlet" method="post" enctype="multipart/form-data">
                    <div class="upload-box" onclick="document.getElementById('picInput').click()">
                        <div style="font-size:35px">📷</div>
                        <p style="color:#1a3c6e;font-weight:600;margin-top:8px">Click to choose photo</p>
                        <p style="color:#888;font-size:12px">JPG, PNG (Max 5MB)</p>
                        <img id="preview" class="upload-preview"/>
                    </div>
                    <input type="file" id="picInput" name="profilePic"
                        accept="image/*" onchange="previewImage(this)"/>
                    <button type="submit" class="btn">📸 Update Profile Picture</button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
function previewImage(input) {
    if(input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var preview = document.getElementById('preview');
            preview.src = e.target.result;
            preview.style.display = 'block';
        }
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
</body>
</html>