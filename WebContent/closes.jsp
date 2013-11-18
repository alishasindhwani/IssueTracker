<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%
   
   Object sid = session.getAttribute("sid");
   Object stype = session.getAttribute("stype");
	// There is a session currently in process, redirect to home.jsp
	if (sid == null) {
		response.sendRedirect("login.jsp");
		return;
	}
   if(stype == null || !(stype.equals("tester")))
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

		
		rset = stmt.executeQuery("select I.iid, I.description from Issue I where I.iid NOT IN (Select iid from closes)");
		String iid = request.getParameter("issue");
		
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Calendar cal = Calendar.getInstance();
		String date = dateFormat.format(cal.getTime());
		
		if(iid !=null)
		{
			String t = "insert into closes (tid, iid, closedate) values (" + sid + "," + iid + "," + "'" + date + "')";
			ResultSet rsetFix = stmtFix.executeQuery(t);
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
	<h3>Close an Issue:</h3>
	<form name="closes" action="closes.jsp" method="post">
	<%
			if (rset != null) {
				out.print("<p>Issue <select name=\"issue\">");
				while (rset.next()) {
					int iid = rset.getInt("iid");
					out.print("<option value=\"" + iid + "\">" + "issue #" + rset.getString("iid") + " : "
							+ rset.getString("description") + "</option>");
				}
				out.print("</select> </p>");
			} else {
				out.print(error_msg);
			}
			if (conn != null) {
				conn.close();
			}
		%>
		<input type="submit" value="Close Issue">
	</form>
</body>
</html>