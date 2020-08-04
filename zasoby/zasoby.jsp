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
                    <h2>Úprava zásob</h2>       
                    <hr/>
                    <div class='row'>
    					<div class='col-md-12'>
<%
///deklarace
double[] productStock;
String[] productUnits;
String[] productNames;
int[] productIDs;
int productCount;

///nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");
     
if (session.getAttribute("loginFlag")!=null) {
	///navázání spojení s databází
	try {
		///připojení k DB - odstraněno
	      
	    ///deklarace statementů
	    Statement mySt = myConn.createStatement();
	    ResultSet myRes;
	         
	    ///nařtení počtu produktů
	    myRes = mySt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	         
	    ///alokace polí
	    productStock = new double[productCount];
	    productUnits = new String[productCount];
	    productNames = new String[productCount];
	    productIDs = new int[productCount];
	         
	    ///načtení productNames
	    myRes = mySt.executeQuery("");
	    myRes.next();
	    for (int i=0; i <productCount; i++){
	    	productNames[i] = myRes.getString(1);
	    	productUnits[i] = myRes.getString(2);
	    	productIDs[i] = myRes.getInt(3);
	    	myRes.next();
	    }
	         
	    ///načtení hodnot z databáze do polí
	   	myRes = mySt.executeQuery("");
	    ///vynulování pole
	    for (int i=0; i < productCount;i++){
	    	productStock[i] = 0;
	    }
	    ///načtení hodnot na index se stejným ID
	    while(myRes.next()){
			for (int j=0; j<productCount ;j++){
		       	if (productIDs[j] == myRes.getInt(3)) {
		       		productStock[j] = myRes.getDouble(1);
		       	}
		    }
		}
	    out.println(
	    "<form name='test' action='zasoby-update.jsp' method='post'>");
		for (int i=0; i < productCount;i++){
			if (productUnits[i].equals("ks")) {
				out.println(productNames[i] +": <input type='number' name='textBox"+i+"' size='50' pattern='[-+]?[0-9]+' placeholder='0'/>"+
				"  (aktuálně: "+ productStock[i] + productUnits[i]+")<br/>");
			}
			else {
				out.println(productNames[i] +": <input type='number' name='textBox"+i+"' size='50' step='0.01' pattern='[-+]?[0-9]*[.,]?[0-9]+' placeholder='0'/>"+
				"  (aktuálně: "+ productStock[i] + productUnits[i]+")<br/>");
			}
		}
		out.println(
			"<input type='submit' value='Upravit' name='submit' style='width:auto'/>"+
		"</form>");
		///uzavření spojení
		myConn.close();
	}
	catch(Exception ex){
		out.println(ex);
	} 
} else {
	response.sendRedirect("admin-login.jsp"); ///redirect na login v případě neexsitující session
}
%>			
							<form name="zasoby-zero" action="zasoby-zero.jsp" method="post">
								<input type="submit" value="Vynulovat" name="submit" style="width:auto" />
							</form>
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