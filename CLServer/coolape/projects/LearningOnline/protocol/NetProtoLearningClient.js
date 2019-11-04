    var NetProtoLearning = {}; // 网络协议
    NetProtoLearning.__sessionID = 0; // 会话ID
    NetProtoLearning.dispatch = {};
    //==============================
    // public toMap
    NetProtoLearning._toMap = function(stuctobj, m) {
        var ret = {};
        if (m == null) { return ret; }
        for(k in m) {
            ret[k] = stuctobj.toMap(m[k]);
        }
        return ret;
    }
    // public toList
    NetProtoLearning._toList = function(stuctobj, m) {
        var ret = [];
        if (m == null) { return ret; }
        var count = m.length;
        for (var i = 0; i < count; i++) {
            ret.push(stuctobj.toMap(m[i]));
        }
        return ret;
    }
    // public parse
    NetProtoLearning._parseMap = function(stuctobj, m) {
        var ret = {};
        if(m == null){ return ret; }
        for(k in m) {
            ret[k] = stuctobj.parse(m[k]);
        }
        return ret;
    }
    // public parse
    NetProtoLearning._parseList = function(stuctobj, m) {
        var ret = [];
        if(m == null){return ret; }
        var count = m.length;
        for(var i = 0; i < count; i++) {
            ret.push(stuctobj.parse(m[i]));
        }
        return ret;
    }
  //==================================
  //==================================
    ///@class NetProtoLearning.ST_retInfor 返回信息
    ///@field public msg string 返回消息
    ///@field public code number 返回值
    NetProtoLearning.ST_retInfor = {
        toMap = function(m) {
            var r = {};
            if(m == null) { return r; }
            r[10] = m.msg  // 返回消息 string
            r[11] = m.code  // 返回值 int
            return r;
        },
        parse = function(m) {
            var r = {};
            if(m == nill) { return r; }
            r.msg = m[10] //  string
            r.code = m[11] //  int
            return r;
        },
    }
    ///@class NetProtoLearning.ST_custInfor 客户信息
    ///@field public idx number 唯一标识
    NetProtoLearning.ST_custInfor = {
        toMap = function(m) {
            var r = {};
            if(m == null) { return r; }
            r[12] = m.idx  // 唯一标识 int
            return r;
        },
        parse = function(m) {
            var r = {};
            if(m == nill) { return r; }
            r.idx = m[12] //  int
            return r;
        },
    }
    //==============================
    NetProtoLearning.send = {
    // 登出
    logout = function(custId) {
        var ret = {};
        ret[0] = 13;
        ret[1] = NetProtoLearning.__sessionID;
        ret[14] = custId; // 客户名
        return ret;
    },
    // 登陆
    login = function(custId, password) {
        var ret = {};
        ret[0] = 15;
        ret[1] = NetProtoLearning.__sessionID;
        ret[14] = custId; // 客户id
        ret[16] = password; // 密码
        return ret;
    },
    // 注册
    regist = function(custId, password, name, phone, phone2, email, channel, note) {
        var ret = {};
        ret[0] = 17;
        ret[1] = NetProtoLearning.__sessionID;
        ret[14] = custId; // 客户id
        ret[16] = password; // 密码
        ret[18] = name; // 名字
        ret[19] = phone; // 电话号码
        ret[25] = phone2; // 紧急联系电话
        ret[20] = email; // 邮箱
        ret[21] = channel; // 渠道号
        ret[22] = note; // 备注
        return ret;
    },
    }
    //==============================
    NetProtoLearning.recive = {
    ///@class NetProtoLearning.RC_logout
    ///@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    logout = function(map) {
        var ret = {};
        ret.cmd = "logout";
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) // 返回信息
        return ret;
    },
    ///@class NetProtoLearning.RC_login
    ///@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    ///@field public custInfor NetProtoLearning.ST_custInfor 客户信息
    ///@field public sessionID  会话id
    login = function(map) {
        var ret = {};
        ret.cmd = "login";
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) // 返回信息
        ret.custInfor = NetProtoLearning.ST_custInfor.parse(map[23]) // 客户信息
        ret.sessionID = map[24] // 会话id
        return ret;
    },
    ///@class NetProtoLearning.RC_regist
    ///@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    ///@field public custInfor NetProtoLearning.ST_custInfor 客户信息
    ///@field public sessionID  会话id
    regist = function(map) {
        var ret = {};
        ret.cmd = "regist";
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) // 返回信息
        ret.custInfor = NetProtoLearning.ST_custInfor.parse(map[23]) // 客户信息
        ret.sessionID = map[24] // 会话id
        return ret;
    },
    }
    //==============================
    NetProtoLearning.dispatch[13]={onReceive = NetProtoLearning.recive.logout, send = NetProtoLearning.send.logout}
    NetProtoLearning.dispatch[15]={onReceive = NetProtoLearning.recive.login, send = NetProtoLearning.send.login}
    NetProtoLearning.dispatch[17]={onReceive = NetProtoLearning.recive.regist, send = NetProtoLearning.send.regist}
    //==============================
    NetProtoLearning.cmds = {
        logout = "logout", // 登出,
        login = "login", // 登陆,
        regist = "regist", // 注册
    }
    //==============================