package com.floodalert.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.floodalert.dbcon.ConnectDb;

/**
 * Servlet implementation class AddAlert
 */
public class AddAlert extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddAlert() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		
		try {
			int aid = 0;
			String severityLevel = request.getParameter("severitylevel");
	        String message = request.getParameter("amessage");
	        String date = request.getParameter("adate");
	        String state = request.getParameter("astate");
	        String district = request.getParameter("adistrict");
	        String city = request.getParameter("acity");
	        
	        Connection con = ConnectDb.getConnect();
			
			PreparedStatement p = con.prepareStatement("INSERT INTO alerts VALUES (?, ?, ?, ?, ?, ?, ?)");
			p.setInt(1,  aid);
			p.setString(2,  severityLevel);
			p.setString(3,  message);
			p.setString(4,  date);
			p.setString(5,  state);
			p.setString(6,  district);
			p.setString(7,  city);
			int i  = p.executeUpdate();
			
			if(i > 0) {
				response.sendRedirect("authority-dashboard.jsp");
			} else {
				
				response.sendRedirect("error.html");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.html");
		}
		
	}

}
