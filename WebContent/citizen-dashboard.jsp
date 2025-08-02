<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection" %>
<%@page import="com.floodalert.dbcon.ConnectDb" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Dashboard | FloodAlert India</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #1a5f9c;
            --secondary-blue: #0288d1;
            --dark-blue: #0d47a1;
            --saffron: #FF9933;
            --white: #ffffff;
            --light-gray: #f5f5f5;
            --dark-gray: #333333;
            --warning-red: #e53935;
            --warning-orange: #fb8c00;
            --safe-green: #43a047;
            --text-light: #666;
            --text-color: #333;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            display: flex;
            min-height: 100vh;
            background-color: var(--light-gray);
            color: var(--text-color);
        }

        /* Vertical Navbar */
        .navbar {
            width: 250px;
            background: linear-gradient(to bottom, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            height: 100vh;
            position: fixed;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 100;
        }

        .navbar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .navbar-header h2 {
            margin-top: 10px;
            font-size: 1.2rem;
        }

        .nav-links {
            padding: 20px 0;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--white);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .nav-links a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .nav-links a:hover, .nav-links a.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-left: 4px solid var(--saffron);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
            background-color: var(--light-gray);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .header h1 {
            color: var(--dark-blue);
            font-size: 28px;
            font-weight: 600;
        }

        .user-info {
            display: flex;
            align-items: center;
            background: var(--white);
            padding: 8px 15px;
            border-radius: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .user-info img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid var(--primary-blue);
        }

        /* Alert Cards */
        .alert-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .alert-card {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 4px solid var(--primary-blue);
        }

        .alert-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
        }

        .alert-card.high {
            border-left-color: var(--warning-red);
        }

        .alert-card.medium {
            border-left-color: var(--warning-orange);
        }

        .alert-card.low {
            border-left-color: var(--safe-green);
        }

        .alert-card h3 {
            color: var(--dark-gray);
            font-size: 1.1rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .alert-card .location {
            font-weight: 600;
            color: var(--primary-blue);
        }

        .alert-card .date {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        .alert-card .severity {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .severity-high {
            background-color: rgba(229, 57, 53, 0.1);
            color: var(--warning-red);
        }

        .severity-medium {
            background-color: rgba(251, 140, 0, 0.1);
            color: var(--warning-orange);
        }

        .severity-low {
            background-color: rgba(67, 160, 71, 0.1);
            color: var(--safe-green);
        }

        /* Form Styles */
        .form-container {
            background: var(--white);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            padding: 25px;
            margin-bottom: 30px;
            display: none;
        }

        .form-container.active {
            display: block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-gray);
        }

        .form-group input, 
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s;
        }

        .form-group input:focus, 
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--primary-blue);
            outline: none;
            box-shadow: 0 0 0 3px rgba(26, 95, 156, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
        }

        .submit-btn {
            background-color: var(--primary-blue);
            color: var(--white);
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
            font-size: 15px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .submit-btn:hover {
            background-color: var(--dark-blue);
        }

        .submit-btn i {
            margin-right: 8px;
        }

        /* Change Password Form */
        .password-form {
            max-width: 500px;
            margin: 0 auto;
        }

        /* Alert Banner */
        .alert-banner {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            color: white;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(229, 57, 53, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(229, 57, 53, 0); }
            100% { box-shadow: 0 0 0 0 rgba(229, 57, 53, 0); }
        }
        
        .alert-banner.emergency {
            background: linear-gradient(to right, #e53935, #c62828);
        }
        
        .alert-banner i {
            font-size: 1.5rem;
            margin-right: 15px;
        }
        
        .alert-content {
            flex: 1;
        }
        
        .alert-content h3 {
            margin-bottom: 5px;
            font-size: 18px;
        }
        
        .alert-dismiss {
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0 0 0 15px;
            opacity: 0.8;
            transition: opacity 0.3s;
        }
        
        .alert-dismiss:hover {
            opacity: 1;
        }
        
        /* Stat Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            display: flex;
            align-items: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(26, 95, 156, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: var(--primary-blue);
            font-size: 1.2rem;
        }
        
        .stat-info h3 {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .stat-info p {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-blue);
            margin-bottom: 5px;
        }
        
        .stat-info a {
            color: var(--primary-blue);
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: color 0.3s;
        }
        
        .stat-info a:hover {
            color: var(--dark-blue);
            text-decoration: underline;
        }
        
        .stat-info a i {
            margin-left: 5px;
            font-size: 0.8rem;
        }
        
        /* Dashboard Sections */
        .dashboard-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        
        .dashboard-section h2 {
            color: var(--dark-blue);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
        }
        
        .dashboard-section h2 i {
            color: var(--primary-blue);
        }
        
        /* Flood Map */
        .flood-map-container {
            position: relative;
            margin-bottom: 15px;
        }
        
        .map-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 300px;
            background-color: #f0f8ff;
            border-radius: 8px;
            color: var(--text-light);
        }
        
        .map-placeholder i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: var(--primary-blue);
        }
        
        .map-placeholder p {
            font-size: 16px;
        }
        
        .map-legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 15px;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        
        .legend-color {
            width: 18px;
            height: 18px;
            border-radius: 4px;
        }
        
        .legend-color.high-risk { background-color: #e53935; }
        .legend-color.medium-risk { background-color: #fb8c00; }
        .legend-color.low-risk { background-color: #fdd835; }
        .legend-color.safe { background-color: #43a047; }
        
        /* Alert List */
        .alert-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .alert-item {
            border-left: 4px solid;
            padding: 18px;
            background: white;
            border-radius: 0 8px 8px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .alert-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .alert-item.high { border-color: #e53935; }
        .alert-item.medium { border-color: #fb8c00; }
        .alert-item.low { border-color: #fdd835; }
        
        .alert-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            align-items: center;
        }
        
        .alert-header h3 {
            font-size: 16px;
            font-weight: 600;
        }
        
        .alert-severity {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .alert-item.high .alert-severity { background: rgba(229, 57, 53, 0.1); color: #e53935; }
        .alert-item.medium .alert-severity { background: rgba(251, 140, 0, 0.1); color: #fb8c00; }
        .alert-item.low .alert-severity { background: rgba(253, 216, 53, 0.1); color: #c79100; }
        
        .alert-time {
            font-size: 0.8rem;
            color: var(--text-light);
        }
        
        .alert-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-more-info {
            padding: 8px 16px;
            background: var(--primary-blue);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .btn-more-info:hover {
            background-color: var(--dark-blue);
        }
        
        .btn-share-alert {
            padding: 8px 16px;
            background: white;
            color: var(--primary-blue);
            border: 1px solid var(--primary-blue);
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-share-alert:hover {
            background-color: rgba(26, 95, 156, 0.05);
        }
        
        .view-all-link {
            display: block;
            text-align: right;
            margin-top: 15px;
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .view-all-link:hover {
            color: var(--dark-blue);
            text-decoration: underline;
        }
        
        .view-all-link i {
            margin-left: 5px;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .action-card {
            padding: 25px 20px;
            border-radius: 10px;
            text-align: center;
            color: var(--text-color);
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.05);
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        
        .action-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            transition: transform 0.3s ease;
        }
        
        .action-card:hover .action-icon {
            transform: scale(1.1);
        }
        
        .action-card .emergency { background-color: #e53935; }
        .action-card .guide { background-color: #1a5f9c; }
        .action-card .checklist { background-color: #43a047; }
        .action-card .contacts { background-color: #6a1b9a; }
        
        .action-card h3 {
            margin-bottom: 8px;
            font-size: 18px;
            color: var(--dark-gray);
        }
        
        .action-card p {
            font-size: 14px;
            color: var(--text-light);
            line-height: 1.5;
        }
        
        /* Weather Widget */
        .weather-widget {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .current-weather {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }
        
        .weather-main {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .weather-icon {
            font-size: 3rem;
            color: var(--primary-blue);
        }
        
        .weather-temp h3 {
            margin-bottom: 5px;
            font-size: 16px;
            color: var(--dark-gray);
        }
        
        .weather-temp p {
            font-size: 28px;
            font-weight: 600;
            color: var(--dark-blue);
        }
        
        .weather-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        
        .weather-details p {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--text-color);
        }
        
        .weather-details i {
            color: var(--primary-blue);
            width: 20px;
            text-align: center;
        }
        
        .weather-forecast {
            display: flex;
            justify-content: space-between;
            overflow-x: auto;
            gap: 20px;
            padding-bottom: 10px;
        }
        
        .forecast-day {
            min-width: 70px;
            text-align: center;
            padding: 10px;
            background: rgba(26, 95, 156, 0.05);
            border-radius: 8px;
        }
        
        .forecast-day p:first-child {
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .forecast-day i {
            font-size: 1.8rem;
            margin: 8px 0;
            color: var(--primary-blue);
        }
        
        .forecast-day p:last-child {
            font-size: 14px;
            color: var(--text-light);
        }
        
        /* Report Cards */
        .card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-left: 4px solid var(--primary-blue);
        }
        
        .card.high {
            border-left-color: var(--warning-red);
        }
        
        .card.medium {
            border-left-color: var(--warning-orange);
        }
        
        .card.low {
            border-left-color: var(--safe-green);
        }
        
        .card h3 {
            color: var(--dark-gray);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card h3 i {
            color: var(--primary-blue);
        }
        
        .card p {
            margin-bottom: 8px;
            line-height: 1.5;
        }
        
        .card p strong {
            color: var(--dark-gray);
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .main-content {
                padding: 20px;
            }
            
            .dashboard-cards {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .quick-actions {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .navbar {
                width: 70px;
                overflow: hidden;
            }
            
            .navbar-header h2, .nav-links a span {
                display: none;
            }
            
            .nav-links a {
                justify-content: center;
                padding: 15px 0;
            }
            
            .nav-links a i {
                margin-right: 0;
                font-size: 1.2rem;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .dashboard-cards, .quick-actions {
                grid-template-columns: 1fr;
            }
            
            .current-weather {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .weather-details {
                grid-template-columns: 1fr;
                width: 100%;
            }
        }
        
        @media (max-width: 576px) {
            .main-content {
                padding: 15px;
            }
            
            .dashboard-section, .form-container {
                padding: 20px;
            }
            
            .alert-actions {
                flex-direction: column;
            }
            
            .btn-more-info, .btn-share-alert {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Vertical Navbar -->
    <div class="navbar">
        <div class="navbar-header">
            <i class="fas fa-user fa-2x"></i>
            <h2>Citizen Panel</h2>
        </div>
        <div class="nav-links">
            <a href="#" class="active" onclick="showSection('dashboard')"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a>
            <a href="#view-alerts" onclick="showSection('view-alerts')"><i class="fas fa-bell"></i> <span>View Flood Alerts</span></a>
            <a href="#report-incident" onclick="showSection('report-incident')"><i class="fas fa-exclamation-circle"></i> <span>Report Flood Incident</span></a>
            <a href="#change-password" onclick="showSection('change-password')"><i class="fas fa-key"></i> <span>Change Password</span></a>
            <a href="index.html"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Dashboard Section (shown by default) -->
        <div id="dashboard">
            <div class="header">
                <h1>Citizen Dashboard</h1>
                <div class="user-info">
                    <img src="assets/Citizen.png" alt="Citizen">
                    <span>Welcome, Citizen</span>
                </div>
            </div>
        
            <!-- Quick Stats Cards -->
            <div class="dashboard-cards">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Alerts</h3>
                        <p>${activeAlertsCount}</p>
                        <a href="#view-alerts" onclick="showSection('view-alerts')">View Details <i class="fas fa-chevron-right"></i></a>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-map-marked-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Nearby Shelters</h3>
                        <p>${nearbySheltersCount}</p>
                        <a href="">View Map <i class="fas fa-chevron-right"></i></a>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Emergency Contacts</h3>
                        <p>${emergencyContactsCount}</p>
                        <a href="contacts.html">View Numbers <i class="fas fa-chevron-right"></i></a>
                    </div>
                </div>
            </div>
        
            <!-- Recent Alerts -->
			<div class="dashboard-section">
			    <h2><i class="fas fa-exclamation-circle"></i> Recent Alerts</h2>
			    <div class="alert-list">
			        <%
			            try {
			                Connection con = ConnectDb.getConnect();
			
			                PreparedStatement ps = con.prepareStatement("SELECT * FROM alerts ORDER BY adate DESC LIMIT 3");
			                ResultSet rs = ps.executeQuery();
			
			                if(rs.next()) {
			                    String severity = rs.getString("severitylevel");
			                    String amessage = rs.getString("amessage");
			                    String adate = rs.getString("adate");
			                    String astate = rs.getString("astate");
			                    String adistrict = rs.getString("adistrict");
			                    String acity = rs.getString("acity");
			
			                    String cardClass = "";
			                    if (severity.equalsIgnoreCase("High")) {
			                        cardClass = "high";
			                    } else if (severity.equalsIgnoreCase("Medium")) {
			                        cardClass = "medium";
			                    } else {
			                        cardClass = "low";
			                    }
			
			                    String location = acity + ", " + adistrict + ", " + astate;
			        %>
			        <div class="alert-item <%= cardClass %>">
			            <div class="alert-header">
			                <h3><%= location %> <span class="alert-severity"><%= severity %> Risk</span></h3>
			                <span class="alert-time"><%= adate %></span>
			            </div>
			            <p><%= amessage %></p>
			            <div class="alert-actions">
						    <button class="btn-more-info" onclick="showSection('view-alerts')">More Info</button>
						    <%
							    String safeMessage = amessage.replace("'", "\\\\'")
							                                 .replace("\"", "\\\"")
							                                 .replace("\n", " ")
							                                 .replace("\r", " ");
							%>
							<button class="btn-share-alert" onclick="shareAlert('<%= safeMessage %>')">
							    <i class="fas fa-share-alt"></i> Share
							</button>

						</div>
			        </div>
			        <%
			                } // end while
			            } catch (Exception e) {
			                e.printStackTrace();
			        %>
			        <p>Error loading alerts.</p>
			        <%
			            }
			        %>
			
			        <a href="#view-alerts" onclick="showSection('view-alerts')" class="view-all-link">
			            View All Alerts <i class="fas fa-arrow-right"></i>
			        </a>
			    </div>
			</div>

        
            <!-- Quick Actions -->
            <div class="dashboard-section">
                <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
                <div class="quick-actions">
                    <a href="#report-incident" onclick="showSection('report-incident')" class="action-card">
                        <div class="action-icon emergency">
                            <i class="fas fa-exclamation"></i>
                        </div>
                        <h3>Report Flood</h3>
                        <p>Submit a flood incident report</p>
                    </a>
                    <a href="safety.html" class="action-card">
                        <div class="action-icon guide">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3>Safety Guide</h3>
                        <p>Learn flood preparedness</p>
                    </a>
                    <a href="emergencyKit.html" class="action-card">
                        <div class="action-icon checklist">
                            <i class="fas fa-clipboard-check"></i>
                        </div>
                        <h3>Emergency Kit</h3>
                        <p>View checklist</p>
                    </a>
                    <a href="contacts.html" class="action-card">
                        <div class="action-icon contacts">
                            <i class="fas fa-address-book"></i>
                        </div>
                        <h3>Contacts</h3>
                        <p>Emergency numbers</p>
                    </a>
                </div>
            </div>
        
            <!-- Weather Forecast -->
			<div class="dashboard-section">
			    <h2><i class="fas fa-cloud-rain"></i> Weather Forecast</h2>
			    <div class="weather-widget">
			        <div class="current-weather">
			            <div class="weather-main">
			                <i class="fas fa-cloud-showers-heavy weather-icon"></i>
			                <div class="weather-temp">
			                    <h3>Rain</h3>
			                    <p>18°C</p>
			                </div>
			            </div>
			            <div class="weather-details">
			                <p><i class="fas fa-tint"></i> Humidity: 85%</p>
			                <p><i class="fas fa-wind"></i> Wind: 12 km/h</p>
			                <p><i class="fas fa-umbrella"></i> Rain: 75% chance</p>
			                <p><i class="fas fa-eye"></i> Visibility: 8 km</p>
			            </div>
			        </div>
			        <div class="weather-forecast">
			            <div class="forecast-day">
			                <p>Mon</p>
			                <i class="fas fa-cloud-showers-heavy"></i>
			                <p>17°C</p>
			                <p>80%</p>
			            </div>
			            <div class="forecast-day">
			                <p>Tue</p>
			                <i class="fas fa-cloud-sun"></i>
			                <p>20°C</p>
			                <p>30%</p>
			            </div>
			            <div class="forecast-day">
			                <p>Wed</p>
			                <i class="fas fa-sun"></i>
			                <p>23°C</p>
			                <p>10%</p>
			            </div>
			            <div class="forecast-day">
			                <p>Thu</p>
			                <i class="fas fa-sun"></i>
			                <p>24°C</p>
			                <p>5%</p>
			            </div>
			            <div class="forecast-day">
			                <p>Fri</p>
			                <i class="fas fa-cloud"></i>
			                <p>21°C</p>
			                <p>20%</p>
			            </div>
			        </div>
			    </div>
			</div>
        </div>

        <!-- View Flood Alerts Section -->
        <div id="view-alerts" class="form-container">
            <h2><i class="fas fa-bell"></i> Current Flood Alerts</h2>
            <%
                try {
                    Connection con = ConnectDb.getConnect();
        
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM alerts ORDER BY adate DESC");
                    ResultSet rs = ps.executeQuery();
        
                    while (rs.next()) {
                        String severity = rs.getString("severitylevel");
                        String amessage = rs.getString("amessage");
                        String adate = rs.getString("adate");
                        String astate = rs.getString("astate");
                        String adistrict = rs.getString("adistrict");
                        String acity = rs.getString("acity");
        
                        String cardClass = "";
                        if (severity.equalsIgnoreCase("High")) {
                            cardClass = "high";
                        } else if (severity.equalsIgnoreCase("Medium")) {
                            cardClass = "medium";
                        } else {
                            cardClass = "low";
                        }
            %>
        
            <div class="card <%= cardClass %>">
                <h3><i class="fas fa-bell"></i> <%= severity %> Severity Alert</h3>
                <p><strong>Date:</strong> <%= adate %></p>
                <p><strong>Location:</strong> <%= acity %>, <%= adistrict %>, <%= astate %></p>
                <p><strong>Message:</strong><br> <%= amessage %></p>
            </div>
        
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>

        <!-- Report Flood Incident Form -->
        <div id="report-incident" class="form-container">
            <h2><i class="fas fa-exclamation-circle"></i> Report Flood Incident</h2>
            <form action="ReportIncident" method="POST">
                <!-- State -->
                <div class="form-group">
                    <label for="rstate">State</label>
                    <input type="text" id="rstate" name="rstate" required placeholder="Enter the state">
                </div>
            
                <!-- District -->
                <div class="form-group">
                    <label for="rdistrict">District</label>
                    <input type="text" id="rdistrict" name="rdistrict" required placeholder="Enter the district">
                </div>
            
                <!-- City -->
                <div class="form-group">
                    <label for="rcity">City</label>
                    <input type="text" id="rcity" name="rcity" required placeholder="Enter the city">
                </div>

                <div class="form-group">
				    <label for="rstatus">Report Status</label>
				    <input type="text" id="rstatus" name="rstatus" value="Pending" readonly>
				    <small>Status is set to Pending by default and will be updated by authorities.</small>
				</div>
                
                <div class="form-group">
				    <label for="rdate">Date</label>
				    <input type="date" id="rdate" name="rdate" required>
				    <small>Please select the date of the incident.</small>
				</div>

                <!-- Description -->
                <div class="form-group">
                    <label for="rdescription">Incident Description</label>
                    <textarea id="rdesc" name="rdesc" required placeholder="Describe the flood situation in detail (water level, affected areas, etc.)"></textarea>
                </div>

                <!-- Image URL (Optional) -->
				<div class="form-group">
				    <label for="image_url">Image URL (Optional)</label>
				    <input type="url" id="image_url" name="image_url" placeholder="Enter image URL (e.g. https://...)">
				    <small>Enter a direct link to the image (JPG, PNG, etc.).</small>
				</div>

                <!-- Submit Button -->
                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> Submit Report
                </button>
            </form>
        </div>

        <!-- Change Password Form -->
        <div id="change-password" class="form-container">
            <h2><i class="fas fa-key"></i> Change Password</h2>
            <form action="CChangePassword" method="POST" class="password-form">
                <!-- Current Password -->
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" required placeholder="Enter your current password">
                </div>

                <!-- New Password -->
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required placeholder="Enter new password">
                    <small>Minimum 8 characters with at least 1 number and 1 special character</small>
                </div>

                <!-- Confirm New Password -->
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirm new password">
                </div>

                <!-- Submit Button -->
                <button type="submit" class="submit-btn">
                    <i class="fas fa-save"></i> Update Password
                </button>
            </form>
        </div>
    </div>

    <script>
        // Function to show/hide sections
        function showSection(sectionId) {
            // Hide all sections
            document.querySelectorAll('.form-container').forEach(section => {
                section.style.display = 'none';
            });
            document.getElementById('dashboard').style.display = 'none';

            // Show the selected section
            if (sectionId === 'dashboard') {
                document.getElementById('dashboard').style.display = 'block';
            } else {
                document.getElementById(sectionId).style.display = 'block';
            }

            // Update active nav link
            document.querySelectorAll('.nav-links a').forEach(link => {
                link.classList.remove('active');
            });
            event.currentTarget.classList.add('active');
        }
	</script>
</body>
</html>