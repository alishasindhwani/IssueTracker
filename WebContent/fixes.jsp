<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">

<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>

<!-- Database lookup -->
<%
	Connection conn = null;
	ResultSet rset = null;
	ResultSet setDeveloper = null;
	String value = request.getParameter("order");
	String error_msg = "";
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		Statement stmtDeveloper = conn.createStatement();
		rset = stmt
				.executeQuery("select F.fid, F.description, F.iid, D.username from Fix F, Developer D where F.did = D.did");
	} catch (SQLException e) {
		error_msg = e.getMessage();
		if (conn != null) {
			conn.close();
		}
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Projects</title>
</head>

<body>
	<p>
		Click <a href="home.jsp">here</a> to go home.
	</p>
	<H2>Fixes</H2>
	<TABLE>
		<tr>
			<td>Fix ID</td>
			<td>Description</td>
			<td>Issue ID</td>
			<td>Developer</td>
		</tr>
		<tr>
			<td><b>----------</b></td>
			<td><b>------------------------------------------</b></td>
			<td><b>----------</b></td>
			<td><b>----------</b></td>
		</tr>
		<%
			if (rset != null) {
				while (rset.next()) {
					out.print("<tr>");
					out.print("<td>" + rset.getInt("fid") + "</td>");
					out.print("<td>" + rset.getString("description") + "</td>");
					out.print("<td>" + rset.getInt("iid") + "</td>");
					out.print("<td>" + rset.getString("username") + "</td>");
					out.print("</tr>");
				}
			} else {
				out.print(error_msg);
			}
			if (conn != null) {
				conn.close();
			}
		%>
	</TABLE>
</body>
</html>