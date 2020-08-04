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
                    <h2>Vyřízení objednávek</h2>       
                    <hr/>
<%
///deklarace
String orderName = "";
if (session.getAttribute("loginFlag")!=null) {
	try {
		///připojení k DB - odstraněno
	    	 
	    Statement myStmt = myConn.createStatement();
	    
		///update objednávek
	    myStmt.executeUpdate("");
	    
		///uzavření spojení a konfirmace
	    myConn.close();
	    out.println("<b>Objednávky úspěšně vyřízeny. </b><br/>");
	    
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
                       		<form name="objednavky-zpet" action="../admin/admin.jsp" method="post" >
                       			<input type="hidden" value="heslo" name="passBox" style="width:auto" />
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