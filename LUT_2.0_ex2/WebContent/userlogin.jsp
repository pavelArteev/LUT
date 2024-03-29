
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="lut.Security_functions" %>
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{

String user = request.getParameter("username");
String password = request.getParameter("password");
String pw_hash = Security_functions.i_can_haz_salty_md5sum(password);

%>

  		<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  name = '<%=user%>'
				AND password = '<%=pw_hash %>'
		</sql:query>
		<c:set var="userDetails" value="${users.rows[0]}"/>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">

<title>LUT - Login</title>
</head>
<body>
<c:choose>
            <c:when test="${empty userDetails or userDetails.user_key != ''}">
                <h1>Login failed</h1>
                <table>
            <thead>
                <tr>
                    <th>Please go <a href="index.jsp">back</a></th></tr></thead><tbody></tbody></table>
            </c:when>
            <c:otherwise>
            	<h1> Welcome <%=user%> </h1>
            	  <table>
            <thead>
                <tr>
                    <th>
            	You will be redirected in a few seconds. :)</th></tr></thead><tbody></tbody></table>
 <%            	String ip = request.getRemoteAddr();
   				String sid = Security_functions.create_sid(user);     %>     	
            	
           		<sql:transaction dataSource="jdbc/lut2">
           		<sql:update>
            	    	UPDATE users SET session_id = '<%=sid%>', ip = '<%=ip %>' 
            	    	WHERE name = '<%=user%>'
            	  </sql:update>  	
            	  
            	</sql:transaction>
            	
	           <% 
	           
	           Cookie cid = new Cookie("lutsid", sid);
	           Cookie cname = new Cookie("username", user);
			   cname.setMaxAge(60*30);
	           cid.setMaxAge(60*30); //30 Minutes time to live for the cookie
	           response.addCookie(cid);
	           response.addCookie(cname);
	           response.setHeader("Refresh", "5; URL=countries.jsp"); %>
            </c:otherwise>
        </c:choose>
</body>
</html>

<%} %>