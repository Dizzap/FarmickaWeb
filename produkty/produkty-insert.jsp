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
        <div class="col-md-8" style="width:100%"> 
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
                    <h2>Přidání produktu</h2>       
                    <hr/>
<%
double formValuesPrice=0;
double formMaxValue=0;
int productCount;
int[] productIDs;
String[] productNames;
String[] productUnits;
String[] valueConvert;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

if (session.getAttribute("loginFlag")!=null) {
	try {
		///připojení k DB - odstraněno
	    	 
	    Statement myStmt = myConn.createStatement();
	    ResultSet myRes;
	    	 
	    ///query pro přidání produktu
	    PreparedStatement insertQuery = myConn.prepareStatement("");
	    
	    ///selekce produktů k výpisu na konci
	    PreparedStatement selectQuery = myConn.prepareStatement("");
	    
	    ///ošetření čárky
	    try {
	    	if (request.getParameter("cenaBoxNew").contains(",")) {
	    		valueConvert = request.getParameter("cenaBoxNew").split(",");
	    		formValuesPrice = Double.parseDouble(valueConvert[0]+"."+valueConvert[1]);
		    }
	    	else {
	    		formValuesPrice = Double.parseDouble(request.getParameter("cenaBoxNew"));
	    	}
	    } catch (Exception ex) {
	    	formValuesPrice = 0;
	    }
	    try {
	    	if (request.getParameter("maxBoxNew").contains(",")) {
	    		valueConvert = request.getParameter("maxBoxNew").split(",");
	    		formMaxValue = Double.parseDouble(valueConvert[0]+"."+valueConvert[1]);
		    }
	    	else {
	    		formMaxValue = Double.parseDouble(request.getParameter("maxBoxNew"));
	    	}
	    } catch (Exception ex) {
	    	formMaxValue = 0;
	    }
		///vložení produktu
	   	insertQuery.setString(1,request.getParameter("produktBoxNew"));
	   	insertQuery.setDouble(2,formValuesPrice);
	   	insertQuery.setString(3,request.getParameter("jednotkyBoxNew"));
	   	insertQuery.setDouble(4,formMaxValue);
	   	insertQuery.setString(5, request.getParameter("descBoxNew"));
	   	insertQuery.setInt(6,Integer.parseInt(request.getParameter("poradiBoxNew")));
	  	insertQuery.executeUpdate();
	  	
	  	
	  	/// výpis produktů
	    myRes = selectQuery.executeQuery();
	    
	    out.println("Produkt úspěšně přidán:"+
	    "<div style='overflow-x:auto;''>"+
	    "<table class='tbl1' style='width: 98%; margin-left: 1%; margin-right: 1%'>"+
	    	"<tr>"+
	    		"<th>ID</th>"+
	    		"<th style='width: 20%'>Produkt</th>"+
	    		"<th>Popis</th>"+
	    		"<th style='width: 12%'>Cena za jednotku</th>"+
	    		"<th style='width: 8%'>Jednotky</th>"+
	    		"<th>Max/os</th>"+
	    		"<th style='width: 8%'>Pořadí</th>"+
	    		"<th style='width: 7%'>Použít?</th>"+
	    	"</tr>");
	    while(myRes.next()) {
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getString(1) +"</td>");  
	    	out.println("<td>"+ myRes.getString(2) +"</td>");
	    	out.println("<td>"+ myRes.getString(7) +"</td>");
	    	out.println("<td>"+ myRes.getString(3) +"</td>");
	    	out.println("<td>"+ myRes.getString(4) +"</td>");
	    	out.println("<td>"+ myRes.getString(6) +"</td>");
	    	out.println("<td>"+ myRes.getString(8) +"</td>");
	    	out.println("<td>"+ myRes.getString(5) +"</td>");
	    	out.println("</tr>");
	    }
	    out.println("</table>"+
	    "</div><!-- /table div -->");
	    
	    ///uzavření spojení
	    myConn.close();
	    out.println("<br/>");
	    
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
                       		<form name="test" action="produkty.jsp" method="post" >
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