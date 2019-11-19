local tab = {
    name = "user",
    desc = "用户表",
    columns = {
        { "idx", "int(11) NOT NULL", "唯一标识" },
        { "status", "TINYINT", "状态 0:正常;" },
        { "custid", "varchar(45) ", "归属的客户id" },
        { "name", "varchar(128) NOT NULL", "名字" },
        { "birthday", "datetime", "生日" },
        { "sex", "TINYINT", "性别 0:男, 1:女" },
        { "school", "varchar(256)", "学校" },
        { "belongid", "int(11)", "归属老师id" },
        { "crtTime", "datetime", "创建时间" },
        { "note", "TEXT", "备注" },
    },
    primaryKey = {
        "idx",
    },
    cacheKey = { -- 缓存key
        "idx",
    },
    groupKey = {{"custid"}, {"belongid"}}, -- 组key
    defaultData = {}, -- 初始数据
}
return tab
