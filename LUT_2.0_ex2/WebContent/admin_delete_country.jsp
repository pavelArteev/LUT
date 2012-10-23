<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<sql:transaction dataSource="jdbc/lut2">
    <sql:update var="count">
    	DELETE FROM school WHERE country='${param.country_sh}'
    </sql:update>
</sql:transaction>
<sql:transaction dataSource="jdbc/lut2">
    <sql:update var="count">
    	DELETE FROM country WHERE full_name='${param.country}' LIMIT 1
    </sql:update>
</sql:transaction>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<c:redirect url="admin_countries.jsp" />
</body>
</html>