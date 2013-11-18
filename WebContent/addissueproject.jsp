<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">

<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>

<!-- Database lookup -->
<%
	Object sid = session.getAttribute("sid");
	Object type = session.getAttribute("stype");
	if (sid == null || type ==null) {
		response.sendRedirect("home.jsp");
		return;
	}
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
		Click <a href="home.jsp">here</a> to go home.
	</p>
	<%
		if (type != null && type.equals("tester")) {
			out.println("<h3> Open an Issue:</h3>");
			out.println("<form name=\"addissue\" action=\"OpenIssueServlet\" method=\"post\">");
			if (rset != null) {
				out.print("<p>Project <select name=\"project\">");
				while (rset.next()) {
					int pid = rset.getInt("pid");
					out.print("<option value=\"" + pid + "\">" + pid
							+ " : " + rset.getString("name") + "</option>");
				}
				out.print("</select> </p>");
			} else {
				out.print(error_msg);
			}

			if (rsetDeveloper != null) {
				out.print("<p>Assigned Developer <select name=\"developer\">");
				while (rsetDeveloper.next()) {
					out.print("<option value=\""
							+ rsetDeveloper.getInt("did") + "\">"
							+ rsetDeveloper.getString("userName")
							+ "</option>");
				}
				out.print("</select></p>");
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
			out.println("<p>");
			out.println("Criticality: <select name=\"criticality\">");
			out.println("<option value=\"1\">1</option>");
			out.println("<option value=\"2\">2</option>");
			out.println("<option value=\"3\">3</option>");
			out.println("</select>");
			out.println("</p>");
			out.println("<input type=\"submit\" value=\"Open Issue\">");
			out.println("</form>");
		} else if (type != null && type.equals("developer")) {
			out.println("<h3>Create a Project:</h3>");
			out.println("<form name=\"addproject\" action=\"AddProjectServlet\" method=\"post\">");
			out.println("<p>");
			out.println("Project Name: <input type=\"text\" name=\"projectname\" size=\"25\"");
			out.println("maxlength=\"50\" required>");
			out.println("</p>");
			out.println("<input type=\"submit\" value=\"Create Project\">");
			out.println("</form>");
		}
	%>

</body>
</html>
