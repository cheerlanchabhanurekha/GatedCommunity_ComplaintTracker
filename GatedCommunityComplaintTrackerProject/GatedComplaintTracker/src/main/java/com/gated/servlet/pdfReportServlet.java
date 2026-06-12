//package com.gated.servlet;
//
//import com.gated.dao.ComplaintDAO;
//import com.gated.model.Complaint;
//import com.gated.model.User;
//import com.itextpdf.text.*;
//import com.itextpdf.text.pdf.*;
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import jakarta.servlet.annotation.WebServlet;
//import java.io.*;
//import java.text.SimpleDateFormat;
//import java.util.*;
//
//
//@WebServlet("/PdfReportServlet")
//public class pdfReportServlet extends HttpServlet {
//
//    protected void doGet(HttpServletRequest req, HttpServletResponse res)
//            throws ServletException, IOException {
//
//        // Admin check
//        HttpSession session = req.getSession();
//        User admin = (User) session.getAttribute("user");
//        if (admin == null || !"ADMIN".equals(admin.getRole())) {
//            res.sendRedirect("login.jsp");
//            return;
//        }
//
//        // All complaints get cheyyi
//        List<Complaint> complaints = new ComplaintDAO().getAllComplaints();
//
//        // PDF response setup
//        res.setContentType("application/pdf");
//        res.setHeader("Content-Disposition",
//            "attachment; filename=complaint_report_" +
//            new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf");
//
//        try {
//            Document doc = new Document(PageSize.A4);
//            PdfWriter.getInstance(doc, res.getOutputStream());
//            doc.open();
//
//            // ── Fonts ──
//            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD,
//                new BaseColor(26, 60, 110));
//            Font headingFont = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD,
//                new BaseColor(255, 255, 255));
//            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL,
//                new BaseColor(50, 50, 50));
//            Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD,
//                new BaseColor(50, 50, 50));
//            Font smallFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL,
//                new BaseColor(100, 100, 100));
//            Font pendingFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
//                new BaseColor(230, 81, 0));
//            Font progressFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
//                new BaseColor(21, 101, 192));
//            Font resolvedFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
//                new BaseColor(46, 125, 50));
//
//            // ── Header ──
//            PdfPTable headerTable = new PdfPTable(1);
//            headerTable.setWidthPercentage(100);
//            PdfPCell headerCell = new PdfPCell();
//            headerCell.setBackgroundColor(new BaseColor(26, 60, 110));
//            headerCell.setPadding(20);
//            headerCell.setBorder(Rectangle.NO_BORDER);
//
//            Paragraph title = new Paragraph("🏢 Gated Community", titleFont);
//            title.setAlignment(Element.ALIGN_CENTER);
//            Font whiteFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL,
//                new BaseColor(255, 255, 255));
//            Paragraph subtitle = new Paragraph("Complaint Management Report", whiteFont);
//            subtitle.setAlignment(Element.ALIGN_CENTER);
//            Font dateFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL,
//                new BaseColor(200, 210, 230));
//            Paragraph dateP = new Paragraph(
//                "Generated on: " + new SimpleDateFormat("dd MMM yyyy, hh:mm a")
//                    .format(new Date()), dateFont);
//            dateP.setAlignment(Element.ALIGN_CENTER);
//
//            headerCell.addElement(title);
//            headerCell.addElement(subtitle);
//            headerCell.addElement(dateP);
//            headerTable.addCell(headerCell);
//            doc.add(headerTable);
//            doc.add(Chunk.NEWLINE);
//
//            // ── Summary Stats ──
//            long pending = complaints.stream()
//                .filter(c -> "Pending".equals(c.getStatus())).count();
//            long inProgress = complaints.stream()
//                .filter(c -> "In Progress".equals(c.getStatus())).count();
//            long resolved = complaints.stream()
//                .filter(c -> "Resolved".equals(c.getStatus())).count();
//
//            PdfPTable statsTable = new PdfPTable(4);
//            statsTable.setWidthPercentage(100);
//            statsTable.setSpacingBefore(10);
//            statsTable.setSpacingAfter(15);
//
//            addStatCell(statsTable, "Total", String.valueOf(complaints.size()),
//                new BaseColor(26, 60, 110));
//            addStatCell(statsTable, "Pending", String.valueOf(pending),
//                new BaseColor(230, 81, 0));
//            addStatCell(statsTable, "In Progress", String.valueOf(inProgress),
//                new BaseColor(21, 101, 192));
//            addStatCell(statsTable, "Resolved", String.valueOf(resolved),
//                new BaseColor(46, 125, 50));
//
//            doc.add(statsTable);
//
//            // ── Category Breakdown ──
//            Paragraph catTitle = new Paragraph("Category Breakdown", boldFont);
//            catTitle.setSpacingBefore(5);
//            catTitle.setSpacingAfter(8);
//            doc.add(catTitle);
//
//            Map<String, Long> categoryCount = new LinkedHashMap<>();
//            complaints.forEach(c -> {
//                String cat = c.getCategory() != null ? c.getCategory() : "Unknown";
//                categoryCount.merge(cat, 1L, Long::sum);
//            });
//
//            PdfPTable catTable = new PdfPTable(3);
//            catTable.setWidthPercentage(60);
//            catTable.setHorizontalAlignment(Element.ALIGN_LEFT);
//            catTable.setWidths(new float[]{3, 1, 2});
//            catTable.setSpacingAfter(15);
//
//            addTableHeader(catTable, new String[]{"Category", "Count", "Percentage"},
//                headingFont, new BaseColor(26, 60, 110));
//
//            categoryCount.forEach((cat, count) -> {
//                double pct = complaints.isEmpty() ? 0 :
//                    (count * 100.0 / complaints.size());
//                PdfPCell c1 = new PdfPCell(new Phrase(cat, normalFont));
//                PdfPCell c2 = new PdfPCell(new Phrase(String.valueOf(count), normalFont));
//                PdfPCell c3 = new PdfPCell(
//                    new Phrase(String.format("%.1f%%", pct), normalFont));
//                c1.setPadding(6); c2.setPadding(6); c3.setPadding(6);
//                c2.setHorizontalAlignment(Element.ALIGN_CENTER);
//                c3.setHorizontalAlignment(Element.ALIGN_CENTER);
//                catTable.addCell(c1);
//                catTable.addCell(c2);
//                catTable.addCell(c3);
//            });
//            doc.add(catTable);
//
//            // ── Complaints Table ──
//            Paragraph tableTitle = new Paragraph("All Complaints", boldFont);
//            tableTitle.setSpacingBefore(5);
//            tableTitle.setSpacingAfter(8);
//            doc.add(tableTitle);
//
//            PdfPTable table = new PdfPTable(6);
//            table.setWidthPercentage(100);
//            table.setWidths(new float[]{0.5f, 2f, 1.5f, 1f, 1f, 2f});
//            table.setSpacingAfter(10);
//
//            addTableHeader(table,
//                new String[]{"#", "Description", "Category", "Urgency",
//                    "Status", "Date"},
//                headingFont, new BaseColor(26, 60, 110));
//
//            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
//            boolean alternate = false;
//            for (Complaint c : complaints) {
//                BaseColor rowColor = alternate ?
//                    new BaseColor(240, 244, 248) : BaseColor.WHITE;
//                alternate = !alternate;
//
//                Font statusFont = normalFont;
//                String status = c.getStatus() != null ? c.getStatus() : "Pending";
//                if ("Pending".equals(status)) statusFont = pendingFont;
//                else if ("In Progress".equals(status)) statusFont = progressFont;
//                else if ("Resolved".equals(status)) statusFont = resolvedFont;
//
//                String desc = c.getDescription() != null ? c.getDescription() : "-";
//                if (desc.length() > 40) desc = desc.substring(0, 40) + "...";
//
//                String dateStr = c.getCreatedDate() != null ?
//                    sdf.format(c.getCreatedDate()) : "-";
//
//                addRow(table, new String[]{
//                    String.valueOf(c.getId()),
//                    desc,
//                    c.getCategory() != null ? c.getCategory() : "-",
//                    c.getUrgency() != null ? c.getUrgency() : "-",
//                    status,
//                    dateStr
//                }, normalFont, statusFont, rowColor);
//            }
//            doc.add(table);
//
//            // ── Footer ──
//            doc.add(Chunk.NEWLINE);
//            Font footerFont = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC,
//                new BaseColor(150, 150, 150));
//            Paragraph footer = new Paragraph(
//                "This report was automatically generated by Gated Community " +
//                "Complaint Management System.", footerFont);
//            footer.setAlignment(Element.ALIGN_CENTER);
//            doc.add(footer);
//
//            doc.close();
//
//        } catch (DocumentException e) {
//            e.printStackTrace();
//            res.sendError(500, "PDF generation failed!");
//        }
//    }
//
//    // ── Helper: Stat Cell ──
//    private void addStatCell(PdfPTable table, String label,
//            String value, BaseColor color) {
//        PdfPCell cell = new PdfPCell();
//        cell.setBackgroundColor(color);
//        cell.setPadding(12);
//        cell.setBorder(Rectangle.NO_BORDER);
//        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
//
//        Font valFont = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD,
//            BaseColor.WHITE);
//        Font labFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL,
//            new BaseColor(220, 230, 240));
//
//        Paragraph val = new Paragraph(value, valFont);
//        val.setAlignment(Element.ALIGN_CENTER);
//        Paragraph lab = new Paragraph(label, labFont);
//        lab.setAlignment(Element.ALIGN_CENTER);
//
//        cell.addElement(val);
//        cell.addElement(lab);
//        table.addCell(cell);
//    }
//
//    // ── Helper: Table Header ──
//    private void addTableHeader(PdfPTable table, String[] headers,
//            Font font, BaseColor bgColor) {
//        for (String h : headers) {
//            PdfPCell cell = new PdfPCell(new Phrase(h, font));
//            cell.setBackgroundColor(bgColor);
//            cell.setPadding(8);
//            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
//            table.addCell(cell);
//        }
//    }
//
//    // ── Helper: Table Row ──
//    private void addRow(PdfPTable table, String[] values,
//            Font defaultFont, Font statusFont, BaseColor bgColor) {
//        for (int i = 0; i < values.length; i++) {
//            Font f = (i == 4) ? statusFont : defaultFont;
//            PdfPCell cell = new PdfPCell(new Phrase(values[i], f));
//            cell.setBackgroundColor(bgColor);
//            cell.setPadding(6);
//            if (i == 4) cell.setHorizontalAlignment(Element.ALIGN_CENTER);
//            table.addCell(cell);
//        }
//    }
//}
package com.gated.servlet;

