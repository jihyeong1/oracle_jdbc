<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>   
<%@ page import = "java.util.*" %>   
<%
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbUser = "hr";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "select department_id �μ�ID, count(*) �μ��ο�, sum(salary) �޿��հ�,round(avg(salary), 1) �޿����, max(salary) �ִ�޿�, min(salary) �ּұ޿�from employeeswhere department_id is not nullgroup by department_idhaving count(*) order by count(*) desc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("�μ�ID", rs.getInt("�μ�ID"));
		m.put("�μ��ο�", rs.getInt("�μ��ο�"));
		m.put("�޿��հ�", rs.getInt("�޿��հ�"));
		m.put("�޿����", rs.getInt("�޿����"));
		m.put("�ִ�޿�", rs.getInt("�ִ�޿�"));
		m.put("�ּұ޿�", rs.getInt("�ּұ޿�"));
	}
	System.out.println(list);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<h1>Employees table CROUP BY Test</h1>
	<table border="1">
		<tr>
			<td>�μ�ID</td>
			<td>�μ��ο�</td>
			<td>�޿��հ�</td>
			<td>�޿����</td>
			<td>�ִ�޿�</td>
			<td>�ּұ޿�</td>
		</tr>	
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=(Integer)(m.get("�μ�ID"))%></td>
					<td><%=(Integer)(m.get("�μ��ο�"))%></td>
					<td><%=(Integer)(m.get("�޿��հ�"))%></td>
					<td><%=(Integer)(m.get("�޿����"))%></td>
					<td><%=(Integer)(m.get("�ִ�޿�"))%></td>
					<td><%=(Integer)(m.get("�ּұ޿�"))%></td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>