 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>


<%@page import="lut.Security_functions" %>
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{ %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 2.0 - Help Students Conquer the World</title>
    </head>
    <body><table>
            <thead>
                <tr>
                    <th>You entered a disallowed sign. Please go  <a href="#" onClick="history.go(-1)">back</a></th>
                </tr>
                
            </thead>
            <tbody>
            <tr><td>Only allowed are A-Z a-z 0-9 ?!"(){}[]+-*/\_.,:@§</td></tr></tbody></table>

    </body>
</html>
<% } %>  