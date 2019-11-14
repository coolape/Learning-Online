local tab = {
    name = "cfgsubject",
    desc = "课程配置表",
    columns = {
        {"idx", "int(11) NOT NULL", "唯一标识"},
        {"status", "TINYINT", "状态 0:正常;1:废除"},
        {"gid", "int(4) NOT NULL", "分类id一"},
        {"gid2", "int(4) NOT NULL", "分类id二"},
        {"gid3", "int(4) NOT NULL", "分类id三"},
        {"name", "varchar(512) NOT NULL", "名字"},
        {"price", "int(11) NOT NULL", "价格"},
        {"note", "TEXT", "备注"}
    },
    primaryKey = {
        "idx"
    },
    cacheKey = {
        -- 缓存key
        "idx"
    },
    groupKey = {{"gid"}, {"gid", "gid2"}, {"gid", "gid2", "gid3"}}, -- 组key
    defaultData = {} -- 初始数据
}
return tab
