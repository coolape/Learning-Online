---@class Errcode 错误代码
Errcode = {}

Errcode.ok = 1  -- 成功
Errcode.error = -1  -- 错误
Errcode.sessionTimeOut = -10000 -- 会话超时
Errcode.needregist = 2 -- 未注册
Errcode.uidregisted = 3 -- uid已经被注册
Errcode.passwordError = 4 -- 账号或密码错误
Errcode.toomanydevice = 5 -- 设备超限
Errcode.paramsIsNil = 6 -- 参数错误，注意必填项目
Errcode.userIsNil = 7 -- 取得用户为空
Errcode.custIsNil = 8 -- 取得客户为空

return Errcode