import com.gated.dao.ComplaintDAO;
import com.gated.model.Complaint;
import com.gated.model.User;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

@WebServlet("/PdfReportServlet")
public class pdfReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Admin check
        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("user");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        // Fetch complaints
        List<Complaint> complaints = new ComplaintDAO().getAllComplaints();

        // PDF response setup
        res.setContentType("application/pdf");
        res.setHeader("Content-Disposition",
                "attachment; filename=complaint_report_"
                        + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date())
                        + ".pdf");

        try {
            Document doc = new Document(PageSize.A4);
            PdfWriter.getInstance(doc, res.getOutputStream());
            doc.open();

            // Fonts
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD,
                    new BaseColor(26, 60, 110));

            Font headingFont = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD,
                    BaseColor.WHITE);

            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL,
                    new BaseColor(50, 50, 50));

            Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD,
                    new BaseColor(50, 50, 50));

            Font pendingFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
                    new BaseColor(230, 81, 0));

            Font progressFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
                    new BaseColor(21, 101, 192));

            Font resolvedFont = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD,
                    new BaseColor(46, 125, 50));

            // Header
            PdfPTable headerTable = new PdfPTable(1);
            headerTable.setWidthPercentage(100);

            PdfPCell headerCell = new PdfPCell();
            headerCell.setBackgroundColor(new BaseColor(26, 60, 110));
            headerCell.setPadding(20);
            headerCell.setBorder(Rectangle.NO_BORDER);

            Paragraph title = new Paragraph("🏢 Gated Community", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);

            Font whiteFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL,
                    BaseColor.WHITE);

            Paragraph subtitle = new Paragraph("Complaint Management Report", whiteFont);
            subtitle.setAlignment(Element.ALIGN_CENTER);

            Paragraph dateP = new Paragraph(
                    "Generated on: " +
                            new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new Date()),
                    new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, BaseColor.LIGHT_GRAY)
            );
            dateP.setAlignment(Element.ALIGN_CENTER);

            headerCell.addElement(title);
            headerCell.addElement(subtitle);
            headerCell.addElement(dateP);

            headerTable.addCell(headerCell);
            doc.add(headerTable);

            doc.add(Chunk.NEWLINE);

            // Summary
            long pending = complaints.stream().filter(c -> "Pending".equals(c.getStatus())).count();
            long inProgress = complaints.stream().filter(c -> "In Progress".equals(c.getStatus())).count();
            long resolved = complaints.stream().filter(c -> "Resolved".equals(c.getStatus())).count();

            PdfPTable statsTable = new PdfPTable(4);
            statsTable.setWidthPercentage(100);

            addStatCell(statsTable, "Total", String.valueOf(complaints.size()), new BaseColor(26, 60, 110));
            addStatCell(statsTable, "Pending", String.valueOf(pending), new BaseColor(230, 81, 0));
            addStatCell(statsTable, "In Progress", String.valueOf(inProgress), new BaseColor(21, 101, 192));
            addStatCell(statsTable, "Resolved", String.valueOf(resolved), new BaseColor(46, 125, 50));

            doc.add(statsTable);

            doc.add(Chunk.NEWLINE);

            // Category Breakdown
            Paragraph catTitle = new Paragraph("Category Breakdown", boldFont);
            doc.add(catTitle);

            Map<String, Long> categoryCount = new LinkedHashMap<>();
            for (Complaint c : complaints) {
                String cat = c.getCategory() != null ? c.getCategory() : "Unknown";
                categoryCount.put(cat, categoryCount.getOrDefault(cat, 0L) + 1);
            }

            PdfPTable catTable = new PdfPTable(3);
            catTable.setWidthPercentage(80);

            addTableHeader(catTable, new String[]{"Category", "Count", "Percentage"});

            for (Map.Entry<String, Long> entry : categoryCount.entrySet()) {
                double pct = complaints.isEmpty() ? 0 :
                        (entry.getValue() * 100.0 / complaints.size());

                catTable.addCell(entry.getKey());
                catTable.addCell(String.valueOf(entry.getValue()));
                catTable.addCell(String.format("%.1f%%", pct));
            }

            doc.add(catTable);

            doc.add(Chunk.NEWLINE);

            // Complaints table
            Paragraph tableTitle = new Paragraph("All Complaints", boldFont);
            doc.add(tableTitle);

            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);

            addTableHeader(table,
                    new String[]{"ID", "Description", "Category", "Urgency", "Status", "Date"});

            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

            for (Complaint c : complaints) {

                String status = c.getStatus() != null ? c.getStatus() : "Pending";

                table.addCell(String.valueOf(c.getId()));
                table.addCell(c.getDescription());
                table.addCell(c.getCategory());
                table.addCell(c.getUrgency());
                table.addCell(status);
                table.addCell(c.getCreatedDate() != null ? sdf.format(c.getCreatedDate()) : "-");
            }

            doc.add(table);

            doc.close();

        } catch (DocumentException e) {
            throw new ServletException("PDF generation failed", e);
        }
    }

    // ---------- Helpers ----------

    private void addStatCell(PdfPTable table, String label, String value, BaseColor color) {
        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(color);
        cell.setPadding(10);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setBorder(Rectangle.NO_BORDER);

        Font valFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.WHITE);
        Font labFont = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, BaseColor.WHITE);

        cell.addElement(new Paragraph(value, valFont));
        cell.addElement(new Paragraph(label, labFont));

        table.addCell(cell);
    }

    private void addTableHeader(PdfPTable table, String[] headers) {
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h));
            cell.setBackgroundColor(new BaseColor(26, 60, 110));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(5);
            table.addCell(cell);
        }
    }
}