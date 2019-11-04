var XMLLoad = {
	xmlHead: 'xml/head.xml?' + Math.random(0,1),
	xmlFoot: 'xml/foot.xml?' + Math.random(0,1),
	loadHtml: function (id,url) {
		var that = this;
		if(id.indexOf("#") != 0)
			id = "#"+id;
		$(id).load(url);
	},
	loadTxt: function (urlget,success) {
		var that = this;
		var url_ = urlget;
		if(!success)
			success = that.parseXML;
			
		$.ajax({
			type: "GET",
	    	url: url_,
	   		dataType: "text",	   		
	   	 	success: success
	  	});	

	},
	
	loadXML: function (urlget,successFun) {
		var that = this;
		var url_ = urlget;
		if(!successFun)
			successFun = that.parseXML;
		
		$.ajax({
			type: "GET",
	    	url: url_,
	   		dataType: "xml",	   		
	   	 	success: successFun
	  	});	

	},
	
	parseXML: function (xml) {
		console.info(xml);
		var exml = escape(xml);
		console.info("===================");
		console.info(exml);
	}
}

var loadObj = {};

loadObj.init = function(){
	var that = this,s;
	that.doc = document;
    that.wrap = that.doc.getElementsByTagName("head")[0];
	that.body = that.doc.getElementsByTagName("body")[0] || that.doc.body;
    if(!that.wrap){
        that.wrap = that.body;
    }
	that.appname = navigator.appName.toLowerCase();
	that.userAgent = navigator.userAgent.toLowerCase();
	that.sysBrowser = that.sysBrowser || {};
    (s = that.userAgent.match(/msie ([\d.]+)/)) ? that.sysBrowser.ie = s[1] :
    (s = that.userAgent.match(/firefox\/([\d.]+)/)) ? that.sysBrowser.firefox = s[1] :
    (s = that.userAgent.match(/chrome\/([\d.]+)/)) ? that.sysBrowser.chrome = s[1] :
    (s = that.userAgent.match(/opera.([\d.]+)/)) ? that.sysBrowser.opera = s[1] :
    (s = that.userAgent.match(/version\/([\d.]+).*safari/)) ? that.sysBrowser.safari = s[1] : 0;
	
	that.appVersion = navigator.appVersion.toLowerCase();
	that.device = that.device || {};
	that.device.isIphone = (/iphone/gi).test(that.appVersion);
	that.device.isIpad = (/ipad/gi).test(that.appVersion);
	that.device.isAndroid = (/android/gi).test(that.appVersion);
};
loadObj.complete = function(obj,method){
    var that = this;
    if(!obj) return;
    var nodename = obj.nodeName.toLowerCase();
    if((that.appname.indexOf("netscape") == -1 && that.appname.indexOf("opera") == -1) || obj.readyState){
        obj.onreadystatechange = function () {
            if (obj.readyState == "loaded" || obj.readyState == "complete")
            {
				obj.onreadystatechange = null;
                if(typeof method == 'function'){
                    method(nodename);
                }
            }
        };
    }else {
        obj.onload = function () {
            if (nodename == "image"){
                if(obj.complete == true){
                    if(typeof method == 'function'){
                        method(nodename);
                    }
                }
            }else{
                if(typeof method == 'function'){
                    method(nodename);
                }
            }
        }
    }
    obj.onerror = function(){
        if(nodename == "script"){
            var loadurl = obj.getAttribute("src");
            that.wrap.removeChild(obj);
            that.loadJs(loadurl);
        }
        if(typeof method == 'function'){
            method(nodename);
        }
    }
}
loadObj.loadCss = function(url){
   var that = this,cssEl;
   cssEl = that.doc.createElement("link");
   cssEl.setAttribute("type","text/css");
   cssEl.setAttribute("rel","stylesheet");
   cssEl.setAttribute("charset","utf-8");
   cssEl.href = url;
   that.wrap.appendChild(cssEl);
   return cssEl;
}
loadObj.loadJs = function(url){
   var that = this,jsel;
   jsel = that.doc.createElement("script");
   jsel.setAttribute("type","text/javascript");
   jsel.setAttribute("charset","utf-8");
   jsel.src = url;
   that.wrap.appendChild(jsel);
   return jsel;
}
loadObj.loadImg = function(url){
   var that = this,imgObj;
   imgObj = new Image();
   imgObj.src = url;
   return imgObj;
}

