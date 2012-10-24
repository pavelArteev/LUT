<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<sql:query var="users" dataSource="jdbc/lut2">
    SELECT * FROM users
</sql:query>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin - Users</title>
</head>
<body>
	<h1>Manage users</h1><br />
	<hr>
	<form method="post" action="admin_add_user.jsp">
		<strong>Add new User:</strong>
		<p>Name:<input type="text" name="name" size="3"></p>
        <p>Email:<input type="text" name="email" size="20"></p>
        <p>Password:<input type="password" name="pass" size="20"></p>
        <p><input type="submit" value="submit" name="login"></p>
    </form>
    <hr>
	<strong>List of all users:</strong>
	<table>
		<c:forEach var="row" items="${users.rowsByIndex}">
			<tr> 
 			<td><c:out value="${row[1]}"/></td> 
 			<td><form action="admin_edit_user.jsp">
 				<input type="hidden" name="uid" value="${row[0]}">
 				<input type="submit" value="Edit!">
 			</form></td></tr>
 			<tr> 
 			<td><c:out value="${row[1]}"/> | <c:out value="${row[4]}"/></td> 
 			<td><form action="admin_delete_user.jsp">
 				<input type="hidden" name="uid" value="${row[0]}">
 				<input type="submit" value="Delete!">
 			</form></td></tr>
    </c:forEach>
	</table>
</body>
</html>