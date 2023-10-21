LShop.CFG = {}
LShop.CFG.Title = "Black Market Store"
LShop.CFG.WriteBit = function(str) // Converts the string into a int to write
    if type(str) ~= "string" then
        error("String Expected Got '" .. type(str) .. "'")
    end
    local tbc = {
        ["TEST WEAPON1"] = 0,
        ["TEST WEAPON2"] = 1,
        ["TEST WEAPON3"] = 2,
    }
    if tbc[str] == nil then
        error("String not found in table String:'" .. str .. "'")
    end
    return(tbc[str])
end
LShop.CFG.ReadBit = function(int) // Converts the int from a string
    if type(int) ~= "number" then
        error("Number Expected Got '" .. type(int) .. "'")
    end
    local tbc = {
        [0] = "Red Gaster Blaster",
        [1] = "Ak-47 Vulkan",
        [2] = "Lighting Gaster Blaster",
        [3] = "Black Gaster Blaster",
        [4] = "Travis Scott Gaster Blaster",
        [5] = "Shadow Gaster Blaster",
        [6] = "Hive Hand",
        [7]  = "Mega-Vape",
        [8] = "Doom Blaster",
        [9] = "Magnum Lancer",
        [10] = "Heaven Scorcher (#1 One Tapper)",
        [11] = "M32 Venom",
    }
    if tbc[int] == nil then
        error("Int not found in table Int:'" .. int .. "'")
    end
    return(tbc[int])
end
LShop.CFG.FindAction = function(int) // Converts the int into a string to find the action
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
LShop.CFG.WriteAction = function(str) // Converts the string into an int to write the action
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
LShop.CFG.CreateNets = function() // Create all nets for neatness in the config
    if SERVER then
    util.AddNetworkString("LShop") // Used for all networking
    end
end
LShop.CFG.CreateNets()
LShop.CFG.Misc = { // Stores all misc calls
    netName = "LShop",
}

local function writeConfig(pl) // Write the Config To The Player
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Sending Config to Player [" .. pl:Nick() .. "]\n")
    local len = 0
    local data = LShop.CFG
    if !type(data) == "table" then
        print("Data isn't table?") 
    end
    --PrintTable(data)
    data = util.TableToJSON(data)
    --print(data)
    data = util.Compress(data)
    len = #data
    net.Start(LShop.CFG.Misc.netName)
    net.WriteUInt(LShop.CFG.WriteAction("Config") , 2)
    net.WriteUInt(len , 32)
    net.WriteData(data , #data)
    net.Send(pl)
end

hook.Add("PlayerInitialSpawn" , "LShop.CFG::SendConfig" , writeConfig)