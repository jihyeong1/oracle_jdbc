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
	-- nvl(값1, 값2) : 값1이 null이 아니면 값1을 반환, 값1이 null이면 값2를 반환한다
	-- nvl2(값1, 값2, 값3) : 값1이 null아니면 값2반환, 값1이 null이면 값3을 반환
	-- nullif(값1, 값2) : 값1과 값2가 같으면 null을 반환 (null이 아닌값이 null로 치환에 사용)
	-- coalesce(값1, 값2, 값3, .....) : 입력값 중 null아닌 첫번째값을 반환
	*/
	
	//nvl 쿼리
	PreparedStatement nvlStmt = null;
   	ResultSet nvlRs = null;
   	String nvlSql="SELECT 이름, nvl(일분기, 0) 일분기 from onepice";
   	nvlStmt = conn.prepareStatement(nvlSql);
   	System.out.println(nvlStmt +"<--nvlStmt");
   	nvlRs = nvlStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<HashMap<String, Object>>();
   	while(nvlRs.next()){
   		HashMap<String, Object> n = new HashMap<String, Object>();
   		n.put("이름", nvlRs.getString("이름"));
   		n.put("일분기", nvlRs.getInt("일분기"));
   		nvlList.add(n);
   	}
   	System.out.println(nvlList + "<--nvlList");
   	
  //nvl2 쿼리
  	PreparedStatement nvl2Stmt = null;
   	ResultSet nvl2Rs = null;
   	String nvl2Sql="select 이름, nvl2(일분기, 'success', 'fail') 일분기 from onepice";
   	nvl2Stmt = conn.prepareStatement(nvl2Sql);
   	System.out.println(nvl2Stmt +"<--nvl2Stmt");
   	nvl2Rs = nvl2Stmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nvl2List = new ArrayList<HashMap<String, Object>>();
   	while(nvl2Rs.next()){
   		HashMap<String, Object> nv = new HashMap<String, Object>();
   		nv.put("이름", nvl2Rs.getString("이름"));
   		nv.put("일분기", nvl2Rs.getString("일분기"));
   		nvl2List.add(nv);
   	}
   	System.out.println(nvl2List + "<--nvl2List");
   	
    //nullif 쿼리
  	PreparedStatement nullifStmt = null;
   	ResultSet nullifRs = null;
   	String nullifSql="select 이름, nullif(사분기, 100) 사분기 from onepice";
   	nullifStmt = conn.prepareStatement(nullifSql);
   	System.out.println(nullifStmt +"<--nullifStmt");
   	nullifRs = nullifStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nullifList = new ArrayList<HashMap<String, Object>>();
   	while(nullifRs.next()){
   		HashMap<String, Object> i = new HashMap<String, Object>();
   		i.put("이름", nullifRs.getString("이름"));
   		i.put("사분기", nullifRs.getInt("사분기"));
   		nullifList.add(i);
   	}
   	System.out.println(nullifList + "<--nullifList");
   	
  //coalesce 쿼리
  	PreparedStatement coalesceStmt = null;
   	ResultSet coalesceRs = null;
   	String coalesceSql="select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 사분기 from onepice";
   	coalesceStmt = conn.prepareStatement(coalesceSql);
   	System.out.println(coalesceStmt +"<--coalesceStmt");
   	coalesceRs = coalesceStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<HashMap<String, Object>>();
   	while(coalesceRs.next()){
   		HashMap<String, Object> c = new HashMap<String, Object>();
   		c.put("이름", coalesceRs.getString("이름"));
   		c.put("사분기", coalesceRs.getInt("사분기"));
   		coalesceList.add(c);
   	}
   	System.out.println(coalesceList + "<--coalesceList");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<div>
<h1>nvl(일분기, 0)</h1>
   <table border="1">
      <tr>
         <td>이름</td>
         <td>분기별</td>
      </tr>
      <%
         for(HashMap<String, Object> n : nvlList) {
      %>
            <tr>
               <td><%=(String)(n.get("이름"))%></td>
               <td><%=(Integer)(n.get("일분기"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>  

<div>
<h1>nvl2(일분기, 'success', 'fail')</h1>
   <table border="1">
      <tr>
         <td>이름</td>
         <td>분기별</td>
      </tr>
      <%
         for(HashMap<String, Object> nv : nvl2List) {
      %>
            <tr>
               <td><%=(String)(nv.get("이름"))%></td>
               <td><%=(String)(nv.get("일분기"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div> 

<div>
<h1>nullif(사분기, 100)</h1>
   <table border="1">
      <tr>
         <td>이름</td>
         <td>분기별</td>
      </tr>
      <%
         for(HashMap<String, Object> i : nullifList) {
      %>
            <tr>
               <td><%=(String)(i.get("이름"))%></td>
               <td><%=(Integer)(i.get("사분기"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>  

<div>
<h1>coalesce(일분기, 이분기, 삼분기, 사분기)</h1>
   <table border="1">
      <tr>
         <td>이름</td>
         <td>분기별</td>
      </tr>
      <%
         for(HashMap<String, Object> c : coalesceList) {
      %>
            <tr>
               <td><%=(String)(c.get("이름"))%></td>
               <td><%=(Integer)(c.get("사분기"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div> 

</body>
</html>