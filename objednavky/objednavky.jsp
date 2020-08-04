<%@page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>

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
  	<script src="../formCheck.js" type='text/javascript'></script>
  	<script src="../generalJS.js" type='text/javascript'></script>
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body class="container-fluid">  
    <div class="row">
        <div class="col-md-12" id="headerCol">
        </div>
    </div> <!-- / row -->
    <div class="row">
        <div class="col-md-2"> 
        </div> <!-- / col2 -->
        <div class="col-md-8"> 
            <nav >
                <ul class="mainNavHide">
                    <li class="mainli" >
                        <a id="a-special" title="Úvodní stránka" href ="../index.html">Úvod</a>
                    </li><!-- /li-->
                    <li class="leftli">
                        <a id="a-special" title="Informace o sofwaru" href ="../nabidka.jsp">Aktuální nabídka</a>
                    </li><!-- /li-->
                    <li>
                        <a id="a-special" title="Kontaktní údaje" href ="objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
                <div id="mySidenav" class="sidenav sideNavHide">
 					<a class="sideNavHide" href="javascript:void(0)" id='closebtn' class="closebtn">&times;</a>
 					<a class="sideNavHide" href="../index.html">Úvod</a>
 					<a class="sideNavHide" href="../nabidka.jsp">Nabídka</a>
  					<a class="sideNavHide" href="objednavky.jsp">Objednávky</a>
				</div>
				<span class="sideNavHide" id="navButton" style="color: black; font-size:30px;cursor:pointer; margin: auto; padding-right: 60%;">&#9776; Menu</span>
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Objednávky</h2>       
                    <hr/>                     
	                    <div class="row">
		                              <div class="col-md-12">
                    <%
///deklarace
double[] productStock;
String[] productUnits;
String[] productNames;
double[] productPrices;
double[] productMax;
int [] productIDs;
int productCount;
Boolean dateCheck=false;
String orderName;
String orderTel;
String productPricesMerge="";
Timestamp test;
DateTimeFormatter formatter;
                    
LocalDateTime currentDateTime = LocalDateTime.now(ZoneId.of("Europe/Prague"));
                    
///nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");
                    
