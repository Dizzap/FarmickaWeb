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
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Úprava produktů</h2>       
                    <hr/>
<%
///deklarace
String orderName = "";
String[] formValuesNames;
double[] formValuesPrice;
String[] formValuesUnits;
double[] formValuesMaxs;
int[] formValuesIDs;
String [] formValuesChecks;
int [] formValuesChecksINT;
int productCount;
int[] productIDs;
String[] productNames;
String[] productUnits;
String[] valueConvert;
String[] formValuesDesc;
int[] formValuesOrder;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

if (session.getAttribute("loginFlag")!=null) {
	try {
		///připojení k DB - odstraněno
	    	 
	    Statement myStmt = myConn.createStatement();
	    ///update produktů
	    PreparedStatement updateQuery = myConn.prepareStatement("");
	    
	    ///načtení počtu produktů a alokace polí
	    ResultSet myRes =  myStmt.executeQuery("");
	    myRes.next();
	    productCount = myRes.getInt(1);
	    
	    formValuesNames = new String[productCount];
	    formValuesPrice = new double[productCount];
	    formValuesUnits = new String[productCount];
	    formValuesIDs = new int[productCount];
	    formValuesChecksINT = new int[productCount];
	    formValuesMaxs = new double[productCount];
	    formValuesDesc = new String[productCount];
	    formValuesOrder = new int[productCount];
	    
	    for(int i=0;i<formValuesChecksINT.length;i++){
	    	formValuesChecksINT[i] =0;
	    }
	    
	    ///zpracování checkBoxů
	  	formValuesChecks = request.getParameterValues("checkBox"); /// načtení checkboxů (object) do pole
	    for (int i=0; i < productCount;i++){
			for(int j=0;j<formValuesChecks.length;j++){
				if (formValuesChecks[j].equals(Integer.toString(i))) {
					formValuesChecksINT[i]=1;
				}
			}
	    }
	  	///ošetření čárky
	    for(int i=0;i < productCount;i++) { /// pro cenu
	    	try {
	    		if (request.getParameter("cenaBox"+i).contains(",")) {
	    			valueConvert = request.getParameter("cenaBox"+i).split(",");
	    			formValuesPrice[i] = Double.parseDouble(valueConvert[0]+"."+valueConvert[1]);
		    	}
	    		else {
	    			formValuesPrice[i] = Double.parseDouble(request.getParameter("cenaBox"+i));
	    		}
	    	} catch (Exception ex) {
	    		formValuesPrice[i] = 0;
	    	}
	    }
	  	for(int i=0;i < productCount;i++) { ///pro maxNaOS
	    	try {
	    		if (request.getParameter("maxBox"+i).contains(",")) {
	    			valueConvert = request.getParameter("maxBox"+i).split(",");
	    			formValuesMaxs[i] = Double.parseDouble(valueConvert[0]+"."+valueConvert[1]);
		    	}
	    		else {
	    			formValuesMaxs[i] = Double.parseDouble(request.getParameter("maxBox"+i));
	    		}
	    	} catch (Exception ex) {
	    		formValuesMaxs[i] = 0;
	    	}
	    }
	 	///načtení form hodnot do polí + ošetření doublu
	    for(int i=0;i < productCount;i++) {
		    	try{
		    		formValuesNames[i] = request.getParameter("produktBox"+(i));
		    		formValuesUnits[i] = request.getParameter("jednotkyBox"+(i));
		    		formValuesIDs[i] = Integer.parseInt(request.getParameter("labelID"+(i)));
		    		formValuesDesc[i] = request.getParameter("descBox"+(i));
		    		formValuesOrder[i] = Integer.parseInt(request.getParameter("poradiBox"+(i)));
		    	}
		    	catch (Exception ex) {
		    		out.println(ex);
		    	}
		    }
	    ///update produktů 
	    for (int i = 0; i < productCount; i++) {
	    	updateQuery.setString(1, formValuesNames[i]);
	    	updateQuery.setDouble(2, formValuesPrice[i]);
	    	updateQuery.setString(3, formValuesUnits[i]);
	    	updateQuery.setInt(4, formValuesChecksINT[i]);
	    	updateQuery.setDouble(5, formValuesMaxs[i]);	    	
	    	updateQuery.setString(6, formValuesDesc[i]);
	    	updateQuery.setInt(7, formValuesOrder[i]);
	    	updateQuery.setDouble(8, formValuesIDs[i]);
	    	updateQuery.executeUpdate();
	    }
	  	/// výpis produktů pro kontrolu
	    myRes = myStmt.executeQuery("");
	    
	    out.println("Výsledek:"+
	    "<div style='overflow-x:auto;''>"+
		    "<table class='tbl1' style='width: 98%; margin-left: 1%; margin-right: 1%'>"+
		    	"<tr>"+
		    		"<th>ID</th>"+
		    		"<th style='width: 20%'>Produkt</th>"+
		    		"<th>Popis</th>"+
		    		"<th style='width: 12%'>Cena za jednotku</th>"+
		    		"<th style='width: 8%'>Jednotky</th>"+
		    		"<th>Max/os</th>"+
		    		"<th style='width: 8%'>Pořadí</th>"+		
					"<th style='width: 7%'>Použít?</th>"+
		    	"</tr>");
	    while(myRes.next()) {
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getString(1) +"</td>");  
	    	out.println("<td>"+ myRes.getString(2) +"</td>");
	    	out.println("<td>"+ myRes.getString(7) +"</td>");
	    	out.println("<td>"+ myRes.getString(3) +"</td>");
	    	out.println("<td>"+ myRes.getString(4) +"</td>");
	    	out.println("<td>"+ myRes.getString(5) +"</td>");
	    	out.println("<td>"+ myRes.getString(8) +"</td>");
	    	out.println("<td>"+ myRes.getString(6) +"</td>");	    	
	    	out.println("</tr>");
	    }
	    out.println("</table>"+
	    "</div><!-- /table div -->");
	    
	    ///uzavření spojení a konfirmace (s výpisem detailu objednávky)
	    myConn.close();
	    out.println("<br/>");
	    
	}
	catch(Exception ex){
	    out.println(ex);
	}
} else {
	response.sendRedirect("../admin/admin-login.jsp");
}
%>
					<div class="row">
                        <div class="col-md-12">
                       		<form name="produkty-back" action="produkty.jsp" method="post" >
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