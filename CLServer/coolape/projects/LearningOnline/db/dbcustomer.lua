--[[
使用时特别注意：
1、常用方法如下，在不知道表里有没有数据时可以采用如下方法（可能会查询一次表）
    local obj＝ dbcustomer.instanse(custid);
    if obj:isEmpty() then
        -- 没有数据
    else
        -- 有数据
    end
2、使用如下用法时，程序会自动判断是否是insert还是update
    local obj＝ dbcustomer.new(data);
3、使用如下用法时，程序会自动判断是否是insert还是update
    local obj＝ dbcustomer.new();
    obj:init(data);
]]

require("class")
local skynet = require "skynet"
local tonumber = tonumber
require("dateEx")

-- 客户表
---@class dbcustomer
dbcustomer = class("dbcustomer")

dbcustomer.name = "customer"

dbcustomer.keys = {
    idx = "idx", -- 唯一标识
    custid = "custid", -- 客户id
    password = "password", -- 客户密码
    name = "name", -- 客户名字
    crtTime = "crtTime", -- 创建时间
    lastEnTime = "lastEnTime", -- 最后登陆时间
    status = "status", -- 状态 0:正常;
    phone = "phone", -- 电话
    phone2 = "phone2", -- 紧急电话
    email = "email", -- 邮箱
    channel = "channel", -- 渠道来源
    belongid = "belongid", -- 归属老师id
    groupid = "groupid", -- 组id(权限角色管理)
    note = "note", -- 备注
}

function dbcustomer:ctor(v)
    self.__name__ = "customer"    -- 表名
    self.__isNew__ = nil -- false:说明mysql里已经有数据了
    if v then
        self:init(v)
    end
end

function dbcustomer:init(data, isNew)
    data = dbcustomer.validData(data)
    self.__key__ = data.custid
    local hadCacheData = false
    if self.__isNew__ == nil and isNew == nil then
        local d = skynet.call("CLDB", "lua", "get", dbcustomer.name, self.__key__)
        if d == nil then
            d = skynet.call("CLMySQL", "lua", "exesql", dbcustomer.querySql(nil, data.custid))
            if d and d.errno == nil and #d > 0 then
                self.__isNew__ = false
            else
                self.__isNew__ = true
            end
        else
            hadCacheData = true
            self.__isNew__ = false
        end
    else
        self.__isNew__ = isNew
    end
    if self.__isNew__ then
        -- 说明之前表里没有数据，先入库
        local sql = skynet.call("CLDB", "lua", "GETINSERTSQL", self.__name__, data)
        local r = skynet.call("CLMySQL", "lua", "save", sql)
        if r == nil or r.errno == nil then
            self.__isNew__ = false
        else
            return false
        end
    end
    if not hadCacheData then
        skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, data)
    end
    skynet.call("CLDB", "lua", "SETUSE", self.__name__, self.__key__)
    return true
end

function dbcustomer:tablename() -- 取得表名
    return self.__name__
end

function dbcustomer:value2copy()  -- 取得数据复样，注意是只读的数据且只有当前时刻是最新的，如果要取得最新数据及修改数据，请用get、set
    local ret = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__)
    if ret then
        ret.crtTime = self:get_crtTime()
        ret.lastEnTime = self:get_lastEnTime()
    end
    return ret
end

function dbcustomer:refreshData(data)
    if data == nil or self.__key__ == nil then
        skynet.error("dbcustomer:refreshData error!")
        return
    end
    local orgData = self:value2copy()
    if orgData == nil then
        skynet.error("get old data error!!")
    end
    for k, v in pairs(data) do
        orgData[k] = v
    end
    orgData = dbcustomer.validData(orgData)
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, orgData)
end

function dbcustomer:set_idx(v)
    -- 唯一标识
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_idx],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "idx", v)
end
function dbcustomer:get_idx()
    -- 唯一标识
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "idx")
    return (tonumber(val) or 0)
end

function dbcustomer:set_custid(v)
    -- 客户id
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_custid],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "custid", v)
end
function dbcustomer:get_custid()
    -- 客户id
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "custid")
end

function dbcustomer:set_password(v)
    -- 客户密码
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_password],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "password", v)
end
function dbcustomer:get_password()
    -- 客户密码
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "password")
end

function dbcustomer:set_name(v)
    -- 客户名字
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_name],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "name", v)
end
function dbcustomer:get_name()
    -- 客户名字
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "name")
end

function dbcustomer:set_crtTime(v)
    -- 创建时间
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_crtTime],please init first!!")
        return nil
    end
    if type(v) == "number" then
        v = dateEx.seconds2Str(v/1000)
    end
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "crtTime", v)
end
function dbcustomer:get_crtTime()
    -- 创建时间
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "crtTime")
    if type(val) == "string" then
        return dateEx.str2Seconds(val)*1000 -- 转成毫秒
    else
        return val
    end
end

