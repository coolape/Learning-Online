document.write('<script src="js/public/load.js" type="text/javascript" ></script>');
document.write('<script src="js/public/ready.js" type="text/javascript" ></script>');
document.write('<script src="js/option/NetProtoLearnClient.js" type="text/javascript" ></script>');
function ready(){

}

function onsubmit_login(){
	var r = false;
	var lgid = $("#inputEmail");
	var lgpd = $("#inputPassword");
	var lgidval = lgid.val();
	var lgpdval = lgpd.val();
	if(lgidval.length > 0 && lgpdval.length >0){
		NetProtoLearn.send.login(lgidval,lgpdval);
	}
	return r;
}
function cancel_login(){
	var lgid = $("#inputEmail");
	var lgpd = $("#inputPassword");
	lgid.val("");
	lgpd.val("");
}