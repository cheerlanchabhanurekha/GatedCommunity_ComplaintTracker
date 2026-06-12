<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Gated Community</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a3c6e 0%, #2d6a9f 100%); display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .card { background: white; padding: 40px; border-radius: 16px; width: 500px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .logo { text-align: center; margin-bottom: 25px; }
        .logo h2 { color: #1a3c6e; font-size: 22px; }
        .logo p { color: #888; font-size: 13px; }
        .form-row { display: flex; gap: 12px; }
        .form-group { margin-bottom: 15px; flex: 1; }
        label { font-size: 13px; color: #444; font-weight: 600; display: block; margin-bottom: 5px; }
        input, select { width: 100%; padding: 11px 14px; border: 1.5px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: all 0.3s; }
        input:focus, select:focus { border-color: #1a3c6e; outline: none; box-shadow: 0 0 0 3px rgba(26,60,110,0.1); }
        .btn { width: 100%; padding: 13px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.3s; margin-top: 5px; }
        .btn:hover { background: #0f2a52; }
        .link { text-align: center; margin-top: 15px; font-size: 13px; color: #666; }
        .link a { color: #1a3c6e; font-weight: 600; text-decoration: none; }
        .section-title { font-size: 12px; color: #1a3c6e; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin: 15px 0 10px; border-bottom: 2px solid #e8f0fe; padding-bottom: 5px; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <div style="font-size:40px">🏢</div>
        <h2>Gated Community</h2>
        <p>Create your resident account</p>
    </div>
<% if("nameRequired".equals(request.getParameter("error"))) { %>
    <div style="background:#fff0f0;border:1px solid #ffcccc;color:#cc0000;
                padding:10px;border-radius:8px;font-size:13px;margin-bottom:15px;text-align:center;">
        ❌ Name is required!
    </div>
<% } %>
    <form action="RegisterServlet" method="post">
        <input type="hidden" name="action" value="register"/>

        <div class="section-title">👤 Personal Info</div>
        <div class="form-row">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="John Doe" required/>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" placeholder="9876543210" required/>
            </div>
        </div>

        <div class="section-title">🏠 Flat Details</div>
        <div class="form-row">
            <div class="form-group">
                <label>Block Name</label>
                <select name="blockName">
                    <option>Block A</option>
                    <option>Block B</option>
                    <option>Block C</option>
                    <option>Block D</option>
                </select>
            </div>
            <div class="form-group">
                <label>Flat Number</label>
                <input type="text" name="flatNumber" placeholder="A-101" required/>
            </div>
        </div>

        <div class="section-title">🔐 Account Info</div>
        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="john@email.com" required/>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Minimum 6 characters" required/>
        </div>

        <button type="submit" class="btn">Register & Send OTP →</button>
    </form>

    <div class="link">
        Already registered? <a href="login.jsp">Login here</a>
    </div>
</div>
</body>
</html>