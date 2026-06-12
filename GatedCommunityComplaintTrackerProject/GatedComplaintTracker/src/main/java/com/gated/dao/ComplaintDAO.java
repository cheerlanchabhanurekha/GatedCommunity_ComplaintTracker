package com.gated.dao;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import com.gated.model.Complaint;
import com.gated.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class ComplaintDAO {

    public void saveComplaint(Complaint c) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.persist(c);
        tx.commit();
        session.close();
    }

    public List<Complaint> getAllComplaints() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Complaint> list = session.createQuery(
            "FROM Complaint", Complaint.class).list();
        session.close();
        return list;
    }

    public List<Complaint> getComplaintsByUser(int userId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Complaint> list = session.createQuery(
            "FROM Complaint WHERE userId=:uid", Complaint.class)
            .setParameter("uid", userId).list();
        session.close();
        return list;
    }

    public void updateStatus(int complaintId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        Complaint c = session.get(Complaint.class, complaintId);
        c.setStatus(status);
        session.merge(c);
        tx.commit();
        session.close();
    }
    public Complaint getComplaintById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Complaint c = session.get(Complaint.class, id);
        session.close();
        return c;
    }

    public void updateComplaint(Complaint c) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.merge(c);
        tx.commit();
        session.close();
    }
    public void deleteComplaint(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        Complaint c = session.get(Complaint.class, id);
        if (c != null) session.remove(c);
        tx.commit();
        session.close();
    }
}