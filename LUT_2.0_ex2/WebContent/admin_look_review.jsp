<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<sql:query var="reviews" dataSource="jdbc/lut2">
    SELECT * FROM user_reviews WHERE school_id='${param.school}'
</sql:query>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<c:set var="review" value="${reviews.rows[0]}"/>
        <c:choose>
            <c:when test="${ empty review }">
                No reviews for ${param.school_fullname} yet. Help us out by adding one! 
                <br><br>
            </c:when>
            <c:otherwise>
            	<strong>Menage the reviews:</strong>
                <c:forEach var="review" items="${reviews.rowsByIndex}">
                	<hr>
                	<form action="admin_delete_review.jsp">
                		 <c:out value="${review[2]}" /><br>
                   		 <i>${review[1]}</i>
                    	 <br><br>
                    	 <input type="hidden" name="review_sid" value="${review[0]}">
                    	 <input type="hidden" name="review_iud" value="${review[1]}">
                    	 <input type="hidden" name="review_rev" value="${review[2]}">
                    	<input type="submit" value="Delete review" />
                    </form>
                   
                </c:forEach>
            </c:otherwise>
        </c:choose>
</body>
</html>