<%@page import="org.apache.naming.java.javaURLContextFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title></title>    
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="bootstrap/bootstrap.min.css" />
    <script src="bootstrap/jquery.min.js" ></script>
    <script src="bootstrap/bootstrap.min.js"> </script>
    <link rel="stylesheet" href="styles.css" /> 
    <script src='generalJS.js'></script> 
    <style><!-- přesunout do externího -->
#myImg {
  border-radius: 5px;
  cursor: pointer;
  transition: 0.3s;
}

#myImg:hover {
	opacity: 0.7;
	border: 1px solid black;	
}

/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
}

/* Modal Content (image) */
.modal-content {
  margin: auto;
  display: block;
  width: 80%;
  max-width: 700px;
}

/* Caption of Modal Image */
#caption {
  margin: auto;
  display: block;
  width: 80%;
  max-width: 700px;
  text-align: center;
  color: #ccc;
  padding: 10px 0;
  height: 150px;
}

/* Add Animation */
.modal-content, #caption {  
  animation-name: zoom;
  animation-duration: 0.6s;
}

@keyframes zoom {
  from {transform: scale(0.1)} 
  to {transform: scale(1)}
}

/* The Close Button */
.close {
  position: absolute;
  top: 15px;
  right: 35px;
  color: #f1f1f1;
  font-size: 40px;
  font-weight: bold;
  transition: 0.3s;
}

.close:hover,
.close:focus {
  color: #bbb;
  text-decoration: none;
  cursor: pointer;
}

/* 100% Image Width on Smaller Screens */
@media only screen and (max-width: 700px){
  .modal-content {
    width: 100%;
  }
}
tr{
	border-style: solid;
	border-color: linear-gradient(to right, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.75), rgba(0, 0, 0, 0));
	border-width: 0 0 1px 0;
}
td{
	padding: 5px;
	width: 30%;
	vertical-align: top;
}
/*td:hover{
	border: 1px solid black;
	transition: border 0.47s ease-in-out;
}*/
table{
	margin-left: 10%;
	margin-right: 10%;
	width: 80%;'
}

</style>
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
            <nav>
                <ul class="mainNavHide">
                    <li class="mainli" >
                        <a id="a-special" title="Úvodní stránka" href ="index.html">Úvod</a>
                    </li><!-- /li-->
                    <li class="leftli">
                        <a id="a-special" title="Informace o sofwaru" href ="nabidka.jsp">Aktuální nabídka</a>
                    </li><!-- /li-->
                    <li>
                        <a id="a-special" title="Kontaktní údaje" href ="objednavky/objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
                 <div id="mySidenav" class="sidenav sideNavHide">
 					<a class="sideNavHide" href="javascript:void(0)" id='closebtn' class="closebtn">&times;</a>
 					<a class="sideNavHide" href="index.html">Úvod</a>
 					<a class="sideNavHide" href="nabidka.jsp">Nabídka</a>
  					<a class="sideNavHide" href="objednavky/objednavky.jsp">Objednávky</a>
				</div>
				<span class="sideNavHide" id="navButton" style="color: black; font-size:30px;cursor:pointer; margin: auto; padding-right: 60%;">&#9776; Menu</span>
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Aktuální nabídka</h2>  
                    <hr/> 
                    <p style="text-align: center; font-weight: bold;">
                         V nabídce máme aktuálně tyto produkty: 
                    </p><!-- /p-->
                    <div class="row">
                        <div class="col-md-12">
<%
int productCount;
///nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

try {
	///připojení k DB - odstraněno
	
	Statement stt = myConn.createStatement();
	ResultSet myRes = stt.executeQuery("");
	myRes.next();
	productCount = myRes.getInt(1);
	
	
    
    ///deklarace statementu ///selekce názvu, ceny, jednotek a zásoby
    PreparedStatement myStmt = myConn.prepareStatement("");    
    
    myRes = myStmt.executeQuery();
    myRes.next();
  	
    out.println("<table>");
    int counter=0;
    out.println("<tr id='testTR'>");
    for(int i=0;i<productCount;i++){ 
    	///načtení obrázků
      	Blob blob = myRes.getBlob("ikona");  
      	String base64Image="";
    	if (blob!=null){
	      	InputStream inputStream = blob.getBinaryStream();
	      	ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
	      	byte[] buffer = new byte[4096];
	      	int bytesRead = -1;  	 
	      	while ((bytesRead = inputStream.read(buffer)) != -1) {
	      	    outputStream.write(buffer, 0, bytesRead);
	      	}  	 
	      	byte[] imageBytes = outputStream.toByteArray();  	 
	      	base64Image = Base64.getEncoder().encodeToString(imageBytes);  	 
	      	inputStream.close();
	      	outputStream.close();	      	
      	}
    	if (counter==3){
    		counter=0;
    		out.println("<tr id='testTR'>");
    	}   
    	if (blob!=null){
	    	out.println(
			    		"<td>"+
			    			"<img id='myImg' class='imgModal' alt='"+myRes.getString(1)+"' style='max-height: auto; max-width: 55%; display: block; margin:auto; margin-top:2%;' class='img-responsive img-rounded' src='data:image/jpg;base64,"+base64Image+"'/>"+
			    			"<div style='font-weight: bold;'>"+myRes.getString(1)+"</div><div>"+myRes.getString(2)+" Kč/"+myRes.getString(3)+"</div><div style='font-size: 0.9em; padding-left: 10%; padding-right: 10%;'>"+myRes.getString(4)+"</div>"+    					
			    		"</td>"); 
    	} else {
    		out.println(
		    		"<td>"+
		    			"<img id='myImg' class='imgModal' alt='"+myRes.getString(1)+"' style='max-height: auto; max-width: 55%; display: block; margin:auto; margin-top:2%;' class='img-responsive img-rounded' src='graphics/product_icons/nullImage.jpg'/>"+
		    			"<div style='font-weight: bold;'>"+myRes.getString(1)+"</div><div>"+myRes.getString(2)+" Kč/"+myRes.getString(3)+"</div><div style='font-size: 0.9em; padding-left: 10%; padding-right: 10%;'>"+myRes.getString(4)+"</div>"+    					
		    		"</td>"); 
    	}
    	if (counter==3){
    		counter=0;
    		out.println("</tr>");
    	}
    	counter++;
    	myRes.next();
    }
     
    out.println("</table>");
    out.println("<!-- The Modal -->"+
    "<div id='myModal' class='modal'>"+
      "<span class='close'>&times;</span>"+
      "<img class='modal-content' id='img01'>"+
      "<div id='caption'></div>"+
    "</div>");
    ///uzavření spojení
    myConn.close();
}
catch(Exception ex){
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
		// Get the modal
		var modal = document.getElementById('myModal');
		
		// Get the image and insert it inside the modal - use its "alt" text as a caption
		var img = document.querySelectorAll('.imgModal');
		//console.log(img);
		var modalImg = document.getElementById("img01");
		var captionText = document.getElementById("caption");
		$(img).on('click', function(){
			modal.style.display = "block";
			modalImg.src = this.src;
			captionText.innerHTML = this.alt;
		});
		
		// Get the <span> element that closes the modal
		var span = document.getElementsByClassName("close")[0];
		
		// When the user clicks on <span> (x), close the modal
		span.onclick = function() { 
		  modal.style.display = "none";
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