package com.gated.dao;

import com.gated.model.MaintenanceStaff;
import com.gated.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;

public class StaffDAO {

    public List<MaintenanceStaff> getAllStaff() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<MaintenanceStaff> list = session.createQuery(
            "FROM MaintenanceStaff", MaintenanceStaff.class).list();
        session.close();
        return list;
    }

    public MaintenanceStaff getStaffById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        MaintenanceStaff staff = session.get(MaintenanceStaff.class, id);
        session.close();
        return staff;
    }
}