<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>



<sql:query var="schools" dataSource="jdbc/lut2">
    SELECT * FROM school
</sql:query>
<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<h1>Manage schools</h1><br />
	<hr>
	<form method="post" action="admin_add_school.jsp">
		<strong>Add new school:</strong>
		<p>Full name:<input type="text" name="full_name" size="50"></p>
		<p>Short name:<input type="text" name="short_name" size="3"></p>
		<p>Place:<input type="text" name="place" size="20"></p>
		<p>Zip code:<input type="text" name="zip_code" size="10"></p>
        <p>Country name:<select name="country">
                                <c:forEach var="row" items="${country.rowsByIndex}">

                                        <option value="<c:out value="${row[0]}"/>"><c:out value="${row[1]}"/></option>

                                </c:forEach>
                            </select></p>
        <p><input type="submit" value="submit" name="login"></p>
    </form>
    <hr>
	<strong>List of all schools:</strong>
	<table>
		<c:forEach var="row2" items="${schools.rowsByIndex}">
           	
           			<tr> 
           			<td><c:out value="${row2[1]}"/>,&nbsp;<c:out value="${row2[3]}"/></td> 
           			<td><form action="admin_delete_school.jsp">
           				<input type="hidden" name="school_id" value="${row2[0]}">
           				<input type="submit" value="Delete school!">
           			</form></td></tr>
          
     	 </c:forEach>
	</table>
</body>
</html>