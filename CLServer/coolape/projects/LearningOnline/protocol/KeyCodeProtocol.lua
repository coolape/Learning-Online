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
    map[17] = "regist"
    map[18] = "name"
    map[19] = "phone"
    map[20] = "email"
    map[21] = "channel"
    map[22] = "note"
    map[23] = "custInfor"
    map[24] = "sessionID"
    map[25] = "phone2"
    map[26] = "users"
    map[27] = "belongid"
    map[28] = "custid"
    map[29] = "status"
    map[30] = "sex"
    map[31] = "school"
    map[32] = "birthday"
    map[0] = "cmd"
    map["note"] = 22
    map["code"] = 11
    map["belongid"] = 27
    map["msg"] = 10
    map["callback"] = 3
    map["sessionID"] = 24
    map["cmd"] = 0
    map["retInfor"] = 2
    map["users"] = 26
    map[33] = "groupid"
    map["custId"] = 14
    map["sex"] = 30
    map["custid"] = 28
    map["birthday"] = 32
    map["idx"] = 12
    map["logout"] = 13
    map["__currIndex__"] = 34
    map["regist"] = 17
    map["phone"] = 19
    map["phone2"] = 25
    map["groupid"] = 33
    map["email"] = 20
    map["password"] = 16
    map["status"] = 29
    map["name"] = 18
    map["channel"] = 21
    map["school"] = 31
    map["custInfor"] = 23
    map["login"] = 15
    map["__session__"] = 1
    

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