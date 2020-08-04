<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title> 
    <style>
		table{
			border: 1px solid black;
			border-collapse: collapse;
			width:100%;
			text-align: center;
		}
		th{
			border: 1px solid black;
		}
		td{
			border: 1px solid black;
		}
		tr{
			border: 1px solid black;
		}
		table tr:nth-child(even) {
			background-color: #f2f2f2;
		}
		
	</style>
</head>
<body>
<%
///deklarace
try {
	///připojení k DB - odstraněno	
    	 
    Statement myStmt = myConn.createStatement();
    ResultSet myRes;
        
  	
    myRes = myStmt.executeQuery("");
    
    out.println(
    "<div style='overflow-x:auto;''>"+
    	"<table class='tbl1'>"+
    		"<tr>"+
    			"<th id='admin' style='width: 15%')>Datum</th>"+	
    			"<th id='admin' style='width: 15%'>Název</th>"+
    			"<th id='admin'>Popis</th>"+
    		"</tr>");
    while (myRes.next()) {
    	out.println("<tr>");
    	out.println("<td>"+ myRes.getString(1) +"</td>");    	
    	out.println("<td>"+ myRes.getString(2) +"</td>");
    	out.println("<td>"+ myRes.getString(3) +"</td>");
    	out.println("</tr>");
    }
    out.println(///uzavření tabulky 2
    	"</table>"+
    "</div><!-- /table div --><br/>");
    myConn.close();
}
catch(Exception ex){
	out.println(ex);
}
%>
</body>
</html>