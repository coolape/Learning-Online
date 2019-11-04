do
    ---@class NetProtoLearning
    NetProtoLearning = {}
    local table = table
    require("bio.BioUtl")

    NetProtoLearning.__sessionID = 0 -- 会话ID
    NetProtoLearning.dispatch = {}
    local __callbackInfor = {} -- 回调信息
    local __callTimes = 1
    ---@public 设计回调信息
    local setCallback = function (callback, orgs, ret)
       if callback then
           local callbackKey = os.time() + __callTimes
           __callTimes = __callTimes + 1
           __callbackInfor[callbackKey] = {callback, orgs}
           ret[3] = callbackKey
        end
    end
    ---@public 处理回调
    local doCallback = function(map, result)
        local callbackKey = map[3]
        if callbackKey then
            local cbinfor = __callbackInfor[callbackKey]
            if cbinfor then
                pcall(cbinfor[1], cbinfor[2], result)
            end
            __callbackInfor[callbackKey] = nil
        end
    end
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
    NetProtoLearning.send = {
    -- 登出
    logout = function(custId, __callback, __orgs) -- __callback:接口回调, __orgs:回调参数
        local ret = {}
        ret[0] = 22
        ret[1] = NetProtoLearning.__sessionID
        ret[14] = custId; -- 客户名
        setCallback(__callback, __orgs, ret)
        return ret
    end,
    -- 登陆
    login = function(custId, password, __callback, __orgs) -- __callback:接口回调, __orgs:回调参数
        local ret = {}
        ret[0] = 23
        ret[1] = NetProtoLearning.__sessionID
        ret[14] = custId; -- 客户id
        ret[15] = password; -- 密码
        setCallback(__callback, __orgs, ret)
        return ret
    end,
    -- 注册
    regist = function(custId, password, name, phone, email, channel, note, __callback, __orgs) -- __callback:接口回调, __orgs:回调参数
        local ret = {}
        ret[0] = 24
        ret[1] = NetProtoLearning.__sessionID
        ret[14] = custId; -- 客户id
        ret[15] = password; -- 密码
        ret[16] = name; -- 名字
        ret[17] = phone; -- 电话号码
        ret[18] = email; -- 邮箱
        ret[19] = channel; -- 渠道号
        ret[20] = note; -- 备注
        setCallback(__callback, __orgs, ret)
        return ret
    end,
    }
    --==============================
    NetProtoLearning.recive = {
    ---@class NetProtoLearning.RC_logout
    ---@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    logout = function(map)
        local ret = {}
        ret.cmd = "logout"
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) -- 返回信息
        doCallback(map, ret)
        return ret
    end,
    ---@class NetProtoLearning.RC_login
    ---@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    login = function(map)
        local ret = {}
        ret.cmd = "login"
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) -- 返回信息
        doCallback(map, ret)
        return ret
    end,
    ---@class NetProtoLearning.RC_regist
    ---@field public retInfor NetProtoLearning.ST_retInfor 返回信息
    regist = function(map)
        local ret = {}
        ret.cmd = "regist"
        ret.retInfor = NetProtoLearning.ST_retInfor.parse(map[2]) -- 返回信息
        doCallback(map, ret)
        return ret
    end,
    }
    --==============================
    NetProtoLearning.dispatch[22]={onReceive = NetProtoLearning.recive.logout, send = NetProtoLearning.send.logout}
    NetProtoLearning.dispatch[23]={onReceive = NetProtoLearning.recive.login, send = NetProtoLearning.send.login}
    NetProtoLearning.dispatch[24]={onReceive = NetProtoLearning.recive.regist, send = NetProtoLearning.send.regist}
    --==============================
    NetProtoLearning.cmds = {
        logout = "logout", -- 登出,
        login = "login", -- 登陆,
        regist = "regist", -- 注册
    }
    --==============================
    return NetProtoLearning
end
