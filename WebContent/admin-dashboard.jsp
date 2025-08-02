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
    <title>Admin Dashboard | FloodAlert India</title>
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
        }

        /* Vertical Navbar */
        .navbar {
            width: 250px;
            background: linear-gradient(to bottom, var(--primary-blue), var(--dark-blue));
            color: var(--white);
            height: 100vh;
            position: fixed;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
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
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }

        .header h1 {
            color: var(--dark-blue);
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        /* Dashboard Cards */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: var(--white);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            color: var(--dark-gray);
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .card p {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--primary-blue);
        }

        /* Tables */
        .table-container {
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--primary-blue);
            color: var(--white);
            font-weight: 500;
        }

        tr:hover {
            background-color: rgba(2, 136, 209, 0.05);
        }

        .action-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
            font-size: 0.8rem;
        }

        .edit-btn {
            background-color: var(--saffron);
            color: var(--white);
        }

        .delete-btn {
            background-color: var(--warning-red);
            color: var(--white);
        }

        /* Form Styles */
        .form-container {
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .submit-btn {
            background-color: var(--primary-blue);
            color: var(--white);
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                width: 70px;
            }
            .navbar-header h2, .nav-links a span {
                display: none;
            }
            .nav-links a {
                justify-content: center;
            }
            .main-content {
                margin-left: 70px;
            }
        }
    </style>
