--[[
使用时特别注意：
1、常用方法如下，在不知道表里有没有数据时可以采用如下方法（可能会查询一次表）
    local obj＝ dbcfgsubject.instanse(idx);
    if obj:isEmpty() then
        -- 没有数据
    else
        -- 有数据
    end
2、使用如下用法时，程序会自动判断是否是insert还是update
    local obj＝ dbcfgsubject.new(data);
3、使用如下用法时，程序会自动判断是否是insert还是update
    local obj＝ dbcfgsubject.new();
    obj:init(data);
]]

require("class")
local skynet = require "skynet"
local tonumber = tonumber
require("dateEx")

-- 课程配置表
---@class dbcfgsubject
dbcfgsubject = class("dbcfgsubject")

dbcfgsubject.name = "cfgsubject"

dbcfgsubject.keys = {
    idx = "idx", -- 唯一标识
    status = "status", -- 状态 0:正常;1:废除
    gid = "gid", -- 分类id一
    gid2 = "gid2", -- 分类id二
    gid3 = "gid3", -- 分类id三
    name = "name", -- 名字
    price = "price", -- 价格
    note = "note", -- 备注
}

function dbcfgsubject:ctor(v)
    self.__name__ = "cfgsubject"    -- 表名
    self.__isNew__ = nil -- false:说明mysql里已经有数据了
    if v then
        self:init(v)
    end
end

function dbcfgsubject:init(data, isNew)
    data = dbcfgsubject.validData(data)
    self.__key__ = data.idx
    local hadCacheData = false
    if self.__isNew__ == nil and isNew == nil then
        local d = skynet.call("CLDB", "lua", "get", dbcfgsubject.name, self.__key__)
        if d == nil then
            d = skynet.call("CLMySQL", "lua", "exesql", dbcfgsubject.querySql(data.idx))
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

function dbcfgsubject:tablename() -- 取得表名
    return self.__name__
end

function dbcfgsubject:value2copy()  -- 取得数据复样，注意是只读的数据且只有当前时刻是最新的，如果要取得最新数据及修改数据，请用get、set
    local ret = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__)
    if ret then
    end
    return ret
end

function dbcfgsubject:refreshData(data)
    if data == nil or self.__key__ == nil then
        skynet.error("dbcfgsubject:refreshData error!")
        return
    end
    local orgData = self:value2copy()
    if orgData == nil then
        skynet.error("get old data error!!")
    end
    for k, v in pairs(data) do
        orgData[k] = v
    end
    orgData = dbcfgsubject.validData(orgData)
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, orgData)
end

function dbcfgsubject:set_idx(v)
    -- 唯一标识
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_idx],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "idx", v)
end
function dbcfgsubject:get_idx()
    -- 唯一标识
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "idx")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_status(v)
    -- 状态 0:正常;1:废除
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_status],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "status", v)
end
function dbcfgsubject:get_status()
    -- 状态 0:正常;1:废除
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "status")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_gid(v)
    -- 分类id一
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_gid],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "gid", v)
end
function dbcfgsubject:get_gid()
    -- 分类id一
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "gid")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_gid2(v)
    -- 分类id二
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_gid2],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "gid2", v)
end
function dbcfgsubject:get_gid2()
    -- 分类id二
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "gid2")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_gid3(v)
    -- 分类id三
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_gid3],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "gid3", v)
end
function dbcfgsubject:get_gid3()
    -- 分类id三
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "gid3")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_name(v)
    -- 名字
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_name],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "name", v)
end
function dbcfgsubject:get_name()
    -- 名字
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "name")
end

function dbcfgsubject:set_price(v)
    -- 价格
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_price],please init first!!")
        return nil
    end
    v = tonumber(v) or 0
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "price", v)
end
function dbcfgsubject:get_price()
    -- 价格
    local val = skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "price")
    return (tonumber(val) or 0)
end

function dbcfgsubject:set_note(v)
    -- 备注
    if self:isEmpty() then
        skynet.error("[dbcfgsubject:set_note],please init first!!")
        return nil
    end
    v = v or ""
    skynet.call("CLDB", "lua", "set", self.__name__, self.__key__, "note", v)
end
function dbcfgsubject:get_note()
    -- 备注
    return skynet.call("CLDB", "lua", "get", self.__name__, self.__key__, "note")
end

