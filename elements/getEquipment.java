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


public class getEquipment {

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

            		// Create and execute an SQL statement that returns some data.
            		String SQL = "SELECT [ID] ,[Additional Name] ,[Algorithm Used] , [Coded In] ,IIF([Consulting Available]=1,'YES','NO') as 'Consulting Available' ,[Owner], [Contact Phone Number] ,[Contacts] ,[Data Input Format] ,[Data Output Format] ,[Data Source] ,[Data Source Proprietary ID] ,[Description] ,[Developed by] ,[Email Contact] ,IIF([Export Controlled]=1,'YES','NO') as 'Export Controlled' ,[General Availability] ,IIF([Fee for service]=1,'YES','NO') as 'Fee for service' ,[Hours] ,[Access Procedures] ,[Key Specifications] ,[Technical Primary Contact] ,[Lab], [Licence] ,[Name] ,[Operating System] ,[Protocol] ,[Purpose] ,[Records Imported From] ,[Reporting Date 1] ,[Reporting Date 2] ,[Available to] , IIF([Restrictions]=1,'YES','NO') as RESTRICTIONS, [Restrictions Description] ,[Information sheet] ,[Sub Type] ,IIF([Training Required]=1,'YES','NO') as 'Training Required' ,[ItemType] ,[URL] as 'Website',[Testing Performed By] , [Tests Available], [Version], [Principal Investigator], [Keywords], [Group], [Type], [Potential Areas of Use], [Analysis], [Make Model], [Location], [Information Sheet], str([Department ID],5,0) as 'DEPT', [Display In VIVO] FROM [elements-reporting].[dbo].[Equipment (Field Display Names)] WHERE [Display In VIVO] = 1";
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