loadObj.preInGame = function(url){
	var that = this,
		initJs = ["js/wbload/resource.js","js/wbload/loadResource.js","js/wbload/entryGame.js"],
		len = initJs.length,
		i = 0,j = 0,
		li;
	that.init();//初始话下载资源
	that.entryGameUrl = url || "";
	for(;i<len;i++){
		li = initJs[i];
		that.complete(that.loadJs(li),function(){
			j++;
			if(j == len){
				gmEntry.init();
			}
		});
	}
}

loadObj.init();

var requestObj = {}

requestObj.JqueryReq = function(url,data,successFun,errorFun){
	var that = this,tmpUrl,timeout=60000,datatype='json',async=true,type="POST",jsonp="callback";
	if(typeof data == 'object' && data != null){
		jsonp= data.jsonp || "callback";
		if(typeof data.async == 'boolean'){async = data.async;};
		if(!isNaN(data.timeout)){timeout = data.timeout;};
		type = data.jquery_request_type || type;
		switch(data.datatype){
			case "xml":
			case "html":
			case "script":
			case "text":
			case "jsonp":
				datatype = data.datatype;
				break;
			default:
				break;
		}
		if(datatype == 'jsonp'){
			type="GET";
		}
	}else{
		data = {};
	}
	tmpUrl = url;
	if(tmpUrl.indexOf("http://") == -1)
         tmpUrl  =  that.httpHead + tmpUrl;
	
	$.ajax({
		"type":type,
		"url":tmpUrl,
		"data":data,
		"async":async,
		"dataType":datatype,
		"timeout":timeout,		
		"jsonp":jsonp,
		"success":function(backData){
			if(typeof(successFun) == "function"){
				successFun(backData);
			}
		},
		"error":function(xmlhttprequest,textStatus,errorThrown){
			if(typeof(errorFun) == "function"){
				errorFun();
			}
		}
	});
}

requestObj.HttpReq = function(url,args,successFun,errorFun){
	var xmlHttp = null,tmpUrl = "";
	if (typeof args == "object") {
        for (v in args) {
            if ((args[v] != 0 && !args[v]) || !args.hasOwnProperty(v)) continue;
            tmpUrl += v + "=" + encodeURI(args[v]) + "&";
        }
    }
	if(url.indexOf("?") == -1)
        url  +=  "?" + tmpUrl;
	else
		url  +=  "&" + tmpUrl;
	
	tmpUrl = url.substring(0,url.length-1);
	
    if(tmpUrl.indexOf("http://") == -1)
         tmpUrl  = xopc.httpHead + tmpUrl;
		 
	try{
	// Firefox, Opera 8.0+, Safari
		xmlHttp = new XMLHttpRequest();
	}catch (e){
		try{
			// Internet Explorer
			xmlHttp=new ActiveXObject('Msxml2.XMLHTTP');
		}catch (e){
			try{
				xmlHttp=new ActiveXObject('Microsoft.XMLHTTP');
			}catch (e){
				alert('Your browser does not support AJAX!');
				return false;
			}
		}
	}
	var timeOutIntval = setTimeout(function(){
		if(typeof(errorFun) == "function"){
			errorFun();
		}
	},10000);
	xmlHttp.onreadystatechange = function(){
		if(xmlHttp.readyState == 4 && xmlHttp.status == 200){
			clearTimeout(timeOutIntval);
			var backStr = xmlHttp.responseText;
			var backXMl = xmlHttp.responseXML;
            var backData = {};
			if(typeof(successFun) == "function"){
				successFun(backData);
			}
		}
	}
	xmlHttp.open('GET',tmpUrl,true);
	xmlHttp.send(null);
}

function setCookie(name,value){
    var path = "/",domain="";
    var str = name + "=" + escape(value);

    var date = new Date();
    date.setTime(date.getTime() + 1 * 24 * 3600 * 1000); //expires单位为天
    str += ";expires=" + date.toGMTString();
//    if (path != "") {
        str += ";path=" + path; //指定可访问cookie的目录
//    }
//    if (domain != "") {
        str += ";domain=" + domain; //指定可访问cookie的域
//    }
    document.cookie = str;
}

function getCookieVal(name){
    var str = document.cookie.split(";")
    for (var i = 0; i < str.length; i++) {
        var str2 = str[i].split("=");
        if (trim(str2[0]) == trim(name)) {
            return unescape(str2[1]);
        }
    }
    return "";
}

function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}