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
    map[0] = "cmd"
    map["note"] = 22
    map["code"] = 11
    map["__currIndex__"] = 26
    map["msg"] = 10
    map["callback"] = 3
    map["sessionID"] = 24
    map["cmd"] = 0
    map["phone2"] = 25
    map["login"] = 15
    map["custId"] = 14
    map["__session__"] = 1
    map["phone"] = 19
    map["email"] = 20
    map[24] = "sessionID"
    map["idx"] = 12
    map[17] = "regist"
    map[18] = "name"
    map[19] = "phone"
    map[20] = "email"
    map["logout"] = 13
    map[22] = "note"
    map[23] = "custInfor"
    map["password"] = 16
    map[25] = "phone2"
    map["name"] = 18
    map["channel"] = 21
    map[21] = "channel"
    map["custInfor"] = 23
    map["regist"] = 17
    map["retInfor"] = 2
    

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