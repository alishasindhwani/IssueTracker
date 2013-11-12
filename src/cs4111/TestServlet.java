
package cs4111; 

import java.io.IOException; 
import java.io.PrintWriter; 
import java.sql.*; 

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet; 
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse; 

import oracle.jdbc.pool.OracleDataSource; 

/** 
 * Servlet implementation class OracleServlet 
 */ 
public class TestServlet extends HttpServlet { 
	private static final long serialVersionUID = 1L; 
	private static final String connect_string = 
			"jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB"; 
	private Connection conn; 
	/** 
	 * @see HttpServlet#HttpServlet() 
	 */ 
	public TestServlet() { 
		super(); 
		// TODO Auto-generated constructor stub 
	} 

	/** 
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse 
response) 
	 */ 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException { 
		PrintWriter pw = new PrintWriter(response.getOutputStream()); 

		try { 
			if (conn == null) { 
				// Create a OracleDataSource instance and set URL 
				OracleDataSource ods = new OracleDataSource(); 
				ods.setURL(connect_string); 
				conn = ods.getConnection(); 
			} 
			Statement stmt = conn.createStatement();
			String value = request.getParameter("order");
			ResultSet rset = stmt.executeQuery("select I.iid, D.userName, P.name, I.description, I.openDate, I.criticality from Issue I, Project P, Developer D where I.did = D.did and I.pid = P.pid" + " order by " + value);
			
			response.setContentType("text/html");
			pw.println("<html>"); 
			pw.println("<head><title>Issues</title></head>"); 
			pw.println("<H1>Issue Table<BR></H1>"); 
			pw.println("<body>"); 
			pw.println("<table>");
			pw.println("<tr>");
			if(value != null && value.equals("name"))
				pw.println("Order By: <form METHOD=\"POST\" ACTION=\"TestServlet\"><input type=\"radio\" name=\"order\" value=\"iid\">Id <input type=\"radio\" name=\"order\" value=\"userName\">Developer <input type=\"radio\" name=\"order\" value=\"name\" checked>Project <INPUT TYPE=\"submit\" VALUE=\"submit\"></form>");
			else if(value != null && value.equals("userName"))
				pw.println("Order By: <form METHOD=\"POST\" ACTION=\"TestServlet\"><input type=\"radio\" name=\"order\" value=\"iid\">Id <input type=\"radio\" name=\"order\" value=\"userName\" checked>Developer <input type=\"radio\" name=\"order\" value=\"name\">Project <INPUT TYPE=\"submit\" VALUE=\"submit\"></form>");
			else
				pw.println("Order By: <form METHOD=\"POST\" ACTION=\"TestServlet\"><input type=\"radio\" name=\"order\" value=\"iid\" checked>Id <input type=\"radio\" name=\"order\" value=\"userName\">Developer <input type=\"radio\" name=\"order\" value=\"name\">Project <INPUT TYPE=\"submit\" VALUE=\"submit\"></form>");
			pw.println("</tr>"); 
			pw.println("<tr>"); 
			pw.println("<td>Id</td>"); 
			pw.println("<td>Developer</td>"); 
			pw.println("<td>Project</td>"); 
			pw.println("<td>Description</td>"); 
			pw.println("<td>OpenDate</td>"); 
			pw.println("<td>Criticality</td>"); 
			pw.println("</tr>"); 
			pw.println("<tr>"); 
			pw.println("<td><b>----------</b></td>"); 
			pw.println("<td><b>---------------</b></td>"); 
			pw.println("<td><b>---------------</b></td>"); 
			pw.println("<td><b>--------------------------------------------</b></td>"); 
			pw.println("<td><b>-----------------</b></td>"); 
			pw.println("<td><b>----------</b></td>"); 
			pw.println("</tr>"); 
			
			while (rset.next()) { 
				 pw.print("<tr>");
                 pw.print("<td>" + rset.getInt("iid") + "</td><td>"
                                 + rset.getString("userName") + "</td><td>"
                                 + rset.getString("name") + "</td><td>"
                                 + rset.getString("description") + "</td><td>"
                                 + rset.getString("openDate") + "</td><td>"
                                 + rset.getString("criticality") + "</td>");
                 pw.print("</tr>");
			} 
			pw.println("</table></body></html>"); 
		} catch (SQLException e) { 
			pw.println(e.getMessage()); 
		} 

		pw.close(); 
	} 

	/** 
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse 
response) 
	 */ 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException { 
			doGet(request,response);
	} 

}