function dbcustomer:set_lastEnTime(v)
    -- 最后登陆时间
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_lastEnTime],please init first!!")
        return nil
    end
    if type(v) == "number" then
        v = dateEx.seconds2Str(v/1000)
    end
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "lastEnTime", v)
end
function dbcustomer:get_lastEnTime()
    -- 最后登陆时间
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "lastEnTime")
    if type(val) == "string" then
        return dateEx.str2Seconds(val)*1000 -- 转成毫秒
    else
        return val
    end
end

function dbcustomer:set_status(v)
    -- 状态 0:正常;
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_status],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "status", v)
end
function dbcustomer:get_status()
    -- 状态 0:正常;
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "status")
    return (tonumber(val) or 0)
end

function dbcustomer:set_phone(v)
    -- 电话
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_phone],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "phone", v)
end
function dbcustomer:get_phone()
    -- 电话
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "phone")
end

function dbcustomer:set_phone2(v)
    -- 紧急电话
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_phone2],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "phone2", v)
end
function dbcustomer:get_phone2()
    -- 紧急电话
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "phone2")
end

function dbcustomer:set_email(v)
    -- 邮箱
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_email],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "email", v)
end
function dbcustomer:get_email()
    -- 邮箱
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "email")
end

function dbcustomer:set_channel(v)
    -- 渠道来源
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_channel],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "channel", v)
end
function dbcustomer:get_channel()
    -- 渠道来源
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "channel")
end

function dbcustomer:set_belongid(v)
    -- 归属老师id
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_belongid],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "belongid", v)
end
function dbcustomer:get_belongid()
    -- 归属老师id
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "belongid")
    return (tonumber(val) or 0)
end

function dbcustomer:set_groupid(v)
    -- 组id(权限角色管理)
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_groupid],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "groupid", v)
end
function dbcustomer:get_groupid()
    -- 组id(权限角色管理)
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "groupid")
    return (tonumber(val) or 0)
end

function dbcustomer:set_note(v)
    -- 备注
    if self:isEmpty() then
        skynet.error("[dbcustomer:set_note],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "note", v)
end
function dbcustomer:get_note()
    -- 备注
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "note")
end

-- 把数据flush到mysql里， immd=true 立即生效
function dbcustomer:flush(immd)
    local sql
    if self.__isNew__ then
        sql = skynet.call("CLDB", "lua", "GETINSERTSQL", self.__name__, self:value2copy())
    else
        sql = skynet.call("CLDB", "lua", "GETUPDATESQL", self.__name__, self:value2copy())
    end
    return skynet.call("CLMySQL", "lua", "save", sql, immd)
end

function dbcustomer:isEmpty()
    return (self.__key__ == nil) or (self:get_custid() == nil)
end

function dbcustomer:release()
    skynet.call("CLDB", "lua", "SETUNUSE", self.__name__, self.__key__)
    self.__isNew__ = nil
    self.__key__ = nil
end

function dbcustomer:delete()
    local d = self:value2copy()
    skynet.call("CLDB", "lua", "SETUNUSE", self.__name__, self.__key__)
    skynet.call("CLDB", "lua", "REMOVE", self.__name__, self.__key__)
    local sql = skynet.call("CLDB", "lua", "GETDELETESQL", self.__name__, d)
    return skynet.call("CLMySQL", "lua", "EXESQL", sql)
end

---@public 设置触发器（当有数据改变时回调）
---@param server 触发回调服务地址
---@param cmd 触发回调服务方法
---@param fieldKey 字段key(可为nil)
function dbcustomer:setTrigger(server, cmd, fieldKey)
    skynet.call("CLDB", "lua", "ADDTRIGGER", self.__name__, self.__key__, server, cmd, fieldKey)
end

---@param server 触发回调服务地址
---@param cmd 触发回调服务方法
---@param fieldKey 字段key(可为nil)
function dbcustomer:unsetTrigger(server, cmd, fieldKey)
    skynet.call("CLDB", "lua", "REMOVETRIGGER", self.__name__, self.__key__, server, cmd, fieldKey)
end

function dbcustomer.querySql(idx, custid)
    -- 如果某个参数为nil,则where条件中不包括该条件
    local where = {}
    if idx then
        table.insert(where, "`idx`=" .. idx)
    end
    if custid then
        table.insert(where, "`custid`=" .. "'" .. custid  .. "'")
    end
    if #where > 0 then
        return "SELECT * FROM customer WHERE " .. table.concat(where, " and ") .. ";"
    else
       return "SELECT * FROM customer;"
    end
end

