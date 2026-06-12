package com.gated.servlet;

import com.gated.dao.UserDAO;
import com.gated.model.User;
import com.gated.util.EmailUtil;
import com.gated.util.PasswordUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Date;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("register".equals(action)) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String flatNumber = req.getParameter("flatNumber");
            String phone = req.getParameter("phone");
            String blockName = req.getParameter("blockName");

         // Validation
         if (name == null || name.trim().isEmpty()) {
             res.sendRedirect("register.jsp?error=nameRequired");
             return;
         }

            String otp = EmailUtil.generateOTP();
            Date expiry = new Date(System.currentTimeMillis() + 5 * 60 * 1000);

            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setFlatNumber(flatNumber);
            user.setPhone(phone);
            user.setBlockName(blockName);
            user.setOtp(otp);
            user.setOtpExpiry(expiry);
            user.setVerified(false);

            new UserDAO().saveUser(user);

            try {
                EmailUtil.sendOTP(email, otp);
            } catch (Exception e) {
                e.printStackTrace();
            }

            req.getSession().setAttribute("pendingEmail", email);
            res.sendRedirect("verifyOtp.jsp");

        } else if ("verify".equals(action)) {
            String email = (String) req.getSession().getAttribute("pendingEmail");
            String enteredOtp = req.getParameter("otp");

            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);

            if (user != null && user.getOtp() != null
                    && user.getOtp().equals(enteredOtp)
                    && new Date().before(user.getOtpExpiry())) {
                user.setVerified(true);
                user.setOtp(null);
                dao.updateUser(user);
                res.sendRedirect("login.jsp?verified=1");
            } else {
                res.sendRedirect("verifyOtp.jsp?error=1");
            }
        }
    }
}