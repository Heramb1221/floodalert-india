package com.floodalert.dbcon;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectDb {

	static Connection con = null;
	
	public static Connection getConnect() {

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/flood_db", "root", "Heramb@1221");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return con;
	}
	
}