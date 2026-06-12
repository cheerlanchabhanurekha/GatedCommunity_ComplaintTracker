package com.gated.servlet;

import com.gated.dao.ComplaintDAO;
import com.gated.model.Complaint;
import com.gated.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/ComplaintActionServlet")
public class ComplaintActionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) { res.sendRedirect("login.jsp"); return; }

        String action = req.getParameter("action");
        int complaintId = Integer.parseInt(req.getParameter("complaintId"));

        ComplaintDAO dao = new ComplaintDAO();
        Complaint c = dao.getComplaintById(complaintId);

        // Ownership check — resident own complaint matrame edit cheyyagaladu
        if (c == null || c.getUserId() != user.getId()) {
            res.sendRedirect("viewComplaints.jsp?error=unauthorized");
            return;
        }

        if ("update".equals(action)) {
            // Pending lo unte matrame edit cheyyagalandi
            if (!"Pending".equals(c.getStatus())) {
                res.sendRedirect("viewComplaints.jsp?error=cannotedit");
                return;
            }
            c.setCategory(req.getParameter("category"));
            c.setDescription(req.getParameter("description"));
            c.setUrgency(req.getParameter("urgency"));
            dao.updateComplaint(c);
            res.sendRedirect("viewComplaints.jsp?updated=1");

        } else if ("cancel".equals(action)) {
            if ("Resolved".equals(c.getStatus())) {
                res.sendRedirect("viewComplaints.jsp?error=cannotcancel");
                return;
            }
            c.setStatus("Cancelled");
            dao.updateComplaint(c);
            res.sendRedirect("viewComplaints.jsp?cancelled=1");

        } else if ("delete".equals(action)) {
            dao.deleteComplaint(complaintId);
            res.sendRedirect("viewComplaints.jsp?deleted=1");
        }
    }
}