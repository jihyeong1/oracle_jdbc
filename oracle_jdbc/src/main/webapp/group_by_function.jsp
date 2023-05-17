<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.*" %>  
<%
	//디비 연결
	String driver = "oracle.jdbc.driver.OracleDriver";
   String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
   String dbuser = "hr";
   String dbpw = "java1234";
   Class.forName(driver);
   Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
   System.out.println(conn);
   
   /*
   	group by 절에서만 사용가능한 확장 함수
    1) grouping sets()
    2) rollup()
    3) cube()
   */
   
   //grouping sets()쿼리문 , 집합연산(union all)과 비슷한 결과
   PreparedStatement setStmt = null;
   ResultSet setRs = null;
   String setSql="SELECT department_id 무서ID, job_id 직원ID, count(*) 합 from employees group by grouping sets(department_id, job_id)";
   setStmt = conn.prepareStatement(setSql);
   System.out.println(setStmt + "<--setStmt");
   setRs = setStmt.executeQuery();
   ArrayList<HashMap<String, Object>> list = new  ArrayList<HashMap<String, Object>>();
   while(setRs.next()){
	   HashMap<String, Object> s = new  HashMap<String, Object>();
	   s.put("무서ID", setRs.getInt("무서ID"));
	   s.put("직원ID", setRs.getString("직원ID"));
	   s.put("합", setRs.getInt("합"));
	   list.add(s);
   }
   System.out.println(list);
   
   // rollup()  마지막에 전체통계값이 추가된다, 그룹이 두개가 되면 전체통계값과 첫번째의 컬럽이 집계된다
   PreparedStatement rollupStmt = null;
   ResultSet rollupRs = null;
   String rollupSql="SELECT department_id 무서ID, job_id 직원ID, count(*) 합 from employees GROUP by rollup(department_id, job_id)";
   rollupStmt = conn.prepareStatement(rollupSql);
   System.out.println(rollupStmt + "<--rollupStmt");
   rollupRs = rollupStmt.executeQuery();
   ArrayList<HashMap<String, Object>> rolluplist = new  ArrayList<HashMap<String, Object>>();
   while(rollupRs.next()){
	   HashMap<String, Object> r = new  HashMap<String, Object>();
	   r.put("무서ID", rollupRs.getInt("무서ID"));
	   r.put("직원ID", rollupRs.getString("직원ID"));
	   r.put("합", rollupRs.getInt("합"));
	   rolluplist.add(r);
   }
   System.out.println(rollupStmt);
   
   //cube() 모든 컬럼의 수가 집계된다.
    PreparedStatement cubeStmt = null;
   ResultSet cubeRs = null;
   String cubeSql="SELECT department_id 무서ID, job_id 직원ID, count(*)합 from employees GROUP by cube(department_id, job_id)";
   cubeStmt = conn.prepareStatement(cubeSql);
   System.out.println(cubeStmt + "<--rollupStmt");
   cubeRs = cubeStmt.executeQuery();
   ArrayList<HashMap<String, Object>> cubelist = new  ArrayList<HashMap<String, Object>>();
   while(cubeRs.next()){
	   HashMap<String, Object> c = new  HashMap<String, Object>();
	   c.put("무서ID", cubeRs.getInt("무서ID"));
	   c.put("직원ID", cubeRs.getString("직원ID"));
	   c.put("합", cubeRs.getInt("합"));
	   cubelist.add(c);
   }
   System.out.println(cubelist);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<div>
<h1>grouping sets()</h1>
   <table border="1">
      <tr>
         <td>department_id</td>
         <td>job_id</td>
         <td>count</td>
      </tr>
      <%
         for(HashMap<String, Object> s : list) {
      %>
            <tr>
               <td><%=(Integer)(s.get("무서ID"))%></td>
               <td><%=(String)(s.get("직원ID"))%></td>
               <td><%=(Integer)(s.get("합"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>   

<div>  
   <h1>rollup()</h1>
   <table border="1">
      <tr>
         <td>department_id</td>
         <td>job_id</td>
         <td>count</td>
      </tr>
      <%
         for(HashMap<String, Object> r : rolluplist) {
      %>
            <tr>
               <td><%=(Integer)(r.get("무서ID"))%></td>
               <td><%=(String)(r.get("직원ID"))%></td>
               <td><%=(Integer)(r.get("합"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>    
   
<div>
    <h1>cube()</h1>
   <table border="1">
      <tr>
         <td>department_id</td>
         <td>job_id</td>
         <td>count</td>
      </tr>
      <%
         for(HashMap<String, Object> c : cubelist) {
      %>
            <tr>
               <td><%=(Integer)(c.get("무서ID"))%></td>
               <td><%=(String)(c.get("직원ID"))%></td>
               <td><%=(Integer)(c.get("합"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>   
</body>
</html>