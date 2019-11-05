local skynet = require("skynet")
require("dbcustomer")
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
    ---@public 登陆
    login = function(m, fd, agent)
        ---@type NetProtoIsland.ST_retInfor
        local ret = {}
        local custId = tonumber(m.custId)
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
        local sessionid = dateEx.nowMS()

        ret.code = Errcode.ok
        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, cust:value2copy(), sessionid, m)
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
