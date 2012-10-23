<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            
<% 
	double KEY_LENGTH = 25;
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
		mail1 = request.getParameter("mail");
	}
	

	String randKey = UUID.randomUUID().toString();
%>

    
            
            
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Forgot Password</title>
    </head>
<body>
   <h1>Hi student!</h1>
   <h2>Forgot your password?</h2>
        <table border="0">
            <thead>
                <tr>
                    <th>Enter your email to reset your password:</th>
                </tr>
            </thead>
            <tbody>
            
<%
	//Verify the POST data 
	if (post) {
		if(mail1.contentEquals("")){
			out.print("You must to write your UserName!");
		}else{
			// Adding User to Table 
			//TODO also we must to add verification if we have no the same username or email
			// then add user to temp db and send to him email with confirmation
            out.print(randKey);
            int uid = 1;


            String result;

            //Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + String.valueOf(request.getServerPort()) + "/" + 
                request.getContextPath().toString();
            String verifyURL = serverURL + "/verify.jsp?user=" + uid + "&key=" + randKey;

            String content = "Hello,\n Click the following link or copy it in your browser to reset your password: <a href='" + verifyURL + "'>" + verifyURL + "</a>";

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
                result = "Check your email! You have been sent a password reset link";
            }catch (MessagingException mex) {
                mex.printStackTrace();
                result = "Error: unable to send email... Please try again!";
            }

            out.print(result);
		}
   	}
%>
 			
				<tr>
             <td><form method="post" action="forgot_password.jsp">
                            <p>Email:<input type="text" name="mail" value="<%=mail1%>" size="20"></p>                            
                            <p><input type="submit" value="submit" name="login"></p>
                        </form>
                    </td>
                </tr>
                <td><a href="index.jsp">Back to main page</a></td>
                            </tbody>
        </table>


</body>
</html>