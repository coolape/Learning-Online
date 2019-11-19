document.write('<script src="js/public/load.js" type="text/javascript" ></script>');
document.write('<script src="js/public/ready.js" type="text/javascript" ></script>');
document.write('<script src="js/option/NetProtoLearnClient.js" type="text/javascript" ></script>');
function ready(){
	console.log("ready");
	NetProtoLearn.init("http://127.0.0.1:8810/LearningOnline/get",
	function () {
		console.log("show hot  wheel");
	},
	function () {
		console.log("hide hot  wheel");
	});
}

function onsubmit_login(){
	var r = false;
	var lgid = $("#inputEmail");
	var lgpd = $("#inputPassword");
	var lgidval = lgid.val();
	var lgpdval = lgpd.val();
	if(lgidval.length > 0 && lgpdval.length >0){
		NetProtoLearn.send.login(lgidval,lgpdval, function (result, status, xhr) {
			console.log(result)
			if (result.retInfor.code != 1) {
				console.log(result.retInfor.msg);
			} else {
				NetProtoLearn.setSession(result.sessionID)
				console.log(result.custInfor)
			}

		});
	}
	return r;
}
function cancel_login(){
	var lgid = $("#inputEmail");
	var lgpd = $("#inputPassword");
	lgid.val("");
	lgpd.val("");
}