---@public 取得一个组
---@param forceSelect boolean 强制从mysql取数据
---@param orderby string 排序
function dbcustomer.getListBychannel(channel, forceSelect, orderby, limitOffset, limitNum)
    if orderby and orderby ~= "" then
        forceSelect = true
    end
    local data
    local ret = {}
    local cachlist, isFullCached, list
    local groupInfor = skynet.call("CLDB", "lua", "GETGROUP", dbcustomer.name, channel) or {}
    cachlist = groupInfor[1] or {}
    isFullCached = groupInfor[2]
    if isFullCached == true and (not forceSelect) then
        list = cachlist
        for k, v in pairs(list) do
            data = dbcustomer.new(v, false)
            table.insert(ret, data:value2copy())
            data:release()
        end
    else
        local sql = "SELECT * FROM customer WHERE channel=" .. "'" .. channel .. "'" ..  (orderby and " ORDER BY" ..  orderby or "") .. ((limitOffset and limitNum) and (" LIMIT " ..  limitOffset .. "," .. limitNum) or "") .. ";"
        list = skynet.call("CLMySQL", "lua", "exesql", sql)
        if list and list.errno then
            skynet.error("[dbcustomer.getGroup] sql error==" .. sql)
            return nil
         end
         for i, v in ipairs(list) do
             local key = tostring(v.custid)
             local d = cachlist[key]
             if d ~= nil then
                 -- 用缓存的数据才是最新的
                 list[i] = d
                 cachlist[key] = nil
             end
         end
         for k ,v in pairs(cachlist) do
             table.insert(list, v)
         end
         cachlist = nil
         for k, v in ipairs(list) do
             data = dbcustomer.new(v, false)
             ret[k] = data:value2copy()
             data:release()
         end
     end
     list = nil
     -- 设置当前缓存数据是全的数据
     skynet.call("CLDB", "lua", "SETGROUPISFULL", dbcustomer.name, channel)
     return ret
end

---@public 取得一个组
---@param forceSelect boolean 强制从mysql取数据
---@param orderby string 排序
function dbcustomer.getListBybelongid(belongid, forceSelect, orderby, limitOffset, limitNum)
    if orderby and orderby ~= "" then
        forceSelect = true
    end
    local data
    local ret = {}
    local cachlist, isFullCached, list
    local groupInfor = skynet.call("CLDB", "lua", "GETGROUP", dbcustomer.name, belongid) or {}
    cachlist = groupInfor[1] or {}
    isFullCached = groupInfor[2]
    if isFullCached == true and (not forceSelect) then
        list = cachlist
        for k, v in pairs(list) do
            data = dbcustomer.new(v, false)
            table.insert(ret, data:value2copy())
            data:release()
        end
    else
        local sql = "SELECT * FROM customer WHERE belongid=" .. belongid ..  (orderby and " ORDER BY" ..  orderby or "") .. ((limitOffset and limitNum) and (" LIMIT " ..  limitOffset .. "," .. limitNum) or "") .. ";"
        list = skynet.call("CLMySQL", "lua", "exesql", sql)
        if list and list.errno then
            skynet.error("[dbcustomer.getGroup] sql error==" .. sql)
            return nil
         end
         for i, v in ipairs(list) do
             local key = tostring(v.custid)
             local d = cachlist[key]
             if d ~= nil then
                 -- 用缓存的数据才是最新的
                 list[i] = d
                 cachlist[key] = nil
             end
         end
         for k ,v in pairs(cachlist) do
             table.insert(list, v)
         end
         cachlist = nil
         for k, v in ipairs(list) do
             data = dbcustomer.new(v, false)
             ret[k] = data:value2copy()
             data:release()
         end
     end
     list = nil
     -- 设置当前缓存数据是全的数据
     skynet.call("CLDB", "lua", "SETGROUPISFULL", dbcustomer.name, belongid)
     return ret
end

function dbcustomer.validData(data)
    if data == nil then return nil end

    if type(data.idx) ~= "number" then
        data.idx = tonumber(data.idx) or 0
    end
    if type(data.crtTime) == "number" then
        data.crtTime = dateEx.seconds2Str(data.crtTime/1000)
    end
    if type(data.lastEnTime) == "number" then
        data.lastEnTime = dateEx.seconds2Str(data.lastEnTime/1000)
    end
    if type(data.status) ~= "number" then
        data.status = tonumber(data.status) or 0
    end
    if type(data.belongid) ~= "number" then
        data.belongid = tonumber(data.belongid) or 0
    end
    if type(data.groupid) ~= "number" then
        data.groupid = tonumber(data.groupid) or 0
    end
    return data
end

function dbcustomer.instanse(custid)
    if type(custid) == "table" then
        local d = custid
        custid = d.custid
    end
    if custid == nil then
        skynet.error("[dbcustomer.instanse] all input params == nil")
        return nil
    end
    local key = (custid or "")
    if key == "" then
        error("the key is null", 0)
    end
    ---@type dbcustomer
    local obj = dbcustomer.new()
    local d = skynet.call("CLDB", "lua", "get", dbcustomer.name, key)
    if d == nil then
        d = skynet.call("CLMySQL", "lua", "exesql", dbcustomer.querySql(nil, custid))
        if d and d.errno == nil and #d > 0 then
            if #d == 1 then
                d = d[1]
                -- 取得mysql表里的数据
                obj.__isNew__ = false
                obj.__key__ = key
                obj:init(d)
            else
                error("get data is more than one! count==" .. #d .. ", lua==dbcustomer")
            end
        else
            -- 没有数据
            obj.__isNew__ = true
        end
    else
        obj.__isNew__ = false
        obj.__key__ = key
        skynet.call("CLDB", "lua", "SETUSE", dbcustomer.name, key)
    end
    return obj
end

------------------------------------
return dbcustomer
