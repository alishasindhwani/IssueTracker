<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>


<%
   
   Object sid = session.getAttribute("sid");
   Object stype = session.getAttribute("stype");
	// There is a session currently in process, redirect to home.jsp
	if (sid == null) {
		response.sendRedirect("login.jsp");
		return;
	}
   if(stype == null || !(stype.equals("developer")))
   {
	  response.sendRedirect("home.jsp");
		return; 
   }
   Connection conn = null;
	ResultSet rset = null;
	int maxID = 1;
	String error_msg = "";
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		Statement stmtFix = conn.createStatement();
		Statement stmtMaxFix = conn.createStatement();
		
		int maxFID = 1;
		ResultSet rsetID = stmtMaxFix.executeQuery("select MAX(F.fid) as maxfid from Fix F");
		if(rsetID!=null && rsetID.next())
			maxFID = rsetID.getInt("maxfid") + 1;
		
		rset = stmt.executeQuery("select I.iid, I.description from Issue I where I.did=" + sid);
		String iid = request.getParameter("issue");
		String description = request.getParameter("description");
		if(iid !=null)
		{
			ResultSet rsetFix = stmtFix.executeQuery("insert into fix (fid, iid, did, description) values ( " + maxFID + "," + iid + "," +  sid + "," + "'" + description + "')");
			if (conn != null) {
				conn.close();
			} 
			response.sendRedirect("home.jsp");
				return; 
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
<title>Insert title here</title>
</head>
<body>
<body>
	<p>
		Click <a href="home.jsp">here</a> to go home.
	</p>
	<h3>Apply a fix:</h3>
	<form name="applyfix" action="applyfix.jsp" method="post">
	<%
			if (rset != null) {
				out.print("<p>Issue <select name=\"issue\">");
				while (rset.next()) {
					int iid = rset.getInt("iid");
					out.print("<option value=\"" + iid + "\">" + iid + " : "
							+ rset.getString("description") + "</option>");
				}
				out.print("</select> </p>");
			} else {
				out.print(error_msg);
			}
			if (conn != null) {
				conn.close();
			}
			out.println("<p>");
			out.println("Description: <input type=\"text\" name=\"description\" size=\"50\"");
			out.println("maxlength=\"100\" required>");
			out.println("</p>");
		%>
		<input type="submit" value="Apply Fix">
	</form>
</body>
</html>