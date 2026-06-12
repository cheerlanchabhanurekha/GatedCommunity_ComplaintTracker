<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Gated Community</title>
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
        .back-link { display: block; margin-top: 20px; color: #1a3c6e; text-decoration: none; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
<div class="card">
    <div class="icon">🔑</div>
    <h2>Forgot Password?</h2>
    <p>Enter your registered email — we'll send an OTP to reset your password</p>

    <% if("notfound".equals(request.getParameter("error"))) { %>
        <div class="error">❌ Email not registered!</div>
    <% } %>

    <form action="ForgotPasswordServlet" method="post">
        <input type="hidden" name="action" value="sendOtp"/>
        <div class="form-group">
            <label>📧 Email Address</label>
            <input type="email" name="email" placeholder="Enter your email" required/>
        </div>
        <button type="submit" class="btn">Send OTP →</button>
    </form>
    <a href="login.jsp" class="back-link">← Back to Login</a>
</div>
</body>
</html>