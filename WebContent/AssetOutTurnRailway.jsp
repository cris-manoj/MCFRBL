<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
<style>
.customers {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

.customers td, .customers th {
    border: 1px solid #ddd;
    padding: 2px;
    width: 100px;
    
}

.customers tr:nth-child(even){background-color: #f2f2f2;}

.customers tr:hover {background-color: #ddd;}

.customers th {
    padding-top: 6px;
    padding-bottom: 6px;
    text-align: left;
    background-color: #8d9c8e;
    color: white;
}
</style>
<title>Master Production Sheet</title>

<script type="text/javascript">

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
    	// alert ("only number value allowed");
        return false
       
    return true;
}

var req;
var which;
var req1;

function retrieveURL(url,v)
{
	 //tdt=document.getElementById("tdt").value;
	
    //  url=url+"&qty="+v+"&tdt="+tdt;
    url=url+"&qty="+v;
      //alert(url);

  if (window.XMLHttpRequest) { // Non-IE browsers
    req = new XMLHttpRequest();
    req.onreadystatechange = processStateChange;
    try {
      req.open("GET", url, true);
    } catch (e) {
      alert(e);
    }
    req.send(null);
  } else if (window.ActiveXObject) { // IE
    req = new ActiveXObject("Microsoft.XMLHTTP");
    if (req) {
      req.onreadystatechange = processStateChange;
      req.open("GET", url, true);
      req.send();
    }
  }
}

function processStateChange() {
  if (req.readyState == 4) { // Complete
    if (req.status == 200) { // OK response
      document.getElementById("dep").innerHTML = req.responseText;


    } else {
              document.getElementById("dep").innerHTML = req.responseText;
      alert("Problem: " + req.statusText);
    }
  }

}
</script>

</head>
<body>
<div id="dep"></div>

<%
DbConnection db=new DbConnection();
Connection con=db.getConnection(); 
 try 
 {
Statement st_row, st_column, st_qty;
st_row=con.createStatement();
st_column=con.createStatement();
st_qty=con.createStatement();
String asset_subType, railway_code;
String sql_row, sql_column;
ResultSet rs_column, rs_row, rs_qty;
String date=request.getParameter("date");
String assetRSP=request.getParameter("shopRSP");

Calendar calendar1 = Calendar.getInstance();
//out.println("Calender1: "+calendar1.getTime());
int doy1 = calendar1.get(Calendar.DAY_OF_YEAR);

Calendar calendar2 = Calendar.getInstance();
//out.println("System Enter Date: " +date);
int year= Integer.parseInt(date.substring(0,4));
//out.println("Year :" +year);
int month=Integer.parseInt(date.substring(5,7))-1;
//out.println("Month :" +month);
int day= Integer.parseInt(date.substring(8,10));
//out.println("Day :" +day);
calendar2.set(year, month, day);
//out.println("Calender2: "+calendar2.getTime());
int doy2=calendar2.get(Calendar.DAY_OF_YEAR);
int difference= doy1-doy2;
//out.println("Doy1 :" +doy1);
//out.println("Doy2 :"+doy2);
//out.println("Difference: "+difference);

  
  %>
  <p>(Only number values are allowed)</p>
  <table class="customers">   
 <tr>
 <th>Description</th>

 <%

        sql_column="select railway_code from public.railway_master";
        rs_column=st_column.executeQuery(sql_column);
        while(rs_column.next())
        {
        	railway_code=rs_column.getString(1);
       %>
   <th><%=railway_code%></th>
    <% }
    %> 
      </tr>
         <%   
       sql_row="select asset_subtype from public.asset_master where asset_type= '"+assetRSP+"'";
             rs_row=st_row.executeQuery(sql_row);
          while(rs_row.next())
                {
         asset_subType=rs_row.getString(1); %>
         <tr>
         <th ><%=asset_subType%></th>
         <% 
          sql_column="select railway_code from public.railway_master";
          rs_column=st_column.executeQuery(sql_column);
           while(rs_column.next())
           { 
           
           railway_code=rs_column.getString(1);
          
           String  sql_qty= "select asset_gateout_qty from public.asset_gateout_qty_t where railway_code='"+railway_code+"' and asset_type='"+assetRSP+"' and asset_subtype='"+asset_subType+"' and asset_gateout_date='"+date+"'" ;
           rs_qty=st_qty.executeQuery(sql_qty);  
           String qty="";
           while(rs_qty.next())
           {
         	  qty=rs_qty.getString(1);
         	  if(qty==null)
         	  qty=""; 
           }
           if(difference<=300)
           {        %>
          <td> <input type="text" name="assetGateoutQty" size="3" id="myText" value="<%=qty%>" onkeypress='return isNumberKey(event)' onblur="retrieveURL('AssetOutturnRailway_do.jsp?railway_code=<%=railway_code%>&asset_type=<%=assetRSP%>&asset_subtype=<%=asset_subType%>&date=<%=date%>&FIELD=asset_gateout_qty', this.value)"/></td>
    <% }  
    else {
    %>
    	<td><%=qty%></td>
         <%  } } %>
            </tr>
            <% 
           
 }
                }
          
          catch(Exception e)
          {
               out.println("Exception Here "+e.toString());
          }
 finally
 {
 	if(con!=null)
 	con.close();
 }
             %>   
       
           </table>
</body>
</html>