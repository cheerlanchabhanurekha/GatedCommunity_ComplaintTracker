<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP - Gated Community</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #1a3c6e 0%, #2d6a9f 100%); display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .card { background: white; padding: 40px; border-radius: 16px; width: 400px; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        h2 { color: #1a3c6e; margin-bottom: 8px; }
        p { color: #666; font-size: 14px; margin-bottom: 25px; }
        .otp-box { display: flex; gap: 10px; justify-content: center; margin-bottom: 25px; }
        .otp-box input { width: 52px; height: 58px; text-align: center; font-size: 24px; font-weight: bold; border: 2px solid #e0e0e0; border-radius: 10px; color: #1a3c6e; transition: all 0.3s; }
        .otp-box input:focus { border-color: #1a3c6e; outline: none; box-shadow: 0 0 0 3px rgba(26,60,110,0.1); }
        .btn { width: 100%; padding: 13px; background: #1a3c6e; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; }
        .btn:hover { background: #0f2a52; }
        .error { background: #fff0f0; border: 1px solid #ffcccc; color: #cc0000; padding: 10px; border-radius: 8px; font-size: 13px; margin-bottom: 15px; }
        .timer { color: #888; font-size: 13px; margin-top: 15px; }
    </style>
</head>
<body>
<div class="card">
    <div style="font-size:50px;margin-bottom:15px">📧</div>
    <h2>Verify Your Email</h2>
    <p>Enter the 6-digit OTP sent to your email address</p>

    <% if("1".equals(request.getParameter("error"))) { %>
        <div class="error">❌ Invalid or expired OTP! Try again.</div>
    <% } %>

    <form action="RegisterServlet" method="post">
        <input type="hidden" name="action" value="verify"/>
        <div class="otp-box">
            <input type="text" maxlength="1" id="o1" oninput="move(this,'o2')"/>
            <input type="text" maxlength="1" id="o2" oninput="move(this,'o3')"/>
            <input type="text" maxlength="1" id="o3" oninput="move(this,'o4')"/>
            <input type="text" maxlength="1" id="o4" oninput="move(this,'o5')"/>
            <input type="text" maxlength="1" id="o5" oninput="move(this,'o6')"/>
            <input type="text" maxlength="1" id="o6"/>
        </div>
        <input type="hidden" name="otp" id="otpFull"/>
        <button type="submit" class="btn" onclick="combineOtp()">✅ Verify OTP</button>
    </form>
    <div class="timer">⏱️ OTP valid for 5 minutes only</div>
</div>
<script>
function move(current, nextId) {
    if(current.value.length === 1) document.getElementById(nextId).focus();
}
function combineOtp() {
    document.getElementById('otpFull').value =
        document.getElementById('o1').value +
        document.getElementById('o2').value +
        document.getElementById('o3').value +
        document.getElementById('o4').value +
        document.getElementById('o5').value +
        document.getElementById('o6').value;
}
</script>
</body>
</html>