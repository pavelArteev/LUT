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
	String key = "";
    boolean post = false;
         
    key = request.getParameter("key");
	if (key != null) {
        post = true;
        
    }
%>   

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">

    </head>
 
<c:set var="postVal" value = "<%=post%>"/>
<c:choose>
<c:when test="${postVal == true}">
		<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  user_key = '<%=key%>'
		</sql:query>
		<c:set var="userDetails" value="${users.rows[0]}"/>         
</c:when>   
</c:choose>        
 
 <body>   
<c:choose>
<c:when test="${empty userDetails}">
403 Forbiden !
<%
response.setHeader("Refresh", "3; URL=index.jsp");
%>
</c:when>
<c:otherwise>
Account registered! =)
<sql:transaction dataSource="jdbc/lut2">
	<sql:update>
    	UPDATE  users SET user_key = '' WHERE user_key='<%=key%>'
    </sql:update>
</sql:transaction>
<%
response.setHeader("Refresh", "3; URL=index.jsp");
%>
</c:otherwise>
</c:choose>    
</body>
</html>    

<%} %>