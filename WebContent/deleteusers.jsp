<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
			Statement stmtLogin = conn.createStatement();
			if (type != null && type.equals("developer"))
				rsetLogin = stmtLogin.executeQuery("Select D.did as userid, D.username from Developer D where D.did =" + id);
			else if(type !=null && type.equals("tester"))
			{
				rsetLogin = stmtLogin.executeQuery("Select T.tid as userid, T.username from Tester T where T.tid  =" + id);
			}
			if(rsetLogin !=null && rsetLogin.next()) {
				
				if (type != null && type.equals("developer"))
				{
					ResultSet rset = stmt.executeQuery("delete from developer where did =" + id);
				}
				else if(type !=null && type.equals("tester"))
				{
					ResultSet rset = stmt.executeQuery("delete from tester where tid =" + id);
				}	
				if (conn != null) {
					conn.close();
				} 
				response.sendRedirect("home.jsp");
				
			}
			else {
				out.println("That is not a valid ID. Try a different ID.");
				
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
		Click <a href="projects.jsp">here</a> to view all Projects.
	</p>
	<p>
		Click <a href="users.jsp">here</a> to view all Users.
	</p>
	<p>
		Click <a href="home.jsp">here</a> to view all issues.
	</p>
	<h3> Delete User: </h3>
	<form name="addproject" action="deleteusers.jsp" method="post">
		<p>
			ID: <input type="id" name="id" size="25"
				maxlength="50" required>
		</p>
		<p>
			Type: <select name="type">
				<option value="developer">Developer</option>
				<option value="tester">Tester</option>
			</select>
		</p>
		<input type="submit" value="Delete User">
	</form>
</body>
</html>