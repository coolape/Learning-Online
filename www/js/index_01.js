document.write('<script src="js/must.js" type="text/javascript" ></script>');

function ready() {
    XMLLoad.loadTxt('xml/index_01.xml', function(txt) {
        $("#main_contect").append(txt);
        var _ses = NetProtoLearn.getSession();
        var _isLogin = (null != _ses) && ("" != _ses)
        var _str = "登录";
        var _jA = $("nav a[type='user_statue']");
        _jA.attr("onclick", "javascripte:ihome_01.vw_login();");
        if (_isLogin) {
            _str = localStorage.getItem("uname") + ",登出";
            _jA.attr("onclick", "javascripte:ihome_01.vw_logout();");
        }
        _jA.html(_str);
    });
}

var ihome_01 = {};
ihome_01.vw_login = function() {
    window.location.href = "login.html";
}

ihome_01.vw_logout = function() {
    NetProtoLearn.send.logout(function(result, status, xhr) {
        clear_storage();
        alert("登出成功！");
        window.location.reload();
    });
}

ihome_01.on_sub_file = function() {
    return false;
}