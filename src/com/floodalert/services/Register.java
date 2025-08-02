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
 * Servlet implementation class Register
 */
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Register() {
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
		
		int cid = 0;
		String cname = request.getParameter("name");
		String ccontact = request.getParameter("contact");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String cdistrict = request.getParameter("district");
		String cstate = request.getParameter("state");
		String ccity = request.getParameter("city");
		String clocality = request.getParameter("locality");
		String cpincode = request.getParameter("pincode");
		
		try{
			Connection con = ConnectDb.getConnect();
			
			PreparedStatement p = con.prepareStatement("SELECT * FROM citizen WHERE email = ?");
			p.setString(1,  email);
			ResultSet r = p.executeQuery();
			
			if(r.next()) {
				response.sendRedirect("index.html");
			} else {
				PreparedStatement s = con.prepareStatement("INSERT INTO citizen VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				
				s.setInt(1, cid);
				s.setString(2, cname);
				s.setString(3, cstate);
				s.setString(4, cdistrict);
				s.setString(5, ccity);
				s.setString(6, clocality);
				s.setString(7, cpincode);
				s.setString(8, ccontact);
				s.setString(9, email);
				s.setString(10, password);

				
				int i = s.executeUpdate();
				
				if(i > 0) {
					response.sendRedirect("citizen-dashboard.jsp");
				} else {
					response.sendRedirect("error.html");
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.html");
		}
		
	}

}
