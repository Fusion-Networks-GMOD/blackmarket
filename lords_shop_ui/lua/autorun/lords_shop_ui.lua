local function AddFile(File, dir)
    local fileSide = string.lower(string.Left(File, 3))
    if SERVER and fileSide == "sv_" then
        include(dir..File)
        print("[AUTOLOAD] SV INCLUDE: " .. File)
    elseif fileSide == "sh_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
            print("[AUTOLOAD] SH ADDCS: " .. File)
        end
        include(dir..File)
       -- print("[AUTOLOAD] SH INCLUDE: " .. File)
    elseif fileSide == "cl_" then
        if SERVER then 
            AddCSLuaFile(dir..File)
           -- print("[AUTOLOAD] CL ADDCS: " .. File)
        else
            include(dir..File)
           -- print("[AUTOLOAD] CL INCLUDE: " .. File)
        end
    end
end

local function IncludeDir(dir)
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Loading Addon...\n")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Copyright Notice! ❤️\n")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "© 2023 by Kaiseriscool(https://github.com/Kaiseriscool) (Email: afakediscordn@gmail.com)❤️\n")
    dir = dir .. "/"
    local File, Directory = file.Find(dir.."*", "LUA")

    for k, v in ipairs(File) do
        if string.EndsWith(v, ".lua") then
            AddFile(v, dir)
        end
    end
    
    for k, v in ipairs(Directory) do
        --print("[AUTOLOAD] Directory: " .. v)
        IncludeDir(dir..v)
    end
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Loaded Addon!\n")
end

LShop = LShop or {}

hook.Add("ArgonLibaryLoaded" , "LoadBlackMarket" , function()
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Loading Addon...\n")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Copyright Notice! ❤️\n")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "© 2023 by Kaiseriscool(https://github.com/Kaiseriscool) (Email: afakediscordn@gmail.com)❤️\n")
    Argon.Libary.LoadFiles("lords_shop_ui")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Loaded Addon!\n")
end)
/*
timer.Simple(1 , function()
    Argon.Libary.LoadFiles("lords_shop_ui")
end)
*/

/*
    Credits
    [Lord Sugar] - UI
    [Kaiser] - Back End & API
*/

