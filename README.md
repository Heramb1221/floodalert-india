# FloodAlert India

> A multi-role flood monitoring and emergency response platform built with Java Servlets, JSP, and MySQL — designed to coordinate disaster alerts between citizens, local authorities, and administrators across India.

---

![Java](https://img.shields.io/badge/Java-8-orange?style=for-the-badge&logo=openjdk)
![Servlets](https://img.shields.io/badge/JavaEE-Servlets-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/Database-MySQL-blue?style=for-the-badge&logo=mysql)
![Tomcat](https://img.shields.io/badge/Apache-Tomcat-yellow?style=for-the-badge&logo=apachetomcat)
![Status](https://img.shields.io/badge/Status-Learning%20Prototype-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

# About The Project

India experiences recurring flood disasters that affect millions of people annually. Effective alert delivery, emergency reporting, and authority coordination are critical for reducing casualties and infrastructure damage.

FloodAlert India is a full-stack web application prototype that models the core workflows of a flood alert management system.

The platform provides:

- Citizen incident reporting
- Authority-issued flood alerts
- Admin-level management dashboards
- Role-based routing and access separation
- Emergency resource information

This project was built as a practical exploration of:

- Java Servlet lifecycle
- JDBC database access
- JSP-based server-side rendering
- Relational schema design
- Multi-role application architecture

---

# Project Type

Learning-Oriented Full Stack Web Application — built using Java EE (Servlets + JSP), vanilla HTML/CSS/JavaScript, and MySQL as a hands-on exploration of servlet lifecycle management, JDBC, server-side rendering, role-based routing, and foundational backend architecture concepts in Java.

---

# Project Status

**Learning Prototype / Architecture Exploration**

This project is complete as a functional engineering prototype covering all major user flows.

The repository is intentionally preserved in its original state as a portfolio and learning artifact, including documented security flaws and architectural limitations discovered during post-development review.

Known vulnerabilities and improvements are documented transparently below.

---

# Why I Built This

Flood disasters in India frequently expose failures in communication and coordination.

This project was built to explore:

- Multi-role application architecture
- HTTP request-response lifecycle
- Role-based routing
- Database modeling
- Servlet mechanics without framework abstraction
- Security review methodology

The most valuable engineering lesson came from discovering how seemingly functional code can still be critically insecure.

---

# Features

## Core Features

- Citizen registration and login
- Flood incident reporting
- Severity-based flood alerts
- Emergency report workflow
- Admin user management
- Emergency contact resources
- Safety guideline pages
- Role-based dashboards

---

## Engineering Features

- Servlet-per-action architecture
- PreparedStatement query execution
- Relational database schema
- JSP server-side rendering
- Password strength validation
- Responsive CSS design system

---

# Tech Stack

## Frontend

| Technology | Purpose |
|---|---|
| HTML5 / CSS3 | Page structure and responsive styling |
| Vanilla JavaScript | Client-side interaction |
| CSS Custom Properties | Design token system |
| Font Awesome 6 | Icons |
| Google Fonts (Poppins) | Typography |

---

## Backend

| Technology | Purpose |
|---|---|
| Java 8 | Backend language |
| Java Servlets | HTTP request handling |
| JSP | Server-side rendering |
| Apache Tomcat 7 | Servlet container |

---

## Database

| Technology | Purpose |
|---|---|
| MySQL | Relational datastore |
| JDBC | Java-to-MySQL communication |
| PreparedStatement | Parameterized SQL execution |

---


# Architecture

## System Overview

```text
Browser (Client)
    │
    ▼
Apache Tomcat 7.0
(Servlet Container)
    │
    ├── Login Servlet
    ├── Register Servlet
    ├── AddAlert Servlet
    ├── ReportIncident Servlet
    ├── ResolveEmergency Servlet
    │
    ▼
ConnectDb (JDBC)
    │
    ▼
MySQL Database
```

---

## Request Lifecycle

```text
1. User submits form
2. Tomcat routes request to servlet
3. Servlet extracts request parameters
4. JDBC query executes
5. ResultSet processed
6. Redirect to JSP dashboard
7. JSP renders HTML
8. Response returned to browser
```

---

## Role Routing

```text
Login POST
    ├── citizen   → citizen-dashboard.jsp
    ├── authority → authority-dashboard.jsp
    └── admin     → admin-dashboard.jsp
```

> Known architectural gap:
>
> No authenticated session is created after login. Dashboard routes are directly accessible.

---


# Folder Structure

```text
FloodAlert/
├── src/
│   └── com/floodalert/
│       ├── dbcon/
│       │   └── ConnectDb.java
│       │
│       └── services/
│           ├── Login.java
│           ├── Register.java
│           ├── AddAlert.java
│           ├── AddAuthority.java
│           ├── ReportIncident.java
│           ├── ResolveEmergency.java
│           ├── ChangePassword.java
│           └── CChangePassword.java
│
├── WebContent/
│   ├── index.html
│   ├── login.html
│   ├── register.html
│   ├── admin-dashboard.jsp
│   ├── authority-dashboard.jsp
│   ├── citizen-dashboard.jsp
│   ├── css/
│   ├── js/
│   └── assets/
│
├── .classpath
├── .project
└── .gitignore
```

---

# Installation

## Prerequisites

- JDK 1.8+
- Apache Tomcat 7.0
- MySQL 8.0+
- Eclipse IDE with WTP

---

## Database Setup

```sql
CREATE DATABASE flood_db;
USE flood_db;
```

Create the following tables:

- citizen
- authority
- admin
- alerts
- reports

Insert default admin:

```sql
INSERT INTO admin (email, password)
VALUES ('admin@floodalert.in', 'admin123');
```

---

## Configure Database Connection

Update credentials in:

```java
src/com/floodalert/dbcon/ConnectDb.java
```

```java
DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/flood_db",
    "username",
    "password"
);
```

---

# Usage

## Citizen Flow

- Register account
- Login as citizen
- View alerts
- Submit reports
- Track report status

---

## Authority Flow

- Login as authority
- Issue flood alerts
- Review reports
- Update report status

---

## Admin Flow

- Login as admin
- Manage authorities
- Manage citizens
- View system statistics

---

# API Reference

| Endpoint | Method | Purpose |
|---|---|---|
| `/Login` | POST | User authentication |
| `/Register` | POST | Citizen registration |
| `/AddAlert` | POST | Create flood alert |
| `/AddAuthority` | POST | Add authority |
| `/ReportIncident` | POST | Submit incident report |
| `/ResolveEmergency` | POST | Update report status |
| `/ChangePassword` | POST | Change authority password |
| `/CChangePassword` | POST | Change citizen password |

---

# Screenshots

| Page | Screenshot |
|---|---|
| Landing Page | <img width="1901" height="864" alt="image" src="https://github.com/user-attachments/assets/991c68f7-fc6f-4837-8c4a-12d48ee1c12a" /> |
| Login Page | <img width="1917" height="866" alt="image" src="https://github.com/user-attachments/assets/5ac64bc6-37bb-4741-82cb-6e39dc6d8cfc" /> |
| Citizen Dashboard | <img width="1896" height="866" alt="image" src="https://github.com/user-attachments/assets/1b53b987-b8cb-4332-9ab5-1a99702ebd8a" /> |
| Authority Dashboard | <img width="1898" height="865" alt="image" src="https://github.com/user-attachments/assets/a73b980f-6f9d-49bd-949a-9e2fb781d722" /> |
| Admin Dashboard |<img width="1895" height="871" alt="image" src="https://github.com/user-attachments/assets/47ad2832-c1ed-4493-afa7-7c83fc6dad25" /> |

---

# Tradeoffs & Limitations

| Decision | Tradeoff |
|---|---|
| Raw JDBC | More control, less maintainability |
| JSP rendering | Faster iteration, poorer separation |
| Servlet-per-action | Better lifecycle understanding, more boilerplate |
| Hardcoded DB credentials | Faster setup, severe security risk |
| No connection pooling | Simpler setup, poor scalability |

---

# Known Issues

- Dashboard URLs bypass authentication
- `doGet()` called inside `doPost()`
- Weather widget uses static data
- Undefined `shareAlert()` function
- DELETE actions use GET requests
- Password changes not session-bound

---

# Challenges Faced

## Servlet Lifecycle

Understanding why `doGet()` should not be reused inside `doPost()`.

---

## JDBC Connection Management

Understanding thread safety and connection lifecycle problems.

---

## Role-Based Routing

Implementing multi-role routing without frameworks.

---

# What I Learned

- Raw servlet lifecycle mechanics
- PreparedStatement limitations
- Multi-threaded server behavior
- Authentication vs session management
- JSP architectural tradeoffs
- Security auditing methodology

---

# License

Distributed under the MIT License.

See `LICENSE` for details.

---

# Contact

**Heramb Chaudhari**

[![GitHub](https://img.shields.io/badge/GitHub-Heramb1221-black?style=for-the-badge&logo=github)](https://github.com/Heramb1221)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Heramb%20Chaudhari-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/heramb-chaudhari)

[![Email](https://img.shields.io/badge/Email-hchaudhari1221%40gmail.com-red?style=for-the-badge&logo=gmail)](mailto:hchaudhari1221@gmail.com)

---

Built with Java EE fundamentals. Improved through honest engineering review.
