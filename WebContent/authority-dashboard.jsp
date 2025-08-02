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
    <title>Authority Dashboard | FloodAlert India</title>
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

        .form-group input, 
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .submit-btn {
            background-color: var(--primary-blue);
            color: var(--white);
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .submit-btn:hover {
            background-color: var(--dark-blue);
        }

        /* Emergency Reports Table */
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

        .respond-btn {
            background-color: var(--safe-green);
            color: var(--white);
        }

        .severity-high {
            color: var(--warning-red);
            font-weight: 600;
        }

        .severity-medium {
            color: var(--warning-orange);
            font-weight: 600;
        }

        .severity-low {
            color: var(--safe-green);
            font-weight: 600;
        }

        /* Change Password Form */
        .password-form {
            max-width: 500px;
            margin: 0 auto;
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
            <i class="fas fa-user-shield fa-2x"></i>
            <h2>Authority Panel</h2>
        </div>
        <div class="nav-links">
            <a href="#" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a>
            <a href="#add-alert"><i class="fas fa-bell"></i> <span>Add Flood Alert</span></a>
            <a href="#emergencies"><i class="fas fa-exclamation-triangle"></i> <span>Respond to Emergencies</span></a>
            <a href="#change-password"><i class="fas fa-key"></i> <span>Change Password</span></a>
            <a href="index.html"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Authority Dashboard</h1>
            <div class="user-info">
                <img src="assets/Authority.png" alt="Authority">
                <span>Welcome, Authority</span>
            </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="dashboard-cards">
            <div class="card">
                <h3>Active Alerts</h3>
                <%
				    try {
				        Connection con = ConnectDb.getConnect();
				
				        // Replace 'alerts' and 'status' with your actual table and column names
				        PreparedStatement ps = con.prepareStatement(
				            "SELECT COUNT(*) AS active_alerts FROM alerts"
				        );
				
				        ResultSet rs = ps.executeQuery();
				        
				        if (rs.next()) {
				%>
				            <p><%= rs.getInt("active_alerts") %></p>
				<%
				        }
				    } catch (Exception e) {
				        e.printStackTrace();
				    }
				%>

            </div>
            <div class="card">
                <h3>Pending Emergencies</h3>
                <%
				    try {
				        Connection con = ConnectDb.getConnect();

				        PreparedStatement ps = con.prepareStatement(
				            "SELECT COUNT(*) AS pending_reports FROM reports WHERE rstatus = 'pending'"
				        );
				
				        ResultSet rs = ps.executeQuery();
				        
				        if (rs.next()) {
				%>
				            <p><%= rs.getInt("pending_reports") %></p>
				<%
				        }
				    } catch (Exception e) {
				        e.printStackTrace();
				    }
				%>

            </div>
            <div class="card">
                <h3>Resolved Emergencies</h3>
                <%
				    try {
				        Connection con = ConnectDb.getConnect();
				        
				        PreparedStatement ps = con.prepareStatement(
				            "SELECT COUNT(*) AS resolved_reports FROM reports WHERE rstatus = 'actioned'"
				        );
				
				        ResultSet rs = ps.executeQuery();
				        
				        if (rs.next()) {
				%>
				            <p><%= rs.getInt("resolved_reports") %></p>
				<%
				        }
				    } catch (Exception e) {
				        e.printStackTrace();
				    }
				%>

            </div>
        </div>

        <!-- Add Flood Alert Form -->
        <div id="add-alert" class="form-container">
		    <h2><i class="fas fa-bell"></i> Add New Flood Alert</h2>
		    <form action="AddAlert" method="POST">
		        
		        <!-- Severity Level -->
		        <div class="form-group">
		            <label for="severitylevel">Severity Level</label>
		            <select id="severitylevel" name="severitylevel" required>
		                <option value="">Select Severity</option>
		                <option value="Critical">Critical</option>
		                <option value="High">High</option>
		                <option value="Moderate">Moderate</option>
		                <option value="Low">Low</option>
		            </select>
		        </div>
		
		        <!-- Alert Message -->
		        <div class="form-group">
		            <label for="amessage">Alert Message</label>
		            <textarea id="amessage" name="amessage" required></textarea>
		        </div>
		
		        <!-- Alert Date -->
		        <div class="form-group">
		            <label for="adate">Alert Date</label>
		            <input type="date" id="adate" name="adate" required>
		        </div>
		
		        <!-- State -->
		        <div class="form-group">
		            <label for="astate">State</label>
		            <input type="text" id="astate" name="astate" required>
		        </div>
		
		        <!-- District -->
		        <div class="form-group">
		            <label for="adistrict">District</label>
		            <input type="text" id="adistrict" name="adistrict" required>
		        </div>
		
		        <!-- City -->
		        <div class="form-group">
		            <label for="acity">City</label>
		            <input type="text" id="acity" name="acity" required>
		        </div>
		
		        <!-- Submit Button -->
		        <button type="submit" class="submit-btn">Issue Alert</button>
		    </form>
		</div>


        <!-- Respond to Emergencies Table -->
        <div id="emergencies" class="table-container">
		    <h2><i class="fas fa-exclamation-triangle"></i> Emergency Reports</h2>
		    <table>
		        <thead>
		            <tr>
		                <th>Report ID</th>
		                <th>Location</th>
		                <th>Description</th>
		                <th>Date</th>
		                <th>Status</th>
		                <th>Image</th>
		                <th>Actions</th>
		            </tr>
		        </thead>
		        <tbody>
		            <%
		                try {
		                    Connection con = ConnectDb.getConnect();
		                    PreparedStatement ps = con.prepareStatement("SELECT * FROM reports");
		                    ResultSet rs = ps.executeQuery();
		
		                    while (rs.next()) {
		                        int rid = rs.getInt("rid");
		                        String rdesc = rs.getString("rdesc");
		                        String rdate = rs.getString("rdate");
		                        String rstatus = rs.getString("rstatus");
		                        String imageUrl = rs.getString("image_url");
		                        String rcity = rs.getString("rcity");
		                        String rdistrict = rs.getString("rdistrict");
		                        String rstate = rs.getString("rstate");
		
		                        String location = rcity + ", " + rdistrict + ", " + rstate;
		            %>
		            <tr>
		                <td><%= rid %></td>
		                <td><%= location %></td>
		                <td><%= rdesc %></td>
		                <td><%= rdate %></td>
		                <td><%= rstatus %></td>
		                <td>
		                    <% if (imageUrl != null && !imageUrl.trim().isEmpty()) { %>
		                        <a href="<%= imageUrl %>" target="_blank">View Image</a>
		                    <% } else { %>
		                        N/A
		                    <% } %>
		                </td>
		                <td>
						    <%
						    int statusLevel = 0;
						    if ("Pending".equalsIgnoreCase(rstatus)) {
						        statusLevel = 1;
						    } else if ("Reviewed".equalsIgnoreCase(rstatus)) {
						        statusLevel = 2;
						    } else if ("Actioned".equalsIgnoreCase(rstatus)) {
						        statusLevel = 3;
						    }
						%>
						
						<form action="ResolveEmergency" method="POST" onChange="this.submit();">
						    <input type="hidden" name="rid" value="<%= rid %>">
						    <select name="rstatus" class="status-dropdown">
						        <option value="Pending" 
						            <%= "Pending".equalsIgnoreCase(rstatus) ? "selected" : "" %>
						            <%= statusLevel > 1 ? "disabled" : "" %>>
						            Pending
						        </option>
						
						        <option value="Reviewed" 
						            <%= "Reviewed".equalsIgnoreCase(rstatus) ? "selected" : "" %>
						            <%= statusLevel > 2 ? "disabled" : "" %>>
						            In Progress
						        </option>
						
						        <option value="Actioned" 
						            <%= "Actioned".equalsIgnoreCase(rstatus) ? "selected" : "" %>>
						            Resolved
						        </option>
						    </select>
						</form>

						</td>
		            </tr>
		            <%
		                    }
		                } catch (Exception e) {
		                    e.printStackTrace();
		            %>
		            <tr>
		                <td colspan="7">Error loading data.</td>
		            </tr>
		            <%
		                }
		            %>
		        </tbody>
		    </table>
		    
		    <script>
			    function respondToEmergency(rid) {
			        if (!confirm("Mark this report as Resolved?")) return;
			
			        fetch("UpdateReportStatus?rid=" + rid + "&status=Resolved", {
			            method: "GET"
			        })
			        .then(response => {
			            if (response.ok) {
			                alert("Report marked as Resolved.");
			                location.reload();
			            } else {
			                alert("Failed to update status.");
			            }
			        })
			    }
			</script>
		    
		</div>


        <!-- Change Password Form -->
        <div id="change-password" class="form-container password-form">
            <h2><i class="fas fa-key"></i> Change Password</h2>
            <form action="ChangePassword" method="POST">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required minlength="8">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="8">
                </div>
                <button type="submit" class="submit-btn">Update Password</button>
            </form>
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