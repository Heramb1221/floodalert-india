<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection" %>
<%@page import="com.floodalert.dbcon.ConnectDb" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		try {
			String a_id = request.getParameter("a_id");
			
			Connection con = ConnectDb.getConnect();
			PreparedStatement ps = con.prepareStatement("DELETE FROM alerts WHERE a_id = ?");
			ps.setString(1, a_id);
			int i = ps.executeUpdate();
			
			if(i > 0) {
				response.sendRedirect("admin-dashboard.jsp");
			} else {
				response.sendRedirect("error.html");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>