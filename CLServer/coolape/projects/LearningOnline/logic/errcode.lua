---@class Errcode 错误代码
Errcode = {}

Errcode.ok = 1
Errcode.error = -1
Errcode.needregist = 2;  -- 未注册
Errcode.uidregisted = 3;  -- uid已经被注册
Errcode.passwordError = 4;  -- 账号或密码错误
Errcode.toomanydevice = 5;  -- 设备超限

return Errcode
