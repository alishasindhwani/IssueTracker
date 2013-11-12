<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%
	Object sid = session.getAttribute("sid");
	// There is a session currently in process, redirect to home.jsp
	if (sid != null) {
		response.sendRedirect("home.jsp");
		return;
	}

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
				rsetLogin = stmtLogin.executeQuery("Select T.did as userid, T.username from Tester T where T.tid  =" + id);
			if(rsetLogin !=null && rsetLogin.next()) {
				session.setAttribute("sname", rsetLogin.getString("userName"));
				session.setAttribute("stype", type);
				session.setAttribute("sid", rsetLogin.getInt("userid"));
				response.sendRedirect("home.jsp");
			}
			else {
				session.setAttribute("sname", null);
				session.setAttribute("stype", null);
				session.setAttribute("sid", null);
				out.println("Login failed. Please try a different id");
			}
		} catch (SQLException e) {
			error_msg = e.getMessage();
			if (conn != null) {
				conn.close();
			}
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<title>Login</title>
</head>
<body>
	<form method=post action="login.jsp">
		<p>
			Your userid: <input type="text" name="id" size="20" maxlength="30"
				required>
		</p>
		<p>
			Type: <select name="type">
				<option value="developer">Developer</option>
				<option value="tester">Tester</option>
			</select>
		</p>
		<input type=submit>
	</form>
</body>
</html>