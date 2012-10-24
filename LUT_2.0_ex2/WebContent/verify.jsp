<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            

<%@page import="lut.Security_functions" %>
            
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{
    String uid = "";
    String key = "";
	String pw1 ="";
 	String pw2 ="";
    String rst = "";
    boolean post = false;
            

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        post = true;
        pw1 = request.getParameter("pass1");
        pw2 = request.getParameter("pass2");
    }
    rst = request.getParameter("rst");
    uid = request.getParameter("uid");
    key = request.getParameter("key");

%>         
            
            
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <% if (rst.contentEquals("0")){
            out.print("<title>Verify Account - Set Password</title>");
        }else{
            out.print("<title>Reset Password</title>");
        }
        %>
    </head>
<body>
 <table border="0">
    <thead>
        <tr>
            <th>Enter your new password below</th>
        </tr>
    </thead>
    <tbody>
            
<%
    //Verify the POST data 
    if (!(uid.contentEquals("") || key.contentEquals(""))) {
        //Verify good referral link
        if(post && !pw1.contentEquals("") && !pw2.contentEquals("") && !pw1.contentEquals(pw2)){
            out.print("<tr><td><h3>Passwords do not match! Try again!</h3></tr></td>");
            passwordForm(uid, key);
        }else if(pw1.contentEquals(pw2)){
            //Set new password and remove key from database
            //GET * FROM users WHERE uid = "$uid" AND key = "$key"

            //IF empty 
            // out.print("<tr><td><h3>FAIL :(</h3></tr></td>");
            //Else
            //INSERT pass1 into password WHERE uid = "$uid" AND key = "$key"
            out.print("<tr><td><h3>Success!</h3></tr></td>");
        }else{
            passwordForm(uid, key);
        }
    }else{
        out.print("<h1>Invalid Verification Link!</h1>");
    }
%>

        <td><a href="index.jsp">Back to main page</a></td>
    </tbody>
</table>

</body>
</html>

<%!
String passwordForm(String uid, String key) {
	return "<tr>" +
		     "<td><form method='post' action='verify.jsp?uid="+uid+"&key="+key+"'>" +
	            "<p>Password:<input type='password' name='pass1' size='20'></p>"+
	            "<p></p>"+
	            "<p>Retype Password:<input type='password' name='pass2' size='20'></p>"+
	            "<p></p>"+             
	            "<p><input type='submit' value='submit' name='login'></p>"+
	                "</form>"+
	            "</td>"+
	        "</tr>";
}
%>
<% } %>