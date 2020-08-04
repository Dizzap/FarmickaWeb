<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
		table{
			border: 1px solid black;
			border-collapse: collapse;
			width:100%;
			text-align: center;
		}
		th{
			border: 1px solid black;
		}
		td{
			border: 1px solid black;
		}
		tr{
			border: 1px solid black;
		}
		table tr:nth-child(even) {
			background-color: #f2f2f2;
		}
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
<body>
<!-- The Modal -->
<div id="myModal" class="modal">
	<!-- Modal content -->
	<div class="modal-content">
		<span class="close">&times;</span>
		<p>Zaznamenáno. Aktualizujte.</p>
	</div>				
</div>
<%
///deklarace
double[][] productValues;
String[] orderNames;
String[] productNames;
String[] productUnits;
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
double[] orderPriceSum;
String[] baleni;
int[] orderIDs;

try {
	///připojení k DB - odstraněno
    	 
    Statement myStmt = myConn.createStatement();
    ResultSet myRes;
    
  	///načtení počtu objednávek
    myRes = myStmt.executeQuery("");
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
    productPrices = new double[productCount];
    orderStates = new int[orderCount];
    orderPriceSum = new double[orderCount];
    baleni = new String[orderCount];
    orderIDs = new int[orderCount];
    
  	///načtení product ID, nazev, zkratka, cena do pole
    myRes = myStmt.executeQuery("");
    myRes.next();
    for(int i = 0;i<productCount;i++){
    	productIDs[i] = myRes.getInt(1);
    	productNames[i] = myRes.getString(2);
    	productUnits[i] = myRes.getString(3);
    	productPrices[i] = myRes.getDouble(4);
    	myRes.next();
    }
       
    ///načtení objednávek do pole
    myRes = myStmt.executeQuery("");
    myRes.next();
    for(int i = 0;i<orderCount;i++){
    	orderNames[i] = myRes.getString(1);
    	orderStates[i] = myRes.getInt(2);
    	baleni[i] = myRes.getString(3);
    	orderIDs[i]=myRes.getInt(4);
    	myRes.next();
    }
    
    ///načtení hodnot pro každý produkt v objednávce do pole
    ///cyklus pro objednávku
    for (int i=0;i<orderCount; i++){
	    myRes = myStmt.executeQuery("");
	    	    
		///cyklus pro produkty v objednávce
		while(myRes.next())	
		for (int j=0; j < productCount; j++){
			if (myRes.getInt(2) == productIDs[j]) {
				productValues[i][j] = myRes.getDouble(1);	
			}
		}
	    
    }
    out.println(///začátek tabulky 1
    "<div style='overflow-x:auto;'>"+
    	"<table>"+
    		"<tr>"+
    			"<th style='width:2%;'>ID</th>"+	
    			"<th>Objednávka</th>"+
    			"<th>Produkt</th>"+
    			"<th>Objednaná množství</th>"+
    			"<th>Jednotky</th>"+
    			"<th>Cena</th>"+
    		"</tr>");
    for (int j=0;j<orderCount;j++){
    	nonNullProducts=0;
    	for (int k=0;k<productCount;k++){
    		if (productValues[j][k]!=0)
    			nonNullProducts++;	    		
    	}
    	//out.println("<div id="+j+" class='orderDiv'>");//orderDiv
    	if (nonNullProducts != 0){
	    	out.println("<tr class='orderTR"+j+"'>");
	    	out.println("<td id='orderID"+j+"' rowspan='"+nonNullProducts+"'>"+orderIDs[j]+"</td>");
	    	if (orderStates[j]==7){
	    		out.println("<td rowspan='"+nonNullProducts+"' class='spannedTD' id='"+j+"' style='color: darkgreen;'>"+ orderNames[j] +" ✓</td>");
	    	} else {
	    		out.println("<td rowspan='"+nonNullProducts+"' class='spannedTD' id='"+j+"' style='color: red; font-weight: bold'>"+ orderNames[j] +" ✗</td>");
	    	}
	    	int k=0;
	    	for (int i=0;i < productCount;i++) {	
	    		if (productValues[j][i]!=0) {
	    			if(k>0 && nonNullProducts>1){
	    				out.println("<tr class='orderTR"+j+"'>");
	    			}
	    			k++;
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
    	//out.println("</div>");//oderDiv
    }
    out.println("</table></div>"); ///ukončení tabulky 1
    //out.println("<button id='testButton' style='width:10%; margin-left:47.5%;'>Uložit</button>");
    out.println( ///začátek tabulky 2
    	    "<table style='width: 30%; margin-top: 2%; margin-left: 35%; border: 1px solid black; page-break-before: always'>");
    	    for(int i=0; i < orderCount; i++){		
    	    	out.println("<tr><td>"+orderNames[i]+"</td>");
    	    	out.println("<td>"+orderPriceSum[i]+" Kč</td></tr>");
    	    }
    	    out.println("</table>"); ///konec tabulky 2   	
    myConn.close();
}
catch(Exception ex){
	out.println(ex);
}
%>
<script type="text/javascript">
	let orderBoxes = document.querySelectorAll(".orderBox");
	let orderBoxValue=0;	
	let flag;
	let checkBoxSpans = document.querySelectorAll(".orderSpan");
	
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
	///vyžízení objednávky pomocí checkboxu + spanu
	$(checkBoxSpans).on('click', function(e){orderCheck(e)});
	$(orderBoxes).on('change', function(e){orderCheck(e)});
	
	///kontaktování přes dblclick jména objednávky
	let spannedTDs = document.querySelectorAll(".spannedTD");	
	$(spannedTDs).on('dblclick', function(e){
		let orderID = document.querySelector("#orderID"+e.currentTarget.id).innerText;	
		$.post("../admin/admin-kontakt-write.jsp", {
			flag: e.currentTarget.style.color, orderID: orderID
		});
		modal.style.display = "block";
		setTimeout(function(){
			modal.style.display = "none";
		},1000);
	});	
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
				}			
			}		
	}
</script>
</body>
</html>