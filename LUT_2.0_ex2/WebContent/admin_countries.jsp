<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin_countries</title>
</head>
<body>
	<h1>Manage countries</h1><br />
	<hr>
	<form method="post" action="admin_add_country.jsp">
		<strong>Add new country:</strong>
		<p>Short name:<input type="text" name="short_name" size="3"></p>
        <p>Country name:<input type="text" name="country_name" size="20"></p>
        <p><input type="submit" value="submit" name="login"></p>
    </form>
    <hr>
	<strong>List of all countries:</strong>
	<table>
		<c:forEach var="row" items="${country.rowsByIndex}">
 			<tr> 
 			<td><c:out value="${row[1]}"/></td> 
 			<td><form action="admin_delete_country.jsp">
 				<input type="hidden" name="country" value="${row[1]}">
 				<input type="hidden" name="country_sh" value="${row[0]}">
 				<input type="submit" value="Delete country!">
 			</form></td></tr>
    </c:forEach>
	</table>
</body>
</html>