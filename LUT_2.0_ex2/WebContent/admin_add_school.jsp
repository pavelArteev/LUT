<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="max" value="${max_school_id.rows[0]}"/>

<sql:transaction dataSource="jdbc/lut2">
    <sql:update var="count">
        INSERT INTO school (school_id, full_name, short_name, place, zip, country ) VALUES ( ${max.school_id} + 1,'${param.full_name}','${param.short_name}','${param.place}','${param.zip_code}','${param.country}')
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
    <c:redirect url="admin_schools.jsp" />
</body>
</html>