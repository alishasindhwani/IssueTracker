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
	ResultSet rsetLogin = null;
	String value = request.getParameter("order");
	String error_msg = "";
	Object sid = session.getAttribute("sid");
	String id = null;
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		rset = stmt
				.executeQuery("select I.iid, D.userName, P.name, I.description, I.openDate, I.criticality from Issue I, Project P, Developer D where I.did = D.did and I.pid = P.pid"
						+ " order by " + value);
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
<title>Issues</title>
</head>

<body>
	<%
		if (session.getAttribute("sname") != null) {
			out.println("<p>Logged in as " + session.getAttribute("stype")
					+ " " + session.getAttribute("sname"));
			out.println("<p>Click <a href=\"logout.jsp\">here</a> to logout.</p>");
		}
		else{
			out.println("<p>Click <a href=\"login.jsp\">here</a> to login.</p>");
		}
	%>
	<p>
		Click <a href="projects.jsp">here</a> to view all Projects.
	</p>
	<p>
		Click <a href="users.jsp">here</a> to view all Users.
	</p>
	<p>
		Click <a href="addissueproject.jsp">here</a> to create a new Project
		or Issue.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to add a new User.
	</p>
	<H2>Issues</H2>
	<TABLE>
		<tr>
			<td>Order by:</td>
			<td>
				<form action="home.jsp" method="post">
					<%
						if (value != null && value.equals("userName")) {
							out.print("<input type=\"radio\" name=\"order\" value=\"iid\">Id");
							out.print("<input type=\"radio\" name=\"order\" value=\"userName\" checked>Developer");
							out.print("<input type=\"radio\" name=\"order\" value=\"name\">Project");
						} else if (value != null && value.equals("name")) {
							out.print("<input type=\"radio\" name=\"order\" value=\"iid\">Id");
							out.print("<input type=\"radio\" name=\"order\" value=\"userName\">Developer");
							out.print("<input type=\"radio\" name=\"order\" value=\"name\" checked>Project");
						} else {
							out.print("<input type=\"radio\" name=\"order\" value=\"iid\" checked>Id");
							out.print("<input type=\"radio\" name=\"order\" value=\"userName\">Developer");
							out.print("<input type=\"radio\" name=\"order\" value=\"name\">Project");
						}
					%>
					<input type="submit" VALUE="submit">
				</form>
			</td>
		</tr>
	</TABLE>
	<TABLE>
		<tr>
			<td>Id</td>
			<td>Developer</td>
			<td>Project</td>
			<td>Description</td>
			<td>Open Date</td>
			<td>Criticality</td>
		</tr>
		<tr>
			<td><b>----------</b></td>
			<td><b>---------------</b></td>
			<td><b>---------------</b></td>
			<td><b>--------------------------------------------</b></td>
			<td><b>-----------------</b></td>
			<td><b>----------</b></td>
		</tr>
		<%
			if (rset != null) {
				while (rset.next()) {
					out.print("<tr>");
					out.print("<td>" + rset.getInt("iid") + "</td><td>"
							+ rset.getString("userName") + "</td><td>"
							+ rset.getString("name") + "</td><td>"
							+ rset.getString("description") + "</td><td>"
							+ rset.getString("openDate") + "</td><td>"
							+ rset.getString("criticality") + "</td>");
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