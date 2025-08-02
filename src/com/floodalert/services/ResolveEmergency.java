package com.floodalert.services;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.floodalert.dbcon.ConnectDb;

/**
 * Servlet implementation class ResolveEmergency
 */
public class ResolveEmergency extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResolveEmergency() {
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
            int rid = Integer.parseInt(request.getParameter("rid"));
            String newStatus = request.getParameter("rstatus");

            Connection con = ConnectDb.getConnect();
            PreparedStatement ps = con.prepareStatement("UPDATE reports SET rstatus = ? WHERE rid = ?");
            ps.setString(1, newStatus);
            ps.setInt(2, rid);

            int i = ps.executeUpdate();
            if (i > 0) {
                response.sendRedirect("authority-dashboard.jsp"); // or wherever the table is displayed
            } else {
                response.sendRedirect("error.html");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.html");
        }
		
	}

}
