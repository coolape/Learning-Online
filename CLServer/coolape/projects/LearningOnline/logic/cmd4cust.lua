local skynet = require("skynet")
require("public.include")
require("dbcustomer")
require("dbuser")
require("Errcode")
---@type NetProtoLearn
local NetProto = skynet.getenv("NetProtoName")
local table = table

---@public 客户的处理
local cmd4cust = {}

cmd4cust.CMD = {
    ---@public 注册
    ---@param m NetProtoLearn.RC_regist
    regist = function(m, fd, agent)
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        local custId = m.custid
        if
            CLUtl.isNilOrEmpty(custId) or CLUtl.isNilOrEmpty(m.password) or CLUtl.isNilOrEmpty(m.name) or
                CLUtl.isNilOrEmpty(m.phone)
         then
            ret.code = Errcode.paramsIsNil
            ret.msg = "参数错误，注意必填字段"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret, {}, 0, m)
        end

        ---@type dbcustomer
        local cust = dbcustomer.instanse(custId)
        if cust and (not cust:isEmpty()) then
            ret.code = Errcode.uidregisted
            ret.msg = "id已经被注册"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret, {}, 0, m)
        end

        m[dbcustomer.keys.idx] = DBUtl.nextVal("customer")
        m[dbcustomer.keys.password] = m.password
        m[dbcustomer.keys.crtTime] = dateEx.nowMS()
        m[dbcustomer.keys.lastEnTime] = dateEx.nowMS()
        m[dbcustomer.keys.status] = 0
        cust:init(m, true)

        -- 会话id
        local sessionid = skynet.call("CLSessionMgr", "lua", "SET", cust:get_custid())

        ret.code = Errcode.ok
        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, cust:value2copy(), sessionid, m)
        -- 注意要释放
        cust:release()
        return ret
    end,
    ---@public 登陆
    ---@param m NetProtoLearn.RC_login
    login = function(m, fd, agent)
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        local custId = tonumber(m.custId)

        ---@type dbcustomer
        local cust = dbcustomer.instanse(custId)
        if cust == nil or cust:isEmpty() then
            ret.code = Errcode.needregist
            ret.msg = "未注册"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret, {}, 0, m)
        end
        if cust:get_password() ~= m.password then
            ret.code = Errcode.passwordError
            ret.msg = "账号或密码错误"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret, nil, 0, m)
        end
        -- 会话id
        local sessionid = skynet.call("CLSessionMgr", "lua", "SET", cust:get_custid())

        -- 取得用户列表（取得学生）
        local users = dbuser.getListBycustid(cust.get_custid())
        ---@type NetProtoLearn.ST_custInfor
        local custInfor = cust:value2copy()
        custInfor.users = users

        ret.code = Errcode.ok
        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, custInfor, sessionid, m)
        -- 注意要释放
        cust:release()
        return ret
    end,
    ---@public 退出
    ---@param m NetProtoLearn.RC_logout
    logout = function(m, fd, agent)
        if not CLUtl.isNilOrEmpty(m.__session__) then
            skynet.call("CLSessionMgr", "lua", "delete", m.__session__)
        end
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        ret.code = Errcode.ok
        return skynet.call(NetProto, "lua", "send", m.cmd, ret, m)
    end
}

skynet.start(
    function()
        skynet.dispatch(
            "lua",
            function(_, _, command, ...)
                local f = cmd4cust.CMD[command]
                if f then
                    skynet.ret(skynet.pack(f(...)))
                else
                    printe("get cmd func is nil")
                end
            end
        )
    end
)