-- 把数据flush到mysql里， immd=true 立即生效
function dbcfgsubject:flush(immd)
    local sql
    if self.__isNew__ then
        sql = skynet.call("CLDB", "lua", "GETINSERTSQL", self.__name__, self:value2copy())
    else
        sql = skynet.call("CLDB", "lua", "GETUPDATESQL", self.__name__, self:value2copy())
    end
    return skynet.call("CLMySQL", "lua", "save", sql, immd)
end

function dbcfgsubject:isEmpty()
    return (self.__key__ == nil) or (self:get_idx() == nil)
end

function dbcfgsubject:release()
    skynet.call("CLDB", "lua", "SETUNUSE", self.__name__, self.__key__)
    self.__isNew__ = nil
    self.__key__ = nil
end

function dbcfgsubject:delete()
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
function dbcfgsubject:setTrigger(server, cmd, fieldKey)
    skynet.call("CLDB", "lua", "ADDTRIGGER", self.__name__, self.__key__, server, cmd, fieldKey)
end

---@param server 触发回调服务地址
---@param cmd 触发回调服务方法
---@param fieldKey 字段key(可为nil)
function dbcfgsubject:unsetTrigger(server, cmd, fieldKey)
    skynet.call("CLDB", "lua", "REMOVETRIGGER", self.__name__, self.__key__, server, cmd, fieldKey)
end

function dbcfgsubject.querySql(idx)
    -- 如果某个参数为nil,则where条件中不包括该条件
    local where = {}
    if idx then
        table.insert(where, "`idx`=" .. idx)
    end
    if #where > 0 then
        return "SELECT * FROM cfgsubject WHERE " .. table.concat(where, " and ") .. ";"
    else
       return "SELECT * FROM cfgsubject;"
    end
end

---@public 取得一个组
---@param forceSelect boolean 强制从mysql取数据
---@param orderby string 排序
function dbcfgsubject.getListBygid(gid, forceSelect, orderby, limitOffset, limitNum)
    if orderby and orderby ~= "" then
        forceSelect = true
    end
    local data
    local ret = {}
    local cachlist, isFullCached, list
    local groupInfor = skynet.call("CLDB", "lua", "GETGROUP", dbcfgsubject.name, gid) or {}
    cachlist = groupInfor[1] or {}
    isFullCached = groupInfor[2]
    if isFullCached == true and (not forceSelect) then
        list = cachlist
        for k, v in pairs(list) do
            data = dbcfgsubject.new(v, false)
            table.insert(ret, data:value2copy())
            data:release()
        end
    else
        local sql = "SELECT * FROM cfgsubject WHERE gid=" .. gid ..  (orderby and " ORDER BY" ..  orderby or "") .. ((limitOffset and limitNum) and (" LIMIT " ..  limitOffset .. "," .. limitNum) or "") .. ";"
        list = skynet.call("CLMySQL", "lua", "exesql", sql)
        if list and list.errno then
            skynet.error("[dbcfgsubject.getGroup] sql error==" .. sql)
            return nil
         end
         for i, v in ipairs(list) do
             local key = tostring(v.idx)
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
             data = dbcfgsubject.new(v, false)
             ret[k] = data:value2copy()
             data:release()
         end
     end
     list = nil
     -- 设置当前缓存数据是全的数据
     skynet.call("CLDB", "lua", "SETGROUPISFULL", dbcfgsubject.name, gid)
     return ret
end

---@public 取得一个组
---@param forceSelect boolean 强制从mysql取数据
---@param orderby string 排序
function dbcfgsubject.getListBygid_gid2(gid, gid2, forceSelect, orderby, limitOffset, limitNum)
    if orderby and orderby ~= "" then
        forceSelect = true
    end
    local data
    local ret = {}
    local cachlist, isFullCached, list
    local groupInfor = skynet.call("CLDB", "lua", "GETGROUP", dbcfgsubject.name, gid .. "_" .. gid2) or {}
    cachlist = groupInfor[1] or {}
    isFullCached = groupInfor[2]
    if isFullCached == true and (not forceSelect) then
        list = cachlist
        for k, v in pairs(list) do
            data = dbcfgsubject.new(v, false)
            table.insert(ret, data:value2copy())
            data:release()
        end
    else
        local sql = "SELECT * FROM cfgsubject WHERE gid=" .. gid .. " AND gid2=" .. gid2 ..  (orderby and " ORDER BY" ..  orderby or "") .. ((limitOffset and limitNum) and (" LIMIT " ..  limitOffset .. "," .. limitNum) or "") .. ";"
        list = skynet.call("CLMySQL", "lua", "exesql", sql)
        if list and list.errno then
            skynet.error("[dbcfgsubject.getGroup] sql error==" .. sql)
            return nil
         end
         for i, v in ipairs(list) do
             local key = tostring(v.idx)
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
             data = dbcfgsubject.new(v, false)
             ret[k] = data:value2copy()
             data:release()
         end
     end
     list = nil
     -- 设置当前缓存数据是全的数据
     skynet.call("CLDB", "lua", "SETGROUPISFULL", dbcfgsubject.name, gid .. "_" .. gid2)
     return ret
