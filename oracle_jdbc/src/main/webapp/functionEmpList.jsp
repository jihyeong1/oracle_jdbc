<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
	/*
		SELECT last_name, substr(last_name, 1, 3) , 
		salary, round(salary/12, 2),
		hire_date, EXTRACT(year from hire_date) 
		from employees;
		����¡
	*/
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
		
	
	//��� ����
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	int totalRow = 0;
	String totalRowSql="select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	
	int rowPerPage = 10;
	int beginRow = (currentPage-1)*rowPerPage+1;
	int endRow = beginRow + (rowPerPage - 1);	
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	PreparedStatement stmt = null;
	ResultSet rs= null;
	String sql="select ��ȣ, �̸�, �̸�ù����, ����, �޿�, �Ի糯¥, �Ի�⵵ from (SELECT rownum ��ȣ, last_name �̸�, substr(last_name, 1, 1) �̸�ù����, salary ����, round(salary/12, 2) �޿�, hire_date �Ի糯¥, EXTRACT(year from hire_date) �Ի�⵵ from employees) where ��ȣ BETWEEN ? and ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,beginRow);
	stmt.setInt(2,endRow);
	rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("��ȣ", rs.getInt("��ȣ"));
		m.put("�̸�", rs.getString("�̸�"));
		m.put("�̸�ù����", rs.getString("�̸�ù����"));
		m.put("����", rs.getInt("����"));
		m.put("�޿�", rs.getDouble("�޿�"));
		m.put("�Ի糯¥", rs.getString("�Ի糯¥"));
		m.put("�Ի�⵵", rs.getInt("�Ի�⵵"));
		list.add(m);
	}
	System.out.println(list.size()+"<-- list.size");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<table border="1">
		<tr>
			<td>��ȣ</td>
			<td>�̸�</td>
			<td>�̸�ù����</td>
			<td>����</td>
			<td>�޿�</td>
			<td>�Ի糯¥</td>
			<td>�Ի�⵵</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=(Integer)m.get("��ȣ") %></td>
					<td><%=(String)m.get("�̸�") %></td>
					<td><%=(String)m.get("�̸�ù����") %></td>
					<td><%=(Integer)m.get("����") %></td>
					<td><%=(Double)m.get("�޿�") %></td>
					<td><%=(String)m.get("�Ի糯¥") %></td>
					<td><%=(Integer)m.get("�Ի�⵵") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<%
		//������ �׺���̼� ����¡
		int pagePerPage = 10;
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0){
			lastPage = lastPage +1;
		}
		int minPage = ((currentPage-1)/pagePerPage * pagePerPage)+1;
		int maxPage = minPage + (pagePerPage - 1);
		if(maxPage > lastPage){
			maxPage = lastPage;
		}
		if(minPage > 1){
	%>
			<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">����</a>
	<%		
		}
	%>	
	<%	
		for(int i=minPage; i<=maxPage; i=i+1){
			if(i == currentPage){
	%>
				<span><%=i %></span>&nbsp;
	<%				
			}else{
	%>
				<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;
	<%			
			}		
		}
		if(maxPage != lastPage){
	%>
			<a href="<%=request.getContextPath()%>/functionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">����</a>
	<%	
		}
	%>
</body>
</html>