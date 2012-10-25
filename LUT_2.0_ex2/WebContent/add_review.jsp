<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<%@page import="lut.Security_functions" %>
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{
	String sid = "";
	String username = "";
	String ip = request.getRemoteAddr();
	Cookie[] cs = request.getCookies();
	for (Cookie c : cs) {
		if (c.getName().equals("lutsid"))
			sid = c.getValue();
		if (c.getName().equals("username"))
			username = c.getValue();
	}
%>

<sql:query var="user" dataSource="jdbc/lut2">
    SELECT * FROM users where name = '<%=username%>' 
    	and session_id = '<%=sid%>' and ip = '<%=ip%>'
</sql:query>

<c:choose>
	<c:when test="${empty user.rows[0]}">
		<%
			response.setHeader("Refresh", "0; URL=expired.jsp");
		%>
	</c:when>
	<c:otherwise>

		<sql:transaction dataSource="jdbc/lut2">
			<sql:update var="count">
        INSERT INTO user_reviews VALUES ('${param.school_id}', '<%=username %>', '${param.review}');
    </sql:update>
		</sql:transaction>



		<%@page contentType="text/html" pageEncoding="UTF-8"%>
		<!DOCTYPE html>
		<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="refresh" content="5;url=countries.jsp">
<link rel="stylesheet" type="text/css" href="lutstyle.css">
<title>Review added!</title>
</head>
<body>
	<h1>Thanks ${param.name}!</h1>
	Your contribution is appreciated.
	<br> You will be redirected to the LUT2.0 main page in a few
	seconds.
	</tr>
</body>
		</html>



	</c:otherwise>
</c:choose>
<% } %>