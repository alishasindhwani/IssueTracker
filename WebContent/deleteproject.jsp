<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%
	Connection conn = null;
	ResultSet rset = null;
	ResultSet rsetDelete = null;
	String error_msg = "";
	String id = null;
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		String type = request.getParameter("id");
		Statement stmtDelete = conn.createStatement();
		rset = stmt.executeQuery("select P.pid, P.name from Project P");
		String project = request.getParameter("project");
		if (project != null) {
			rsetDelete = stmtDelete.executeQuery("delete from project where pid=" + project);
			if (conn != null) {
				conn.close();
			} 
			response.sendRedirect("home.jsp");
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
<title>Open Issue</title>
</head>
<body>
	<p>
		Click <a href="home.jsp">here</a> to go home.
	</p>
	<h3>Delete a project:</h3>
	<form name="deleteproject" action="deleteproject.jsp" method="post">
		<%
			if (rset != null) {
				out.print("<p>Project <select name=\"project\">");
				while (rset.next()) {
					int pid = rset.getInt("pid");
					out.print("<option value=\"" + pid + "\">" + pid + " : "
							+ rset.getString("name") + "</option>");
				}
				out.print("</select> </p>");
			} else {
				out.print(error_msg);
			}
			if (conn != null) {
				conn.close();
			}
		%>
		<input type="submit" value="Apply fix">
	</form>
</body>
</html>