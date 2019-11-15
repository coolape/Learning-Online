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
    end,
    ---@param m NetProtoLearn.RC_delUser
    delUser = function(m, fd)
        local user = dbuser.instanse(m.idx)
        if not user:isEmpty() then
            user:delete()
        end
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        ret.code = Errcode.ok
        return skynet.call(NetProto, "lua", "send", m.cmd, ret)
    end,
    ---@param m NetProtoLearn.RC_bandingUser
    bandingUser = function(m, fd)
        ---@type NetProtoLearn.ST_retInfor
        local ret = {}
        local user = dbuser.instanse(m.uidx)
        if user:isEmpty() then
            ret.code = Errcode.userIsNil
            ret.msg = "取得用户为空"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret)
        end
        local cust = dbcustomer.instanse(m.cidx)
        if cust:isEmpty() then
            ret.code = Errcode.custIsNil
            ret.msg = "取得客户为空"
            return skynet.call(NetProto, "lua", "send", m.cmd, ret)
        end
        user:set_belongid(tonumber(m.cidx))
        user:release()
        cust:release()
        ret.code = Errcode.ok
        return skynet.call(NetProto, "lua", "send", m.cmd, ret)
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
