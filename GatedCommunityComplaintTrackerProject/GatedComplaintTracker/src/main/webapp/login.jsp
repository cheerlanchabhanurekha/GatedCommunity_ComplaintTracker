<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Gated Community</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a3c6e 0%, #2d6a9f 100%); display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: white; padding: 40px; border-radius: 16px; width: 400px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo h2 { color: #1a3c6e; font-size: 26px; margin-bottom: 5px; }
        .logo p { color: #888; font-size: 13px; }
        .form-group { margin-bottom: 18px; }
        label { font-size: 13px; color: #444; font-weight: 600; display: block; margin-bottom: 6px; }
        input { width: 100%; padding: 12px 15px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: all 0.3s; }
        input:focus { border-color: #1a3c6e; outline: none; box-shadow: 0 0 0 3px rgba(26,60,110,0.1); }
        .btn { width: 100%; padding: 13px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.3s; }
        .btn:hover { background: #0f2a52; }
        .error { background: #fff0f0; border: 1px solid #ffcccc; color: #cc0000; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 15px; text-align: center; }
        .success { background: #f0fff4; border: 1px solid #b3ffcc; color: #006600; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 15px; text-align: center; }
        .forgot { text-align: right; margin-top: -10px; margin-bottom: 18px; }
        .forgot a { color: #1a3c6e; font-size: 13px; text-decoration: none; font-weight: 600; }
        .forgot a:hover { text-decoration: underline; }
        .divider { text-align: center; color: #aaa; margin: 15px 0; font-size: 12px; }
        .link { text-align: center; font-size: 13px; color: #666; }
        .link a { color: #1a3c6e; font-weight: 600; text-decoration: none; }
    </style>
</head>
<body>
<div class="card">

    <div class="logo">
        <div style="font-size:50px">🏢</div>
        <h2>Gated Community</h2>
        <p>Complaint Management System</p>
    </div>

    <%-- Error Messages --%>
    <% String error = request.getParameter("error");
       if("invalid".equals(error)) { %>
        <div class="error">❌ Invalid email or password!</div>
    <% } else if("notverified".equals(error)) { %>
        <div class="error">⚠️ Please verify your email first!</div>
    <% } %>

    <%-- Success Message --%>
    <% if("1".equals(request.getParameter("verified"))) { %>
        <div class="success">✅ Email verified! Please login.</div>
    <% } %>
    <% if("1".equals(request.getParameter("reset"))) { %>
        <div class="success">✅ Password reset successful! Please login.</div>
    <% } %>

    <%-- Login Form --%>
    <form action="LoginServlet" method="post">
        <div class="form-group">
            <label>📧 Email Address</label>
            <input type="email" name="email" placeholder="Enter your email" required/>
        </div>
        <div class="form-group">
            <label>🔒 Password</label>
            <input type="password" name="password" placeholder="Enter your password" required/>
        </div>
        <div class="forgot">
            <a href="forgotPassword.jsp">🔑 Forgot Password?</a>
        </div>
        <button type="submit" class="btn">Login →</button>
    </form>

    <div class="divider">─── or ───</div>
   <div class="link">
    New resident? <a href="register.jsp">Register here</a>
    <br/>
    <small style="color:#aaa;">⚙️ Admin accounts are created by system administrator only</small>
</div>

</div>
</body>
</html>