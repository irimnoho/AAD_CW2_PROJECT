<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="ConnectionManager.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>CharityWare</title>		
		
		<link rel="stylesheet" href="css/reset.css" type="text/css" media="all">
		<link rel="stylesheet" href="css/layout.css" type="text/css" media="all">
		<link rel="stylesheet" href="css/style1.css" type="text/css" media="all">
			
		<script type="text/javascript" src="js/tabsScript.js"></script>
		<script type="text/javascript" src="js/charityManager.js"></script>
		<script type="text/javascript" src="js/xhr.js"></script>
		<!-- Google Charts Stuff -->

		<!--Load the AJAX API-->
    	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    	<script type="text/javascript">

	      // Load the Visualization API and the piechart package.
	      google.load('visualization', '1.0', {'packages':['corechart']});
	
	      // Set a callback to run when the Google Visualization API is loaded.
	      google.setOnLoadCallback(drawChart);
	
	      // Callback that creates and populates a data table,
	      // instantiates the pie chart, passes in the data and
	      // draws it.
	      function populateData(data)
	      {
	    	  resp = xhr("/CharityWare/StatisticsDataServlet",false);
	    	  obj = JSON.parse(resp);
	    	  data.addRows(obj);
	      }
	      function drawChart() {
	
	        // Create the data table.
	        var data = new google.visualization.DataTable();
	        data.addColumn('string', 'User');
	        data.addColumn('number', 'Records');
	        populateData(data);
	        var options = {'title':'Records inputted by each User',
	                       'width':500,
	                       'height':400};
	
	        // Instantiate and draw our chart, passing in some options.
	        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
	        chart.draw(data, options);
	      }
    	</script>
    	
    	<!-- Google Charts Stuff -->
