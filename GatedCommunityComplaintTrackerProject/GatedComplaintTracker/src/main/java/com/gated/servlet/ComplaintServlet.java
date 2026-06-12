package com.gated.servlet;

import com.gated.dao.ComplaintDAO;
import com.gated.dao.NotificationDAO;
import com.gated.model.Complaint;
import com.gated.model.Notification;
import com.gated.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.util.Date;

@WebServlet("/ComplaintServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class ComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) { res.sendRedirect("login.jsp"); return; }

        // ── Photo Upload ──
        String photoPath = null;
        try {
            Part photoPart = req.getPart("photo");
            System.out.println("Photo part: " + photoPart);
            System.out.println("Photo size: " + (photoPart != null ? photoPart.getSize() : 0));

            if (photoPart != null && photoPart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/") + "uploads";
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                String fileName = "complaint_" + user.getId() + "_"
                    + System.currentTimeMillis() + "_"
                    + photoPart.getSubmittedFileName();

                String fullPath = uploadDir + File.separator + fileName;
                photoPart.write(fullPath);
                photoPath = "uploads/" + fileName;

                System.out.println("✅ Photo saved at: " + fullPath);
                System.out.println("✅ Photo path in DB: " + photoPath);
            } else {
                System.out.println("❌ No photo uploaded or size is 0");
            }
        } catch (Exception e) {
            System.out.println("❌ Photo upload error: " + e.getMessage());
            e.printStackTrace();
        }

        // ── Complaint Save ──
        Complaint c = new Complaint();
        c.setUserId(user.getId());
        c.setCategory(req.getParameter("category"));
        c.setDescription(req.getParameter("description"));
        c.setUrgency(req.getParameter("urgency"));
        c.setStatus("Pending");
        c.setPhoto(photoPath);
        c.setCreatedDate(new Date());

        System.out.println("Saving complaint with photo: " + photoPath);
        new ComplaintDAO().saveComplaint(c);

        // ── Notification ──
        Notification n = new Notification();
        n.setUserId(user.getId());
        n.setMessage("Your complaint about '"
            + c.getCategory() + "' submitted successfully!");
        new NotificationDAO().saveNotification(n);

        res.sendRedirect("viewComplaints.jsp?success=1");
    }
}