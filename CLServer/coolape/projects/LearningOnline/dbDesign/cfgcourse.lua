local tab = {
    name = "cfgcourse",
    desc = "课件配置表",
    columns = {
        {"idx", "int(11) NOT NULL", "唯一标识"},
        {"subjectidx", "int(4) NOT NULL", "课程idx"},
        {"status", "TINYINT", "状态 0:正常;1:废除"},
        {"name", "varchar(512) NOT NULL", "名字"},
        {"ppt", "varchar(512)", "ppt名"},
        {"pptpath", "varchar(512)", "ppt路径"},
        {"res", "varchar(512)", "资源名"},
        {"respath", "varchar(512)", "资源路径"},
        {"exercises_json", "TEXT", "练习题json"},
        {"note", "TEXT", "备注"}
    },
    primaryKey = {
        "idx"
    },
    cacheKey = {
        -- 缓存key
        "idx"
    },
    groupKey = {{"subjectidx"}}, -- 组key
    defaultData = {} -- 初始数据
}
return tab
