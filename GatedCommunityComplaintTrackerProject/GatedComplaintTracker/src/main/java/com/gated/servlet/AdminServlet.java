package com.gated.servlet;

import com.gated.dao.ComplaintDAO;
import com.gated.dao.NotificationDAO;
import com.gated.dao.UserDAO;
import com.gated.model.Complaint;
import com.gated.model.Notification;
import com.gated.model.User;
import com.gated.util.EmailUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Date;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("user");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        int complaintId = Integer.parseInt(req.getParameter("complaintId"));
        String status = req.getParameter("status");
        String adminComment = req.getParameter("adminComment");

        ComplaintDAO dao = new ComplaintDAO();
        Complaint c = dao.getComplaintById(complaintId);
        c.setStatus(status);
        c.setAdminComment(adminComment);
        String staffIdStr = req.getParameter("staffId");
        if (staffIdStr != null && !staffIdStr.isEmpty()) {
            c.setAssignedStaffId(Integer.parseInt(staffIdStr));
        }

        if ("Resolved".equals(status)) {
            c.setResolvedDate(new Date());
        }
        dao.updateComplaint(c);

        // Notification save 
        Notification n = new Notification();
        n.setUserId(c.getUserId());
        n.setMessage("Your complaint '" + c.getCategory() +
            "' status updated to: " + status);
        new NotificationDAO().saveNotification(n);

        // Email send 
        try {
            User resident = new UserDAO().getUserById(c.getUserId());
            if (resident != null) {
                EmailUtil.sendStatusUpdate(
                    resident.getEmail(),
                    resident.getName(),
                    c.getCategory(),
                    status
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        res.sendRedirect("adminDashboard.jsp?success=1");
    }
}