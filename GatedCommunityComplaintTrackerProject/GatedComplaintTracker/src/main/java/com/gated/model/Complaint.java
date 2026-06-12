package com.gated.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "complaints")
public class Complaint {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "user_id", nullable = false)
    private int userId;

    private String category;
    private String description;
    private String urgency;
    private String status = "Pending";
    private String photo;

    @Column(name = "admin_comment")
    private String adminComment;
    
    @Column(name = "assigned_staff_id")
    private Integer assignedStaffId;

    public Integer getAssignedStaffId() { return assignedStaffId; }
    public void setAssignedStaffId(Integer id) { this.assignedStaffId = id; }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_date")
    private Date createdDate = new Date();

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "resolved_date")
    private Date resolvedDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getDescription() { return description; }
    public void setDescription(String d) { this.description = d; }
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }
    public String getAdminComment() { return adminComment; }
    public void setAdminComment(String c) { this.adminComment = c; }
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date d) { this.createdDate = d; }
    public Date getResolvedDate() { return resolvedDate; }
    public void setResolvedDate(Date d) { this.resolvedDate = d; }
}