<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="schools" dataSource="jdbc/lut2">
    SELECT * FROM school
</sql:query>
<sql:query var="country" dataSource="jdbc/lut2">
    SELECT * FROM country
</sql:query>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 2.0 - Admin part</title>
    </head>
    <body>
        <h1>Manage reviews!</h1>
        <table border="0">
            <tbody>
                <tr>
                    <td>Select the school for which you wont to manage reviews:</td>
                </tr>
                <tr>
                    <td><form action="admin_look_review.jsp">
                            <strong>Select a school:</strong>
                            <select name="school">
                                <c:forEach var="row" items="${schools.rowsByIndex}">
                                        <option value="<c:out value="${row[0]}"/>"><c:out value="${row[1]},${row[5]}"/></option>
                                </c:forEach>
                            </select>
                            <input type="submit" value="submit" />
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>

    </body>
</html>
