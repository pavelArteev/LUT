
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="lut.Security_functions"%>

<%
	String user = request.getParameter("username");
	String password = request.getParameter("password");
	String site = request.getParameter("site");

	if (!Security_functions.check_input(request.getParameterMap()))
		System.out.print("EVIL INPUT!");

	String pw_hash = Security_functions
			.i_can_haz_salty_md5sum(password);
%>

<sql:query var="users" dataSource="jdbc/lut2">
    SELECT * FROM admin_users
    WHERE  uname = '<%=user%>'
    AND pw = '<%=pw_hash%>'
</sql:query>

<c:set var="userDetails" value="${users.rows[0]}" />

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="lutstyle.css">
<title>LUT Admin pages</title>
</head>
<body>
	<c:choose>
		<c:when test="${ empty userDetails }">
                Login failed
            </c:when>
		<c:otherwise>



			<h1>
				Welcome
				<%=user%>
			</h1>

			<br />
			<form method="post" action="adminpanel.jsp?site=admin_countries">
				<input type="hidden" name="username" value="<%=user%>" /> <input
					type="hidden" name="password" value="<%=password%>" /> <input
					type="submit" value="Add/remove countries" />
			</form>


			<form method="post" action="adminpanel.jsp?site=admin_schools">
				<input type="hidden" name="username" value="<%=user%>" /> <input
					type="hidden" name="password" value="<%=password%>" /> <input
					type="submit" value="Add/remove schools" />
			</form>

			<form method="post" action="adminpanel.jsp?site=admin_reviews">
				<input type="hidden" name="username" value="<%=user%>" /> <input
					type="hidden" name="password" value="<%=password%>" /> <input
					type="submit" value="Manage reviews" />
			</form>

			<form method="post" action="adminpanel.jsp?site=admin_users">
				<input type="hidden" name="username" value="<%=user%>" /> <input
					type="hidden" name="password" value="<%=password%>" /> <input
					type="submit" value="Manage User" />
			</form>

			<form method="post" action="index.jsp">
				<input type="submit" value="Logout" />
			</form>
			<c:choose>

				<c:when test="${param.site== 'index'}">
		Select what you want to do. 
	</c:when>

				<c:when test="${param.site== 'admin_schools'}">
					<sql:query var="schools" dataSource="jdbc/lut2">
    SELECT * FROM school
</sql:query>
					<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>
					<form method="post" action="adminpanel.jsp?site=add_school">
						<strong>Add new school:</strong>
						<p>
							Full name:<input type="text" name="full_name" size="50">
						</p>
						<p>
							Short name:<input type="text" name="short_name" size="3">
						</p>
						<p>
							Place:<input type="text" name="place" size="20">
						</p>
						<p>
							Zip code:<input type="text" name="zip_code" size="10">
						</p>
						<p>
							Country name:<select name="country">
								<c:forEach var="row" items="${country.rowsByIndex}">

									<option value='<c:out value="${row[0]}"/>'>
										<c:out value="${row[1]}" />
									</option>

								</c:forEach>
							</select>
						</p>
						<input type="hidden" name="username" value="<%=user%>" /> <input
							type="hidden" name="password" value="<%=password%>" />

						<p>
							<input type="submit" value="submit" />
						</p>
					</form>
					<hr>
					<strong>List of all schools:</strong>
					<table>
						<c:forEach var="row2" items="${schools.rowsByIndex}">

							<tr>
								<td><c:out value="${row2[1]}" />,&nbsp;<c:out
										value="${row2[3]}" /></td>
								<td><form method="post"
										action="adminpanel.jsp?site=delete_school">
										<input type="hidden" name="username" value="<%=user%>" /> <input
											type="hidden" name="password" value="<%=password%>" /> <input
											type="hidden" name="school_id" value="${row2[0]}"> <input
											type="submit" value="Delete school!">
									</form></td>
							</tr>

						</c:forEach>
					</table>
				</c:when>

				<c:when test="${param.site== 'add_school'}">
					<sql:query var="max_school_id" dataSource="jdbc/lut2">
    SELECT school_id FROM school ORDER BY school_id DESC
</sql:query>
					<c:set var="max" value="${max_school_id.rows[0]}" />

					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
        INSERT INTO school (school_id, full_name, short_name, place, zip, country ) VALUES ( ${max.school_id} + 1,'${param.full_name}','${param.short_name}','${param.place}','${param.zip_code}','${param.country}')
    </sql:update>
					</sql:transaction>
School added!
				</c:when>

				<c:when test="${param.site== 'delete_school'}">
					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
    	DELETE FROM user_reviews WHERE school_id='${param.school_id}'
    </sql:update>
					</sql:transaction>

					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
    	DELETE FROM school WHERE school_id='${param.school_id}' LIMIT 1
    </sql:update>
					</sql:transaction>
