<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@ page import="java.io.*,java.util.*,javax.mail.*, javax.naming.*, com.sun.mail.smtp.*"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="javax.annotation.Resource" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="lut.Security_functions" %>
            
<% 
   if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   }else{
	boolean post = false;
	boolean addToDataBase = false;
 	String uname ="";
	String pw1 ="";
 	String pw2 ="";
 	String pw_hash = "";
	String mail1 ="";
	String mail2 ="";
	String A = "test";
            
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


<c:set var="postVal" value = "<%=post%>"/>
<c:choose>
<c:when test="${postVal == true}">
<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  name = '<%=uname%>'
		</sql:query>
		<c:set var="userDetails" value="${users.rows[0]}"/>            
</c:when>   
</c:choose>        
            
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



<c:choose>
	<c:when test="${empty userDetails}">
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
			//Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + String.valueOf(request.getServerPort()) + "/" + 
                request.getContextPath().toString();
            String verifyURL = serverURL + "/verify.jsp?user=" + uname + "&key=" + randKey + "&rst=0";

            String verificationMessage = "Welcome to LUT, \n Click the following link or copy it in your browser to verify your email: "+ verifyURL;
            
            out.println("Trying to send email...");
            
            SendEmail sendEmail = new SendEmail();
            boolean sendEmailResult = sendEmail.sendMessage(mail1, verificationMessage);
            
            if(sendEmailResult){
            	out.print("Send email - OK Check your email for confirmation =)");
           		pw_hash = Security_functions.i_can_haz_salty_md5sum(pw1);
            	addToDataBase = true;
            }else{
            	out.print("Send email - Error \n Please try again latter =/"); 
            	addToDataBase = false;
            }
            
            response.setHeader("Refresh", "5; URL=index.jsp");
       }
   	}
%>
</c:when>
	<c:otherwise>
	User exist
	</c:otherwise>   
</c:choose>

<!-- Temporary adding user to database -->
<c:set var="atdb" value = "<%=addToDataBase%>"/>
<c:choose>

<c:when test="${atdb == true}">


				
	<sql:transaction dataSource="jdbc/lut2">
		<sql:update >
			INSERT INTO users VALUES (NULL, '<%=uname %>','<%=pw_hash %>' , NULL ,'<%=mail1 %>', NULL,'<%=randKey %>')
		</sql:update>
	</sql:transaction>
</c:when>
<c:otherwise>




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
</c:otherwise>
</c:choose>








<%!

//	up JavaMail session on your localhost
//	asadmin --user admin create-javamail-resource --mailhost="smtp.gmail.com" --mailuser="group8.lut@gmail.com" --fromaddress="group8.lut@gmail.com" --debug="false" --enabled="true" --description="A new JavaMail Session!" --property="mail.smtp.password=getc0ins:mail.smtp.auth=true:mail.smtp.port=465:mail.smtp.socketFactory.fallback=false:mail.smtp.socketFactory.port=465:mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory" "mail/newsession"
//	group8.lut@gmail.com
//	getc0ins

/**
* Simple Class for sending email
*/
public class SendEmail{
	
	
	public boolean sendMessage(String email, String message) {
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
          
          	return true;
		 }catch(Exception e){
			 return false;
		 }
	  }
}
%>

<%} %>
