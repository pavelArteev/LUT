<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*, javax.naming.*, com.sun.mail.smtp.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="javax.annotation.Resource" %>

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
	String randKey = UUID.randomUUID().toString();
%>          
            
            
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
            //out.print(randKey);
			//out.print(uname+pw1+pw2+mail1+mail2);
            int uid = 1;

            //INSERT INTO users email, encripted(pass), key
           

            //Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + String.valueOf(request.getServerPort()) + "/" + 
                request.getContextPath().toString();
            String verifyURL = serverURL + "/verify.jsp?user=" + uid + "&key=" + randKey + "&rst=0";

            String verificationMessage = "Welcome to LUT, \n Click the following link or copy it in your browser to verify your email: "+ verifyURL;
            
            out.println("Trying to send email...");
            
            SendEmail sendEmail = new SendEmail();
            out.println(sendEmail.sendMessage(mail1, verificationMessage));
            
            response.setHeader("Refresh", "5; URL=index.jsp");
            
            return;
            
 		}
   	}
%>
        <table border="0">
            <thead>
                <tr>
                    <th>Please provide the following information</th>
                </tr>
            </thead>
            <tbody>
            

 			
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
                            
                            <p><input type="submit" value="submit" name="login"></p>
                        </form>
                    </td>
                </tr>
                <td><a href="index.jsp">Back to main page</a></td>
                            </tbody>
        </table>


</body>
</html>





<%!

//	up JavaMail session on your localhost
//	asadmin --user admin create-javamail-resource --mailhost="smtp.gmail.com" --mailuser="group8.lut@gmail.com" --fromaddress="group8.lut@gmail.com" --debug="false" --enabled="true" --description="A new JavaMail Session!" --property="mail.smtp.password=getc0ins:mail.smtp.auth=true:mail.smtp.port=465:mail.smtp.socketFactory.fallback=false:mail.smtp.socketFactory.port=465:mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory" "mail/newsession"
//	group8.lut@gmail.com
//	getc0ins

/**
* Simple Class for sending email
*/
public class SendEmail{
	
	
	public String sendMessage(String email, String message) {
		String returnResult = "";
		  
		try{
			InitialContext ctx = new InitialContext();  
			Session session =  
				(Session) ctx.lookup("mail/newsession");  
			Message emailMessage = new MimeMessage(session);
	
			emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email, false));
	
			// Set the message's subject
			emailMessage.setSubject("Confirmation user account");
			// Insert the message's body
			emailMessage.setText(message);
			// Set header
			emailMessage.setHeader("LUT_2.0", "Lut");
	        // Adjust the date of sending the message
	        Date timeStamp = new Date();
	        emailMessage.setSentDate(timeStamp);

	        // Use the 'send' static method of the Transport
			// class to send the message
          	Transport.send(emailMessage);
          
          	return "Send email - OK Check your email for confirmation =)";
		 }catch(Exception e){
			 return "Send email - Error \n Please try again latter =/"; 
		 }
	  }
}
%>

