package com.gated.servlet;

import com.gated.dao.UserDAO;
import com.gated.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/ProfileServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) { res.sendRedirect("login.jsp"); return; }

        // Upload folder path
        String uploadDir = getServletContext().getRealPath("") + "uploads/";
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        // Photo save cheyyi
        Part filePart = req.getPart("profilePic");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = "profile_" + user.getId() + "_" +
                filePart.getSubmittedFileName();
            String filePath = uploadDir + fileName;
            filePart.write(filePath);

            // DB update cheyyi
            user.setProfilePic("uploads/" + fileName);
            new UserDAO().updateUser(user);
            session.setAttribute("user", user);
        }

        res.sendRedirect("profile.jsp?success=1");
    }
}
