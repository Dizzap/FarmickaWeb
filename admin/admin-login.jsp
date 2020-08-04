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
                        <a id="a-special" title="Úvodní stránka" href ="index.html">Úvod</a>
                    </li><!-- /li-->
                    <li class="leftli">
                        <a id="a-special" title="Informace o sofwaru" href ="nabidka.jsp">Aktuální nabídka</a>
                    </li><!-- /li-->
                    <li>
                        <a id="a-special" title="Kontaktní údaje" href ="../objednavky/objednavky.jsp">Objednávky</a>
                    </li><!-- /li-->
                </ul><!-- /ul-->
            </nav><!-- /nav -->   
            <section id="c" style="height: 100%">                
                <article>
                    <h2>Administrace</h2>       
                    <hr/> 
                    <div class="row">
                        <div class="col-md-12">
                        <%
                        if (session.getAttribute("loginFlag")!=null){ ///kontrola existence session
                        	response.sendRedirect("admin.jsp"); ///redirect na admin.jsp v případě že session existuje
                        } else {
                        	out.println( ///výpis přihlašovacího formuláře pokud session neexsituje
                        	"<form name='loginForm' action='createSession.jsp' method='post' accept-charset='utf-8'>"+
                        		"<input style='width: 30%;' type='password' name='passBox'></input>"+
                        		"<input style='margin-left: 1%; width: auto;' type='submit' value='Přihlásit'>"+
                        	"</form>");
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
</body>
</html>