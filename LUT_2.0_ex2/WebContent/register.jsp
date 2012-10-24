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
            //out.print(randKey);
			//out.print(uname+pw1+pw2+mail1+mail2);
            int uid = 1;

            //INSERT INTO users email, encripted(pass), key
           

            //Get server info for email:
            String serverURL = request.getScheme().toString() + "://" + request.getServerName().toString() + ":" + String.valueOf(request.getServerPort()) + "/" + 
                request.getContextPath().toString();
            String verifyURL = serverURL + "/verify.jsp?user=" + uid + "&key=" + randKey + "&rst=0";

            String message = "Welcome to LUT, \n Click the following link or copy it in your browser to verify your email: <a href='" + verifyURL + "'>" + verifyURL + "</a>";
            
            out.print("Trying to send email...");
            SendEmail email = new SendEmail();
            email.sendMessage(mail1, message);
            //MailService email = new MailService();
            //email.sendMessage(mail1, message);

            //asadmin --user admin create-javamail-resource --mailhost="smtp.gmail.com" --mailuser="group8.lut@gmail.com" --fromaddress="group8.lut@gmail.com" --debug="false" --enabled="true" --description="A new JavaMail Session!" --property="mail.smtp.password=getc0ins:mail.smtp.auth=true:mail.smtp.port=465:mail.smtp.socketFactory.fallback=false:mail.smtp.socketFactory.port=465:mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory" "mail/newsession"

            //In order for mail to work we need an SMTP server
            //$: sudo apt-get install postfix
            /*
            try{
                Session mailSession = Session.getInstance(System.getProperties());
                Transport transport = new SMTPTransport(mailSession,new URLName("localhost"));
                transport.connect("localhost",25,null,null);
                MimeMessage m = new MimeMessage(mailSession);
                m.setFrom(new InternetAddress(%><%request.getParameter("noreply@lut.com")%><%));
                Address[] toAddr = new InternetAddress[] {
                    new InternetAddress(%><%request.getParameter(mail1)%><%)
                };
                m.setRecipients(javax.mail.Message.RecipientType.TO, toAddr);
                m.setSubject(%><%request.getParameter("LUT: Verify your email")%><%);
                m.setSentDate(new java.util.Date());
                m.setContent(%><%request.getParameter(message)%><%, "text/html");
                transport.sendMessage(m,m.getAllRecipients());
                transport.close();
                out.println("Check your email and you'll be good to go!");
            }catch(Exception e){
                out.print("Error: ");
                out.println(e.getMessage());
                e.printStackTrace();
            }
            */


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

<%! 
public class SendEmail {
  @Resource(name = "mail/group8")
  private Session mailSession;

  public String sendMessage(String email, String message) {
	  String result = "";
	  Message msg = new MimeMessage(mailSession);
	    try {
	      msg.setSubject("LUT: Verify Your Email");
	      msg.setRecipient(Message.RecipientType.TO,
	              new InternetAddress(email));
	      msg.setText(message);
	      Transport.send(msg);
	      result = "Check your email! You have been sent a comfermation link";
	    }
	    catch(Exception e) {
   		  //e.printStackTrace();
          result = "Error: unable to send email... Please try again!";
	    }
	   return result;
  }
}
%>

<%!
/*
public class MailService {  
    public String sendMissage(String email, String message){  
        String result = "";
        String myEmailId = "group8.lut@gmail.com";
        String myPassword = "getc0ins";
        try {
            MultiPartEmail email = new MultiPartEmail();
            email.setSmtpPort(587);
            email.setAuthenticator(new DefaultAuthenticator(myEmailId, myPassword));
            email.setDebug(true);
            email.setHostName("smtp.gmail.com");
            email.setFrom(myEmailId);
            email.setSubject("LUT: Verify Your Email");
            email.setMsg(message);
            email.addTo(email);
            email.setTLS(true);
            email.send();
            result = "Check your email! You have been sent a comfermation reset link";
        } catch (Exception e) {
            result = "Crap: " + e;
        }
        return result;
    }   
}  
*/
%>