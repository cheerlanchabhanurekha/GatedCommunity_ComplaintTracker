package com.gated.servlet;

import com.gated.dao.UserDAO;
import com.gated.model.User;
import com.gated.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Date;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // Step 1 — Email submit chesthe OTP send cheyyi
        if ("sendOtp".equals(action)) {
            String email = req.getParameter("email");
            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);

            if (user == null) {
                res.sendRedirect("forgotPassword.jsp?error=notfound");
                return;
            }

            String otp = EmailUtil.generateOTP();
            Date expiry = new Date(System.currentTimeMillis() + 5 * 60 * 1000);
            user.setOtp(otp);
            user.setOtpExpiry(expiry);
            dao.updateUser(user);

            try {
                EmailUtil.sendOTP(email, otp);
            } catch (Exception e) {
                e.printStackTrace();
            }

            req.getSession().setAttribute("resetEmail", email);
            res.sendRedirect("verifyForgotOtp.jsp");

        // Step 2 — OTP verify cheyyi
        } else if ("verifyOtp".equals(action)) {
            String email = (String) req.getSession().getAttribute("resetEmail");
            String enteredOtp = req.getParameter("otp");

            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);

            if (user != null && user.getOtp() != null
                    && user.getOtp().equals(enteredOtp)
                    && new Date().before(user.getOtpExpiry())) {
                req.getSession().setAttribute("otpVerified", true);
                res.sendRedirect("resetPassword.jsp");
            } else {
                res.sendRedirect("verifyForgotOtp.jsp?error=1");
            }

        // Step 3 — New password save cheyyi
        } else if ("resetPassword".equals(action)) {
            String email = (String) req.getSession().getAttribute("resetEmail");
            Boolean verified = (Boolean) req.getSession().getAttribute("otpVerified");

            if (email == null || verified == null || !verified) {
                res.sendRedirect("forgotPassword.jsp");
                return;
            }

            String newPassword = req.getParameter("newPassword");
            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);
            user.setPassword(com.gated.util.PasswordUtil.hashPassword(newPassword));
            user.setOtp(null);
            dao.updateUser(user);

            req.getSession().removeAttribute("resetEmail");
            req.getSession().removeAttribute("otpVerified");

            res.sendRedirect("login.jsp?reset=1");
        }
    }
}