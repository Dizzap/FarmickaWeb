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
                    <h2>Souhrn objednávky</h2>       
                    <hr/>
<%

///deklarace
String orderName;
double[] formValues;
String orderDesigHashed;
double[] productStock;
Boolean stockCheck = false;
String[] valueConvert;
String[] arr;
int productCount;
int[] productIDs;
String[] productNames;
String[] productUnits;
double[] productMax;
double[] productPrices;
Boolean negativeCheck = false;
Boolean subStringCheck = false;
Boolean zeroCheck = false;
Boolean dotCheck = false;
double productAdd = 0;
String [] subStrings = ""
String orderTel;
double orderSum=0;
double orderPrice=0;
String [] formValuesChecks;
Boolean GDPR = false;
String baleni;
Boolean maxCheck=false;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

///zpracování checkboxu
/*formValuesChecks = request.getParameterValues("checkBox"); /// načtení checkboxů (object) do pole
if(formValuesChecks != null){
	GDPR = true;
}*/
GDPR = true; //dočasné odstranění

///input check na jméno
orderName = request.getParameter("nameBox");
orderTel = request.getParameter("telBox");

if (orderName == "" || orderName == " " || orderName == null || orderName.length() < 3 || orderName.length() > 50) {
	subStringCheck = true;	
} else {
	for (int i = 0; i < subStrings.length; i++) {
		if (orderName.contains(subStrings[i])){
			subStringCheck = true;
		}		
	}
}
if (subStringCheck == true || GDPR == false) {
	if(subStringCheck == true) {
		out.println("Jméno není vyplněno nebo obsahuje nepovolené znaky.");
	} else {
		out.println("Musíte souhlasit se zpracováním údajů.");
	}
}
else {
	///timestamp pro orderDesig
	Timestamp tstamp = new Timestamp(System.currentTimeMillis());
	String orderDesig = orderName +"-"+ tstamp.getTime();
	
	try {
		///připojení k DB - odstraněno
	    	 
	    Statement myStmt = myConn.createStatement();
	    
	    ///načtení počtu produktů a alokace polí
	    ResultSet myRes =  myStmt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	    formValues = new double[productCount];
	    productStock = new double[productCount];
	    valueConvert = new String[productCount];
	    productIDs = new int[productCount];
	    productNames = new String[productCount];
	    productUnits = new String[productCount];
	    productMax = new double[productCount];
	    productPrices = new double[productCount];
	    
	    ///vynulování polí
	    for (int i=0;i<productCount;i++) {
	    	formValues[i] = 0;
	    	productStock[i] = 0;
	    	productIDs[i] = 0;
	    	productMax[i] = 0;
	    	productPrices[i] = 0;
	    }
	    
	    ///načtení form hodnot do polí + ošetření doublu
	    for(int i=0;i < productCount;i++) {
	    	valueConvert[i] = request.getParameter("textBox"+i);
	    	try {
	    		if (valueConvert[i].contains(",")) {
	    			formValues[i] = 0;
		    		dotCheck=true;
		    	}
	    		else {
	    			formValues[i] = Double.parseDouble(request.getParameter("textBox"+i));
	    		}
	    	} catch (Exception ex) {
	    		formValues[i] = 0;
	    	}
	    }
	    ///načtení hodnot radioButton
	    baleni = request.getParameter("baleni");
	    
	    ///načtení zásob z databáze do pole
	    myRes= myStmt.executeQuery("");
	    
	    for (int i=0; myRes.next();i++){
	    	if (myRes.getString(1)!=null) {
	    		productStock[i] = Double.parseDouble(myRes.getString(1));
	    	} else {
	    		productStock[i] = 0;
	    	}
	    }
	    
	    ///načtení produktových ID z databáze do pole
	    myRes = myStmt.executeQuery("");
	    for(int i=0;myRes.next();i++){
	    	productIDs[i]=myRes.getInt(1);
	    	productNames[i] = myRes.getString(2);
	    	productUnits[i] = myRes.getString(3);
	    	productMax[i] = myRes.getDouble(4);
	    	productPrices[i] = myRes.getDouble(5);
	    }
	    
	    ///porovnání form hodnot vůči zásobě + ošetření záporných hodnot
	    for (int i=0;i < productStock.length;i++){	    	
	    	if (formValues[i]!=0){
		    	productAdd = productAdd+formValues[i];
		    	if (formValues[i] < 0) {
		    		negativeCheck = true;
		    	}
		    	if (formValues[i] > productMax[i]) {	    		
		    		maxCheck = true;
		    	}
		    	if (formValues[i] > productStock[i]){
		    		stockCheck = true;
		    	}
	    	}
	    }
	    ///ošetření prázdné objednávky
	    if (productAdd == 0) {
    		zeroCheck = true;
    	}
	    
	    ///stockCheck
	    if (stockCheck == true || negativeCheck == true || zeroCheck == true || dotCheck == true || maxCheck == true){
	    	if (stockCheck == true){
	     		out.println("<b>Množství některého z produktů přesáhlo dostupné množství.</b>");
	    	}
	    	if (negativeCheck == true){
	     		out.println("<b>Hodnota množství některého z produktů je záporná.</b>");
	    	}
	    	if (zeroCheck == true){
	     		out.println("<b>Objednávka je prázdná!</b>");
	    	}
	    	if (dotCheck == true){
	     		out.println("<b>Neplatný vstup.</b>");
	    	}
	    	if (maxCheck == true){
	    		out.println("<b>Množství některého z produktů přesáhlo maximální množství.</b>");
	    	}
	    }
	    else{    	
		    ///sečtení objednávky
		    for (int i=0; i < formValues.length;i++){
		    	orderPrice += formValues[i]*productPrices[i];
		    }
		    out.println("<br/>");
		 	///konfirmace objednávky
		 	out.println("<div style='color: red; font-weight: bold; font-size: 1.2em;'>Pokud objednáváte poprvé, nejdříve nás prosím kontaktujte na Facebooku.</div>");
		    out.println("<b>Přejete si potvrdit objednávku "+orderDesig+"? <br/>");
		    for(int i =0;i<productCount;i++){
		    	if (formValues[i] !=0){
		    		out.println(productNames[i]+": "+formValues[i]+" "+productUnits[i]+"<br/>");
		    	}
		    }
		    out.println("<div style='font-weight: bold; color: red'>Celková částka: "+orderPrice+"Kč</div>");
		    
		  	///hidden form pro předání parametrů na writeSQL.jsp
		    out.println("<form name='objednavka' action='objednavky-write.jsp' method='post'>");
		   	out.println("<input type='hidden' id='nameBox' name='nameBox' value='"+orderName+"'></input>");
		   	out.println("<input type='hidden' id='telBox' name='telBox' value='"+orderTel+"'></input>");
		   	for (int i=0;i<productCount;i++) {
		   		out.println("<input type='hidden' id='textBox"+i+"' name='textBox"+i+"' value='"+formValues[i]+"'></input>");
		   	}
		   	out.println("<input type='hidden' name='baleni' value='"+baleni+"')>");
		   	out.println("<input type='submit' value='Ano' name='submit' style='width:auto'/>");
		    out.println("</form>"); ///konec formuláře
		    
		}
	    myConn.close(); ///uzavření spojení
	}
	catch(Exception ex){
	    out.println(ex);
	}
}
%>
					<div class="row">
                        <div class="col-md-12">
							<a href="objednavky.jsp">Zpět</a>
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