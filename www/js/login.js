document.write('<script src="js/public/load.js" type="text/javascript" ></script>');
document.write('<script src="js/public/foot.js" type="text/javascript" ></script>');
document.write('<script src="js/public/ready.js" type="text/javascript" ></script>');
document.write('<script src="js/option/request.js" type="text/javascript" ></script>');
function ready(){
	initHead();
	initMidd();
	initFoot();
}

function initHead(){
}

function initMidd(){
	var xml_lg_md = 'xml/login.xml';
	XMLLoad.loadTxt(xml_lg_md,function(txt){
		$("#lgc_mid").append(txt);
	});
}

function initFoot(){
	ready_foot("lgc_bot");
}

function onsubmit_login(){
	var r = false;
	var lgid = $("#login_id");
	var lgpd = $("#login_pwd");
	var lgidval = lgid.val();
	var lgpdval = lgpd.val();
	if(lgidval.length > 0 && lgpdval.length >0){
		RM.login(lgidval,lgpdval);
	}
	return r;
}
function cancel_login(){
	var lgid = $("#login_id");
	var lgpd = $("#login_pwd");
	lgid.val("");
	lgpd.val("");
}