<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    Boolean verified = (Boolean) session.getAttribute("otpVerified");
    if(verified == null || !verified) { response.sendRedirect("forgotPassword.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - Gated Community</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a3c6e 0%, #2d6a9f 100%); display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: white; padding: 40px; border-radius: 16px; width: 400px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); text-align: center; }
        .icon { font-size: 55px; margin-bottom: 15px; }
        h2 { color: #1a3c6e; margin-bottom: 8px; }
        p { color: #666; font-size: 14px; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; text-align: left; }
        label { font-size: 13px; color: #444; font-weight: 600; display: block; margin-bottom: 6px; }
        input { width: 100%; padding: 12px 15px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: all 0.3s; }
        input:focus { border-color: #1a3c6e; outline: none; box-shadow: 0 0 0 3px rgba(26,60,110,0.1); }
        .btn { width: 100%; padding: 13px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.3s; }
        .btn:hover { background: #0f2a52; }
        .error { background: #fff0f0; border: 1px solid #ffcccc; color: #cc0000; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 15px; }
        .strength { height: 4px; border-radius: 2px; margin-top: 6px; transition: all 0.3s; }
    </style>
</head>
<body>
<div class="card">
    <div class="icon">🔒</div>
    <h2>Reset Password</h2>
    <p>Enter your new password below</p>

    <form action="ForgotPasswordServlet" method="post">
        <input type="hidden" name="action" value="resetPassword"/>
        <div class="form-group">
            <label>🔑 New Password</label>
            <input type="password" name="newPassword" id="newPass"
                placeholder="Min 6 characters" required
                oninput="checkStrength(this.value)"/>
            <div class="strength" id="strengthBar"></div>
        </div>
        <div class="form-group">
            <label>🔑 Confirm Password</label>
            <input type="password" id="confirmPass"
                placeholder="Re-enter password" required/>
        </div>
        <button type="submit" class="btn" onclick="return checkMatch()">
            Reset Password ✅
        </button>
    </form>
</div>
<script>
function checkStrength(val) {
    var bar = document.getElementById('strengthBar');
    if(val.length < 4) { bar.style.width='30%'; bar.style.background='#ff4444'; }
    else if(val.length < 7) { bar.style.width='60%'; bar.style.background='#ffaa00'; }
    else { bar.style.width='100%'; bar.style.background='#00cc44'; }
}
function checkMatch() {
    var p1 = document.getElementById('newPass').value;
    var p2 = document.getElementById('confirmPass').value;
    if(p1 !== p2) { alert('Passwords do not match!'); return false; }
    return true;
}
</script>
</body>
</html>