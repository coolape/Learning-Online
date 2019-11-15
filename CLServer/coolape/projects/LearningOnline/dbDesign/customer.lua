local tab = {
    name = "customer",
    desc = "客户表",
    columns = {
        { "idx", "int(11) NOT NULL", "唯一标识" },
        { "custid", "varchar(45) NOT NULL", "客户id" },
        { "password", "varchar(45) NOT NULL", "客户密码" },
        { "name", "varchar(128) NOT NULL", "客户名字" },
        { "crtTime", "datetime", "创建时间" },
        { "lastEnTime", "datetime", "最后登陆时间" },
        { "status", "TINYINT", "状态 0:正常;" },
        { "phone", "varchar(45)", "电话" },
        { "phone2", "varchar(45)", "紧急电话" },
        { "email", "varchar(45)", "邮箱" },
        { "channel", "varchar(45)", "渠道来源" },
        { "belongid", "int(11)", "归属老师id" },
        { "groupid", "TINYINT", "组id(权限角色管理), 1:家长,2:销售,3:教师,100:管理员" },
        { "note", "TEXT", "备注" },
    },
    primaryKey = {
        "idx",
        "custid",
    },
    cacheKey = { -- 缓存key
        "custid",
    },
    groupKey = {{"channel"}, {"belongid"}}, -- 组key
    defaultData = {}, -- 初始数据
}
return tab
