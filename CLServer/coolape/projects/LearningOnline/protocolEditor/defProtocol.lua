--[[
-- 定义接口协议
--]]
defProtocol = {}
defProtocol.name = "NetProtoLearn" -- 协议名字
defProtocol.isSendClientInt2bio = false -- 发送给客户端时是否把int转成bio
defProtocol.compatibleJsonp = true;     -- 是否考虑兼容json
defProtocol.isGenLuaClientFile = false -- 生成lua客户端接口文件
defProtocol.isGenJsClientFile = true -- 生成js客户端接口文件
--===================================================
--===================================================
--===================================================
--[[ 数据结构定义,格式如下

defProtocol.structs.数据结构名 = {
    "数据结构的说明",
    {
        字段1 = { 可以确定类型的初始值, "字段说明" },
        字段2 = { 可以确定类型的初始值, "字段说明" },
    }
}
例如：
defProtocol.structs.retInfor = {
    "返回信息",
    {
        code = { 1, "返回值" },
        msg = { "", "返回消息" },
    }
}

.注意每个字段对应一个list，list[1]=设置一个值，以确定该字段的类型,可以嵌套其它数据结构, list[2]=该字段的备注说明（可以没有）
例如：
defProtocol.structs.AA = {
    "例1",
    {
        a = { 1, "说明" },
    }
}

defProtocol.structs.BB = {
    "例2",
    {
        b = { {d = defProtocol.structs.AA}, "该字段是一个table形，值是一个defProtocol.structs.AA数据结构" },
        c = { {defProtocol.structs.AA, defProtocol.structs.AA}, "该字段是个list，里面的值是defProtocol.structs.AA数据结构"},
    }
}

--]]
---@class defProtocol.structs
defProtocol.structs = {}
defProtocol.structs.retInfor = {
    "返回信息",
    {
        code = {1, "返回值"},
        msg = {"", "返回消息"}
    }
}

defProtocol.structs.custInfor = {
    "客户信息",
    {
        idx = {0, "唯一标识"}
        --name = { "", "名字" },
    }
}

--===================================================
--===================================================
--===================================================
local structs = defProtocol.structs
--===================================================
--===================================================
--===================================================
-- 接口定义
defProtocol.cmds = {
    --[[
login = {       -- 接口名
    desc="";       -- 接口说明
    input = {"userId", "password" };  -- 入参
    inputDesc = {"用户名","密码"};     -- 入参说明
    output = { structs.retInfor, structs.userInfor, "sysTime" };        -- 出参
    outputDesc = {"返回信息","用户信息","系统时间"};  -- 出参说明
    logic = "cmd4user";     -- 处理的接口的lua
};
--]]
    regist = {
        desc = "注册", -- 接口说明
        input = {"custId", "password", "name", "phone", "phone2", "email", "channel", "note"}, -- 入参
        inputDesc = {"客户id", "密码", "名字", "电话号码", "紧急联系电话", "邮箱", "渠道号", "备注"}, -- 入参说明
        output = {structs.retInfor, structs.custInfor, "sessionID"}, -- 出参
        outputDesc = {"返回信息", "客户信息", "会话id"}, -- 出参说明
        logic = "cmd4cust"
    },
    login = {
        desc = "登陆", -- 接口说明
        input = {"custId", "password"}, -- 入参
        inputDesc = {"客户id", "密码"}, -- 入参说明
        output = {structs.retInfor, structs.custInfor, "sessionID"}, -- 出参
        outputDesc = {"返回信息", "客户信息", "会话id"}, -- 出参说明
        logic = "cmd4cust"
    },
    logout = {
        desc = "登出", -- 接口说明
        input = {"custId"}, -- 入参
        inputDesc = {"客户名"}, -- 入参说明
        output = {structs.retInfor}, -- 出参
        outputDesc = {"返回信息"}, -- 出参说明
        logic = "cmd4cust"
    }
}

return defProtocol
