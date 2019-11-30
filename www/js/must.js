document.write('<script src="js/public/load.js" type="text/javascript" ></script>');
document.write('<script src="js/option/NetProtoLearnClient.js" type="text/javascript" ></script>');

function showCircle() {
    var jMain = $(document.body); // $("#div_wrap");
    var jLock = $("#lock");
    var _h = jMain.height();
    jLock.height(_h);
    jLock.show();
}

function hideCircle() {
    $("#lock").hide();
}

function clear_storage() {
    NetProtoLearn.removeSession();
    localStorage.removeItem("uname");
}

$(document).ready(function() {
    var host_ip = "http://192.168.0.186:8810/LearningOnline/cmd";
    NetProtoLearn.init(host_ip, showCircle, hideCircle);
    ready();
});