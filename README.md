# GatedCommunity_ComplaintTracker
# 🏢 Gated Community – Complaint Tracker

A full-stack web application for managing resident complaints in gated communities and apartment complexes. Residents can raise, track, and manage complaints, while admins can monitor, assign, and resolve them efficiently — with real-time notifications, analytics, and PDF reporting.

---

## 📌 Problem Statement

Managing complaints in apartment complexes is often inefficient, with issues getting lost or unresolved due to a lack of proper tracking. This system provides a centralized platform for residents to log complaints and for the administration team to track and resolve them in a streamlined, transparent way.

---

## ✨ Features

### 👤 Resident Features
- 🔐 Secure registration with OTP email verification
- 🔑 Login with BCrypt-hashed passwords
- 🔓 Forgot password flow with OTP-based reset
- 📝 Submit complaints with category, urgency level, description, and photo
- 📋 View complaint status (Pending → In Progress → Resolved)
- ✏️ Edit or cancel complaints (while pending)
- 🗑️ Delete complaint history
- 👨‍🔧 View assigned maintenance staff details
- 🔔 Real-time notifications on status updates
- 👤 Profile management with profile picture upload

### ⚙️ Admin Features
- 📊 Analytics dashboard with interactive charts (status, urgency, category, monthly trends)
- 📄 One-click PDF report generation
- 📋 View and manage all complaints
- 🔄 Update complaint status with admin comments
- 👨‍🔧 Assign complaints to maintenance staff
- 📧 Automatic email notifications to residents on status change
- 🔒 Role-based access control (Admin accounts are not self-registrable)

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java, Servlets, JSP |
| ORM | Hibernate |
| Database | MySQL |
| Server | Apache Tomcat |
| Frontend | HTML, CSS, JavaScript |
| Charts | Chart.js |
| PDF Generation | iText |
| Email/OTP | Jakarta Mail (Gmail SMTP) |
| Security | BCrypt password hashing |

---

## 🏗️ Architecture

```
Browser (JSP Pages)
        │
        ▼
   Servlets (Controller)
        │
        ▼
   DAO Layer (Hibernate)
        │
        ▼
   MySQL Database
```

**Project Structure:**
```
GatedComplaintTracker/
├── src/main/java/com/gated/
│   ├── model/        → User, Complaint, Notification, MaintenanceStaff
│   ├── dao/           → UserDAO, ComplaintDAO, NotificationDAO, StaffDAO
│   ├── servlet/        → Login, Register, Complaint, Admin, Analytics, PDF...
│   └── util/          → HibernateUtil, EmailUtil, PasswordUtil
├── src/main/resources/
│   └── hibernate.cfg.xml
├── src/main/webapp/
│   ├── login.jsp, register.jsp, verifyOtp.jsp
│   ├── residentDashboard.jsp, submitComplaint.jsp, viewComplaints.jsp
│   ├── adminDashboard.jsp, analytics.jsp
│   ├── profile.jsp, notifications.jsp
│   └── WEB-INF/web.xml
└── pom.xml
```

---

## 🔄 Workflow

1. **Resident Registration** – Sign up with email OTP verification
2. **Complaint Submission** – Submit complaints with category, urgency, description, and photo
3. **Admin Review** – Admin views all complaints in a unified dashboard
4. **Staff Assignment** – Admin assigns complaints to relevant maintenance staff
5. **Status Updates** – Admin updates status (Pending → In Progress → Resolved)
6. **Notifications** – Residents receive in-app and email notifications on updates
7. **Reporting** – Admin generates PDF reports and views analytics

---

## 🚀 Getting Started

### Prerequisites
- JDK 17+
- Apache Tomcat 11
- MySQL 8+
- Eclipse IDE (with Dynamic Web Project support)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/GatedComplaintTracker.git
   ```

2. **Create the database**
   ```sql
   CREATE DATABASE gated_db;
   ```
   Run the schema script provided in `/database/schema.sql`

3. **Configure Hibernate**

   Update `src/main/resources/hibernate.cfg.xml` with your MySQL credentials:
   ```xml
   <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/gated_db</property>
   <property name="hibernate.connection.username">root</property>
   <property name="hibernate.connection.password">yourpassword</property>
   ```

4. **Configure Email (OTP)**

   Update `EmailUtil.java` with your Gmail App Password:
   ```java
   private static final String FROM_EMAIL = "yourgmail@gmail.com";
   private static final String PASSWORD = "your_app_password";
   ```

5. **Run on Apache Tomcat**

   Deploy the project on Tomcat 11 via Eclipse → Run As → Run on Server

6. **Access the application**
   ```
   http://localhost:8081/GatedComplaintTracker/
   ```

---

## 🔮 Future Enhancements

- 🤖 AI-based automatic complaint categorization
- 📍 Location pin / flat-wise map view
- 💬 In-app chat between residents and admin
- 📲 SMS notifications
- 🌙 Dark mode toggle
- 📊 Export complaint data to Excel

---

## 👩‍💻 Author

**Cheerlancha BhanuRekha**
Aspiring Java Full Stack Developer

📧 Feel free to connect for feedback or collaboration!

---

## 📄 License

This project is open source and available for educational purposes.<img width="1886" height="970" alt="Screenshot 2026-06-12 182855" src="https://github.com/user-attachments/assets/5152e27c-788e-464e-8042-9962adfabe8f" />
<img width="1862" height="985" alt="Screenshot 2026-06-12 183003" src="https://github.com/user-attachments/assets/a7e90a03-a027-4f01-8649-fefa09f53101" />