School succesfull deleted!
				</c:when>

				<c:when test="${param.site== 'admin_reviews'}">
					<sql:query var="schools" dataSource="jdbc/lut2">
    SELECT * FROM school
</sql:query>
					<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>
					<h1>Manage reviews!</h1>
					<table border="0">
						<tbody>
							<tr>
								<td>Select the school for which you wont to manage reviews:</td>
							</tr>
							<tr>
								<td><form method="post"
										action="adminpanel.jsp?site=look_reviews">
										<strong>Select a school:</strong> <select name="school">
											<c:forEach var="row" items="${schools.rowsByIndex}">
												<option value="<c:out value="${row[0]}"/>">
													<c:out value="${row[1]},${row[5]}" />
												</option>
											</c:forEach>
										</select> <input type="hidden" name="username" value="<%=user%>" /> <input
											type="hidden" name="password" value="<%=password%>" /> <input
											type="submit" value="submit" />
									</form></td>
							</tr>
						</tbody>
					</table>
				</c:when>

				<c:when test="${param.site== 'look_reviews'}">
					<sql:query var="reviews" dataSource="jdbc/lut2">
    SELECT * FROM user_reviews WHERE school_id='${param.school}'
</sql:query>

					<c:set var="review" value="${reviews.rows[0]}" />
					<c:choose>
						<c:when test="${ empty review }">
                No reviews for ${param.school_fullname} yet. 
                <br>
							<br>
						</c:when>
						<c:otherwise>
							<strong>Menage the reviews:</strong>
							<c:forEach var="review" items="${reviews.rowsByIndex}">
								<hr>
								<form method="post" action="adminpanel.jsp?site=delete_review">
									<c:out value="${review[2]}" />
									<br> <i>${review[1]}</i> <br>
									<br> <input type="hidden" name="review_sid"
										value="${review[0]}"> <input type="hidden"
										name="review_iud" value="${review[1]}"> <input
										type="hidden" name="review_rev" value="${review[2]}">
									<input type="hidden" name="username" value="<%=user%>" /> <input
										type="hidden" name="password" value="<%=password%>" /> <input
										type="submit" value="Delete review" />
								</form>

							</c:forEach>
						</c:otherwise>
					</c:choose>
				</c:when>

				<c:when test="${param.site== 'delete_review'}">

					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
    	DELETE FROM user_reviews WHERE school_id='${param.review_sid}' AND user_id='${param.review_iud}' AND review='${param.review_rev}'
    </sql:update>
					</sql:transaction>
Review deleted!
				</c:when>

				<c:when test="${param.site== 'admin_countries'}">
					<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>

					<h1>Manage countries</h1>
					<br />
					<hr>
					<form method="post" action="adminpanel.jsp?site=add_country">
						<strong>Add new country:</strong>
						<p>
							Short name:<input type="text" name="short_name" size="3">
						</p>
						<p>
							Country name:<input type="text" name="country_name" size="20">
						</p>
						<input type="hidden" name="username" value="<%=user%>" /> <input
							type="hidden" name="password" value="<%=password%>" />

						<p>
							<input type="submit" value="submit" name="login">
						</p>
					</form>
					<hr>
					<strong>List of all countries:</strong>
					<table>
						<c:forEach var="row" items="${country.rowsByIndex}">
							<tr>
								<td><c:out value="${row[1]}" /></td>
								<td><form method="post"
										action="adminpanel.jsp?site=delete_country">
										<input type="hidden" name="country" value="${row[1]}">
										<input type="hidden" name="country_sh" value="${row[0]}">
										<input type="hidden" name="username" value="<%=user%>" /> <input
											type="hidden" name="password" value="<%=password%>" /> <input
											type="submit" value="Delete country!">
									</form></td>
							</tr>
						</c:forEach>
					</table>
				</c:when>

				<c:when test="${param.site== 'delete_country'}">

					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
    	DELETE FROM school WHERE country='${param.country_sh}'
    </sql:update>
					</sql:transaction>
					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
    	DELETE FROM country WHERE full_name='${param.country}' LIMIT 1
    </sql:update>
					</sql:transaction>
Country deleted!

		</c:when>

				<c:when test="${param.site== 'add_country'}">
					<sql:transaction dataSource="jdbc/lut2">
						<sql:update var="count">
        INSERT INTO country VALUES ('${param.short_name}','${param.country_name}')
    </sql:update>
					</sql:transaction>
Country added!
		</c:when>



				<c:when test="${param.site== 'admin_users'}">
			To be implemented
		</c:when>

				<c:otherwise>
Specified Site not found. :(
</c:otherwise>



			</c:choose>
		</c:otherwise>
	</c:choose>

</body>
</html>