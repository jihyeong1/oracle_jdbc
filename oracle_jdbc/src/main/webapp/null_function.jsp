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
	-- nvl(��1, ��2) : ��1�� null�� �ƴϸ� ��1�� ��ȯ, ��1�� null�̸� ��2�� ��ȯ�Ѵ�
	-- nvl2(��1, ��2, ��3) : ��1�� null�ƴϸ� ��2��ȯ, ��1�� null�̸� ��3�� ��ȯ
	-- nullif(��1, ��2) : ��1�� ��2�� ������ null�� ��ȯ (null�� �ƴѰ��� null�� ġȯ�� ���)
	-- coalesce(��1, ��2, ��3, .....) : �Է°� �� null�ƴ� ù��°���� ��ȯ
	*/
	
	//nvl ����
	PreparedStatement nvlStmt = null;
   	ResultSet nvlRs = null;
   	String nvlSql="SELECT �̸�, nvl(�Ϻб�, 0) �Ϻб� from onepice";
   	nvlStmt = conn.prepareStatement(nvlSql);
   	System.out.println(nvlStmt +"<--nvlStmt");
   	nvlRs = nvlStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<HashMap<String, Object>>();
   	while(nvlRs.next()){
   		HashMap<String, Object> n = new HashMap<String, Object>();
   		n.put("�̸�", nvlRs.getString("�̸�"));
   		n.put("�Ϻб�", nvlRs.getInt("�Ϻб�"));
   		nvlList.add(n);
   	}
   	System.out.println(nvlList + "<--nvlList");
   	
  //nvl2 ����
  	PreparedStatement nvl2Stmt = null;
   	ResultSet nvl2Rs = null;
   	String nvl2Sql="select �̸�, nvl2(�Ϻб�, 'success', 'fail') �Ϻб� from onepice";
   	nvl2Stmt = conn.prepareStatement(nvl2Sql);
   	System.out.println(nvl2Stmt +"<--nvl2Stmt");
   	nvl2Rs = nvl2Stmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nvl2List = new ArrayList<HashMap<String, Object>>();
   	while(nvl2Rs.next()){
   		HashMap<String, Object> nv = new HashMap<String, Object>();
   		nv.put("�̸�", nvl2Rs.getString("�̸�"));
   		nv.put("�Ϻб�", nvl2Rs.getString("�Ϻб�"));
   		nvl2List.add(nv);
   	}
   	System.out.println(nvl2List + "<--nvl2List");
   	
    //nullif ����
  	PreparedStatement nullifStmt = null;
   	ResultSet nullifRs = null;
   	String nullifSql="select �̸�, nullif(��б�, 100) ��б� from onepice";
   	nullifStmt = conn.prepareStatement(nullifSql);
   	System.out.println(nullifStmt +"<--nullifStmt");
   	nullifRs = nullifStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> nullifList = new ArrayList<HashMap<String, Object>>();
   	while(nullifRs.next()){
   		HashMap<String, Object> i = new HashMap<String, Object>();
   		i.put("�̸�", nullifRs.getString("�̸�"));
   		i.put("��б�", nullifRs.getInt("��б�"));
   		nullifList.add(i);
   	}
   	System.out.println(nullifList + "<--nullifList");
   	
  //coalesce ����
  	PreparedStatement coalesceStmt = null;
   	ResultSet coalesceRs = null;
   	String coalesceSql="select �̸�, coalesce(�Ϻб�, �̺б�, ��б�, ��б�) ��б� from onepice";
   	coalesceStmt = conn.prepareStatement(coalesceSql);
   	System.out.println(coalesceStmt +"<--coalesceStmt");
   	coalesceRs = coalesceStmt.executeQuery();
   	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<HashMap<String, Object>>();
   	while(coalesceRs.next()){
   		HashMap<String, Object> c = new HashMap<String, Object>();
   		c.put("�̸�", coalesceRs.getString("�̸�"));
   		c.put("��б�", coalesceRs.getInt("��б�"));
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
<h1>nvl(�Ϻб�, 0)</h1>
   <table border="1">
      <tr>
         <td>�̸�</td>
         <td>�б⺰</td>
      </tr>
      <%
         for(HashMap<String, Object> n : nvlList) {
      %>
            <tr>
               <td><%=(String)(n.get("�̸�"))%></td>
               <td><%=(Integer)(n.get("�Ϻб�"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>  

<div>
<h1>nvl2(�Ϻб�, 'success', 'fail')</h1>
   <table border="1">
      <tr>
         <td>�̸�</td>
         <td>�б⺰</td>
      </tr>
      <%
         for(HashMap<String, Object> nv : nvl2List) {
      %>
            <tr>
               <td><%=(String)(nv.get("�̸�"))%></td>
               <td><%=(String)(nv.get("�Ϻб�"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div> 

<div>
<h1>nullif(��б�, 100)</h1>
   <table border="1">
      <tr>
         <td>�̸�</td>
         <td>�б⺰</td>
      </tr>
      <%
         for(HashMap<String, Object> i : nullifList) {
      %>
            <tr>
               <td><%=(String)(i.get("�̸�"))%></td>
               <td><%=(Integer)(i.get("��б�"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div>  

<div>
<h1>coalesce(�Ϻб�, �̺б�, ��б�, ��б�)</h1>
   <table border="1">
      <tr>
         <td>�̸�</td>
         <td>�б⺰</td>
      </tr>
      <%
         for(HashMap<String, Object> c : coalesceList) {
      %>
            <tr>
               <td><%=(String)(c.get("�̸�"))%></td>
               <td><%=(Integer)(c.get("��б�"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
</div> 

</body>
</html>