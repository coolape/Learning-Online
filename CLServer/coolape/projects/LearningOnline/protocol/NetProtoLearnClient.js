    var NetProtoLearn = {}; // 网络协议
    NetProtoLearn.__sessionID = 0; // 会话ID
    //==============================
    /*
    * 初始化
    * url:地址
    * beforeCallFunc:请求之前的回调
    * afterCallFunc:请求结束后的回调
    */
    NetProtoLearn.init = function(url, beforeCallFunc, afterCallFunc) {
        NetProtoLearn.url = url;
        NetProtoLearn.beforeCallFunc = beforeCallFunc;
        NetProtoLearn.afterCallFunc = afterCallFunc;
    };
    /*
    * 跨域调用
    * url:地址
    * params：参数
    * success：成功回调，（result, status, xhr）
    * error：失败回调，（jqXHR, textStatus, errorThrown）
    */
    NetProtoLearn.call = function ( params, callback) {
        if(NetProtoLearn.beforeCallFunc != null) {
            NetProtoLearn.beforeCallFunc();
        }
        $.ajax({
            url: NetProtoLearn.url,
            data: params,
            dataType: 'jsonp',
            crossDomain: true,
            jsonp:'callback',  //Jquery生成验证参数的名称
            success: function(result, status, xhr) { //成功的回调函数,
                if(result == null) {
                    console.log("result nil,cmd=" + params[0]);
                } else {
                    if(callback != null) {
                        var cmd = result[0];
                        if(cmd == undefined || cmd == null) {
                            console.log("get cmd is nil");
                        } else {
                            var dispatch = NetProtoLearn.dispatch[cmd];
                            if(dispatch != null && dispatch != undefined) {
                                callback(dispatch.onReceive(result), status, xhr);
                            } else {
                                console.log("get dispatcher is nil");
                            }
                        }
                    }
                }
                if(NetProtoLearn.afterCallFunc != null) {
                    NetProtoLearn.afterCallFunc();
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                if(NetProtoLearn.afterCallFunc != null) {
                    NetProtoLearn.afterCallFunc();
                }
                if(callback != null) {
                    callback(nil, textStatus, jqXHR);
                }
                console.log(textStatus + ":" + errorThrown);
            }
        });
    }
    NetProtoLearn.dispatch = {};
    //==============================
    // public toMap
    NetProtoLearn._toMap = function(stuctobj, m) {
        var ret = {};
        if (m == null) { return ret; }
        for(k in m) {
            ret[k] = stuctobj.toMap(m[k]);
        }
        return ret;
    };
    // public toList
    NetProtoLearn._toList = function(stuctobj, m) {
        var ret = [];
        if (m == null) { return ret; }
        var count = m.length;
        for (var i = 0; i < count; i++) {
            ret.push(stuctobj.toMap(m[i]));
        }
        return ret;
    };
    // public parse
    NetProtoLearn._parseMap = function(stuctobj, m) {
        var ret = {};
        if(m == null){ return ret; }
        for(k in m) {
            ret[k] = stuctobj.parse(m[k]);
        }
        return ret;
    };
    // public parse
    NetProtoLearn._parseList = function(stuctobj, m) {
        var ret = [];
        if(m == null){return ret; }
        var count = m.length;
        for(var i = 0; i < count; i++) {
            ret.push(stuctobj.parse(m[i]));
        }
        return ret;
    };
  //==================================
  //==================================
    ///@class NetProtoLearn.ST_retInfor 返回信息
    ///@field public msg string 返回消息
    ///@field public code number 返回值
    NetProtoLearn.ST_retInfor = {
        toMap : function(m) {
            var r = {};
            if(m == null) { return r; }
            r[10] = m.msg  // 返回消息 string
            r[11] = m.code  // 返回值 int
            return r;
        },
        parse : function(m) {
            var r = {};
            if(m == null) { return r; }
            r.msg = m[10] //  string
            r.code = m[11] //  int
            return r;
        },
    }
    ///@class NetProtoLearn.ST_custInfor 客户信息
    ///@field public idx number 唯一标识
    NetProtoLearn.ST_custInfor = {
        toMap : function(m) {
            var r = {};
            if(m == null) { return r; }
            r[12] = m.idx  // 唯一标识 int
            return r;
        },
        parse : function(m) {
            var r = {};
            if(m == null) { return r; }
            r.idx = m[12] //  int
            return r;
        },
    }
    //==============================
    NetProtoLearn.send = {
    // 登出
    logout : function(custId, callback) {
        var ret = {};
        ret[0] = 13;
        ret[1] = NetProtoLearn.__sessionID;
        ret[14] = custId; // 客户名
        NetProtoLearn.call(ret, callback);
    },
    // 登陆
    login : function(custId, password, callback) {
        var ret = {};
        ret[0] = 15;
        ret[1] = NetProtoLearn.__sessionID;
        ret[14] = custId; // 客户id
        ret[16] = password; // 密码
        NetProtoLearn.call(ret, callback);
    },
    // 注册
    regist : function(custId, password, name, phone, phone2, email, channel, note, callback) {
        var ret = {};
        ret[0] = 17;
        ret[1] = NetProtoLearn.__sessionID;
        ret[14] = custId; // 客户id
        ret[16] = password; // 密码
        ret[18] = name; // 名字
        ret[19] = phone; // 电话号码
        ret[25] = phone2; // 紧急联系电话
        ret[20] = email; // 邮箱
        ret[21] = channel; // 渠道号
        ret[22] = note; // 备注
        NetProtoLearn.call(ret, callback);
    },
    };
    //==============================
    NetProtoLearn.recive = {
    ///@class NetProtoLearn.RC_logout
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    logout : function(map) {
        var ret = {};
        ret.cmd = "logout";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        return ret;
    },
    ///@class NetProtoLearn.RC_login
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    ///@field public custInfor NetProtoLearn.ST_custInfor 客户信息
    ///@field public sessionID  会话id
    login : function(map) {
        var ret = {};
        ret.cmd = "login";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        ret.custInfor = NetProtoLearn.ST_custInfor.parse(map[23]) // 客户信息
        ret.sessionID = map[24] // 会话id
        return ret;
    },
    ///@class NetProtoLearn.RC_regist
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    ///@field public custInfor NetProtoLearn.ST_custInfor 客户信息
    ///@field public sessionID  会话id
    regist : function(map) {
        var ret = {};
        ret.cmd = "regist";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        ret.custInfor = NetProtoLearn.ST_custInfor.parse(map[23]) // 客户信息
        ret.sessionID = map[24] // 会话id
        return ret;
    },
    };
    //==============================
    NetProtoLearn.dispatch[13]={onReceive : NetProtoLearn.recive.logout, send : NetProtoLearn.send.logout}
    NetProtoLearn.dispatch[15]={onReceive : NetProtoLearn.recive.login, send : NetProtoLearn.send.login}
    NetProtoLearn.dispatch[17]={onReceive : NetProtoLearn.recive.regist, send : NetProtoLearn.send.regist}
    //==============================
    NetProtoLearn.cmds = {
        logout : "logout", // 登出,
        login : "login", // 登陆,
        regist : "regist", // 注册
    }
    //==============================