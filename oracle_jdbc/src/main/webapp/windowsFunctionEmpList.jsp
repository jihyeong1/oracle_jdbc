<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
/* �м��Լ��� ���, over �� ���� ���� ������� �ְ� �� �ڿ� ���������������� ������� �پ �����Եȴ�.
-- ���� �� ������� �������ʰ� �״�� ��µǸ� over �� ���� �������� ������� ���� ��µ� �� �ִ�.	*/

		//currentPage �� ����
		int currentPage = 1;
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		//rowPerPage �� ����
		int rowPerPage = 10;
		
		// ��񿬰�
		String driver = "oracle.jdbc.driver.OracleDriver";
		String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
		String dbuser = "hr";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		System.out.println(conn);
		
		//totalRow ������, ������ �ۼ�
		int totalRow = 0;
		String totalRowSql = "select count(*) from employees";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		if(totalRowRs.next()){
			totalRow = totalRowRs.getInt("count(*)");
		}
		
		// beginRow, endRow ����
		// beginRow �� ���������� ��µǴ� ������ endRow�� ��������
		int beginRow = (currentPage - 1)* rowPerPage +1;
		int endRow = beginRow + (rowPerPage - 1);
		if(endRow > totalRow){
			endRow = totalRow;
		}
		
		//�м��Լ�(over) ���� �ۼ�
		PreparedStatement overStmt = null;
		ResultSet overRs = null;
		/*
		select ��ȣ, ���̵�, �������̸�, �޿�, ��ü�޿����, ��ü�޿��հ�, ��ü����� from
			(select rownum ��ȣ, employee_id ���̵�, last_name �������̸�, salary �޿�, 
			    round(avg(salary) over()) ��ü�޿����,
			    sum(salary) over() ��ü�޿��հ�,
			    count(*) over() ��ü�����
			from employees)
		where ��ȣ BETWEEN 1 and 10
		*/
		String overSql = "select ��ȣ, ���̵�, �������̸�, �޿�, ��ü�޿����, ��ü�޿��հ�, ��ü����� from (select rownum ��ȣ, employee_id ���̵�, last_name �������̸�, salary �޿�, round(avg(salary) over()) ��ü�޿����, sum(salary) over() ��ü�޿��հ�, count(*) over() ��ü����� from employees) where ��ȣ BETWEEN ? and ?";
		overStmt = conn.prepareStatement(overSql);
		overStmt.setInt(1, beginRow);
		overStmt.setInt(2, endRow);
		overRs = overStmt.executeQuery();
		
		System.out.println(overStmt + "<--overStmt");
		
		//List �����
		ArrayList<HashMap<String, Object>> overList = new ArrayList<>();
		while(overRs.next()){
			HashMap<String, Object> o = new HashMap<>();
			o.put("��ȣ", overRs.getInt("��ȣ"));
			o.put("���̵�", overRs.getInt("���̵�"));
			o.put("�������̸�", overRs.getString("�������̸�"));
			o.put("�޿�", overRs.getInt("�޿�"));
			o.put("��ü�޿����", overRs.getInt("��ü�޿����"));
			o.put("��ü�޿��հ�", overRs.getInt("��ü�޿��հ�"));
			o.put("��ü�����", overRs.getInt("��ü�����"));
			overList.add(o);
		}
		
		//����¡ ����
		// �ϴܿ� ���� ���� ����� ��Ÿ������ ������ ����
		int pagePerPage = 10;
		// ������������ ����, totalRow �� rowPerPage(���� 10)�� ������ lastPage
		int lastPage = totalRow / rowPerPage; 
		if(totalRow % rowPerPage != 0 ){
			// totalRow �� rowPerPage�� �������� �� 0���� �������� ������ �����Ͱ� �����ִ� ���̱⶧����
			// lastPage�� 1�������� �� �߰��Ѵ�.
			lastPage = lastPage + 1;
		}
		
		//min,maxPage �� ����
		//minpage �� �ϴܿ� ���� ���� ����� ȿ�õǴ� ������ ���� ���� ��
		//maxpage �� �ϴܿ� ���� ���� ����� ǥ�õǴ� ���� �� ���� ū ��
		int minPage = (currentPage - 1) / pagePerPage * pagePerPage +1;
		int maxPage = minPage + (pagePerPage -1);
		// maxpage�� lastPage ���� Ŭ �� lastpage�� maxpage�� ��������.
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
			<td>����ü�޿���տ�</td>
			<td>��ü�޿��հ�</td>
			<td>��ü�����</td>
		</tr>
		<%
			for(HashMap<String, Object> o : overList){
		%>
				<tr>
					<td><%=(Integer)o.get("��ȣ") %></td>
					<td><%=(Integer)o.get("���̵�") %></td>
					<td><%=(String)o.get("�������̸�") %></td>
					<td><%=(Integer)o.get("�޿�") %></td>
					<td><%=(Integer)o.get("��ü�޿����") %></td>
					<td><%=(Integer)o.get("��ü�޿��հ�") %></td>
					<td><%=(Integer)o.get("��ü�����") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<!-- ------------------------- ����¡ ----------------------- -->
	<%
		//�ϴܿ� ���� �̶�� ǥ���Ǵ� �ڵ�
		//minpage �� �ϴܿ� ��Ÿ���� ������ ���� ���� ����
		//maxPage �� �ϴܿ� ��Ÿ���� ������ ���� ū ����
		if(minPage > 1){
	%>
			<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage - pagePerPage%>">����</a>
	<%
		}
			// �ϴܿ� ǥ���Ǵ� ����, 1�� ����
			for(int i=minPage; i<=maxPage; i=i+1){
				if(i == currentPage){
	%>
					<span><%=i %></span>	
	<%				
				}else{
	%>
					<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%				
				}
			}
		// maxpage �� lastpage�� ���� ���� �� ���� ǥ�� ��Ÿ��	
		if(maxPage != lastPage){
	%>
			<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage + pagePerPage%>">����</a>
	<%		
		}
	%>	
			
			
</body>
</html>