do
    ---@class NetProtoLearn 网络协议
    local NetProtoLearn = {}
    local table = table
    local CMD = {}
    local skynet = require "skynet"

    require "skynet.manager"    -- import skynet.register
    require("BioUtl")

    NetProtoLearn.dispatch = {}
    --==============================
    -- public toMap
    NetProtoLearn._toMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.toMap(v)
        end
        return ret
    end
    -- public toList
    NetProtoLearn._toList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.toMap(v))
        end
        return ret
    end
    -- public parse
    NetProtoLearn._parseMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.parse(v)
        end
        return ret
    end
    -- public parse
    NetProtoLearn._parseList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.parse(v))
        end
        return ret
    end
  --==================================
  --==================================
    ---@class NetProtoLearn.ST_retInfor 返回信息
    ---@field public msg string 返回消息
    ---@field public code number 返回值
    NetProtoLearn.ST_retInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[10] = m.msg  -- 返回消息 string
            r[11] = m.code  -- 返回值 int
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.msg = m[10] or m["10"] --  string
            r.code = m[11] or m["11"] --  int
            return r;
        end,
    }
    ---@class NetProtoLearn.ST_custInfor 客户信息
    ---@field public idx number 唯一标识
    ---@field public note string 备注
    ---@field public phone string 电话
    ---@field public phone2 string 紧急电话
    ---@field public email string 邮箱
    ---@field public users table 用户列表
    ---@field public name string 名字
    ---@field public channel string 渠道来源
    ---@field public groupid number 组id(权限角色管理)
    ---@field public belongid number 归属老师id
    ---@field public custid number 账号id
    ---@field public status number 状态
    NetProtoLearn.ST_custInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[12] = m.idx  -- 唯一标识 int
            r[22] = m.note  -- 备注 string
            r[19] = m.phone  -- 电话 string
            r[25] = m.phone2  -- 紧急电话 string
            r[20] = m.email  -- 邮箱 string
            r[26] = NetProtoLearn._toList(NetProtoLearn.ST_userInfor, m.users)  -- 用户列表
            r[18] = m.name  -- 名字 string
            r[21] = m.channel  -- 渠道来源 string
            r[33] = m.groupid  -- 组id(权限角色管理) int
            r[27] = m.belongid  -- 归属老师id int
            r[28] = m.custid  -- 账号id int
            r[29] = m.status  -- 状态 int
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.idx = m[12] or m["12"] --  int
            r.note = m[22] or m["22"] --  string
            r.phone = m[19] or m["19"] --  string
            r.phone2 = m[25] or m["25"] --  string
            r.email = m[20] or m["20"] --  string
            r.users = NetProtoLearn._parseList(NetProtoLearn.ST_userInfor, m[26] or m["26"])  -- 用户列表
            r.name = m[18] or m["18"] --  string
            r.channel = m[21] or m["21"] --  string
            r.groupid = m[33] or m["33"] --  int
            r.belongid = m[27] or m["27"] --  int
            r.custid = m[28] or m["28"] --  int
            r.status = m[29] or m["29"] --  int
            return r;
        end,
    }
    ---@class NetProtoLearn.ST_userInfor 用户信息
    ---@field public idx number 唯一标识
    ---@field public note string 备注
    ---@field public belongid number 归属老师id
    ---@field public name string 名字
    ---@field public sex number 性别 0:男, 1:女
    ---@field public school string 学校
    ---@field public status number 状态
    ---@field public custid number 账号id
    ---@field public birthday string 生日
    NetProtoLearn.ST_userInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[12] = m.idx  -- 唯一标识 int
            r[22] = m.note  -- 备注 string
            r[27] = m.belongid  -- 归属老师id int
            r[18] = m.name  -- 名字 string
            r[30] = m.sex  -- 性别 0:男, 1:女 int
            r[31] = m.school  -- 学校 string
            r[29] = m.status  -- 状态 int
            r[28] = m.custid  -- 账号id int
            r[32] = m.birthday  -- 生日 string
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.idx = m[12] or m["12"] --  int
            r.note = m[22] or m["22"] --  string
            r.belongid = m[27] or m["27"] --  int
            r.name = m[18] or m["18"] --  string
            r.sex = m[30] or m["30"] --  int
            r.school = m[31] or m["31"] --  string
            r.status = m[29] or m["29"] --  int
            r.custid = m[28] or m["28"] --  int
            r.birthday = m[32] or m["32"] --  string
            return r;
        end,
    }
    --==============================
    NetProtoLearn.recive = {
    -- 登出
    ---@class NetProtoLearn.RC_logout
    ---@field public custId  客户名
    logout = function(map)
        local ret = {}
        ret.cmd = "logout"
        ret.__session__ = map[1] or map["1"]
        ret.callback = map[3]
        ret.custId = map[14] or map["14"] -- 客户名
        return ret
    end,
    -- 登陆
    ---@class NetProtoLearn.RC_login
    ---@field public custId  客户id
    ---@field public password  密码
    login = function(map)
        local ret = {}
        ret.cmd = "login"
        ret.__session__ = map[1] or map["1"]
        ret.callback = map[3]
        ret.custId = map[14] or map["14"] -- 客户id
        ret.password = map[16] or map["16"] -- 密码
        return ret
    end,
    -- 注册
    ---@class NetProtoLearn.RC_regist
    ---@field public custInfor NetProtoLearn.ST_custInfor 客户信息
    ---@field public password  密码
    regist = function(map)
        local ret = {}
        ret.cmd = "regist"
        ret.__session__ = map[1] or map["1"]
        ret.callback = map[3]
        ret.custInfor = NetProtoLearn.ST_custInfor.parse(map[23] or map["23"]) -- 客户信息
        ret.password = map[16] or map["16"] -- 密码
        return ret
    end,
    }
    --==============================
    NetProtoLearn.send = {
    logout = function(retInfor, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 13
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearn.ST_retInfor.toMap(retInfor); -- 返回信息
        return ret
    end,
    login = function(retInfor, custInfor, sessionID, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 15
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearn.ST_retInfor.toMap(retInfor); -- 返回信息
        ret[23] = NetProtoLearn.ST_custInfor.toMap(custInfor); -- 客户信息
        ret[24] = sessionID; -- 会话id
        return ret
    end,
    regist = function(retInfor, custInfor, sessionID, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 17
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearn.ST_retInfor.toMap(retInfor); -- 返回信息
        ret[23] = NetProtoLearn.ST_custInfor.toMap(custInfor); -- 客户信息
        ret[24] = sessionID; -- 会话id
        return ret
    end,
    }
    --==============================
    NetProtoLearn.dispatch[13]={onReceive = NetProtoLearn.recive.logout, send = NetProtoLearn.send.logout, logicName = "cmd4cust"}
    NetProtoLearn.dispatch[15]={onReceive = NetProtoLearn.recive.login, send = NetProtoLearn.send.login, logicName = "cmd4cust"}
    NetProtoLearn.dispatch[17]={onReceive = NetProtoLearn.recive.regist, send = NetProtoLearn.send.regist, logicName = "cmd4cust"}
    --==============================
    NetProtoLearn.cmds = {
        logout = "logout", -- 登出,
        login = "login", -- 登陆,
        regist = "regist", -- 注册
    }

    --==============================
    function CMD.dispatcher(agent, map, client_fd)
        if map == nil then
            skynet.error("[dispatcher] map == nil")
            return nil
        end
        local cmd = map[0]
        if cmd == nil then
            skynet.error("get cmd is nil")
            return nil;
        end
        local dis = NetProtoLearn.dispatch[cmd]
        if dis == nil then
            skynet.error("get protocol cfg is nil")
            return nil;
        end
        local m = dis.onReceive(map)
        local logicProc = skynet.call(agent, "lua", "getLogic", dis.logicName)
        if logicProc == nil then
            skynet.error("get logicServe is nil. serverName=[" .. dis.loginAccount .."]")
            return nil
        else
            return skynet.call(logicProc, "lua", m.cmd, m, client_fd, agent)
        end
    end
    --==============================
    skynet.start(function()
        skynet.dispatch("lua", function(_, _, command, command2, ...)
            if command == "send" then
                local f = NetProtoLearn.send[command2]
                skynet.ret(skynet.pack(f(...)))
            else
                local f = CMD[command]
                skynet.ret(skynet.pack(f(command2, ...)))
            end
        end)
    
        skynet.register "NetProtoLearn"
    end)
end
