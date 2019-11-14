local skynet = require("skynet")
require("include")
require("dbuser")
require("Errcode")
---@type NetProtoLearn
local NetProto = skynet.getenv("NetProtoName")
local table = table

local cmd4user = {}

cmd4user.CMD = {
    ---@param m NetProtoLearn.RC_addUser
    addUser = function(m, fd)
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        if CLUtl.isNilOrEmpty(m.name) or CLUtl.isNilOrEmpty(m.custid) or CLUtl.isNilOrEmpty(m.birthday) then
            ret.code = Errcode.paramsIsNil
            ret.code = "参数错误，注意必填项目"

            return skynet.call(NetProto, "lua", "send", m.cmd, ret, nil)
        end
        local user = dbuser.new()
        m[dbuser.keys.idx] = DBUtl.nextVal("user")
        m[dbuser.keys.crtTime] = dateEx.nowMS()
        m[dbuser.keys.belongid] = 0
        user:init(m, true)

        local result = skynet.call(NetProto, "lua", "send", m.cmd, ret, user:value2copy())
        user:release()
        return result
    end
}

skynet.start(
    function()
        skynet.dispatch(
            "lua",
            function(_, _, command, ...)
                local f = cmd4user.CMD[command]
                skynet.ret(skynet.pack(f(...)))
            end
        )
    end
)
