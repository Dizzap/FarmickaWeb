<%@page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>    
    <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body class="container-fluid">  
Přesměrovávám...
    <%
String pass = request.getParameter("passBox");

if (pass!= null && pass.equals()) {
		session.setAttribute("loginFlag", true);
		response.sendRedirect("admin.jsp");
} else {
	response.sendRedirect("admin-login.jsp");
}
    
    %>
</body>
</html>