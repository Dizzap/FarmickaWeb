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
    <style>
		/* The Modal (background) */
		.modal {
		  display: none; /* Hidden by default */
		  position: fixed; /* Stay in place */
		  z-index: 1; /* Sit on top */
		  left: 0;
		  top: 0;
		  width: 100%; /* Full width */
		  height: 100%; /* Full height */
		  overflow: auto; /* Enable scroll if needed */
		  background-color: rgb(0,0,0); /* Fallback color */
		  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
		}		
		/* Modal Content/Box */
		.modal-content {
		  background-color: #fefefe;
		  margin: 15% auto; /* 15% from the top and centered */
		  padding: 10px;
		  border: 1px solid #888;
		  max-width: 50%; /* Could be more or less, depending on screen size */
		}		
		/* The Close Button */
		.close {
		  color: #aaa;
		  float: right;
		  font-size: 28px;
		  font-weight: bold;
		}		
		.close:hover,
		.close:focus {
		  color: black;
		  text-decoration: none;
		  cursor: pointer;
		} 
    </style>
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
                <!-- The Modal -->
				<div id="myModal" class="modal">
 				  <!-- Modal content -->
				  <div class="modal-content">
				    <span class="close">&times;</span>
				    <p>Zaznamenáno. Aktualizujte.</p>
				  </div>				
				</div>
                <article>
                    <h2>Administrace</h2>  
                    <a href='logout.jsp'>Odhlásit</a> / 
                    <a href='changelog.jsp' target='_blank'>Changelog</a>   
                    <hr/>
                    <div class="row">
                        <div class="col-md-12">
                       		
<%
double[][] productValues;
String[] orderNames;
String[] productNames;
String[] productUnits; //doplnit
String[] orderTels;
double[] productPrices;
int[] orderStates;
int[] productIDs;
int productCount;
int orderCount;
int nonNullProducts =0;
String pass;
byte[] passBytes;
String dateLower;
String dateUpper;
Boolean sessionValue = false;
double[] orderPriceSum;
double productPriceSum = 0;
String [] baleni;
int [] productOrder;
int [] orderIDs;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