</head>
<body>
    <!-- Vertical Navbar -->
    <div class="navbar">
        <div class="navbar-header">
            <i class="fas fa-shield-alt fa-2x"></i>
            <h2>Admin Panel</h2>
        </div>
        <div class="nav-links">
            <a href="#" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a>
            <a href="#add-authority"><i class="fas fa-user-plus"></i> <span>Add Authority</span></a>
            <a href="#view-authorities"><i class="fas fa-users"></i> <span>View Authorities</span></a>
            <a href="#view-citizens"><i class="fas fa-users"></i> <span>View Citizens</span></a>
            <a href="#view-alerts"><i class="fas fa-bell"></i> <span>View Alerts</span></a>
            <a href="index.html"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <div class="user-info">
                <img src="assets/admin.png" alt="Admin">
                <span>Welcome, Admin</span>
            </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="dashboard-cards">
            <div class="card">
                <h3>Total Authorities</h3>
                <%
					try {
						
						Connection con = ConnectDb.getConnect();
						PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total_authorities FROM authority");
						ResultSet rs1 = ps.executeQuery();
						
						if(rs1.next()) {
							%>
							<p><%=rs1.getInt("total_authorities") %></p>
							<% 
						} else {
						}
					} catch(Exception e) {
						e.printStackTrace();
					}
				%>
                <p>${authoritiesCount}</p>
            </div>
            <div class="card">
                <h3>Total Citizens</h3>
                
                <%
					try {
						
						Connection con = ConnectDb.getConnect();
						PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total_citizens FROM citizen");
						ResultSet rs2 = ps.executeQuery();
						
						if(rs2.next()) {
							%>
							<p><%=rs2.getInt("total_citizens") %></p>
							<% 
						} else {
						}
					} catch(Exception e) {
						e.printStackTrace();
					}
				%>

            </div>
            <div class="card">
                <h3>Active Alerts</h3>
                <%
					try {
						
						Connection con = ConnectDb.getConnect();
						PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total_alerts FROM alerts");
						ResultSet rs3 = ps.executeQuery();
						
						if(rs3.next()) {
							%>
							<p><%=rs3.getInt("total_alerts") %></p>
							<% 
						} else {
						}
					} catch(Exception e) {
						e.printStackTrace();
					}
				%>
            </div>
            <div class="card">
                <h3>Emergency Reports</h3>
                <%
					try {
						
						Connection con = ConnectDb.getConnect();
						PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total_reports FROM reports");
						ResultSet rs4 = ps.executeQuery();
						
						if(rs4.next()) {
							%>
							<p><%=rs4.getInt("total_reports") %></p>
							<% 
						} else {
						}
					} catch(Exception e) {
						e.printStackTrace();
					}
				%>
            </div>
        </div>

        <!-- Add Authority Form (Visible when #add-authority is in URL) -->
        <div id="add-authority" class="form-container">
            <h2>Add New Authority</h2>
            <form action="AddAuthority" method="POST">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="department">Department</label>
                    <input type="text" id="department" name="department" required>
                </div>
                <div class="form-group">
                    <label for="contact">Contact Number</label>
                    <input type="tel" id="contact" name="contact" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="zone">Zone</label>
                    <input type="text" id="zone" name="zone" required>
                </div>
                <button type="submit" class="submit-btn">Add Authority</button>
            </form>
        </div>

        <!-- View Authorities Table -->
        <div id="view-authorities" class="table-container">
            <h2>Authorities List</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Contact</th>
                        <th>Email</th>
                        <th>Zone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <%
				  try {
					
				  	Connection con = ConnectDb.getConnect();
				  	PreparedStatement ps = con.prepareStatement("SELECT * FROM authority");
				  	ResultSet rs = ps.executeQuery();
				  	
				  	while(rs.next()) {
				  		%>
				  		
				  			<tr>
							   <td><%=rs.getInt("aid") %></td>
							   <td><%=rs.getString("aname") %></td>
							   <td><%=rs.getString("adepartment") %></td>
							   <td><%=rs.getString("acontact") %></td>
							   <td><%=rs.getString("email") %></td>
							   <td><%=rs.getString("zone") %></td>
							   <td><a href="deleteAuthority.jsp?aid=<%=rs.getInt("aid")%>">Delete</a></td>
							 </tr>
				  		
				  		<%
				  	}
				  } catch(Exception e) {
				  	e.printStackTrace();
				  }
			  	
			  %>
            </table>
        </div>

        <!-- View Citizens Table -->
        <div id="view-citizens" class="table-container">
            <h2>Citizens List</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>State</th>
                        <th>Contact</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <%
				  try {
					
				  	Connection con = ConnectDb.getConnect();
				  	PreparedStatement ps = con.prepareStatement("SELECT * FROM citizen");
				  	ResultSet rs = ps.executeQuery();
				  	
				  	while(rs.next()) {
				  		%>
				  		
				  			<tr>
							   <td><%=rs.getInt("cid") %></td>
							   <td><%=rs.getString("cname") %></td>
							   <td><%=rs.getString("cstate") %></td>
							   <td><%=rs.getString("ccontact") %></td>
							   <td><%=rs.getString("email") %></td>
							   <td><a href="deleteCitizen.jsp?cid=<%=rs.getInt("cid")%>">Delete</a></td>
							 </tr>
				  		
				  		<%
				  	}
				  } catch(Exception e) {
				  	e.printStackTrace();
				  }
			  	
			  %>
            </table>
        </div>

        <!-- View Alerts Table -->
        <div id="view-alerts" class="table-container">
            <h2>Flood Alerts</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Location</th>
                        <th>Severity</th>
                        <th>Message</th>
                        <th>Date Issued</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <%
				  try {
					
				  	Connection con = ConnectDb.getConnect();
				  	PreparedStatement ps = con.prepareStatement("SELECT * FROM alerts");
				  	ResultSet rs = ps.executeQuery();
				  	
				  	while(rs.next()) {
				  		%>
				  		
				  			<tr>
							   <td><%=rs.getInt("a_id") %></td>
							   <td><%=rs.getString("astate") %></td>
							   <td><%=rs.getString("severitylevel") %></td>
							   <td><%=rs.getString("amessage") %></td>
							   <td><%=rs.getString("adate") %></td>
							   <td><a href="deleteAlerts.jsp?a_id=<%=rs.getInt("a_id")%>">Delete</a></td>
							 </tr>
				  		
				  		<%
				  	}
				  } catch(Exception e) {
				  	e.printStackTrace();
				  }
			  	
			  %>
            </table>
        </div>
    </div>

    <script>
        // Simple tab navigation
        document.querySelectorAll('.nav-links a').forEach(link => {
            link.addEventListener('click', function(e) {
                // Hide all sections
                document.querySelectorAll('.form-container, .table-container').forEach(section => {
                    section.style.display = 'none';
                });
                
                // Show selected section
                const target = this.getAttribute('href');
                if(target !== 'logout.jsp' && target !== '#') {
                    document.querySelector(target).style.display = 'block';
                    e.preventDefault();
                }
                
                // Update active link
                document.querySelectorAll('.nav-links a').forEach(a => {
                    a.classList.remove('active');
                });
                this.classList.add('active');
            });
        });

        // Show dashboard by default and hide other sections
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.form-container, .table-container').forEach(section => {
                section.style.display = 'none';
            });
        });
    </script>
</body>
</html>