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
        <div class="col-md-8" style="width: 100%"> 
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
            <section style="height: 100%;">                
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
                    
//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");
 
if (session.getAttribute("loginFlag")!=null) {
	///navázání spojení s databází
	try {
		///připojení k DB - odstraněno
		                    
		Statement mySt = myConn.createStatement();
		ResultSet myRes;
		                        
		///načtení počtu produktů
		myRes = mySt.executeQuery("");
		myRes.next();
		productCount = myRes.getInt(1);
		                        
		///načtení počtu jednotek
		myRes = mySt.executeQuery("");
		myRes.next();
		productUnitsCount = myRes.getInt(1);
		                        
		///alokace polí
		productUnits = new String[productUnitsCount];
		productUnitsIDs = new int[productUnitsCount];
		                        
		///načtení jednotek z databáze do pole
		myRes = mySt.executeQuery("");
		for (int i=0; myRes.next();i++){
		productUnits[i] = myRes.getString(1);
		productUnitsIDs[i] = myRes.getInt(2); 
		}                       
		out.println(///začátek formuláře pro update
		"<form name='update' action='produkty-update.jsp' method='post'>");
		
		/// editace produktů
		myRes = mySt.executeQuery("");
		      						      						
		out.println(
		"<div style='overflow-x:auto;'>"+
			"Editace stávajících produktů:"+
			"<table class='tbl1' style='width: 98%; margin-left: 1%; margin-right: 1%'"+
				"<tr>"+
					"<th>ID</th>"+
					"<th style='width: 12%'>Produkt</th>"+
					"<th style='width: 10%'>Cena</th>"+
					"<th>Popis</th>"+
					"<th style='width: 8%'>Jednotky</th>"+
					"<th>Max/os</th>"+
					"<th style='width: 8%'>Pořadí</th>"+
					"<th style='width: 7%'>Použít?</th>"+
				"</tr>");
		myRes.next();
		for (int i=0;i<productCount;i++) {
		out.println("<tr>");
		out.println("<td><label>"+myRes.getString(1)+"</label>");
		out.println("<input type='hidden' name='labelID"+i+"' value='"+myRes.getString(1)+"' /></td>");
		out.println("<td><input style='width: 100%;' type='text' name='produktBox"+i+"'value='"+ myRes.getString(2) +"'></td>");  
		out.println("<td><input style='width: 100%;' type='number' name='cenaBox"+i+"' step='0.01' pattern='[-+]?[0-9]*[.]?[0-9]+' value='"
		+ myRes.getString(3) +"'></td>");
		out.println("<td><input style='width: 100%;' type='text' name='descBox"+i+"'value='"+ myRes.getString(8) +"'></td>");
		out.println("<td><select style='width: 100%;' name='jednotkyBox"+i+"' value='"+ myRes.getString(4) +"'>");
		out.println("<option value='"+myRes.getString(4)+"'>"+myRes.getString(4)+"</option>");
		      					    	
		for (int j = 0; j < productUnitsCount; j++) {
			if (productUnitsIDs[j]!=myRes.getInt(5)) {
		    	out.println("<option value='"+productUnits[j]+"'>"+productUnits[j]+"</option>");
		    }
		}
		out.println("</select>");
		out.println(
				"<td style='width:10%;'>"+
					"<input style='width: 100%;' type='number' name='maxBox"+i+"' step='0.01' pattern='[-+]?[0-9]*[.]?[0-9]+' value='"
					+ myRes.getString(7) +"'>"+
				"</td>");	
		out.println(
				"<td>"+
					"<input style='width: 100%;' type='number' step='1' name='poradiBox"+i+"' value='"+myRes.getString(9)+"'></input>"+
				 "</td>");
		if (myRes.getInt(6) == 1) {
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
		}   					    		
		out.println("</tr>");
		myRes.next();
		}
		out.println("</table></div><!-- /table div -->");///ukončení tabulky
		out.println(
			"<input type='submit' value='Upravit' name='submit' style='width:auto'/>"+
		"</form>");///ukončení formuláře pro update
		
		out.println(///začátek formuláře pro insert
		"<form name='insert' action='produkty-insert.jsp' method='post'>");
		
		/// přidání produktu
		out.println(///header
		"<div style='overflow-x:auto;''><br/>"+
			"Přidání produktu:"+
			"<table class='tbl1' style='width: 98%; margin-left: 1%; margin-right: 1%'>"+
				"<tr>"+
					"<th>Název</th>"+
					"<th>Popis</th>"+
					"<th>Cena za jednotku (ve formátu 0.0)</th>"+
					"<th>Jednotky</th>"+
					"<th>Pořadí</th>"+
					"<th>Max/os</th>"+
				"</tr>");
		out.println("<tr>"+
			"<td>"+
				"<input style='width: 100%;' type='text' name='produktBoxNew'>"+	///název produktu	
			"</td>"+   
			"<td>"+
				"<input style='width: 100%;' type='text' name='descBoxNew'>"+	///název produktu	
			"</td>"+  
			"<td>"+
				"<input style='width: 100%;' type='number' name='cenaBoxNew'>"+		///cena produktu
			"</td>"+
			"<td>"+
			"<select style='width: 100%;' name='jednotkyBoxNew'>");	///jednotky produtku (comboBox)
		for (int j = 0; j < productUnitsCount; j++) {	///načtení možností jednotek
			out.println("<option value='"+productUnits[j]+"'>"+productUnits[j]+"</option>");
		}
		out.println(
				"<td>"+
					"<input style='width: 100%;' type='number' step='1' name='poradiBoxNew'></input>"+
				 "</td>");
		out.println("</select>"+
				"<td>"+
					"<input style='width: 100%;' type='number' name='maxBoxNew'>"+ ///maxNaOS
				"</td>"+
			"</tr>"+
		"</table>"+
		"</div><!-- /table div -->");
		      	
		///uzavření spojení
		myConn.close();
	}
	catch(Exception ex){
		out.println(ex);
	} 
} else {
	response.sendRedirect("../admin/admin-login.jsp"); ///redirect na login v případě neexistující session
}
out.println("<input type='submit' value='Přidat' name='submit' style='width:auto'/>"+
"</form>");
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