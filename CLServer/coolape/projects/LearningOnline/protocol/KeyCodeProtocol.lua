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
    map[13] = "logout"
    map[14] = "custId"
    map[15] = "login"
    map[16] = "password"
    map["retInfor"] = 2
    map["note"] = 22
    map["code"] = 11
    map["msg"] = 10
    map["callback"] = 3
    map["sessionID"] = 24
    map["cmd"] = 0
    map["login"] = 15
    map[0] = "cmd"
    map[19] = "phone"
    map[20] = "email"
    map["logout"] = 13
    map["password"] = 16
    map["idx"] = 12
    map[17] = "regist"
    map[18] = "name"
    map["regist"] = 17
    map["phone"] = 19
    map[21] = "channel"
    map[22] = "note"
    map[23] = "custInfor"
    map[24] = "sessionID"
    map["__currIndex__"] = 25
    map["name"] = 18
    map["channel"] = 21
    map["email"] = 20
    map["custInfor"] = 23
    map["__session__"] = 1
    map["custId"] = 14
    

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