///check na session (přihlášení)
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
	    
	    ///pole
	    productValues = new double[orderCount] [productCount];
	    orderNames = new String[orderCount];
	    productUnits = new String[productCount];
	    productIDs = new int[productCount];
	    productNames = new String[productCount];
	    orderTels = new String[orderCount];
	    productPrices = new double[productCount];
	    orderStates = new int[orderCount];
	    orderPriceSum = new double[orderCount];
	    baleni = new String[orderCount];
	    orderIDs = new int[orderCount];
	    //productOrder = new int[productCount];
	    
	  	///načtení product informací do polí
	    myRes = myStmt.executeQuery("");
	    myRes.next();
	    for(int i = 0;i<productCount;i++){
	    	productIDs[i] = myRes.getInt(1);
	    	productNames[i] = myRes.getString(2);
	    	productUnits[i] = myRes.getString(3);
	    	productPrices[i] = myRes.getDouble(4);
	    	//productOrder[i] = myRes.getInt(5);
	    	myRes.next();
	    }
	       
	    ///načtení objednávek do pole
	    myRes = myStmt.executeQuery("");
	    myRes.next();
	    for(int i = 0;i<orderCount;i++){
	    	orderNames[i] = myRes.getString(1);
	    	//orderTels[i] = myRes.getString(2);
	    	orderStates[i] = myRes.getInt(2);
	    	baleni[i] = myRes.getString(3);
	    	orderIDs[i] = myRes.getInt(4);
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
	 	///načtení data
	 	myRes = myStmt.executeQuery("");
	 	myRes.next();
	 	dateLower = myRes.getString(1);
	 	dateUpper = myRes.getString(2);
	    
	 	///sekce zásoby
	    ///výpis tabulky 1 - zbývající zásoby
	    myRes = myStmt.executeQuery("");
	    out.println("<h3>Sekce zásoby:</h3>");
	    out.println(
	    "Zbývající zásoby:"+
	    "<div style='overflow-x:auto;''>"+
	    	"<table class='tbl1'>"+
	    	"<tr>"+
	    		"<th id='admin'>Produkt</th>"+
	    		"<th id='admin'>Stav zásob</th>"+
	    		"<th id='admin'>Jednotky</th>"+
	    	"</tr>");
	    while (myRes.next()) {
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getString(1) +"</td>");    	
	    	out.println("<td>"+ myRes.getString(2) +"</td>");
	    	out.println("<td>"+ myRes.getString(3) +"</td>");
	    	out.println("</tr>");
	    }
	    out.println(
	    	"</table>"+ ///uzavření tabulky 1
	    "</div><!-- /table div -->"+ 
	    " <a href='../zasoby/zasoby.jsp'>úprava zásob</a><br/><br/>");///odkaz na úpravu zásob
	    ///konec sekce zásoby
	    	    
	 	///sekce produkty
	    out.println("<h3>Sekce Produkty:</h3>");
	    myRes = myStmt.executeQuery("");
	    
	    ///výpis tabulky 2 - seznam produktů
	    out.println(
	    "Seznam aktuálních produktů:"+
	    "<div style='overflow-x:auto;''>"+
	    	"<table class='tbl1'>"+
	    		"<tr>"+
	    			"<th id='admin'>Produkt</th>"+
	    			"<th id='admin'>Cena za jednotku</th>"+
	    			"<th id='admin'>Jednotky</th>"+
	    			"<th id='admin'>Pořadí</th>"+
	    		"</tr>");
	    while (myRes.next()) {
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getString(1) +"</td>");    	
	    	out.println("<td>"+ myRes.getString(2) +"</td>");
	    	out.println("<td>"+ myRes.getString(3) +"</td>");
	    	out.println("<td>"+ myRes.getInt(4) +"</td>");
	    	out.println("</tr>");
	    }
	    out.println(
	    	"</table>"+ ///uzavření tabulky 2
	    "</div><!-- /table div -->"); 
	    out.println("<a href='../produkty/produkty.jsp'>upravit produkty</a>"); ///uzavření sekce produkty
	    
	    ///konfigurace data
	    out.println(
	    "<p style='font-weight: bold'>Sekce konfigurace:</p>"+
	    "<div id='errorBox' style='color: red'></div>");
	    out.println("Aktuálně:</br> "+dateLower+" - "+dateUpper);
	    out.println("<form name='datum' action='datum.jsp' method='post'>"+//onsubmit ='return(validate_date())'
	    "Otevřít objednávky od:</br>");
	    out.println("<input style='width:auto; text-align: center;' type='datetime' name='dateLower' id='dateLower' value='"+dateLower+"' required></input> do");
	    out.println("<input style='width:auto; text-align: center;' type='datetime' name='dateUpper' id='dateUpper' value='"+dateUpper+"' required></input>");
	    out.println("</br><input type='submit' value='Upravit' style='width:auto; margin-top: 2px;'></input>"+"</br> (formát YYYY-MM-DD HH-MM-SS)"+
	    "</form>");
	    ///uzavření konfigurace data
	    
	 	///sekce objednávky
	    ///výpis tabulky 3 - sumy objednávek
	    myRes = myStmt.executeQuery("");
	    out.println("<h3>Sekce objednávky:</h3>");
	    out.println(
	    "Sumy objednaných produktů: <a href='../reporty/report-sumy.jsp' target='_blank'>report</a>"+
	    "<div style='overflow-x:auto;''>"+
	    	"<table class='tbl1'>"+
	    		"<tr>"+
	    			"<th id='admin'>Produkt</th>"+
	    			"<th id='admin'>Objednaná množství</th>"+
	    			"<th id='admin'>Jednotky</th>"+
	    			"<th id='admin'>Cena</th>"+
	    		"</tr>");
	    while (myRes.next()) {
	    	
	    	productPriceSum = productPriceSum + myRes.getDouble(4);
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getString(1) +"</td>");    	
	    	out.println("<td>"+ myRes.getString(2) +"</td>");
	    	out.println("<td>"+ myRes.getString(3) +"</td>");
	    	out.println("<td>"+ myRes.getString(4) +"</td>");
	    	out.println("</tr>");
	    }
	    out.println("<tr style='border: 1px solid black; font-weight: bold'>"+
	    "<td colspan='3'>Součet: </td>"+
	    "<td>"+productPriceSum+"</td>"
	    );
	    out.println(///uzavření tabulky 3
	    	"</table>"+
	    "</div><!-- /table div --><br/>");
	   
	  	///výpis tabulky 4 - objednávky podle jména
	    out.println(
	    "Objednávky podle jména: </br>"+ " <a href='../reporty/report-objednavky.jsp' target='_blank'>report</a> /"+
	    " <a href='../objednavky/objednavky-edit.jsp'>úprava objednávek</a> / "+///odkaz na report a úpravu
	    "<a href='../objednavky/objednavky-kontaktovano.jsp'>kontaktováni</a>"+
	    " <div style='overflow-x:auto;'>"+
	    	"<table class='tbl1' id='adminTable4'>"+
	    		"<tr>"+
	    			"<th id='admin'>ID</th>"+
	    			"<th id='admin'>Kontakt</th>"+
	    			"<th id='admin'>Produkt</th>"+
	    			"<th id='admin'>Objednaná množství</th>"+
	    			"<th id='admin'>Jednotky</th>"+
	    			"<th id='admin'>Cena</th>"+
	    		"</tr>");
	    for (int j=0;j<orderCount;j++){
	    	nonNullProducts=0;
	    	for (int k=0;k<productCount;k++){
	    		if (productValues[j][k]!=0)
	    			nonNullProducts++;	    		
	    	}
	    	if (nonNullProducts != 0){
		    	out.println("<tr class='orderTR"+j+"'>");
		    	out.println("<td id='orderID"+j+"' rowspan='"+nonNullProducts+"'>"+orderIDs[j]+"</td>");
		    	if (orderStates[j]==7){
		    		out.println("<td class='spannedTD' id='"+j+"' rowspan='"+nonNullProducts+"' style='color: darkgreen; cursor: default;'>"+ orderNames[j] +" ✓</td>");
		    	} else {
		    		out.println("<td class='spannedTD' id='"+j+"' rowspan='"+nonNullProducts+"' style='color: red; font-weight: bold; cursor: default;'>"+ orderNames[j] +" ✗</td>");
		    	}
		    	int k=0;
		    	for (int i=0;i < productCount;i++) {	
		    		if (productValues[j][i]!=0) {
		    			if(k>0 && nonNullProducts>1){
		    				out.println("<tr class='orderTR"+j+"'>");
		    			}
		    			k++;
			    		//out.println("<td>"+ orderTels[j] +"</td>");
			    		out.println("<td>"+ productNames[i] +"</td>");
				    	out.println("<td>"+ productValues[j][i] +"</td>"); 
				    	out.println("<td>"+productUnits[i]+"</td>");
				    	out.println("<td>"+productValues[j][i]*productPrices[i]+"</td>");
				    	out.println("</tr>");
						orderPriceSum[j] += productValues[j][i]*productPrices[i];
				    }
			    }
		    	out.println(
		    		"<tr style='border-bottom: 1px solid black' class='orderTRsum"+j+"'>"+
		    			"<td colspan='6'>"+ orderNames[j]+": "+ orderPriceSum[j] + " Kč ("+ baleni[j] +")"+
		    				"<span style='margin-left: 2%;' class='orderSpan' id='"+j+"'>Vyřízeno: <input type='checkbox' name='done' value='checked"+j+"' class='orderBox' id='"+j+"'></input></span>"+    			
		    		    "</td>"+
		    		"</tr>"
		    	);
	    	}
	    }
	    out.println(
	    	"</table>"+ ///uzavření tabulky 4
	    "</div>");
	    out.println("</br><a href='../objednavky/objednavky-update.jsp' style='color: red; font-weight: bold; "+
	    "font-size: 1.5em; border: 2px solid red; padding: 1px; margin-top: 8px;'>Vyřídit vše</a></br>");
	    ///uzavření sekce objednávky
	    
	    myConn.close(); ///uzavření připojení
	}
	catch(Exception ex){
	    out.println(ex);
	}
} else {
	response.sendRedirect("admin-login.jsp"); ///redirect na login v případě neexistující session
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
<script type="text/javascript">
	//Get the modal
	var modal = document.getElementById("myModal");
	// Get the <span> element that closes the modal
	var span = document.getElementsByClassName("close")[0];
	// When the user clicks on <span> (x), close the modal
	span.onclick = function() {
	  modal.style.display = "none";
	}
	// When the user clicks anywhere outside of the modal, close it
	window.onclick = function(event) {
	  if (event.target == modal) {
	    modal.style.display = "none";
	  }
	} 
	window.onload = function() {
		for (let i=0;i<orderBoxes.length;i++){
			orderBoxes[i].checked = false;
		}
	};
	let orderBoxes = document.querySelectorAll(".orderBox");
	let orderBoxValue=0;	
	let flag;
	let checkBoxSpans = document.querySelectorAll(".orderSpan");
	
	///vyžízení objednávky pomocí checkboxu + spanu
	$(checkBoxSpans).on('click', function(e){orderCheck(e)});
	$(orderBoxes).on('change', function(e){orderCheck(e)});
	function orderCheck(e){		
			let id = e.target.id;			
			for (let i=0;i<orderBoxes.length;i++){
				if(orderBoxes[i].id==id){
					if (orderBoxes[i].checked){
						orderBoxes[i].checked = false;
					} else{
						orderBoxes[i].checked = true;
					}
					let orderID = document.querySelector("#orderID"+id).innerText;
					let orderTRs = document.querySelectorAll(".orderTR"+id);	
					let orderTRsums = document.querySelectorAll('.orderTRsum'+id);
					if (orderBoxes[i].checked){
						orderBoxValue = 1;
						orderTRsums[0].style.textDecoration="line-through";					
						for(let j=0;j<orderTRs.length;j++){
							orderTRs[j].style.display="none";
						}
					} else{
						orderBoxValue = 0;
						orderTRsums[0].style.textDecoration="";
						for(let j=0;j<orderTRs.length;j++){
							orderTRs[j].style.display="";						
						}
					}
				$.post("../reporty/report-objednavky-write.jsp", {
					orderBoxValue: orderBoxValue, orderID: orderID
				});
			}			
		}
	}
	let spannedTDs = document.querySelectorAll(".spannedTD");	
	$(spannedTDs).on('dblclick', function(e){
		let orderID = document.querySelector("#orderID"+e.currentTarget.id).innerText;
		$.post("admin-kontakt-write.jsp", {
			flag: e.currentTarget.style.color, orderID: orderID
		});
		modal.style.display = "block";
		setTimeout(function(){
			modal.style.display = "none";
		},1000);
	});		
	document.addEventListener('mousedown', function (event) {
		  if (event.detail === 2) {
		    event.preventDefault();
		  }
	}, false);
	
</script>

</body>
</html>