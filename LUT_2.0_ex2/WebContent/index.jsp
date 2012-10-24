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
    <body>
        <h1>Hi student!</h1>
        <table border="0">
            <thead>
                <tr>
                    <th>Please login or register to continue!</th>
                </tr>
            </thead>
            <tbody>
				<tr>
                    <td><form method="post" action="userlogin.jsp">
                            <p>Username:</font><input type="text" name="username" size="20"></p>
                            <p>Password:</font><input type="password" name="password" size="20"></p>
                            <p><input type="submit" value="submit" name="login"></p>
                        </form>
                    </td>
                </tr>
                <td><a href="forgot_password.jsp" value="Forgot your password!">Forgot your password!</a></td>
                <td><a href="register.jsp" value="Sing up!">Sine UP!</a></td>
            </tbody>
        </table>
		 <thead>
                <tr>
                    <th><a href="lutadmin.jsp" value="lutadmin">Copyright!</a></th>
                </tr>
        </thead>
    </body>
</html>
<% } %>