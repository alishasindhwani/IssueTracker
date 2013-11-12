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
	ResultSet rsetDeveloper = null;
	ResultSet rsetMaxID = null;
	int maxID = 1;
	String error_msg = "";
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		Statement stmtDeveloper = conn.createStatement();
		rset = stmt.executeQuery("select P.pid, P.name from Project P");
		rsetDeveloper = stmtDeveloper
				.executeQuery("select D.did, D.userName from Developer D");
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
<title>Open Issue</title>
</head>
<body>
	<p>
		Click <a href="projects.jsp">here</a> to view all Projects.
	</p>
	<p>
		Click <a href="users.jsp">here</a> to view all Users.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to view all Issues.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to add a new User.
	</p>
<h3> Open an Issue:</h3>
	<form name="addissue" action="AddIssueServlet" method="post">
		<%
			if (rset != null) {
					out.print("<p>Project <select name=\"project\">");
					while (rset.next()) {
						int pid = rset.getInt("pid");
						out.print("<option value=\"" + pid + "\">"
								+ pid + " : " + rset.getString("name") + "</option>");
					}
					out.print("</select> </p>");
				} else {
					out.print(error_msg);
				}
				
				if (rsetDeveloper != null) {
					out.print("<p>Assigned Developer <select name=\"developer\">");
					while (rsetDeveloper.next()) {
						out.print("<option value=\"" + rsetDeveloper.getInt("did") + "\">"
								+ rsetDeveloper.getString("userName") + "</option>");
					}
					out.print("</select></p>");
				} else {
					out.print(error_msg);
			}
				
			if (conn != null) {
				conn.close();
			}
		%>
		<p>
			Description: <input type="text" name="description" size="50"
				maxlength="100" required>
		</p>
		<p>
			Criticality: <select name="criticality">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
			</select>
		</p>
		<input type="submit" value="Open Issue">
	</form>
<h3> Create a Project:</h3>
	<form name="addproject" action="AddProjectServlet" method="post">
		<p>
			Project Name: <input type="text" name="projectname" size="25" maxlength="50" required>
		</p>
		<input type="submit" value="Create Project">
	</form>
</body>
</html>
