<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<%
String flag="";
String orderID;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

try{
	///připojení k DB - odstraněno
		
	flag = request.getParameter("flag");
	orderID = request.getParameter("orderID");
	PreparedStatement orderUpdateQuery = myConn.prepareStatement("");
	orderUpdateQuery.setInt(2, Integer.parseInt(orderID));
	if(flag.equals("red")){
		orderUpdateQuery.setInt(1, 7);			
	} else {
		orderUpdateQuery.setInt(1, 3);
	}	
	orderUpdateQuery.executeUpdate();
	myConn.close();
}
catch (Exception ex) {
	out.println(ex);
}
%>
</body>
</html>