</head>
<body id="page1">
	<div class="body1">
		<div class="main">
	  
	   <jsp:include page="HeaderLoggedIn.jsp"></jsp:include>
	    
	          
	    <!-- Main Content -->
	    
	    <article id="content">
	      <div class="wrapper">
	        <div class="box1">
	        
	        	<p> 
					<h2> Charity Administration Panel </h2> 
				</p>
								
				<div id="tabs">
			        <ul> 
			            <li><a href="javascript:tabSwitch(1,5,'tab_', 'content_');" id="tab_1" class="active">Manage Application</a></li>  
			            <li><a href="javascript:tabSwitch(2,5,'tab_', 'content_');" id="tab_2">Manage Users</a></li>  
			            <li><a href="javascript:tabSwitch(3,5,'tab_', 'content_');" id="tab_3">Manage Events</a></li>
			            <li><a href="javascript:tabSwitch(4,5,'tab_', 'content_');" id="tab_4">Search</a></li>
			            <li><a href="javascript:tabSwitch(5,5,'tab_', 'content_');" id="tab_5">Statistics</a></li>  
			        </ul>
			    </div> 
			    <div class="tabbed_area">       
			       <div id="content_1" class="tabContent">
      					<fieldset id="myforms">
      					<legend>My forms</legend>
      					<div id="myformslist">
      					<c:choose>
      					<c:when test='${sentForms!= null && sentForms.size() > 0}'>
      				 	<c:forEach items="${sentForms}" var="theform">
      				 	<div>
      				 	<input type="hidden" value="${theform.getFormId() }" />
      				 	<label for="myform_${theform.getFormId()}">Form name:</label>
      				 	<input type="text" readonly id="myform_${theform.getFormId()}" value='${theform.getFormName() }'/>
      				 	<button type="button" onclick="viewCurrentFormStructure(this)">View structure</button>
      				 	<button type="button" onclick="viewCurrentFormData(this)">View data</button>
      				 	<button type="button" onclick="">Remove</button>
      				 	</div>
      				 	</c:forEach>
      					</c:when>
      					<c:otherwise>
      						Sorry, it appears you have no forms defined!
      				 	</c:otherwise>
      				 	</c:choose>     				 	
      					</div>
      					<button type="button" onclick="showWizard(this)">Add new Form</button>
      					</fieldset>
      					<fieldset id="currentformrows" class="nodisplay"></fieldset>
      					<fieldset id="formwizard" class="nodisplay">
      					<legend>Form Wizard</legend>
      					
      					<fieldset>
      					<legend>Form description</legend>
      					<label>Form name:</label>
      					<input id="formname" type="text" />
      					<label>Description</label>
      					<input id="formdesc" type="text"/>
      					<button type="button" id="btnSubmitForm" onclick="submitForm()">Create this form!</button>
      					</fieldset>
      					
      					<fieldset id = "fieldselect">
      					<legend>Field wizard</legend>
      					<label for="fieldname">Field name</label>
      					<input id="fieldname" type="text"/>
      					<label for="typeoptions">Input type</label>
      					<select id="typeoptions" onchange="onRowTypeChanged()">
      					<option value="int" selected>Integer</option>
      					<option value="string">String</option>
      					<option value="datetime">Date</option>
      					<option value="text">Text</option>
      					<option value="bool">Yes/No</option>
      					<option value="img">Image</option>
      					<option value="enum">Dropdown</option>
      					</select>
      					<input type="checkbox" id="rowrequired" name="rowrequired"/>
      					<label for="rowrequired">Mandatory?</label>
      					<br/>
      					<button onclick="addRow()" type="button" >Add row</button>
      					<div id="extra" class="nodisplay"></div>
      					<div id="errmsg" class="nodisplay"></div>
      					</fieldset>
      					<form id="rowset" action="CreateTableServlet" method="post">
      					<fieldset>
      					<input type="hidden" id="argc" name="argc" />
      					<legend>Current rows:</legend>
      					<div id="rowsetrows"></div>
      					</fieldset>
      					<button type="button" id="clearbtn" onclick='removeChildren(document.getElementById("rowsetrows") ); document.getElementById("argc").value=0;'>Clear all rows</button>
      					</form>
      					</fieldset>
				   
			     </div>
			     
			     <div id="content_2" class="tabContent">
			     		<ul id="menubar2">
				     		<li><a href =""> View Accounts </a> <b>|</b> </li>
	             	       	<li><a href = ""> Change Password Requests </a> <b>|</b> </li>
	                        <li><a href = ""> Delete Accounts </a></li>
                        </ul>
			     </div>  
			     
			     <div id="content_3" class="tabContent">
			     		<iframe src="https://www.google.com/calendar/embed?src=mghh43qdbd9baft4ulhsugv3sc%40group.calendar.google.com&ctz=Europe/London" style="border: 5px" width="800" height="600" frameborder="0" scrolling="no">
			     		</iframe>
			     </div>  
			     
			     <div id="content_4" class="tabContent">
			     		<form id="frmSearch" name="frmSearch" method="post" action="">
						  <p>
						    <label for=""></label>
						    <select name="Category" id="Category">
						      <option>Date</option>
						      <option>Category1</option>
						      <option>Category2</option>
						      <option>Category3</option>
						    </select>
						    :
						<input type="text" />
						  </p>
						  <p>
						    <select name="Category2" id="Category2">
						      <option>Date</option>
						      <option>Category1</option>
						      <option>Category2</option>
						      <option>Category3</option>
						    </select>
						:
						<input type="text" />
						  </p>
						  <p>
						    <select name="Category3" id="Category3">
						      <option>Date</option>
						      <option>Category1</option>
						      <option>Category2</option>
						      <option>Category3</option>
						    </select>
						:
						<input type="text" />
						  </p>
						  <p>&nbsp;</p>
						  <p>
						    <input type="submit" name="Search" id="Search" value="Search" />
						  </p>
						</form>
			     </div>  
			     
			     <div id="content_5" class="tabContent">
			     		<ul id="menubar2">
				     		<li><a href =""> Report 1 </a> <b>|</b> </li>
	             	       	<li><a href = ""> Report 2 </a> <b>|</b> </li>
	                        <li><a href = ""> Report 3 </a></li>
                        </ul>
			     
			     		<!--Div that will hold the pie chart-->
    					<div id="chart_div"></div>
			     </div>  
			    </div>  
				
	        </div>
	      </div>
		</article>
	    <!-- Main content -->
	    
		 <jsp:include page="Footer.jsp"></jsp:include>   
	      
	      <div id="footer_text">Copyright &copy; <a href="http://www.ucl.ac.uk">UCL</a> All Rights Reserved &nbsp;&nbsp;&nbsp;&nbsp;
	        Design by <a target="_blank" href="http://www.ucl.ac.uk">UCL Computer Science</a></div>
	    </footer>
	    
	  </div>
	</div>
	</body>
</html>
