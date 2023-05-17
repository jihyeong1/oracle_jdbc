<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*" %>    
<%@ page import="java.util.*" %>  
<%
	//��� ����
	String driver = "oracle.jdbc.driver.OracleDriver";
   String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
   String dbuser = "hr";
   String dbpw = "java1234";
   Class.forName(driver);
   Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
   System.out.println(conn);
   
   /*
   	group by �������� ��밡���� Ȯ�� �Լ�
    1) grouping sets()
    2) rollup()
    3) cube()
   */
   
   //grouping sets()������ , ���տ���(union all)�� ����� ���
   PreparedStatement setStmt = null;
   ResultSet setRs = null;
   String setSql="SELECT department_id ����ID, job_id ����ID, count(*) �� from employees group by grouping sets(department_id, job_id)";
   setStmt = conn.prepareStatement(setSql);
   System.out.println(setStmt + "<--setStmt");
   setRs = setStmt.executeQuery();
   ArrayList<HashMap<String, Object>> list = new  ArrayList<HashMap<String, Object>>();
   while(setRs.next()){
	   HashMap<String, Object> s = new  HashMap<String, Object>();
	   s.put("����ID", setRs.getInt("����ID"));
	   s.put("����ID", setRs.getString("����ID"));
	   s.put("��", setRs.getInt("��"));
	   list.add(s);
   }
   System.out.println(list);
   
   // rollup()  �������� ��ü��谪�� �߰��ȴ�, �׷��� �ΰ��� �Ǹ� ��ü��谪�� ù��°�� �÷��� ����ȴ�
   PreparedStatement rollupStmt = null;
   ResultSet rollupRs = null;
   String rollupSql="SELECT department_id ����ID, job_id ����ID, count(*) �� from employees GROUP by rollup(department_id, job_id)";
   rollupStmt = conn.prepareStatement(rollupSql);
   System.out.println(rollupStmt + "<--rollupStmt");
   rollupRs = rollupStmt.executeQuery();
   ArrayList<HashMap<String, Object>> rolluplist = new  ArrayList<HashMap<String, Object>>();
   while(rollupRs.next()){
	   HashMap<String, Object> r = new  HashMap<String, Object>();
	   r.put("����ID", rollupRs.getInt("����ID"));
	   r.put("����ID", rollupRs.getString("����ID"));
	   r.put("��", rollupRs.getInt("��"));
	   rolluplist.add(r);
   }
   System.out.println(rollupStmt);
   
   //cube() ��� �÷��� ���� ����ȴ�.
    PreparedStatement cubeStmt = null;
   ResultSet cubeRs = null;
   String cubeSql="SELECT department_id ����ID, job_id ����ID, count(*)�� from employees GROUP by cube(department_id, job_id)";
   cubeStmt = conn.prepareStatement(cubeSql);
   System.out.println(cubeStmt + "<--rollupStmt");
   cubeRs = cubeStmt.executeQuery();
   ArrayList<HashMap<String, Object>> cubelist = new  ArrayList<HashMap<String, Object>>();
   while(cubeRs.next()){
	   HashMap<String, Object> c = new  HashMap<String, Object>();
	   c.put("����ID", cubeRs.getInt("����ID"));
	   c.put("����ID", cubeRs.getString("����ID"));
	   c.put("��", cubeRs.getInt("��"));
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
               <td><%=(Integer)(s.get("����ID"))%></td>
               <td><%=(String)(s.get("����ID"))%></td>
               <td><%=(Integer)(s.get("��"))%></td>
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
               <td><%=(Integer)(r.get("����ID"))%></td>
               <td><%=(String)(r.get("����ID"))%></td>
               <td><%=(Integer)(r.get("��"))%></td>
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
               <td><%=(Integer)(c.get("����ID"))%></td>
               <td><%=(String)(c.get("����ID"))%></td>
               <td><%=(Integer)(c.get("��"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>   
</body>
</html>