end

---@public 取得一个组
---@param forceSelect boolean 强制从mysql取数据
---@param orderby string 排序
function dbcfgsubject.getListBygid_gid2_gid3(gid, gid2, gid3, forceSelect, orderby, limitOffset, limitNum)
    if orderby and orderby ~= "" then
        forceSelect = true
    end
    local data
    local ret = {}
    local cachlist, isFullCached, list
    local groupInfor = skynet.call("CLDB", "lua", "GETGROUP", dbcfgsubject.name, gid .. "_" .. gid2 .. "_" .. gid3) or {}
    cachlist = groupInfor[1] or {}
    isFullCached = groupInfor[2]
    if isFullCached == true and (not forceSelect) then
        list = cachlist
        for k, v in pairs(list) do
            data = dbcfgsubject.new(v, false)
            table.insert(ret, data:value2copy())
            data:release()
        end
    else
        local sql = "SELECT * FROM cfgsubject WHERE gid=" .. gid .. " AND gid2=" .. gid2 .. " AND gid3=" .. gid3 ..  (orderby and " ORDER BY" ..  orderby or "") .. ((limitOffset and limitNum) and (" LIMIT " ..  limitOffset .. "," .. limitNum) or "") .. ";"
        list = skynet.call("CLMySQL", "lua", "exesql", sql)
        if list and list.errno then
            skynet.error("[dbcfgsubject.getGroup] sql error==" .. sql)
            return nil
         end
         for i, v in ipairs(list) do
             local key = tostring(v.idx)
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
             data = dbcfgsubject.new(v, false)
             ret[k] = data:value2copy()
             data:release()
         end
     end
     list = nil
     -- 设置当前缓存数据是全的数据
     skynet.call("CLDB", "lua", "SETGROUPISFULL", dbcfgsubject.name, gid .. "_" .. gid2 .. "_" .. gid3)
     return ret
end

function dbcfgsubject.validData(data)
    if data == nil then return nil end

    if type(data.idx) ~= "number" then
        data.idx = tonumber(data.idx) or 0
    end
    if type(data.status) ~= "number" then
        data.status = tonumber(data.status) or 0
    end
    if type(data.gid) ~= "number" then
        data.gid = tonumber(data.gid) or 0
    end
    if type(data.gid2) ~= "number" then
        data.gid2 = tonumber(data.gid2) or 0
    end
    if type(data.gid3) ~= "number" then
        data.gid3 = tonumber(data.gid3) or 0
    end
    if type(data.price) ~= "number" then
        data.price = tonumber(data.price) or 0
    end
    return data
end

function dbcfgsubject.instanse(idx)
    if type(idx) == "table" then
        local d = idx
        idx = d.idx
    end
    if idx == nil then
        skynet.error("[dbcfgsubject.instanse] all input params == nil")
        return nil
    end
    local key = (idx or "")
    if key == "" then
        error("the key is null", 0)
    end
    ---@type dbcfgsubject
    local obj = dbcfgsubject.new()
    local d = skynet.call("CLDB", "lua", "get", dbcfgsubject.name, key)
    if d == nil then
        d = skynet.call("CLMySQL", "lua", "exesql", dbcfgsubject.querySql(idx))
        if d and d.errno == nil and #d > 0 then
            if #d == 1 then
                d = d[1]
                -- 取得mysql表里的数据
                obj.__isNew__ = false
                obj.__key__ = key
                obj:init(d)
            else
                error("get data is more than one! count==" .. #d .. ", lua==dbcfgsubject")
            end
        else
            -- 没有数据
            obj.__isNew__ = true
        end
    else
        obj.__isNew__ = false
        obj.__key__ = key
        skynet.call("CLDB", "lua", "SETUSE", dbcfgsubject.name, key)
    end
    return obj
end

------------------------------------
return dbcfgsubject
