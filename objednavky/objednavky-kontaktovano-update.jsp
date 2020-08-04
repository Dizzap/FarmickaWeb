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
                        <a title="Kontaktní údaje" href ="../objednavky/objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Aktualizace objednávek</h2>       
                    <hr/>
<%
///deklarace
int orderCount;
int [] formValuesChecksINT;
int[] formValuesIDs;
String [] formValuesChecks;

//nastavení encoding pro data z form
request.setCharacterEncoding("UTF-8");

if (session.getAttribute("loginFlag")!=null) {
	try {
		///připojení k DB - odstraněno
	    	 
	    Statement myStmt = myConn.createStatement();
	    ///update objednávek
	    PreparedStatement updateQuery = myConn.prepareStatement("");
	    
	    ///načtení počtu objednávek a alokace polí
	    ResultSet myRes =  myStmt.executeQuery("");
	    myRes.next();
	    orderCount = myRes.getInt(1);
	    
	    formValuesIDs = new int[orderCount];
	    formValuesChecksINT = new int[orderCount];
	    
	    myRes =  myStmt.executeQuery("");
	    myRes.next();
	    for(int i=0;i<orderCount;i++){
	    	formValuesIDs[i] = myRes.getInt(1);
	    	myRes.next();
	    }
	    for(int i=0;i<formValuesChecksINT.length;i++){
	    	formValuesChecksINT[i] =0;
	    }
	    
	    ///zpracování checkBoxů
	    formValuesChecks = request.getParameterValues("checkBox"); /// načtení checkboxů (object) do pole
	    for (int i=0; i < orderCount;i++){
			for(int j=0;j<formValuesChecks.length;j++){
				if (formValuesChecks[j].equals(Integer.toString(i))) {
					formValuesChecksINT[i]=1;
				}
			}
	    }
	  	
	    ///update objednávek 
	    for (int i = 0; i < orderCount; i++) {
	    	if (formValuesChecksINT[i]==1){
	    		updateQuery.setInt(1, 7);
	    		
	    	} else {
	    		updateQuery.setInt(1, 3);
	    	}
	    	updateQuery.setInt(2, formValuesIDs[i]);
    		updateQuery.executeUpdate();
	    }
	    
	  	/// výpis objednávek pro kontrolu
	    myRes = myStmt.executeQuery("");
	    
	    out.println("Výsledek:"+
	    "<div style='overflow-x:auto;''>"+
		    "<table class='tbl1'>"+
		    	"<tr>"+
		    		"<th>ID</th>"+
		    		"<th>Jméno</th>"+
		    		"<th>Kontaktován/a</th>"+
		    	"</tr>");
	    while(myRes.next()) {
	    	out.println("<tr>");
	    	out.println("<td>"+ myRes.getInt(1) +"</td>");  
	    	out.println("<td>"+ myRes.getString(2) +"</td>");    
	    	if (myRes.getInt(3)==7){
	    		out.println("<td>Kontaktován/a</td>");
	    	} else {
	    		out.println("<td>Nekontaktován/a</td>");
	    	}
	    		
	    	out.println("</tr>");
	    }
	    out.println("</table>"+
	    "</div><!-- /table div -->");
	    
	    ///uzavření spojení
	    myConn.close();
	    out.println("<br/>");
	    
	}
	catch(Exception ex){
	    out.println(ex);
	}
} else {
	response.sendRedirect("admin-login.jsp");
}
%>
					<div class="row">
                        <div class="col-md-12">
                       		<form name="produkty-back" action="../objednavky/objednavky-kontaktovano.jsp" method="post" >
								<input type="submit" value="Zpět" name="submit" style="width:auto" />
							</form>
                        </div><!-- /col6-->
                    </div><!-- /row-->
                    </article><!-- /article -->                
                    <footer style="padding-top: 0px" id="footer">
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