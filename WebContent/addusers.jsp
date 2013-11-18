<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%
	if (request.getParameter("id") != null) {
		Connection conn = null;
		ResultSet rsetLogin = null;
		String error_msg = "";
		String id = null;
		try {
			OracleDataSource ods = new OracleDataSource();

			ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			id = request.getParameter("id");
			String type = request.getParameter("type");
			String username = request.getParameter("username");
			Statement stmtLogin = conn.createStatement();
			if (type != null && type.equals("developer"))
				rsetLogin = stmtLogin.executeQuery("Select D.did as userid, D.username from Developer D where D.did =" + id);
			else if(type !=null && type.equals("tester"))
			{
				rsetLogin = stmtLogin.executeQuery("Select T.tid as userid, T.username from Tester T where T.tid  =" + id);
			}
			if(rsetLogin !=null && rsetLogin.next()) {
				out.println("A User already has that id. Please try again");
			}
			else {
				if (type != null && type.equals("developer"))
				{
					ResultSet rset = stmt.executeQuery("insert into developer (did, username) values (" + id + " , '" + username + "')");
				}
				else if(type !=null && type.equals("tester"))
				{
					ResultSet rset = stmt.executeQuery("insert into tester (tid, username) values (" + id + " , '" + username + "')");
				}	
				response.sendRedirect("home.jsp");
			}
		} catch (SQLException e) {
			error_msg = e.getMessage();
			if (conn != null) {
				conn.close();
			}
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
	<h3> Add a New User: </h3>
	<form name="addproject" action="addusers.jsp" method="post">
		<p>
			ID: <input type="id" name="id" size="25"
				maxlength="50" required>
		</p>
		<p>
			Username: <input type="text" name="username" size="25"
				maxlength="50" required>
		</p>
		<p>
			Type: <select name="type">
				<option value="developer">Developer</option>
				<option value="tester">Tester</option>
			</select>
		</p>
		<input type="submit" value="Add User">
	</form>
</body>
</html>