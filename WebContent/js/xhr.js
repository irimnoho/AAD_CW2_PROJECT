function xhr(url,async,callback)
{
	var xmlhttp = newXhr();
	xmlhttp.onreadystatechange=function()
	  {
	  if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
		  if(typeof callback !== "undefined")
			  callback(xmlhttp.responseText);
	    }
	  };
	xmlhttp.open("GET",url,async);
	xmlhttp.send();
	return xmlhttp.responseText;
}

function newXhr()
{
	var xmlhttp;
	if (window.XMLHttpRequest)
	  {// code for IE7+, Firefox, Chrome, Opera, Safari
	  xmlhttp=new XMLHttpRequest();
	  }
	else
	  {// code for IE6, IE5
	  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	  }
	return xmlhttp;
}