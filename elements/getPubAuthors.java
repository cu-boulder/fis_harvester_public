//=====================================================================
//
//  File:    connectURL.java      
//  Summary: This Microsoft JDBC Driver for SQL Server sample application
//	     demonstrates how to connect to a SQL Server database by using
//	     a connection URL. It also demonstrates how to retrieve data 
//	     from a SQL Server database by using an SQL statement.
//
//---------------------------------------------------------------------
//
//  This file is part of the Microsoft JDBC Driver for SQL Server Code Samples.
//  Copyright (C) Microsoft Corporation.  All rights reserved.
//
//  This source code is intended only as a supplement to Microsoft
//  Development Tools and/or on-line documentation.  See these other
//  materials for detailed information regarding Microsoft code samples.
//
//  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
//  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//  PARTICULAR PURPOSE.
//
//===================================================================== 

import java.sql.*;
import java.io.IOException;
import java.util.Properties;
import java.nio.file.*;
import java.io.FileInputStream;

public class getPubAuthors {

	public static void main(String[] args) {
		
		// Declare the JDBC objects.
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

                // Load JDBC connection properties file
                Properties props = new Properties();
                FileInputStream fis = null;
                try {
                    fis = new FileInputStream("../config/db.properties");
                    props.load(fis);
// load the Elements Driver Class
                    Class.forName(props.getProperty("EL_DB_DRIVER_CLASS"));
                } catch (IOException | ClassNotFoundException e) {
                    e.printStackTrace();
                }
// Connect and run sql
        	try {
        		// Establish the connection.
                        con = DriverManager.getConnection(props.getProperty("EL_DB_URL"), props.getProperty("EL_DB_USERNAME"), props.getProperty("EL_DB_PASSWORD"));
            		String SQL = "select * from [experts-authors]";
            		stmt = con.createStatement();
            		rs = stmt.executeQuery(SQL);

			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();

			// Print column headers
		 	String name = rsmd.getColumnName(1);
			System.out.print( name.toUpperCase());
			// The column count starts from 1
			for (int i = 2; i < columnCount + 1; i++ ) {
			  name = rsmd.getColumnName(i);
			  System.out.print("|" + name.toUpperCase());
			}
			System.out.println();
            
            		// Iterate through the data in the result set and display it.
            		while (rs.next()) {
            			System.out.print(rs.getString(1).replace("\n","; "));
				for (int i = 2; i < columnCount + 1; i++ ) {
				  if( rs.getString(i) != null && !rs.getString(i).isEmpty()){
            		  	    if(rs.getString(i).toUpperCase() != "NULL") { 
                                       System.out.print("|" + rs.getString(i).replace("\n","; ")); 
                                    } else { System.out.print("|"); }
 
				  } else { System.out.print("|"); }
				}
				System.out.println();

            		}
        	}
        
		// Handle any errors that may have occurred.
		catch (Exception e) {
			e.printStackTrace();
		}

		finally {
			if (rs != null) try { rs.close(); } catch(Exception e) {}
	    		if (stmt != null) try { stmt.close(); } catch(Exception e) {}
	    		if (con != null) try { con.close(); } catch(Exception e) {}
		}
	}
}

