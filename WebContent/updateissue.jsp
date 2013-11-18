<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="java.util.ArrayList"%>
<%
	Object sid = session.getAttribute("sid");
	Object stype = session.getAttribute("stype");
	// There is a session currently in process, redirect to home.jsp
	if (sid == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	if (stype == null || !(stype.equals("tester"))) {
		response.sendRedirect("home.jsp");
		return;
	}
	Connection conn = null;
	ResultSet rsetDeveloper = null;
	int maxID = 1;
	String error_msg = "";
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmtDeveloper = conn.createStatement();
		Statement stmtID = conn.createStatement();
		Statement updateStatement = conn.createStatement();
		rsetDeveloper = stmtDeveloper
				.executeQuery("select D.did, D.userName from Developer D");
		String id = request.getParameter("id");
		if (id != null) {
			ResultSet rsetID = stmtID.executeQuery("Select I.iid as userid from Issue I where I.iid =" + id);
			if (rsetID != null && rsetID.next()) {

				String developer = request.getParameter("developer");
				String description = request.getParameter("description");
				String criticality = request.getParameter("criticality");
				String t = "update issue set did=" + developer
						+ ", description='" + description
						+ "', criticality=" + criticality + " where iid ="
						+ id;
				updateStatement.executeQuery(t);
				if (conn != null) {
					conn.close();
				} 
				response.sendRedirect("home.jsp");
				return;
			} else {
				out.println("That is not a valid ID. Try a different ID.");

			}
		}
	} catch (SQLException e) {
		error_msg = e.getMessage();
		if (conn != null) {
			conn.close();
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Issue</title>
</head>
<body>
	<p>
		Click <a href="home.jsp">here</a> to go home.
	</p>
	<h3>Edit Issue:</h3>
	<form name="updateissue" action="updateissue.jsp" method="post">
		<p>
			ID: <input type="id" name="id" size="25" maxlength="50" required>
		</p>
		<%
			if (rsetDeveloper != null) {
				out.print("<p>New Assigned Developer <select name=\"developer\">");
				while (rsetDeveloper.next()) {
					out.print("<option value=\"" + rsetDeveloper.getInt("did")
							+ "\">" + rsetDeveloper.getString("userName")
							+ "</option>");
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
			New Description: <input type="text" name="description" size="25"
				maxlength="50" required>
		</p>
		<p>
			New Criticality: <select name="criticality">
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
			</select>
		</p>
		<input type="submit" value="Update Issue">
	</form>
</body>
</html>