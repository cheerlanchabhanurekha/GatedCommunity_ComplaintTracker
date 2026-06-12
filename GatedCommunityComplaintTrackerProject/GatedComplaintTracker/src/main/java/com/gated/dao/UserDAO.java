package com.gated.dao;

import com.gated.model.User;
import com.gated.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

public class UserDAO {

    public void saveUser(User user) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.persist(user);
        tx.commit();
        session.close();
    }
    public User login(String email, String password) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Query<User> q = session.createQuery(
            "FROM User WHERE email=:e", User.class);
        q.setParameter("e", email);
        User user = q.uniqueResult();
        session.close();

        if (user != null && com.gated.util.PasswordUtil.checkPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public User getUserByEmail(String email) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Query<User> q = session.createQuery(
            "FROM User WHERE email=:e", User.class);
        q.setParameter("e", email);
        User user = q.uniqueResult();
        session.close();
        return user;
    }

    public void updateUser(User user) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = session.beginTransaction();
        session.merge(user);
        tx.commit();
        session.close();
    }
    public User getUserById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        User user = session.get(User.class, id);
        session.close();
        return user;
    }
    
}