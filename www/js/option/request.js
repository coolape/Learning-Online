var RM = {};
RM.session = null;
RM.name = "";
RM.URL = "http://127.0.0.1:8080/Jinx/admin";

RM._jsCall = null; // 回调函数

function _callBack(back){
	hideCircle();
	// console.log(back);
	if(back && back.code == "fails"){
		alert(back.tip || back.msg);
		if(back.error){
			RM.session = null;
		}
		return;
	}
	alert("请求成功！");
	var _fCall = RM._jsCall;
	RM._jsCall = null;
	
	if(_fCall != null){
		_fCall(back);
	}
};

// 登录
RM.login = function(){
	showCircle();
	var that = this,args = arguments;
	var lgid = args[0],lgpwd = args[1];
	
	var data = {datatype:"jsonp",cmd:1,lgid:lgid,lgpwd:lgpwd};
	RM._jsCall = function(msg){
		that.session = escape(msg.session);
		that.name = escape(msg.name);
		window.location.href = "index.html?session="+that.session +"&name="+that.name;
	};
	requestObj.JqueryReq(that.URL,data,_callBack);
}