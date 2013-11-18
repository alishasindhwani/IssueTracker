package cs4111;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.jdbc.pool.OracleDataSource;

/**
 * Servlet implementation class AddJspServlet
 */

public class OpenIssueServlet extends HttpServlet {
	private static final long serialVersionUID = 1L; 
	private static final String connect_string = 
			"jdbc:oracle:thin:as4312/nyquil@//w4111b.cs.columbia.edu:1521/ADB"; 
	private Connection conn; 
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OpenIssueServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw = new PrintWriter(response.getOutputStream()); 

		try { 
			if (conn == null) { 
				// Create a OracleDataSource instance and set URL 
				OracleDataSource ods = new OracleDataSource(); 
				ods.setURL(connect_string); 
				conn = ods.getConnection(); 
			} 
			Statement stmt = conn.createStatement();
			
			response.setContentType("text/html"); 
			String developer = request.getParameter("developer");
			String project = request.getParameter("project");
			String description = request.getParameter("description");
			String criticality = request.getParameter("criticality");
			DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
			Calendar cal = Calendar.getInstance();
			String date = dateFormat.format(cal.getTime());
			
			
			int maxID = 1;
			ResultSet rsetID = stmt.executeQuery("select MAX(I.iid) as maxid from Issue I");
			if(rsetID!=null && rsetID.next())
				maxID = rsetID.getInt("maxid") + 1;
			String t = "insert into issue (iid, did, pid, tid, description, opendate, criticality) values ( " + maxID + " , " + developer + " , " + project + " , 2863300, '" + description + "' , '" +  date + "', " + criticality + ")";
			ResultSet rset = stmt.executeQuery(t);
			response.sendRedirect("home.jsp");
		} catch (SQLException e) { 
			pw.println(e.getMessage()); 
		} 

		pw.close(); 
	} 


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
