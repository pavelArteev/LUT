<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>


<%@page import="lut.Security_functions" %>
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{


   String sid = "";
   String username = "";
   String ip = request.getRemoteAddr();
   Cookie[] cs = request.getCookies();
   for (Cookie c: cs){
	   if (c.getName().equals("lutsid")) 
		   sid = c.getValue(); 
	   if (c.getName().equals("username"))
		   username = c.getValue();
   }
%>

<sql:query var="user" dataSource="jdbc/lut2">
    SELECT * FROM users where name = '<%=username %>' 
    	and session_id = '<%=sid %>' and ip = '<%=ip %>'
</sql:query>

<c:choose>
	<c:when test="${empty user.rows[0]}">
		<% 	           response.setHeader("Refresh", "0; URL=expired.jsp"); %> 
 	</c:when>
</c:choose>


<sql:query var="country" dataSource="jdbc/lut2">
    SELECT full_name FROM country
</sql:query>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 2.0 - Help Students Conquer the World</title>
    </head>
    <body>
    
    


        <h1>Hi student!</h1>
        <table border="0">
            <thead>
                <tr>
                    <th>LUT 2.0 provides information about approved international schools</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>To view information about schools in a country, please select a country below:</td>
                </tr>
                <tr>
                    <td><form action="schools.jsp">
                            <strong>Select a country:</strong>
                            <select name="country">
                                <c:forEach var="row" items="${country.rowsByIndex}">
                                    <c:forEach var="column" items="${row}">
                                        <option value="<c:out value="${column}"/>"><c:out value="${column}"/></option>
                                    </c:forEach>
                                </c:forEach>
                            </select>
                            <input type="submit" value="submit" />
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>

    </body>
</html>
<% } %>