try {
	///připojení k DB - odstraněno
		                     
	Statement mySt = myConn.createStatement();
	ResultSet myRes;
  
   	///načtení data
   	formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
   	myRes = mySt.executeQuery("");
   	myRes.next();
   	LocalDateTime dateLower = LocalDateTime.parse(myRes.getString(1), formatter);
   	LocalDateTime dateUpper = LocalDateTime.parse(myRes.getString(2), formatter);
    
    ///porovnání datumu
    if ((currentDateTime.isAfter(dateLower) && currentDateTime.isBefore(dateUpper))|| currentDateTime.isEqual(dateLower)|| currentDateTime.isEqual(dateUpper)){
    	dateCheck=true;
    	
    }   
   	if (dateCheck) {
	    ///načtení počtu produktů
	    myRes = mySt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	    
	    ///alokace polí
	    productStock = new double[productCount];
	    productUnits = new String[productCount];
	    productNames = new String[productCount];
	    productIDs = new int[productCount];
	    productPrices = new double[productCount];
	    productMax = new double[productCount];
	            
	    ///načtení názvu, jednotek, ID, ceny, maxNaOS
	    myRes = mySt.executeQuery("");
	    for(int i=0;myRes.next();i++) {
	    	productNames[i] = myRes.getString(1);
	    	productUnits[i] = myRes.getString(2);
	    	productIDs[i] = myRes.getInt(3);
	    	productPrices[i] = myRes.getDouble(4);
	    	productMax[i] = myRes.getDouble(5);
	    }
	                                   
	    ///načtení zásob
	    myRes = mySt.executeQuery("");
	            
	    while(myRes.next()){
		    for (int j=0; j<productCount ;j++){
		    	if (productIDs[j] == myRes.getInt(2)) {
		        	productStock[j] = myRes.getDouble(1);
		        }
		    }
	    }
	    out.println("<p style='padding-bottom: 10px; text-align: center'>Zde prosím vyplňte svojí objednávku.</p><!-- /p-->");
	    
        ///začátek formuláře
	    out.println("<form name='objednavky-form' action='objednavky-sum.jsp' method='post'"+
	    " accept-charset='utf-8' onsubmit='return validateOrderForm();'>");
	    
	    ///výpis input elementů
	    out.println(
	    "<div id='nadpis' style='font-weight: bold;'>"
	    	+"Facebookové jméno*:"
	    +"</div>"
	    +"<input type='text' style='width: 45%; margin: auto;' id='nameBox' name='nameBox' size='50' placeholder='Fb jméno' required minlength='3' maxlength='50' pattern='[^0-9]+' title='Neplatný tvar jména.' />"
		+"<div style='font-size: 0.7em')>"
	    	+"*Pokud nemáte, vyplňte skutečné jméno."
	    +"</div>"
	    );
		out.println(
		"</br>"
		+"<div style='font-weight: bold;'>"
		+"<i>Desetinná čísla zadávejte s tečkou, a na max. 2 místa.</i></br>"
		+"<i>Kusy nelze dělit.</i>"
		+"</div>"
		);
		out.println(				
				"<table id='product-table'>"
		);
		for (int i=0; i < productCount;i++){
			if (productStock[i] > 0){
				out.println(
					"<tr>"+
						"<td colspan='4' id='productName' style='text-align: center; font-weight: bold; font-size: 1.2em;'>"+ productNames[i] +"</td>"+	
					"</tr>"+
					"<tr>"+				
						"<td id='productPrices' style='text-align: center;'>"+
							" <span id='productPrice"+i+"' data-value='"+productPrices[i]+"'> Cena: "+ productPrices[i] +"</span> Kč/"+ productUnits[i] +""+
						"</td>");						
				if (productMax[i] > productStock[i]){
					out.println(
							"<td style='text-align:right; margin-right: 2%;'>Dost.: </td>"+
							"<td id='stock' style='text-align: left'>"+
							productStock[i]+" "+productUnits[i]);
				} else {
					if (productMax[i] < productStock[i]) {
						out.println(
							"<td style='text-align:right; margin-right: 2%;'>Dost.: > </td>"+
							"<td id='stock' style='text-align: left'>"+
							productMax[i]+" "+productUnits[i]);
					} else {///k čemu tohle??
						out.println(
							"<td style='text-align:right; margin-right: 2%;'>Dost.: </td>"+
							"<td id='stock' style='text-align: left'>"+
								productMax[i]+" "+productUnits[i]);	
					}
				}
				out.println(
						"</td>"+
						"<td style='text-align: left'><div class='productMaxColumn'>Max: "+
							productMax[i]+
						"</div></td>"+
					"</tr>");
				out.println(
				"<tr style='border-bottom: 1px solid black'>"+
						"<td colspan='5' id='textBox' style='padding-bottom: 2%; padding-top: 2%;'>"
				);	
				
				if (productUnits[i].equals("ks") || productUnits[i].equals("sv") ) {
					out.println(					
							"Objednat: <input style='max-width: 25%;' type='number' class='textBox' name='textBox"+i+"' id='textBox"+i+"' size='50'"+ 
							"placeholder='0' pattern='[0-9]?' title='Lze objednávat pouze celé kusy.' min='0'/>");					
				} else {
					out.println(
							"Objednat: <input style='max-width: 25%;' type='number' class='textBox' name='textBox"+i+"' id='textBox"+i+"' size='50'"+
							" placeholder='0' step='0.1' pattern='[+]?[0-9]*[.]?[0-9]+' min='0' />");	
				}
				out.println("</td></tr>");
			}
			else {
				out.println("<tr style='border-bottom: 1px solid black'><td colspan='6' id='outOfStock'>"+productNames[i]+" není k dispozici </td></tr>");
			}
		}
		out.println("</table>");
		out.println(
			"<span id='priceDiv'>Cena: 0 Kč</span>"
			+"<input type='button' value='Přepočítat' onclick='priceCalc("+productCount+")' style='margin-left: 1%; width: auto'></button></br>"
			//+"<span id='GDPRError'><input type='checkbox' id='checkBox' name='checkBox' value='GDPRYes'>Souhlasím se zpracováním osobních údajů za účelem vytvoření objednávky.</input></span></br>"
			
			+"Balení: <input type='radio' name='baleni' value='Taška'>Taška</input>"
			+"<input type='radio' name='baleni' value='Bedýnka'>Bedýnka</input></br>"
			+"<div id='errorElement'></div>"
			+"<input type='submit' id='submitButton' value='Přejít na souhrn' name='submit' style='width:auto; margin-top: 10px;' />"+
		"</form>"); ///uzavření formuláře
	} else {
		out.println("<b>Objednávky jsou momentálně uzavřeny.</b>");
	}
   	
	///uzavření spojení
	myConn.close();
} catch(Exception ex){
	out.println(ex);
}
%>		
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
   <script>
		let nameBoxObject = document.getElementById("nameBox");
		let subStrings = [".","'", "-","*","%","(",")","§","+",";","¨","´","=","ˇ",",","]","[","<",">","/","|","&","@","{","}","#","°","^","$","?",":","!","_","1","2","3","4","5","6","7","8","9","0"];
		let textBoxCollection = document.querySelectorAll(".textBox");
		
	    nameBoxObject.onchange = function(){
	    	validateName();	    	
	    }
	    $('.textBox').on('change', validateBoxes);
	    function validateName(){
	    	let valid=0;
	    	if (nameBoxObject.value.length < 3) {
	    		valid +=1;
	    	} else {
	    		let charTest;
	    		for (let i=0;i<subStrings.length;i++){
	    			charTest = nameBoxObject.value.indexOf(subStrings[i]);
	    			if (charTest != -1) {
	    				valid+=1;
	    			}
	    		}
	    	}
	    	if (valid > 0){
				nameBoxObject.style.border="2px solid red";
	    	} else {
	    		nameBoxObject.style.border="";
	    	}
	    	return valid;
	    }
	    function validateBoxes(){
	    	let textBoxSum = 0;			
			let found = 0;
			let productMaxCollection = document.querySelectorAll(".productMaxColumn");	
			let productStock = document.querySelectorAll("#stock");
			///nejlíp načítat z databáze...
			let valid=0;
	    	for (let j=0; j < textBoxCollection.length; j++){
	    		textBoxSum += textBoxCollection[j].value;
		    	if(textBoxCollection[j].value > 0){
		    		let cutStringMax = productMaxCollection[j].textContent.split(" ");
		    		let cutStringStock = productStock[j].textContent.split(" ");
		    		if ((parseFloat(textBoxCollection[j].value) > parseFloat(cutStringMax[1])) || (parseFloat(textBoxCollection[j].value) > parseFloat(cutStringStock[0]))) {
		    			valid+=1;
		    			textBoxCollection[j].style.border = "2px solid red";
		    		} else 
		    			textBoxCollection[j].style.border = "";
		    	}
	    	}
	    	if (textBoxSum <= 0){
	    		valid += 1;
	    	}
	    	return valid;
	    }
	    function validateOrderForm() {	 
	    	let validPass = 0;
	    	validPass += validateName();
	    	validPass += validateBoxes();
	    	
	    	if (validPass == 0) {
	    		document.getElementById("errorElement").textContent="";
	    		return true;	    		
	    	} else {	    		
	    		document.getElementById("errorElement").textContent="Objednávka je chybně vyplněna.";
	    		document.getElementById("errorElement").style.color="red";
	    		document.getElementById("errorElement").style.fontWeight="bold";
	    		return false;
	    	}
	    }
	    ///otevírání menu
	    let sideNav = document.querySelector("#mySidenav");
	  	document.querySelector("#navButton").onclick = function(){
	  		sideNav.style.width = "200px";	  		 		
	  	}
	  	document.querySelector("#closebtn").onclick = function(){
	  		sideNav.style.width = "0";	  		 		
	  	}
   </script>
</body>
</html>