<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
	//currentPage �� ����
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//rowPerPage ��� �� �� �� ����
	int rowPerPage = 10;
	
	//��񿬰�
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// totalRow ��ü �� �� ���� �� ������ �ۼ�
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	
	//beginRow, endRow �� ���� ������ ����
	int beginRow = (currentPage - 1) * rowPerPage +1;
	int endRow = beginRow +(rowPerPage) -1;
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	//rank �Լ� ������ �ۼ�
	PreparedStatement rankStmt = null;
	ResultSet rankRs = null;
	String rankSql = "select ��ȣ, ���̵�, �������̸�, �޿�, �޿����� from (select rownum ��ȣ, ���̵�, �������̸�, �޿�, �޿����� from (select employee_id ���̵�, last_name �������̸�, salary �޿�,  rank() over(order by salary desc) �޿����� from employees)) where ��ȣ between ? and ?";
	rankStmt = conn.prepareStatement(rankSql);
	rankStmt.setInt(1, beginRow);
	rankStmt.setInt(2, endRow);
	rankRs = rankStmt.executeQuery();
	
	System.out.println(rankStmt + "<--rankStmt");
	
	//list �����
	ArrayList<HashMap<String, Object>> rankList = new ArrayList<>();
	while(rankRs.next()){
		HashMap<String, Object> r = new HashMap<>();
		r.put("��ȣ", rankRs.getInt("��ȣ"));
		r.put("���̵�", rankRs.getInt("���̵�"));
		r.put("�������̸�", rankRs.getString("�������̸�"));
		r.put("�޿�", rankRs.getInt("�޿�"));
		r.put("�޿�����", rankRs.getInt("�޿�����"));
		rankList.add(r);
	}
	
	//����¡ ����
	//��� ���ڸ� ��Ÿ�������� ���� pagePerPage
	int pagePerPage = 5;
	
	// ������������ ���ϱ�
	int lastPage = totalRow / rowPerPage;
	// �������������� �����Ͱ� �������� ��
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage +1; 
	}
	
	//min,maxpage �� ���ϱ�
	int minPage = (currentPage - 1) / pagePerPage * pagePerPage +1;
	int maxPage = minPage + (pagePerPage - 1);
	if(maxPage > lastPage){
		maxPage = lastPage;
	}
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
			<td>���̵�</td>
			<td>�������̸�</td>
			<td>�޿�</td>
			<td>�޿�����</td>
		</tr>
		<%
			for(HashMap<String, Object> r : rankList){
		%>
				<tr>
					<td><%=(Integer)r.get("��ȣ") %></td>
					<td><%=(Integer)r.get("���̵�") %></td>
					<td><%=(String)r.get("�������̸�") %></td>
					<td><%=(Integer)r.get("�޿�") %></td>
					<td><%=(Integer)r.get("�޿�����") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<%
		if(minPage > 1){
	%>
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage - pagePerPage%>">����</a>
	<%		
		}
			for(int i=minPage; i<=maxPage; i=i+1){
				if(i == currentPage){
	%>
				<span><%=i %></span>
	<%			
			}else{
	%>
				<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%			
			}
		}	
		if(maxPage != lastPage){
	%>
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage + pagePerPage%>">����</a>
	<%		
		}
	%>
</body>
</html>