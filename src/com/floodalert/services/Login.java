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
 * Servlet implementation class Login
 */
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
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
			
			String userType = request.getParameter("userType");
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			
			String sql = "SELECT * FROM "+userType+ " WHERE email = ? AND password = ?";
			
			Connection con = ConnectDb.getConnect();
					
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, password);
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				
				if (userType.equals("citizen")) {
                    response.sendRedirect("citizen-dashboard.jsp");
                } else if (userType.equals("authority")) {
                    response.sendRedirect("authority-dashboard.jsp");
                } else if (userType.equals("admin")) {
                    response.sendRedirect("admin-dashboard.jsp");
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
