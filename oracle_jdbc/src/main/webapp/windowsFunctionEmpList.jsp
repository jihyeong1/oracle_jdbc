<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%
/* 분석함수를 사용, over 을 쓰면 원래 결과셋은 있고 그 뒤에 서브쿼리형식으로 결과셋이 붙어서 나오게된다.
-- 따라서 원 결과셋은 깨지지않고 그대로 출력되며 over 로 만든 서브쿼리 집계또한 같이 출력될 수 있다.	*/

		//currentPage 값 선언
		int currentPage = 1;
		if(request.getParameter("currentPage") != null){
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}
		//rowPerPage 값 선언
		int rowPerPage = 10;
		
		// 디비연결
		String driver = "oracle.jdbc.driver.OracleDriver";
		String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
		String dbuser = "hr";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		System.out.println(conn);
		
		//totalRow 값선언, 쿼리문 작성
		int totalRow = 0;
		String totalRowSql = "select count(*) from employees";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		if(totalRowRs.next()){
			totalRow = totalRowRs.getInt("count(*)");
		}
		
		// beginRow, endRow 설정
		// beginRow 는 한페이지에 출력되는 시작행 endRow는 마지막행
		int beginRow = (currentPage - 1)* rowPerPage +1;
		int endRow = beginRow + (rowPerPage - 1);
		if(endRow > totalRow){
			endRow = totalRow;
		}
		
		//분석함수(over) 쿼리 작성
		PreparedStatement overStmt = null;
		ResultSet overRs = null;
		/*
		select 번호, 아이디, 마지막이름, 급여, 전체급여평균, 전체급여합계, 전체사원수 from
			(select rownum 번호, employee_id 아이디, last_name 마지막이름, salary 급여, 
			    round(avg(salary) over()) 전체급여평균,
			    sum(salary) over() 전체급여합계,
			    count(*) over() 전체사원수
			from employees)
		where 번호 BETWEEN 1 and 10
		*/
		String overSql = "select 번호, 아이디, 마지막이름, 급여, 전체급여평균, 전체급여합계, 전체사원수 from (select rownum 번호, employee_id 아이디, last_name 마지막이름, salary 급여, round(avg(salary) over()) 전체급여평균, sum(salary) over() 전체급여합계, count(*) over() 전체사원수 from employees) where 번호 BETWEEN ? and ?";
		overStmt = conn.prepareStatement(overSql);
		overStmt.setInt(1, beginRow);
		overStmt.setInt(2, endRow);
		overRs = overStmt.executeQuery();
		
		System.out.println(overStmt + "<--overStmt");
		
		//List 만들기
		ArrayList<HashMap<String, Object>> overList = new ArrayList<>();
		while(overRs.next()){
			HashMap<String, Object> o = new HashMap<>();
			o.put("번호", overRs.getInt("번호"));
			o.put("아이디", overRs.getInt("아이디"));
			o.put("마지막이름", overRs.getString("마지막이름"));
			o.put("급여", overRs.getInt("급여"));
			o.put("전체급여평균", overRs.getInt("전체급여평균"));
			o.put("전체급여합계", overRs.getInt("전체급여합계"));
			o.put("전체사원수", overRs.getInt("전체사원수"));
			overList.add(o);
		}
		
		//페이징 설정
		// 하단에 이전 다음 가운데에 나타내지는 숫자의 갯수
		int pagePerPage = 10;
		// 마지막페이지 선언, totalRow 와 rowPerPage(현재 10)을 나누면 lastPage
		int lastPage = totalRow / rowPerPage; 
		if(totalRow % rowPerPage != 0 ){
			// totalRow 와 rowPerPage를 나누었을 때 0으로 떨어지지 않으면 데이터가 남아있는 것이기때문에
			// lastPage에 1페이지를 더 추가한다.
			lastPage = lastPage + 1;
		}
		
		//min,maxPage 값 설정
		//minpage 는 하단에 이전 다음 가운데에 효시되는 숫자중 가장 작은 것
		//maxpage 는 하단에 이전 다음 가운데에 표시되는 숫자 중 가장 큰 것
		int minPage = (currentPage - 1) / pagePerPage * pagePerPage +1;
		int maxPage = minPage + (pagePerPage -1);
		// maxpage가 lastPage 보다 클 때 lastpage는 maxpage와 같아진다.
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
			<td>급전체급여평균여</td>
			<td>전체급여합계</td>
			<td>전체사원수</td>
		</tr>
		<%
			for(HashMap<String, Object> o : overList){
		%>
				<tr>
					<td><%=(Integer)o.get("번호") %></td>
					<td><%=(Integer)o.get("아이디") %></td>
					<td><%=(String)o.get("마지막이름") %></td>
					<td><%=(Integer)o.get("급여") %></td>
					<td><%=(Integer)o.get("전체급여평균") %></td>
					<td><%=(Integer)o.get("전체급여합계") %></td>
					<td><%=(Integer)o.get("전체사원수") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<!-- ------------------------- 페이징 ----------------------- -->
	<%
		//하단에 이전 이라고 표현되는 코드
		//minpage 는 하단에 나타나는 숫자중 제일 작은 변수
		//maxPage 는 하단에 나타나는 숫자중 제일 큰 변수
		if(minPage > 1){
	%>
			<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage - pagePerPage%>">이전</a>
	<%
		}
			// 하단에 표현되는 숫자, 1씩 증가
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
		// maxpage 가 lastpage와 같지 않을 때 다음 표시 나타냄	
		if(maxPage != lastPage){
	%>
			<a href="<%=request.getContextPath()%>/windowsFunctionEmpList.jsp?currentPage=<%=minPage + pagePerPage%>">다음</a>
	<%		
		}
	%>	
			
			
</body>
</html>