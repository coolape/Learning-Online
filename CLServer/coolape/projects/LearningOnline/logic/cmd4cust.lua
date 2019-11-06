local skynet = require("skynet")
require("dbcustomer")
require("dbuser")
require("Errcode")
---@type CLUtl
local CLUtl = require("CLUtl")
local DBUtl = require "DBUtl"
---@type dateEx
local dateEx = require("dateEx")
---@type NetProtoUsermgr
local NetProto = skynet.getenv("NetProtoName")
require("CLGlobal")
local table = table

---@public 客户的处理
local cmd4cust = {}

cmd4cust.CMD = {
    ---@public 注册
    ---@param m NetProtoLearn.RC_regist
    regist = function(m, fd, agent)
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        local custId = tonumber(m.custId)
        if custId == nil or CLUtl.isNilOrEmpty(m.name) or CLUtl.isNilOrEmpty(m.phone) or CLUtl.isNilOrEmpty(m.password) then
            ret.code = Errcode.paramsIsNil
            ret.msg = "参数错误，注意必填项目"
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
        m[dbcustomer.keys.crtTime] = dateEx.nowMS()
        m[dbcustomer.keys.lastEnTime] = dateEx.nowMS()
        m[dbcustomer.keys.status] = 0
        cust:init(m, true)

        -- 会话id//TODO:
        local sessionid = dateEx.nowMS()

        ret.code = Errcode.ok
        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, cust:value2copy(), sessionid, m)
        -- 注意要释放
        cust.release()
        return ret
    end,
    ---@public 登陆
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
        -- 会话id//TODO:
        local sessionid = dateEx.nowMS()
        local users = dbuser.getListBycustid(cust.get_custid())
        -- 取得用户列表（取得孩子）
        ---@type NetProtoLearn.ST_custInfor
        local custInfor = cust:value2copy()
        custInfor.users = users

        ret.code = Errcode.ok
        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, custInfor, sessionid, m)
        -- 注意要释放
        cust.release()
        return ret
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
