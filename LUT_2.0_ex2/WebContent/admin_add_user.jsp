<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<sql:transaction dataSource="jdbc/lut2">
    <sql:update var="users">
        INSERT INTO country VALUES ('${param.name}','${param.pass}' , NULL, ,'${param.email}', NULL,'${param.key}')
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
    <c:redirect url="admin_users.jsp" />
</body>
</html>