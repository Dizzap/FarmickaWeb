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
                        <a title="Kontaktní údaje" href ="objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Objednávky</h2>       
                    <hr/>
<%

///deklarace
String orderName;
double[] formValues;
String[] valueConvert;
int productCount;
int[] productIDs;
String[] productNames;
String[] productUnits;
String baleni;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

orderName = request.getParameter("nameBox");

	///timestamp pro orderDesig
	Timestamp tstamp = new Timestamp(System.currentTimeMillis());
	String orderDesig = orderName +"-"+ tstamp.getTime();
	
	try {
		///připojení k DB - odstraněno
	    	 
	    ///deklarace statementů
	    Statement myStmt = myConn.createStatement();
	    PreparedStatement orderInsertQuery = myConn.prepareStatement("");
	    PreparedStatement valuesInsertQuery = myConn.prepareStatement("");
	    
	    ///načtení počtu produktů a alokace polí
	    ResultSet myRes =  myStmt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	    formValues = new double[productCount];
	    valueConvert = new String[productCount];
	    productIDs = new int[productCount];
	    productNames = new String[productCount];
	    productUnits = new String[productCount];
	    
	    ///vynulování polí
	    for (int i=0;i<productCount;i++) {
	    	formValues[i] = 0;
	    	productIDs[i] = 0;
	    }
	    
	    ///načtení form hodnot do polí + ošetření doublu
	    for(int i=0;i < productCount;i++) {
	    	valueConvert[i] = request.getParameter("textBox"+i);
	    	try {
	    		if (valueConvert[i].contains(",")) {
	    			formValues[i] = 0;
		    	}
	    		else {
	    			formValues[i] = Double.parseDouble(request.getParameter("textBox"+i));
	    		}
	    	} catch (Exception ex) {
	    		formValues[i] = 0;
	    	}
	    }
	    ///načtení radioButton
	    baleni=request.getParameter("baleni");
	    
	    ///načtení produktových informací z databáze do pole
	    myRes = myStmt.executeQuery("");
	    for(int i=0;myRes.next();i++){
	    	productIDs[i] = myRes.getInt(1);
	    	productNames[i] = myRes.getString(2);
	    	productUnits[i] = myRes.getString(3);
	    }
		    orderInsertQuery.setString(1, orderDesig);
		    orderInsertQuery.setString(2, orderName);
		    orderInsertQuery.setString(3, "");
		    orderInsertQuery.setString(4, baleni);
		    orderInsertQuery.executeUpdate();
		    
			///získání ID objednávky
			myRes = myStmt.executeQuery("");
		    myRes.next();
		    int order_ID = myRes.getInt(1);
		
		    ///zápis změny hodnoty produktu, ID objednávky, ID produktu do databáze
		    for(int i=0;i<productCount;i++) {
		    	if (formValues[i] != 0){
		    		valuesInsertQuery.setDouble(1,-formValues[i]);
		    		valuesInsertQuery.setInt(2,order_ID);
		    		valuesInsertQuery.setInt(3,productIDs[i]);
		    		valuesInsertQuery.executeUpdate();
		    	}
		    }
		    ///výpis objednávky
		    out.println("<br/>");		    
		    out.println("<b>Vaše objednávka "+orderDesig+": <br/>");
		    for(int i =0;i<productCount;i++){
		    	if (formValues[i] !=0){
		    		out.println(productNames[i]+": "+formValues[i]+" "+productUnits[i]+"<br/>");
		    	}
		    }
		    ///konfirmace
		    out.println(" byla úspěšně zpracována. </b><br/>");
		//}
	    ///uzavření spojení
	    myConn.close();
	}
	catch(Exception ex){
	    out.println(ex);
	}
%>
					<div class="row">
                        <div class="col-md-12">
                       		<form name="test" action="objednavky.jsp" method="post" >
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