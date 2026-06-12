package com.gated.servlet;

import com.gated.dao.UserDAO;
import com.gated.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            if (!user.isVerified()) {
                res.sendRedirect("login.jsp?error=notverified");
                return;
            }
            
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            if ("ADMIN".equals(user.getRole())) {
                res.sendRedirect("adminDashboard.jsp");
            } else {
                res.sendRedirect("residentDashboard.jsp");
            }
        } else {
            res.sendRedirect("login.jsp?error=invalid");
        }
    }
}