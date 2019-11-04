function showCircle(){
	var jMain = $(document.body); // $("#div_wrap");
	var jLock = $("#lock");
	var _h = jMain.height();
	jLock.height(_h);
	jLock.show();
}

function hideCircle(){
	$("#lock").hide();
}

var _system = null,_objInv1 = null;
function init_system_platform(){
	//平台、设备和操作系统
	_system ={win : false,mac : false,xll : false};
    //检测平台   
    var p = navigator.platform;
	// alert(p);
    _system.win = p.indexOf("Win") == 0;  
    _system.mac = p.indexOf("Mac") == 0;  
    _system.x11 = (p == "X11") || (p.indexOf("Linux") == 0);
	_system.isPhone = !(_system.win||_system.mac||_system.xll);
}

function time_landscape(){
    var width = document.documentElement.clientWidth;
    var height =  document.documentElement.clientHeight;
    $wrap =  $('#div_wrap');
    if(width > height){
       $wrap.width(width);
       $wrap.height(height);
       $wrap.css('top',  0 );
       $wrap.css('left',  0 );
       $wrap.css('transform' , 'none');
       $wrap.css('transform-origin','50% 50%');
    } else {
       $wrap.width(height);
       $wrap.height(width);
       $wrap.css('top',  (height-width)/2 );
       $wrap.css('left',  0-(height-width)/2 );
       $wrap.css('transform' , 'rotate(90deg)');
       $wrap.css('transform-origin','50% 50%');
    }
}

function resize_window(){
	if(_system.isPhone){
		_objInv1 = setInterval("time_landscape()",200);
	}else{
		if(_objInv1){
			clearInterval(_objInv1);
			_objInv1 = null;
		}
	}
}

$(document).ready(function(){
    ready();
	init_system_platform();
	// resize_window();
});

// var evt = "onorientationchange" in window ? "orientationchange" : "resize";
// window.addEventListener(evt,resize_window);