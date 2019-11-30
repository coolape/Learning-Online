--[[
-- 定义接口协议
--]]
defProtocol = {}
defProtocol.name = "NetProtoLearn" -- 协议名字
defProtocol.isSendClientInt2bio = false -- 发送给客户端时是否把int转成bio
defProtocol.compatibleJsonp = true -- 是否考虑兼容json
defProtocol.isGenLuaClientFile = false -- 生成lua客户端接口文件
defProtocol.isGenJsClientFile = true -- 生成js客户端接口文件
defProtocol.isCheckSession = true -- 生成检测session超时的代码
defProtocol.donotCheckSessionCMDs = {"login", "regist"} -- 不做session超时检测的接口
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

defProtocol.structs.userInfor = {
    "用户信息",
    {
        idx = {0, "唯一标识"},
        custid = {0, "账号id"},
        name = {"", "名字"},
        birthday = {"", "生日"},
        sex = {0, "性别 0:男, 1:女"},
        school = {"", "学校"},
        status = {0, "状态"},
        belongid = {0, "归属老师id"},
        note = {"", "备注"}
    }
}

defProtocol.structs.custInfor = {
    "客户信息",
    {
        idx = {0, "唯一标识"},
        custid = {0, "账号id"},
        name = {"", "名字"},
        status = {0, "状态"},
        phone = {"", "电话"},
        phone2 = {"", "紧急电话"},
        email = {"", "邮箱"},
        channel = {"", "渠道来源"},
        belongid = {0, "归属老师id"},
        groupid = {0, "组id 1:家长,2:销售,3:教师,100:管理员"},
        note = {"", "备注"},
        users = {{defProtocol.structs.userInfor, defProtocol.structs.userInfor}, "用户列表"}
    }
}

defProtocol.structs.cfgSubject = {
    "课程/科目配置",
    {
        idx = {0, "唯一标识"},
        status = {0, "状态 0:正常;1:废除"},
        gid = {0, "分类id一"},
        gid2 = {0, "分类id二"},
        gid3 = {0, "分类id三"},
        name = {"", "名字"},
        price = {0, "价格"},
        note = {"", "备注"}
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
        input = {"custid", "password", "name", "phone", "email", "channel", "note"}, -- 入参
        inputDesc = {"客户id", "密码", "名字", "电话", "邮箱", "来源渠道", "备注"}, -- 入参说明
        output = {structs.retInfor, structs.custInfor, "sessionID"}, -- 出参
        outputDesc = {"返回信息", "客户信息", "会话id"}, -- 出参说明
        logic = "cmd4cust"
    },
    login = {
        desc = "登陆", -- 接口说明
        input = {"custid", "password"}, -- 入参
        inputDesc = {"客户id", "密码"}, -- 入参说明
        output = {structs.retInfor, structs.custInfor, "sessionID"}, -- 出参
        outputDesc = {"返回信息", "客户信息", "会话id"}, -- 出参说明
        logic = "cmd4cust"
    },
    logout = {
        desc = "登出", -- 接口说明
        input = {}, -- 入参
        inputDesc = {}, -- 入参说明
        output = {structs.retInfor}, -- 出参
        outputDesc = {"返回信息"}, -- 出参说明
        logic = "cmd4cust"
    },
    addUser = {
        desc = "添加用户", -- 接口说明
        input = {"custid", "name", "birthday", "sex", "school"}, -- 入参
        inputDesc = {"客户id", "姓名", "生日", "性别 0:男, 1:女", "学校(可选)"}, -- 入参说明
        output = {structs.retInfor, structs.userInfor}, -- 出参
        outputDesc = {"返回信息", "用户信息"}, -- 出参说明
        logic = "cmd4user"
    },
    delUser = {
        desc = "删除用户", -- 接口说明
        input = {"idx"}, -- 入参
        inputDesc = {"用户id"}, -- 入参说明
        output = {structs.retInfor}, -- 出参
        outputDesc = {"返回信息"}, -- 出参说明
        logic = "cmd4user"
    },
    bandingUser = {
        desc = "分配用户给教师", -- 接口说明
        input = {"uidx", "cidx"}, -- 入参
        inputDesc = {"用户id", "教师id(客户id)"}, -- 入参说明
        output = {structs.retInfor}, -- 出参
        outputDesc = {"返回信息"}, -- 出参说明
        logic = "cmd4user"
    },
    configSubject = {
        desc = "配置课程", -- 接口说明
        input = {"name", "gid", "gid2", "gid3", "price", "note"}, -- 入参
        inputDesc = {"名字", "分类id一", "分类id二", "分类id三", "价格", "备注"}, -- 入参说明
        output = {structs.retInfor, defProtocol.structs.cfgSubject}, -- 出参
        outputDesc = {"返回信息", "课程的配置信息"}, -- 出参说明
        logic = "cmd4subject"
    },
    configCourse = {
        desc = "配置课件", -- 接口说明
        input = {}, -- 入参
        inputDesc = {}, -- 入参说明
        output = {structs.retInfor}, -- 出参
        outputDesc = {"返回信息"}, -- 出参说明
        logic = "cmd4course",
        httpType = "POST"
    }
}

return defProtocol
