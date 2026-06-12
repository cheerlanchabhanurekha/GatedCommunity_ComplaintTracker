package com.gated.dao;

import com.gated.model.Notification;
import com.gated.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class NotificationDAO {

    public void saveNotification(Notification n) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.persist(n);
        tx.commit();
        session.close();
    }

    public List<Notification> getNotificationsByUser(int userId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Notification> list = session.createQuery(
            "FROM Notification WHERE userId=:uid ORDER BY createdDate DESC",
            Notification.class)
            .setParameter("uid", userId)
            .list();
        session.close();
        return list;
    }

    public int getUnreadCount(int userId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Long count = session.createQuery(
            "SELECT COUNT(*) FROM Notification WHERE userId=:uid AND isRead=false",
            Long.class)
            .setParameter("uid", userId)
            .uniqueResult();
        session.close();
        return count.intValue();
    }

    public void markAllRead(int userId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.createMutationQuery(
            "UPDATE Notification SET isRead=true WHERE userId=:uid")
            .setParameter("uid", userId)
            .executeUpdate();
        tx.commit();
        session.close();
    }
}
