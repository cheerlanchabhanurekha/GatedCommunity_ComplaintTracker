package com.gated.model;

import jakarta.persistence.*;

@Entity
@Table(name = "maintenance_staff")
public class MaintenanceStaff {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    private String specialization;
    private String phone;

    @Column(name = "is_available")
    private boolean isAvailable = true;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSpecialization() { return specialization; }
    public void setSpecialization(String s) { this.specialization = s; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean a) { isAvailable = a; }
}