package com.floodalert.services;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.floodalert.dbcon.ConnectDb;

/**
 * Servlet implementation class ChangePassword
 */
public class ChangePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangePassword() {
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
		
		try{
			
			String currentPassword = request.getParameter("currentPassword");
			String newPassword = request.getParameter("newPassword");
			String confirmPassword = request.getParameter("confirmPassword");
			
			if(newPassword.equals(confirmPassword)) {
				Connection con = ConnectDb.getConnect();
				
				PreparedStatement p = con.prepareStatement("SELECT email FROM authority WHERE password = ?");
				p.setString(1,  currentPassword);
				ResultSet r = p.executeQuery();
				
				if(r.next()) {
					String email = r.getString("email");
					PreparedStatement p1 = con.prepareStatement("UPDATE authority SET password = ? WHERE email = ?");
					p1.setString(1, newPassword);
					p1.setString(2, email);
					
					int i = p1.executeUpdate();
					
					if(i > 0) {
						response.sendRedirect("authority-dashboard.jsp");
					} else {
						response.sendRedirect("error.html");
					}
					
				} else {
					response.sendRedirect("error.html");
				}
			} else {
				response.sendRedirect("error.html");
			}
			
			
		} catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.html");
		}
	}

}
