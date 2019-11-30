document.write('<script src="js/must.js" type="text/javascript" ></script>');

function ready() {

}

function onsubmit_login() {
    var r = false;
    var lgid = $("#inputEmail");
    var lgpd = $("#inputPassword");
    var lgidval = lgid.val();
    var lgpdval = lgpd.val();
    if (lgidval.length > 0 && lgpdval.length > 0) {
        NetProtoLearn.send.login(lgidval, lgpdval, function(result, status, xhr) {
            console.log(result)
            NetProtoLearn.removeSession();
            if (result.retInfor.code != 1) {
                alert(result.retInfor.msg);
            } else {
                NetProtoLearn.setSession(result.sessionID);
                localStorage.setItem("uname", result.custInfor.name);
                window.location.href = "index_01.html";
            }
        });
    }
    return r;
}

function cancel_login() {
    var lgid = $("#inputEmail");
    var lgpd = $("#inputPassword");
    lgid.val("");
    lgpd.val("");
}