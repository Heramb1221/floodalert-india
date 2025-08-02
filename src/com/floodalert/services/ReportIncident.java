package com.floodalert.services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.floodalert.dbcon.ConnectDb;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class ReportIncident
 */
public class ReportIncident extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReportIncident() {
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
		    int rid = 0;
		    String rstate = request.getParameter("rstate");
		    String rdistrict = request.getParameter("rdistrict");
		    String rcity = request.getParameter("rcity");
		    String rdesc = request.getParameter("rdesc");
		    String imageUrl = request.getParameter("image_url");
		    String rstatus = request.getParameter("rstatus");
		    String rdate = request.getParameter("rdate");

		    Connection con = ConnectDb.getConnect();

		    PreparedStatement p = con.prepareStatement("INSERT INTO reports VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
		    p.setInt(1, rid); // Usually auto-increment
		    p.setString(2, rdesc);
		    p.setString(3, rdate);
		    p.setString(4, rstatus);
		    p.setString(5, imageUrl);
		    p.setString(6, rcity);
		    p.setString(7, rdistrict);
		    p.setString(8, rstate);

		    int i = p.executeUpdate();

		    if (i > 0) {
		        response.sendRedirect("citizen-dashboard.jsp");
		    } else {
		        response.sendRedirect("error.html");
		    }

		} catch (Exception e) {
		    e.printStackTrace();
		    response.sendRedirect("error.html");
		}

		
	}

}
