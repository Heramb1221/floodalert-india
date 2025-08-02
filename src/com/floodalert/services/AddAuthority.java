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
 * Servlet implementation class AddAuthority
 */
public class AddAuthority extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddAuthority() {
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
			
			Connection con = ConnectDb.getConnect();
			int id = 0;
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String department = request.getParameter("department");
			String zone = request.getParameter("zone");
			String name = request.getParameter("name");
			String contact = request.getParameter("contact");
					
			PreparedStatement ps = con.prepareStatement("INSERT INTO authority VALUES(?, ?, ?, ?, ?, ?, ?)");
			ps.setInt(1, id);
			ps.setString(2, name);
			ps.setString(3, department);
			ps.setString(4, contact);
			ps.setString(5, email);
			ps.setString(6, password);
			ps.setString(7, zone);
			
			int i = ps.executeUpdate();
			
			if(i > 0) {
				
				response.sendRedirect("admin-dashboard.jsp");
				
			} else {
				response.sendRedirect("error.html");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.html");
		}
	}

}
