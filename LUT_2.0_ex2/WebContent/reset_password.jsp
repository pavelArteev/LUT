<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*, javax.naming.*, com.sun.mail.smtp.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="javax.annotation.Resource" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            

<%@page import="lut.Security_functions" %>
            
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{
	boolean post = false;
	boolean resetPassword = false;
	boolean _badPassword = false;
	     
    String key = request.getParameter("key");
    String u_name = request.getParameter("user");
    String pass1 = request.getParameter("pass1");
    String pass2 = request.getParameter("pass2");
    String hash_pass = "";
    
	if (key != null && u_name != null) {
		post = true;
		if(pass1 != null && pass2 != null){
			if(pass1.contentEquals(pass2) && !pass1.contentEquals("")){
				_badPassword = false;
				resetPassword = true;
				hash_pass =  Security_functions.i_can_haz_salty_md5sum(pass1);
			}else{
				_badPassword = true;
			}
		}
    }
%>   

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">

    </head>
    <body>
 
<c:set var="_rstPas" value = "<%=resetPassword %>"/>
<c:set var="_pstVal" value = "<%=post%>"/>
<c:set var="_bdPas" value = "<%=_badPassword %>"/>
<c:choose>
<c:when test="${_rstPas == true}">
	<!-- GetUSER -->
	<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  user_key = '<%=key%>' AND 
				name = '<%=u_name%>'
	</sql:query>
	<c:set var="userDetails" value="${users.rows[0]}"/>   
	<c:choose>
	<c:when test="${empty  userDetails}">
		403 Forbiden ! Empty UserDetails
			<%
				response.setHeader("Refresh", "3; URL=index.jsp");

			%>
	</c:when>
	<c:otherwise>

	<sql:transaction dataSource="jdbc/lut2">
	<sql:update>
    	UPDATE  users SET password = '<%=hash_pass%>', user_key='321' WHERE user_key='<%=key%>'
    </sql:update>
	</sql:transaction>
	
	Password reseted ! 
	<%
		response.setHeader("Refresh", "3; URL=index.jsp");

	%>
		
	</c:otherwise>
	</c:choose>

</c:when>
<c:when test="${_pstVal == true}">
		<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  user_key = '<%=key%>' AND 
				name = '<%=u_name%>'
		</sql:query>
		<c:set var="userDetails" value="${users.rows[0]}"/>    
		<c:choose>
		<c:when test="${!empty userDetails}">
		
		<c:choose>
			<c:when test = "${_bdPas == true}">
				Bad password
			</c:when>
		</c:choose>
		
		<table border="0">
            <thead>
                <tr>
                    <th>Please provide the following information</th>
                </tr>
            </thead>
            <tbody>
            

 			
				<tr>
             <td><form method="post" action="reset_password.jsp">
                            <input type="hidden" name="user" value="<%=u_name%>" size="20">
                           	<input type="hidden" name="key" value="<%=key%>" size="20">
                            <p>Password:<input type="password" name="pass1" value="" size="20"></p>
                            <p></p>
                            <p>Retype Password:<input type="password" name="pass2" value="" size="20"></p>
                            <p></p>
                            
                            <p></p>
                            
                            <p><input type="submit" value="submit" name="login"></p>
                        </form>
                    </td>
                </tr>
                <td><a href="index.jsp">Back to main page</a></td>
                            </tbody>
        </table>
		
		
		</c:when>
		<c:otherwise>
		403 Forbiden !
			<%
				response.setHeader("Refresh", "3; URL=index.jsp");
			%>
		</c:otherwise>
		</c:choose>
		
</c:when>   

<c:otherwise>

403 Forbiden !
<%
response.setHeader("Refresh", "3; URL=index.jsp");
%>
</c:otherwise>


</c:choose>   

</body>
 </html>
 
 
 
 <%} %>
