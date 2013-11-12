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
	ResultSet rsetTester = null;
	ResultSet rsetDeveloper = null;
	String value = request.getParameter("order");
	String error_msg = "";
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmtTester = conn.createStatement();
		Statement stmtDeveloper = conn.createStatement();
		rsetDeveloper = stmtDeveloper
				.executeQuery("Select D.did, D.userName from Developer D");
		rsetTester = stmtTester.executeQuery("Select T.tid, T.userName from Tester T");
		
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
<title>Users</title>
</head>

<body>
	<p>
		Click <a href="projects.jsp">here</a> to view all Projects.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to view all Issues.
	</p>
	<p>
		Click <a href="addissueproject.jsp">here</a> to create a new Project or Issue.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to add a new User.
	</p>
	<H2>Users</H2>
	<TABLE>
		<tr>
			<td>Developers</td>
			<td>Testers</td>
		</tr>
		<tr>
			<td><b>----------</b></td>
			<td><b>----------</b></td>

		</tr>
		<%
			if (rsetDeveloper != null) {
				while (rsetDeveloper.next()) {
					out.print("<tr>");
					out.print("<td>" + rsetDeveloper.getString("userName") + "</td>");
					if(rsetTester !=null && rsetTester.next())
						out.print("<td>" + rsetTester.getString("userName") + "</td>");
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