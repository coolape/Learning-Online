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
        if(NetProtoLearn.beforeCallFunc) {
            NetProtoLearn.beforeCallFunc();
        }
        $.ajax({
            url: NetProtoLearn.url,
            data: params,
            dataType: 'jsonp',
            crossDomain: true,
            jsonp:'callback',  //Jquery生成验证参数的名称
            success: function(result, status, xhr) { //成功的回调函数,
                if(NetProtoLearn.afterCallFunc) {
                    NetProtoLearn.afterCallFunc();
                }
                if(!result) {
                    console.log("result nil,cmd=" + params[0]);
                } else {
                    if(callback) {
                        var cmd = result[0];
                        if(!cmd) {
                            console.log("get cmd is nil");
                        } else {
                            var dispatch = NetProtoLearn.dispatch[cmd];
                            if(!!dispatch) {
                                callback(dispatch.onReceive(result), status, xhr);
                            } else {
                                console.log("get dispatcher is nil");
                            }
                        }
                    }
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                if(NetProtoLearn.afterCallFunc) {
                    NetProtoLearn.afterCallFunc();
                }
                if(callback) {
                    callback(nil, textStatus, jqXHR);
                }
                console.log(textStatus + ":" + errorThrown);
            }
        });
    }
    NetProtoLearn.setSession = function(ss)
    {
        localStorage.setItem("NetProtoLearn.__sessionID", ss)
    }
    NetProtoLearn.getSession = function()
    {
        return localStorage.getItem("NetProtoLearn.__sessionID")
    }
    NetProtoLearn.removeSession = function()
    {
        localStorage.removeItem("NetProtoLearn.__sessionID")
    }
    NetProtoLearn.dispatch = {};
    //==============================
    // public toMap
    NetProtoLearn._toMap = function(stuctobj, m) {
        var ret = {};
        if (!m) { return ret; }
        for(k in m) {
            ret[k] = stuctobj.toMap(m[k]);
        }
        return ret;
    };
    // public toList
    NetProtoLearn._toList = function(stuctobj, m) {
        var ret = [];
        if (!m) { return ret; }
        var count = m.length;
        for (var i = 0; i < count; i++) {
            ret.push(stuctobj.toMap(m[i]));
        }
        return ret;
    };
    // public parse
    NetProtoLearn._parseMap = function(stuctobj, m) {
        var ret = {};
        if(!m){ return ret; }
        for(k in m) {
            ret[k] = stuctobj.parse(m[k]);
        }
        return ret;
    };
    // public parse
    NetProtoLearn._parseList = function(stuctobj, m) {
        var ret = [];
        if(!m){return ret; }
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
            if(!m) { return r; }
            r[10] = m.msg  // 返回消息 string
            r[11] = m.code  // 返回值 int
            return r;
        },
        parse : function(m) {
            var r = {};
            if(!m) { return r; }
            r.msg = m[10] //  string
            r.code = m[11] //  int
            return r;
        },
    }
    ///@class NetProtoLearn.ST_custInfor 客户信息
    ///@field public idx number 唯一标识
    ///@field public note string 备注
    ///@field public status number 状态
    ///@field public phone2 string 紧急电话
    ///@field public email string 邮箱
    ///@field public users table 用户列表
    ///@field public name string 名字
    ///@field public channel string 渠道来源
    ///@field public groupid number 组id 1:家长,2:销售,3:教师,100:管理员
    ///@field public belongid number 归属老师id
    ///@field public custid number 账号id
    ///@field public phone string 电话
    NetProtoLearn.ST_custInfor = {
        toMap : function(m) {
            var r = {};
            if(!m) { return r; }
            r[12] = m.idx  // 唯一标识 int
            r[22] = m.note  // 备注 string
            r[29] = m.status  // 状态 int
            r[25] = m.phone2  // 紧急电话 string
            r[20] = m.email  // 邮箱 string
            r[26] = NetProtoLearn._toList(NetProtoLearn.ST_userInfor, m.users)  // 用户列表
            r[18] = m.name  // 名字 string
            r[21] = m.channel  // 渠道来源 string
            r[33] = m.groupid  // 组id 1:家长,2:销售,3:教师,100:管理员 int
            r[27] = m.belongid  // 归属老师id int
            r[28] = m.custid  // 账号id int
            r[19] = m.phone  // 电话 string
            return r;
        },
        parse : function(m) {
            var r = {};
            if(!m) { return r; }
            r.idx = m[12] //  int
            r.note = m[22] //  string
            r.status = m[29] //  int
            r.phone2 = m[25] //  string
            r.email = m[20] //  string
            r.users = NetProtoLearn._parseList(NetProtoLearn.ST_userInfor, m[26])  // 用户列表
            r.name = m[18] //  string
            r.channel = m[21] //  string
            r.groupid = m[33] //  int
            r.belongid = m[27] //  int
            r.custid = m[28] //  int
            r.phone = m[19] //  string
            return r;
        },
    }
    ///@class NetProtoLearn.ST_userInfor 用户信息
    ///@field public idx number 唯一标识
    ///@field public note string 备注
    ///@field public status number 状态
    ///@field public name string 名字
    ///@field public sex number 性别 0:男, 1:女
    ///@field public school string 学校
    ///@field public belongid number 归属老师id
    ///@field public custid number 账号id
    ///@field public birthday string 生日
    NetProtoLearn.ST_userInfor = {
        toMap : function(m) {
            var r = {};
            if(!m) { return r; }
            r[12] = m.idx  // 唯一标识 int
            r[22] = m.note  // 备注 string
            r[29] = m.status  // 状态 int
            r[18] = m.name  // 名字 string
            r[30] = m.sex  // 性别 0:男, 1:女 int
            r[31] = m.school  // 学校 string
            r[27] = m.belongid  // 归属老师id int
            r[28] = m.custid  // 账号id int
            r[32] = m.birthday  // 生日 string
            return r;
        },
        parse : function(m) {
            var r = {};
            if(!m) { return r; }
            r.idx = m[12] //  int
            r.note = m[22] //  string
            r.status = m[29] //  int
            r.name = m[18] //  string
            r.sex = m[30] //  int
            r.school = m[31] //  string
            r.belongid = m[27] //  int
            r.custid = m[28] //  int
            r.birthday = m[32] //  string
            return r;
        },
    }
    //==============================
    NetProtoLearn.send = {
    // 删除用户
    delUser : function(idx, callback) {
        var ret = {};
        ret[0] = 34;
        ret[1] = NetProtoLearn.getSession();
        ret[12] = idx; // 用户id
        NetProtoLearn.call(ret, callback);
    },
    // 登陆
    login : function(custid, password, callback) {
        var ret = {};
        ret[0] = 15;
        ret[1] = NetProtoLearn.getSession();
        ret[28] = custid; // 客户id
        ret[16] = password; // 密码
        NetProtoLearn.call(ret, callback);
    },
    // 注册
    regist : function(custid, password, name, phone, email, channel, note, callback) {
        var ret = {};
        ret[0] = 17;
        ret[1] = NetProtoLearn.getSession();
        ret[28] = custid; // 客户id
        ret[16] = password; // 密码
        ret[18] = name; // 名字
        ret[19] = phone; // 电话
        ret[20] = email; // 邮箱
        ret[21] = channel; // 来源渠道
        ret[22] = note; // 备注
        NetProtoLearn.call(ret, callback);
    },
    // 登出
    logout : function(custid, callback) {
        var ret = {};
        ret[0] = 13;
        ret[1] = NetProtoLearn.getSession();
        ret[28] = custid; // 客户名
        NetProtoLearn.call(ret, callback);
    },
    // 添加用户
    addUser : function(custid, name, birthday, sex, school, callback) {
        var ret = {};
        ret[0] = 35;
        ret[1] = NetProtoLearn.getSession();
        ret[28] = custid; // 客户id
        ret[18] = name; // 姓名
        ret[32] = birthday; // 生日
        ret[30] = sex; // 性别 0:男, 1:女
        ret[31] = school; // 学校(可选)
        NetProtoLearn.call(ret, callback);
    },
    // 分配用户给教师
    bandingUser : function(uidx, cidx, callback) {
        var ret = {};
        ret[0] = 37;
        ret[1] = NetProtoLearn.getSession();
        ret[38] = uidx; // 用户id
        ret[39] = cidx; // 教师id(客户id)
        NetProtoLearn.call(ret, callback);
    },
    };
    //==============================
    NetProtoLearn.recive = {
    ///@class NetProtoLearn.RC_delUser
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    delUser : function(map) {
        var ret = {};
        ret.cmd = "delUser";
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
    ///@class NetProtoLearn.RC_logout
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    logout : function(map) {
        var ret = {};
        ret.cmd = "logout";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        return ret;
    },
    ///@class NetProtoLearn.RC_addUser
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    ///@field public userInfor NetProtoLearn.ST_userInfor 用户信息
    addUser : function(map) {
        var ret = {};
        ret.cmd = "addUser";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        ret.userInfor = NetProtoLearn.ST_userInfor.parse(map[36]) // 用户信息
        return ret;
    },
    ///@class NetProtoLearn.RC_bandingUser
    ///@field public retInfor NetProtoLearn.ST_retInfor 返回信息
    bandingUser : function(map) {
        var ret = {};
        ret.cmd = "bandingUser";
        ret.retInfor = NetProtoLearn.ST_retInfor.parse(map[2]) // 返回信息
        return ret;
    },
    };
    //==============================
    NetProtoLearn.dispatch[34]={onReceive : NetProtoLearn.recive.delUser, send : NetProtoLearn.send.delUser}
    NetProtoLearn.dispatch[15]={onReceive : NetProtoLearn.recive.login, send : NetProtoLearn.send.login}
    NetProtoLearn.dispatch[17]={onReceive : NetProtoLearn.recive.regist, send : NetProtoLearn.send.regist}
    NetProtoLearn.dispatch[13]={onReceive : NetProtoLearn.recive.logout, send : NetProtoLearn.send.logout}
    NetProtoLearn.dispatch[35]={onReceive : NetProtoLearn.recive.addUser, send : NetProtoLearn.send.addUser}
    NetProtoLearn.dispatch[37]={onReceive : NetProtoLearn.recive.bandingUser, send : NetProtoLearn.send.bandingUser}
    //==============================
    NetProtoLearn.cmds = {
        delUser : "delUser", // 删除用户,
        login : "login", // 登陆,
        regist : "regist", // 注册,
        logout : "logout", // 登出,
        addUser : "addUser", // 添加用户,
        bandingUser : "bandingUser", // 分配用户给教师
    }
    //==============================