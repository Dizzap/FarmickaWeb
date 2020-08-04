<%@page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>
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
    <script src="../formCheck.js" ></script>
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
        <div class="col-md-8"  style="width: 100%"> 
            <nav>
                <ul>
                    <li class="mainli" >
                        <a id="a-special" title="Úvodní stránka" href ="../index.html">Úvod</a>
                    </li><!-- /li-->
                    <li class="leftli">
                        <a id="a-special" title="Informace o sofwaru" href ="../nabidka.jsp">Nabídka</a>
                    </li><!-- /li-->
                    <li>
                        <a id="a-special" title="Kontaktní údaje" href ="../objednavky/objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Úprava objednávky</h2>  
                    <a href='../admin/logout.jsp'>Odhlásit</a>     
                    <hr/>
                    <div class="row">
                        <div class="col-md-12">
                       		
<%
double[][] productValues;
String[] orderNames;
String[] productNames;
String[] productUnits; //doplnit
String[] orderTels;
int[] productIDs;
int[] orderIDs;
int productCount;
int orderCount;
int nonNullProducts =0;
String pass;
byte[] passBytes;
String dateLower;
String dateUpper;
Boolean sessionValue = false;
String[] orderDates;


//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");


///check na session
if (session.getAttribute("loginFlag")!=null) {
		
	try {
		///připojení k DB - odstraněno
			    
	    ///deklarace statementu
	    Statement myStmt = myConn.createStatement();
	    
	    ///načtení počtu objednávek
	    ResultSet myRes = myStmt.executeQuery("");
	    myRes.next();
	    orderCount = myRes.getInt(1);
	    
	    ///načtení počtu produktů
	    myRes = myStmt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	    
	    ///alokace polí
	    productValues = new double[orderCount] [productCount];
	    orderNames = new String[orderCount];
	    productUnits = new String[productCount];
	    productIDs = new int[productCount];
	    productNames = new String[productCount];
	    orderTels = new String[orderCount];
	    orderIDs = new int[orderCount];
	    orderDates = new String[orderCount];
	    
	  	///načtení product ID, nazev, zkratka do pole
	    myRes = myStmt.executeQuery("");
	    myRes.next();
	    for(int i = 0;i<productCount;i++){
	    	productIDs[i] = myRes.getInt(1);
	    	productNames[i] = myRes.getString(2);
	    	productUnits[i] = myRes.getString(3);
	    	myRes.next();
	    }
	       
	    ///načtení objednávek do pole
	    myRes = myStmt.executeQuery("");
	    myRes.next();
	    for(int i = 0;i<orderCount;i++){
	    	orderNames[i] = myRes.getString(1);
	    	orderTels[i] = myRes.getString(2);
	    	orderIDs[i] = myRes.getInt(3);
	    	orderDates[i] = myRes.getString(4);
	    	myRes.next();
	    }
	    
	    ///načtení hodnot pro každý produkt v objednávce do pole
	    PreparedStatement valueSelectQuery = myConn.prepareStatement("");
	    ///cyklus pro objednávku
	    for (int i=0;i<orderCount; i++){
	    	valueSelectQuery.setString(1,orderNames[i]);
		 	myRes =  valueSelectQuery.executeQuery();
			///cyklus pro produkty v objednávce
			while(myRes.next())	
			for (int j=0; j < productCount; j++){
				if (myRes.getInt(2) == productIDs[j]) {
					productValues[i][j] = myRes.getDouble(1);	
				}
			}
		    
	    }
	    
	  	///výpis tabulky 1
	    out.println(
	    "Objednávky podle jména:"+
	    " <div style='overflow-x:auto; margin-bottom: 3%'>"+
	    	"<table class='tbl1' style='width: 90%; margin-left: 5%; margin-right: 5%'>"+
	    		"<tr>"+
	    			"<th id='admin'>Datum</th>"+
	    			"<th id='admin'>Objednávka</th>"+
	    			"<th id='admin'>ID</th>"+
	    			"<th id='admin'>Produkt</th>"+
	    			"<th id='admin'>ID</th>"+
	    			"<th id='admin'>Objednaná množství</th>"+
	    		"</tr>");
	    for (int j=0;j<orderCount;j++){
	    	nonNullProducts=0;
	    	for (int k=0;k<productCount;k++){
	    		if (productValues[j][k]!=0)
	    			nonNullProducts++;
	    	}
	    	for (int i=0;i < productCount;i++) {
	    		if (productValues[j][i]!=0) {
		    		out.println("<tr>");
		    		out.println("<td>"+ orderDates[j] +"</td>");
		    		out.println("<td>"+ orderNames[j] +"</td>");
		    		out.println("<td>"+ orderIDs[j] +"</td>");
		    		out.println("<td>"+ productNames[i] +"</td>");
		    		out.println("<td>"+ productIDs[i] +"</td>");
			    	out.println("<td>"+ productValues[j][i] +"</td>"); 
			    	out.println("</tr>");
			    }
		    }
	    }
	    out.println(
	    	"</table>"+
	    "</div>"); ///uzavření tabulky 1
	    
	    ///výpis tabulky 2 - editace množství
	    out.println(
	    "Změna množství: <form name='objednavky-edit' action='objednavky-edit-mnozstvi.jsp' method='post'>"+
		    "<table class='tbl1' style='text-align: center;'>"+
			    "<tr>"+
					"<th id='admin'>ID objednávky</th>"+
					"<th id='admin'>ID produktu</th>"+
					"<th id='admin'>Změna na</th>"+
				"</tr>"+
		    	"<tr>"+
		    		"<td><input type='number' id='orderIDBox' name='orderIDBox' style='width: 100%; text-align: center;'></input></td>"+
		    		"<td><input type='number' id='productIDBox' name='productIDBox' style='width: 100%; text-align: center;'></input></td>"+
		    		"<td><input type='number' step='0.01' id='changeBox' name='changeBox' style='width: 100%; text-align: center;'></input></td>"+
		    	"</tr>"+
		    "</table>"
	    );
	    out.println(	    
	    	"<input type='submit' value='Upravit' size='50'/>"+
	    "</form>");///uzavření tabulky 2
	  	
	    ///výpis tabulky 3 - přidání produktů
	    out.println(
	    "</br>Přidání produktu k objednávce: <form name='objednavky-edit-add' action='objednavky-edit-add.jsp' method='post'>"+
		    "<table class='tbl1' style='text-align: center;'>"+
			    "<tr>"+
					"<th id='admin'>ID objednávky</th>"+
					"<th id='admin'>ID produktu</th>"+
					"<th id='admin'>Množství</th>"+
				"</tr>"+
		    	"<tr>"+
		    		"<td><input type='number' id='orderIDBoxNew' name='orderIDBoxNew' style='width: 100%; text-align: center;'></input></td>"+
		    		"<td><input type='number' id='productIDBoxNew' name='productIDBoxNew' style='width: 100%; text-align: center;'></input></td>"+
		    		"<td><input type='number' step='0.01' id='changeBoxNew' name='changeBoxNew' style='width: 100%; text-align: center;'></input></td>"+
		    	"</tr>"+
		    "</table>"
	    );
	    out.println(	    
	    	"<input type='submit' value='Přidat' size='50'/>"+
	    "</form>");///uzavření tabulky 3
	    
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