/*
    Horrid
    Fucking Horid
    But its 3 am and i still have 3 more addons to do so
*/
LShop.CFG = {}
LShop.CFG.Misc = { // Stores all misc calls
    netName = "LShop",
}
LShop.WriteBit = function(str) // Converts the string into a int to write
    if type(str) ~= "string" then
        error("String Expected Got '" .. type(str) .. "'")
    end
    local tbc = {
        ["Red Gaster Blaster"] = 0,
        ["Ak-47 Vulkan"] = 1,
        ["Lighting Gaster Blaster"] = 2,
        ["Black Gaster Blaster"] = 3,
        ["Travis Scott Gaster Blaster"] = 4,
        ["Shadow Gaster Blaster"] = 5,
        ["Hive Hand"] = 6,
        ["Mega-Vape"] = 7,
        ["Doom Blaster"] = 8,
        ["Magnum Lancer"] = 9,
        ["Heaven Scorcher (#1 One Tapper)"] = 10,
        ["M32 Venom"] = 11,
    }
    if tbc[str] == nil then
        error("String not found in table String:'" .. str .. "'")
    end
    return(tbc[str])
end
LShop.FindAction = function(int) // Converts the int into a string to find the action
    if type(int) ~= "number" then
        error("Number Expected Got '" .. type(int) .. "'")
    end
    local tbc = {
    [0] = "Buy",
    [1] = "Sell",
    [2] = "Config",
    }
    if tbc[int] == nil then
        error("String not found in table String:'" .. str .. "'")
    end
    
    return(tbc[int])
end
LShop.WriteAction = function(str) // Converts the string into an int to write the action
    if type(str) ~= "string" then
        error("String Expected Got '" .. type(str) .. "'")
    end
    local tbc = {
        ["Buy"] = 0,
        ["Sell"] = 1,
        ["Config"] = 2,
    }
    if tbc[str] == nil then
        error("String not found in table String:'" .. str .. "'")
    end
    return(tbc[str])
end

--PrintTable(LShop)

net.Receive(LShop.CFG.Misc.netName , function()
    local action = LShop.FindAction(net.ReadUInt(2))
    if action == "Config" then
        local len = net.ReadUInt(32)
        local data = net.ReadData(len)
        data = util.Decompress(data)
        data = util.JSONToTable(data)
        LShop.CFG = data
    end
end)