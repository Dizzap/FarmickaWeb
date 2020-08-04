<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest"%>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>    
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="../bootstrap/bootstrap.min.css" />
    <script src="../bootstrap/jquery.min.js" ></script>
    <script src="../bootstrap/bootstrap.min.js"> </script>
    <link rel="stylesheet" href="../styles.css" />  
    <script src='../generalJS.js'></script>  
</head>
<body class="container-fluid">  
    <div class="row">
        <div class="col-md-12" style="height: 75px">
        </div>
    </div> <!-- / row -->
    <div class="row">
        <div class="col-md-2"> 
        </div> <!-- / col2 -->
        <div class="col-md-8"> 
            <nav>
                <ul>
                    <li class="mainli" >
                        <a title="Úvodní stránka" href ="../index.html">Úvod</a>
                    </li><!-- /li-->
                    <li class="leftli">
                        <a title="Informace o sofwaru" href ="../nabidka.jsp">Nabídka</a>
                    </li><!-- /li-->
                    <li>
                        <a title="Kontaktní údaje" href ="../objednavky/objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Úprava produktů</h2>       
                    <hr/>
<%
///deklarace
String[] valueConvert;
int orderID=0;
int productID=0;
double change=0;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

if (session.getAttribute("loginFlag")!=null) {
	try {
		///připojení k DB - odstraněno
		 	 
	    Statement myStmt = myConn.createStatement();
	    ///update objednávky
	    PreparedStatement updateQuery = myConn.prepareStatement("");
	    
	 	///načtení form hodnot do polí
	    orderID = Integer.parseInt(request.getParameter("orderIDBoxNew"));
		productID = Integer.parseInt(request.getParameter("productIDBoxNew"));
		
		//change = Double.parseDouble(request.getParameter("changeBox"));
		
	  	///ošetření čárky
	   	try {
	   		if (request.getParameter("changeBoxNew").contains(",")) {
	   			valueConvert = request.getParameter("changeBoxNew").split(",");
	   			change = Double.parseDouble(valueConvert[0]+"."+valueConvert[1]);
	    	}
	   		else {
	   			change = Double.parseDouble(request.getParameter("changeBoxNew"));
	   		}
	   	} catch (Exception ex) {
	   		change = 0;
	   	}
	    
		///update produktů
		updateQuery.setDouble(1, -change);
	   	updateQuery.setInt(2, orderID);
	   	updateQuery.setInt(3, productID);
	    	
	    updateQuery.executeUpdate();
		
	    ///uzavření spojení a konfirmace (s výpisem detailu objednávky)
	    myConn.close();
	    out.println("<br/>");
	    out.println("<b>Úprava proběhla úspěšně.</b>");
	}
	catch(Exception ex){
	    out.println(ex);
	}
} else {
	response.sendRedirect("../admin/admin-login.jsp");
}
%>
					<div class="row">
                        <div class="col-md-12">
                       		<form name="produkty-back" action="objednavky-edit.jsp" method="post" >
								<input type="submit" value="Zpět" name="submit" style="width:auto" />
							</form>
                        </div><!-- /col6-->
                    </div><!-- /row-->
                    </article><!-- /article -->                
                    <footer style="padding-top: 0px">
                        <hr/>
                        <div id="footerData"></div>    
                    </footer><!-- /footer-->
            </section>   <!-- /section-->          
        </div> <!-- / col8 -->
       <div class="col-md-2"> 
       </div>   <!-- / col2 -->   
   </div> <!-- / row -->


</body>
</html>