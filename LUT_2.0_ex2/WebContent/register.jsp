<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            
            
            
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Sign Up to LUT!</title>
    </head>
<body>
   <h1>Hi student!</h1>
        <table border="0">
            <thead>
                <tr>
                    <th>Please provide the following informations</th>
                </tr>
            </thead>
            <tbody>
            <% 
            boolean user = false;
            boolean password = false;
            boolean mail = false;
            boolean captcha = false;
            boolean post = false;
            String uname ="";
            String pw1 ="";
            String pw2 ="";
            String mail1 ="";
            String mail2 ="";
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                post = true;
                uname = request.getParameter("username");
                pw1 = request.getParameter("password");
                pw2 = request.getParameter("password2");
            	mail1 = request.getParameter("mail");
            	mail2 = request.getParameter("mail2");
            	out.print(uname+pw1+pw2+mail1+mail2);
               }
 			%>
				<tr>
             <td><form method="post" action="register.jsp">
                            <p>Username:<input type="text" name="username" value="<%=uname%>" size="20"></p>
                            <p></p>
                            <p>Password:<input type="password" name="password" value="<%=pw1%>" size="20"></p>
                            <p></p>
                            <p>Retype Password:<input type="password" name="password2" value="<%=pw2%>" size="20"></p>
                            <p></p>
                            <p>Email:<input type="text" name="mail" value="<%=mail%>" size="20"></p>
                            <p></p>
                            <p>Retype Email:<input type="text" name="mail2" value="<%=mail2%>" size="20"></p>
                            <p></p>
             <!--           <p>Security Question:<input type="password" name="password" size="20"></p>
                            <p></p>
                            <p>Answer:<input type="password" name="password" size="20"></p>
                            <p></p> -->
                            
                            <p><input type="submit" value="submit" name="login"></p>
                        </form>
                    </td>
                </tr>
                <td><a href="index.jsp"">Back to main page</a></td>
                            </tbody>
        </table>


</body>
</html>