<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
	//currentPage 값 선언
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//rowPerPage 출력 될 행 값 선언
	int rowPerPage = 10;
	
	//디비연결
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// totalRow 전체 행 값 선언 및 쿼리문 작성
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	
	//beginRow, endRow 값 선언 시작행 끝행
	int beginRow = (currentPage - 1) * rowPerPage +1;
	int endRow = beginRow +(rowPerPage) -1;
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	//rank 함수 쿼리문 작성
	PreparedStatement rankStmt = null;
	ResultSet rankRs = null;
	String rankSql = "select 번호, 아이디, 마지막이름, 급여, 급여순위 from (select rownum 번호, 아이디, 마지막이름, 급여, 급여순위 from (select employee_id 아이디, last_name 마지막이름, salary 급여,  rank() over(order by salary desc) 급여순위 from employees)) where 번호 between ? and ?";
	rankStmt = conn.prepareStatement(rankSql);
	rankStmt.setInt(1, beginRow);
	rankStmt.setInt(2, endRow);
	rankRs = rankStmt.executeQuery();
	
	System.out.println(rankStmt + "<--rankStmt");
	
	//list 만들기
	ArrayList<HashMap<String, Object>> rankList = new ArrayList<>();
	while(rankRs.next()){
		HashMap<String, Object> r = new HashMap<>();
		r.put("번호", rankRs.getInt("번호"));
		r.put("아이디", rankRs.getInt("아이디"));
		r.put("마지막이름", rankRs.getString("마지막이름"));
		r.put("급여", rankRs.getInt("급여"));
		r.put("급여순위", rankRs.getInt("급여순위"));
		rankList.add(r);
	}
	
	//페이징 설정
	//몇개의 숫자를 나타낼것인지 설정 pagePerPage
	int pagePerPage = 5;
	
	// 마지막페이지 구하기
	int lastPage = totalRow / rowPerPage;
	// 마지막페이지에 데이터가 남아있을 때
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage +1; 
	}
	
	//min,maxpage 값 구하기
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
			<td>번호</td>
			<td>아이디</td>
			<td>마지막이름</td>
			<td>급여</td>
			<td>급여순위</td>
		</tr>
		<%
			for(HashMap<String, Object> r : rankList){
		%>
				<tr>
					<td><%=(Integer)r.get("번호") %></td>
					<td><%=(Integer)r.get("아이디") %></td>
					<td><%=(String)r.get("마지막이름") %></td>
					<td><%=(Integer)r.get("급여") %></td>
					<td><%=(Integer)r.get("급여순위") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<%
		if(minPage > 1){
	%>
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage - pagePerPage%>">이전</a>
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
			<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage + pagePerPage%>">다음</a>
	<%		
		}
	%>
</body>
</html>