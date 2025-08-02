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
			String aid = request.getParameter("aid");
			
			Connection con = ConnectDb.getConnect();
			PreparedStatement ps = con.prepareStatement("DELETE FROM authority WHERE aid = ?");
			ps.setString(1, aid);
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