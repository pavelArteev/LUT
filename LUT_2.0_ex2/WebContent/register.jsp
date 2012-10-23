<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            
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
	}
%>
<rand:string id="randKey" length="25" charset="a-zA-Z0-9"/><br/>            
            
            
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
                    <th>Please provide the following information</th>
                </tr>
            </thead>
            <tbody>
            
<%
	//Verify the POST data 
	if (post) {
		if(uname.contentEquals("")){
			out.print("You must to write your UserName!");
		}else if(pw1.contentEquals("")){
			out.print("You must to write Password!");
		}else if(mail1.contentEquals("")){
			out.print("You must to write your email!");
		}else if(!mail1.contains("@")){ //TODO  make write verification on code 
			out.print("You must to write a vaild email");
		}else if(!pw1.contentEquals(pw2)){
			out.print("Second password different from first");
		}else if(!mail1.contentEquals(mail2)){
			out.print("Second email different from the first");
		}else{
			// Adding User to Table 
			//TODO also we must to add verification if we have no the same username or email
			// then add user to temp db and send to him email with confirmation
            out.print(randKey);
			out.print(uname+pw1+pw2+mail1+mail2);
            int uid = 1;


            String result;

            //Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + request.getServerPort().toString() + "/" + 
                request.getContextPath().toString();
            String verifyURL = serverURL + "/verify.jsp?user=" + uid + "&key=" + randKey + "&rst=0";

            String content = "Welcome to LUT, \n 
            Click the following link or copy it in your browser to verify your email:
            <a href='" + verifyURL + "'>" + verifyURL + "</a>";

            String from = "noreply@lutproject.com";

            // Assuming you are sending email from localhost
            String host = "localhost";

            // Get system properties object
            Properties properties = System.getProperties();

            // Setup mail server
            properties.setProperty("mail.smtp.host", host);

            // Get the default Session object.
            Session mailSession = Session.getDefaultInstance(properties);

            try{
                // Create a default MimeMessage object.
                MimeMessage message = new MimeMessage(mailSession);
                // Set From: header field of the header.
                message.setFrom(new InternetAddress(from));
                // Set To: header field of the header.
                message.addRecipient(Message.RecipientType.TO,
                                       new InternetAddress(mail1));
                // Set Subject: header field
                message.setSubject("LUT: Verify Your Email");
                // Now set the actual message
                message.setText(content);
                // Send message
                Transport.send(message);
                result = "Check your email! Before you can use LUT you have to conferm your email address";
            }catch (MessagingException mex) {
                mex.printStackTrace();
                result = "Error: unable to register... Please try again!";
            }

            out.print(result);
		}
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
                            <p>Email:<input type="text" name="mail" value="<%=mail1%>" size="20"></p>
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
                <td><a href="index.jsp">Back to main page</a></td>
                            </tbody>
        </table>


</body>
</html>