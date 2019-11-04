do
    local KeyCodeProtocol = {}
    KeyCodeProtocol.map = {}
    local map = KeyCodeProtocol.map
    map[1] = "__session__"
    map[2] = "retInfor"
    map[3] = "callback"
    map[10] = "msg"
    map[11] = "code"
    map[12] = "idx"
    map[13] = "registAccount"
    map[14] = "custId"
    map[15] = "password"
    map[16] = "name"
    map[0] = "cmd"
    map["note"] = 20
    map["code"] = 11
    map["msg"] = 10
    map["callback"] = 3
    map["cmd"] = 0
    map[24] = "regist"
    map["custId"] = 14
    map["regist"] = 24
    map[23] = "login"
    map["login"] = 23
    map[20] = "note"
    map["logout"] = 22
    map["idx"] = 12
    map[17] = "phone"
    map[18] = "email"
    map[19] = "channel"
    map["phone"] = 17
    map[21] = "loginAccount"
    map[22] = "logout"
    map["email"] = 18
    map["password"] = 15
    map["__currIndex__"] = 25
    map["name"] = 16
    map["channel"] = 19
    map["loginAccount"] = 21
    map["retInfor"] = 2
    map["__session__"] = 1
    map["registAccount"] = 13
    

    KeyCodeProtocol.getKeyCode = function(key)
        local val = map[key]
        if val == nil then
            map[key] = map.__currIndex__
            map[map.__currIndex__] = key
            map.__currIndex__ = map.__currIndex__ + 1
        end
        val = map[key]
        return val
    end
    return KeyCodeProtocol
end