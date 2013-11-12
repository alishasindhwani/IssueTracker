<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%
	session.setAttribute("sname", null);
	session.setAttribute("stype", null);
	session.setAttribute("sid", null);
	response.sendRedirect("home.jsp");
%>