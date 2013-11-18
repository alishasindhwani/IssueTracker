<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">

<!-- This import is necessary for JDBC -->
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="java.util.ArrayList"%>

<!-- Database lookup -->
<%
	Connection conn = null;
	ResultSet rset = null;
	ArrayList<Integer> closesList = null;
	String value = request.getParameter("order");
	String error_msg = "";
	Object sid = session.getAttribute("sid");
	String id = null;
	try {
		OracleDataSource ods = new OracleDataSource();

		ods.setURL("jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		Statement stmtClosed = conn.createStatement();
		closesList = new ArrayList<Integer>();
		ResultSet rsetClosed = stmtClosed.executeQuery("select iid from closes");
		if (rsetClosed != null) {
			while (rsetClosed.next()) {
				closesList.add(rsetClosed.getInt("iid"));
			}
		} else {
			out.print(error_msg);
		}
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
			Object type = session.getAttribute("stype");
			if(type !=null)
			{
				if(type.equals("tester"))
				{
					out.println("<p>Click <a href=\"addissueproject.jsp\">here</a> to create a new issue.</p>");
					out.println("<p>Click <a href=\"verifyfix.jsp\">here</a> to verify a fix.</p>");
					out.println("<p>Click <a href=\"corrects.jsp\">here</a> to correct an issue.</p>");
					out.println("<p>Click <a href=\"closes.jsp\">here</a> to close an issue.</p>");
				}
				else if(type.equals("developer"))
				{
					out.println("<p>Click <a href=\"addissueproject.jsp\">here</a> to create a new project.</p>");
					out.println("<p>Click <a href=\"applyfix.jsp\">here</a> to apply a fix.</p>");
				}
					
			}
		}
		else{
			out.println("<p>Click <a href=\"login.jsp\">here</a> to login.</p>");			
		}
		
	%>
	<p>
		Click <a href="projects.jsp">here</a> to view all projects.
	</p>
	<p>
		Click <a href="users.jsp">here</a> to view all users.
	</p>
	<p>
		Click <a href="addusers.jsp">here</a> to add a new user.
	</p>
	<p>
		Click <a href="deleteusers.jsp">here</a> to delete a user.
	</p>
	<p>
		Click <a href="deleteproject.jsp">here</a> to delete a project.
	</p>
	<p>
		Click <a href="updateissue.jsp">here</a> to update an issue.
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
			<td>Status</td>
		</tr>
		<tr>
			<td><b>----------</b></td>
			<td><b>---------------</b></td>
			<td><b>---------------</b></td>
			<td><b>--------------------------------------------</b></td>
			<td><b>-----------------</b></td>
			<td><b>-------------</b></td>
			<td><b>----------</b></td>
		</tr>
		<%
			if (rset != null) {
				while (rset.next()) {
					out.print("<tr>");
					int iid = rset.getInt("iid");
					out.print("<td>" + iid + "</td><td>"
							+ rset.getString("userName") + "</td><td>"
							+ rset.getString("name") + "</td><td>"
							+ rset.getString("description") + "</td><td>"
							+ rset.getString("openDate") + "</td><td>"
							+ rset.getString("criticality") + "</td>");
					if(closesList.contains(iid))
						out.print("<td> Closed </td>");
					else
						out.print("<td> Open </td>");
						
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