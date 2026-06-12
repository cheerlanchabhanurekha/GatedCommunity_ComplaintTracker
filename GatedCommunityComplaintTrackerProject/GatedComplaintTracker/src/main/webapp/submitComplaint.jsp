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
    <title>Submit Complaint</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f4f8; }
        .navbar { background: #1a3c6e; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h2 { font-size: 20px; }
        .nav-link { color: white; text-decoration: none; font-size: 14px; }
        .container { max-width: 600px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .card h3 { color: #1a3c6e; margin-bottom: 20px; font-size: 18px; border-bottom: 2px solid #e8f0fe; padding-bottom: 10px; }
        .form-group { margin-bottom: 18px; }
        label { font-size: 13px; color: #444; font-weight: 600; display: block; margin-bottom: 6px; }
        input, select, textarea { width: 100%; padding: 11px 14px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: all 0.3s; font-family: 'Segoe UI', sans-serif; }
        input:focus, select:focus, textarea:focus { border-color: #1a3c6e; outline: none; box-shadow: 0 0 0 3px rgba(26,60,110,0.1); }
        textarea { resize: vertical; min-height: 100px; }
        .urgency-group { display: flex; gap: 10px; }
        .urgency-btn { flex: 1; padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; text-align: center; cursor: pointer; font-size: 13px; font-weight: 600; transition: all 0.3s; }
        .urgency-btn.low { color: #2e7d32; }
        .urgency-btn.low.active, .urgency-btn.low:hover { background: #e8f5e9; border-color: #2e7d32; }
        .urgency-btn.medium { color: #e65100; }
        .urgency-btn.medium.active, .urgency-btn.medium:hover { background: #fff3e0; border-color: #e65100; }
        .urgency-btn.high { color: #c62828; }
        .urgency-btn.high.active, .urgency-btn.high:hover { background: #ffebee; border-color: #c62828; }
        .btn { width: 100%; padding: 13px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.3s; margin-top: 5px; }
        .btn:hover { background: #0f2a52; }
        .category-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
        .category-item { padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; text-align: center; cursor: pointer; font-size: 13px; transition: all 0.3s; }
        .category-item:hover, .category-item.active { border-color: #1a3c6e; background: #e8f0fe; color: #1a3c6e; font-weight: 600; }
        .upload-box { border: 2px dashed #1a3c6e; border-radius: 10px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.3s; background: #f8f9ff; }
        .upload-box:hover { background: #e8f0fe; }
        .upload-box .icon { font-size: 35px; margin-bottom: 8px; }
        .upload-box p { color: #1a3c6e; font-weight: 600; font-size: 13px; margin-bottom: 4px; }
        .upload-box small { color: #888; font-size: 12px; }
        #photoPreview { max-width: 100%; max-height: 180px; margin-top: 12px; border-radius: 8px; display: none; border: 2px solid #e0e0e0; }
    </style>
</head>
<body>
<div class="navbar">
    <h2>📝 Submit Complaint</h2>
    <a href="residentDashboard.jsp" class="nav-link">← Back to Dashboard</a>
</div>

<div class="container">
    <div class="card">
        <h3>🏠 Flat: <%= user.getFlatNumber() != null ? user.getFlatNumber() : "N/A" %> | <%= user.getBlockName() != null ? user.getBlockName() : "N/A" %></h3>

        <form action="ComplaintServlet" method="post" enctype="multipart/form-data">

            <%-- Category --%>
            <div class="form-group">
                <label>📂 Category</label>
                <div class="category-grid">
                    <div class="category-item" onclick="selectCategory('Water Supply',this)">💧 Water Supply</div>
                    <div class="category-item" onclick="selectCategory('Electricity',this)">⚡ Electricity</div>
                    <div class="category-item" onclick="selectCategory('Maintenance',this)">🔧 Maintenance</div>
                    <div class="category-item" onclick="selectCategory('Security',this)">🔒 Security</div>
                    <div class="category-item" onclick="selectCategory('Garbage',this)">🗑️ Garbage</div>
                    <div class="category-item" onclick="selectCategory('Other',this)">📌 Other</div>
                </div>
                <input type="hidden" name="category" id="categoryInput"/>
            </div>

            <%-- Urgency --%>
            <div class="form-group">
                <label>⚠️ Urgency Level</label>
                <div class="urgency-group">
                    <div class="urgency-btn low" onclick="selectUrgency('Low',this)">🟢 Low</div>
                    <div class="urgency-btn medium" onclick="selectUrgency('Medium',this)">🟡 Medium</div>
                    <div class="urgency-btn high" onclick="selectUrgency('High',this)">🔴 High</div>
                </div>
                <input type="hidden" name="urgency" id="urgencyInput"/>
            </div>

            <%-- Description --%>
            <div class="form-group">
                <label>📝 Description</label>
                <textarea name="description"
                    placeholder="Describe your complaint in detail..." required></textarea>
            </div>

            <%-- Photo Upload --%>
            <div class="form-group">
                <label>📸 Attach Photo (Optional)</label>
                <div class="upload-box" onclick="document.getElementById('photoInput').click()">
                    <div class="icon">📷</div>
                    <p>Click to attach a photo</p>
                    <small>JPG, PNG supported (Max 5MB)</small>
                    <img id="photoPreview"/>
                </div>
                <input type="file" id="photoInput" name="photo"
                    accept="image/*" style="display:none"
                    onchange="previewPhoto(this)"/>
            </div>

            <button type="submit" class="btn"
                onclick="return validateForm()">🚀 Submit Complaint</button>
        </form>
    </div>
</div>

<script>
function selectCategory(value, el) {
    document.querySelectorAll('.category-item').forEach(e => e.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('categoryInput').value = value;
}

function selectUrgency(value, el) {
    document.querySelectorAll('.urgency-btn').forEach(e => e.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('urgencyInput').value = value;
}

function previewPhoto(input) {
    if(input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var preview = document.getElementById('photoPreview');
            preview.src = e.target.result;
            preview.style.display = 'block';
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function validateForm() {
    if(!document.getElementById('categoryInput').value) {
        alert('Please select a category!');
        return false;
    }
    if(!document.getElementById('urgencyInput').value) {
        alert('Please select urgency level!');
        return false;
    }
    return true;
}
</script>
</body>
</html>