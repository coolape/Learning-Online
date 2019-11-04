do
    ---@class NetProtoLearning 网络协议
    local NetProtoLearning = {}
    local table = table
    local CMD = {}
    local skynet = require "skynet"

    require "skynet.manager"    -- import skynet.register
    require("BioUtl")

    NetProtoLearning.dispatch = {}
    --==============================
    -- public toMap
    NetProtoLearning._toMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.toMap(v)
        end
        return ret
    end
    -- public toList
    NetProtoLearning._toList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.toMap(v))
        end
        return ret
    end
    -- public parse
    NetProtoLearning._parseMap = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for k,v in pairs(m) do
            ret[k] = stuctobj.parse(v)
        end
        return ret
    end
    -- public parse
    NetProtoLearning._parseList = function(stuctobj, m)
        local ret = {}
        if m == nil then return ret end
        for i,v in ipairs(m) do
            table.insert(ret, stuctobj.parse(v))
        end
        return ret
    end
  --==================================
  --==================================
    ---@class NetProtoLearning.ST_retInfor 返回信息
    ---@field public msg string 返回消息
    ---@field public code number 返回值
    NetProtoLearning.ST_retInfor = {
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
            r.msg = m[10] --  string
            r.code = m[11] --  int
            return r;
        end,
    }
    ---@class NetProtoLearning.ST_custInfor 客户信息
    ---@field public idx number 唯一标识
    NetProtoLearning.ST_custInfor = {
        toMap = function(m)
            local r = {}
            if m == nil then return r end
            r[12] = m.idx  -- 唯一标识 int
            return r;
        end,
        parse = function(m)
            local r = {}
            if m == nil then return r end
            r.idx = m[12] --  int
            return r;
        end,
    }
    --==============================
    NetProtoLearning.recive = {
    -- 登出
    logout = function(map)
        local ret = {}
        ret.cmd = "logout"
        ret.__session__ = map[1]
        ret.callback = map[3]
        ret.custId = map[14]-- 客户名
        return ret
    end,
    -- 登陆
    login = function(map)
        local ret = {}
        ret.cmd = "login"
        ret.__session__ = map[1]
        ret.callback = map[3]
        ret.custId = map[14]-- 客户id
        ret.password = map[16]-- 密码
        return ret
    end,
    -- 注册
    regist = function(map)
        local ret = {}
        ret.cmd = "regist"
        ret.__session__ = map[1]
        ret.callback = map[3]
        ret.custId = map[14]-- 客户id
        ret.password = map[16]-- 密码
        ret.name = map[18]-- 名字
        ret.phone = map[19]-- 电话号码
        ret.email = map[20]-- 邮箱
        ret.channel = map[21]-- 渠道号
        ret.note = map[22]-- 备注
        return ret
    end,
    }
    --==============================
    NetProtoLearning.send = {
    logout = function(retInfor, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 13
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearning.ST_retInfor.toMap(retInfor); -- 返回信息
        return ret
    end,
    login = function(retInfor, custInfor, sessionID, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 15
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearning.ST_retInfor.toMap(retInfor); -- 返回信息
        ret[23] = NetProtoLearning.ST_custInfor.toMap(custInfor); -- 客户信息
        ret[24] = sessionID; -- 会话id
        return ret
    end,
    regist = function(retInfor, mapOrig) -- mapOrig:客户端原始入参
        local ret = {}
        ret[0] = 17
        ret[3] = mapOrig and mapOrig.callback or nil
        ret[2] = NetProtoLearning.ST_retInfor.toMap(retInfor); -- 返回信息
        return ret
    end,
    }
    --==============================
    NetProtoLearning.dispatch[13]={onReceive = NetProtoLearning.recive.logout, send = NetProtoLearning.send.logout, logicName = "cmd4user"}
    NetProtoLearning.dispatch[15]={onReceive = NetProtoLearning.recive.login, send = NetProtoLearning.send.login, logicName = "cmd4user"}
    NetProtoLearning.dispatch[17]={onReceive = NetProtoLearning.recive.regist, send = NetProtoLearning.send.regist, logicName = "cmd4user"}
    --==============================
    NetProtoLearning.cmds = {
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
        local dis = NetProtoLearning.dispatch[cmd]
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
                local f = NetProtoLearning.send[command2]
                skynet.ret(skynet.pack(f(...)))
            else
                local f = CMD[command]
                skynet.ret(skynet.pack(f(command2, ...)))
            end
        end)
    
        skynet.register "NetProtoLearning"
    end)
end
