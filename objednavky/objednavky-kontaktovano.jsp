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
                        <a title="Kontaktní údaje" href ="objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Úprava produktů</h2>       
                    <hr/>
                    <div class='row'>
						<div class='col-md-12'>
<%
///deklarace
String[] productStock;
String[] productUnits;
int[] productUnitsIDs;
String[] productNames;
int productCount;
int productUnitsCount;
double[] productMaxs;
int orderCount;
                    
//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");
 
if (session.getAttribute("loginFlag")!=null) {
	///navázání spojení s databází
	try {
		///připojení k DB - odstraněno
		                    
		Statement mySt = myConn.createStatement();
		ResultSet myRes;
		                        
		///načtení počtu objednávek
		myRes = mySt.executeQuery("");
		myRes.next();
		orderCount = myRes.getInt(1);
		               
		out.println(///začátek formuláře
		"<form name='update' action='objednavky-kontaktovano-update.jsp' method='post'>");
		
		///načtení objednávek
		myRes = mySt.executeQuery("");
		      						      						
		out.println(///výpis tabulky
		"<div style='overflow-x:auto;'>"+
			"Aktualizace objednávek:"+
			"<table class='tbl1'>"+
				"<tr>"+
					"<th>ID</th>"+
					"<th>Jméno</th>"+
					"<th>Kontaktován/a</th>"+
				"</tr>");
		myRes.next();
		for (int i=0;i<orderCount;i++) {///naplnení tabulky
			out.println("<tr>");
			out.println("<td><label>"+myRes.getString(1)+"</label>");
			out.println("<input type='hidden' name='labelID"+i+"' value='"+myRes.getString(1)+"' /></td>");
			out.println("<td><label>"+myRes.getString(2)+"</label></td>");
			if (myRes.getInt(3) == 7) {
				out.println(
					"<td>"+
						"<input style='width: 100%;' type='checkbox' name='checkBox' value='"+i+"' checked></input>"+
					"</td>");
			}
			else {
			    out.println(
				    "<td>"+
						"<input style='width: 100%;' type='checkbox' name='checkBox' value='"+i+"'></input>"+
				    "</td>");
			   					    		
			out.println("</tr>");
			}
			
		myRes.next();
		}
		out.println("</table></div><!-- /table div -->");///ukončení tabulky
		out.println(
			"<input type='submit' value='Aktualizovat' name='submit' style='width:auto'/>"+
		"</form>");///ukončení formuláře pro update
		  	
		///uzavření spojení
		myConn.close();
	}
	catch(Exception ex){
		out.println(ex);
	} 
} else {
	response.sendRedirect("../admin/admin-login.jsp");
}
%>						
							<a href='../admin/admin.jsp'>Zpět</a>
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