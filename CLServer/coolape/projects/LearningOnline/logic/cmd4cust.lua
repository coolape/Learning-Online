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
        ---@type NetProtoLearning.ST_retInfor
        local ret = {}
        ret.code = Errcode.ok
        ---@type NetProtoLearning.ST_custInfor
        local custInfor = {}
        custInfor.idx = 1234567890

        local ret = skynet.call(NetProto, "lua", "send", m.cmd, ret, custInfor, 98754321, m)
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
