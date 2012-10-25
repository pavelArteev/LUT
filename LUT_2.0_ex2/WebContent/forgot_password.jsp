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
	String mail1 = "";
	boolean post = false;
	if(! Security_functions.check_input(request.getParameterMap())){
	   response.setHeader("Refresh", "0; URL=badinput.jsp");
   	}else{
		
	   if ("POST".equalsIgnoreCase(request.getMethod())) {
		post = true;
		mail1 = request.getParameter("mail");
	}
	

	String randKey = UUID.randomUUID().toString();
%>

<c:set var="postVal" value = "<%=post%>"/>
<c:choose>
<c:when test="${postVal == true}">
<sql:query var="users" dataSource="jdbc/lut2">
				SELECT * FROM users
				WHERE  email = '<%=mail1%>'
		</sql:query>
		<c:set var="userDetails" value="${users.rows[0]}"/> 
		   <c:set var="u_name" value="${userDetails.name}" />
		  
		
</c:when>   
</c:choose>      
            
            
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<link rel="stylesheet" type="text/css" href="lutstyle.css">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Forgot Password</title>
    </head>
<body>


<c:choose>
	<c:when test="${!empty userDetails and postVal==true}">
	Check email to reset password
	<sql:transaction dataSource="jdbc/lut2">
	<sql:update>
    	UPDATE  users SET user_key = '<%=randKey %>' WHERE email='<%=mail1%>'
    </sql:update>
    </sql:transaction>
	<%
	//Verify the POST data 
	if (post) {
            //Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + String.valueOf(request.getServerPort()) + "/" + 
                request.getContextPath().toString();
            
            String resetURL = serverURL + "/reset_password.jsp?user=" + pageContext.getAttribute("u_name") + "&key=" + randKey;

            String content = "Hello,\n Click the following link or copy it in your browser to reset your password: " + resetURL;

            SendEmail sendEmail = new SendEmail();
            boolean sendEmailResult = sendEmail.sendMessage(mail1, content);
            
            if(sendEmailResult){
            	out.print("Send email - OK Check your email for confirmation =)");
            }else{
            	out.print("Send email - Error \n Please try again latter =/");
            }
            
	}
   	
%>

</c:when>
	
<c:when test="${empty userDetails and postVal==true}">
	Wrong email
</c:when>
	
<c:otherwise>
   <h1>Hi student!</h1>
   <h2>Forgot your password?</h2>
        <table border="0">
            <thead>
                <tr>
                    <th>Enter your email to reset your password:</th>
                </tr>
            </thead>
            <tbody>
            

 			
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
</c:otherwise>
	   
</c:choose>



   
   



</body>
</html>

<%!

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
<% } %>