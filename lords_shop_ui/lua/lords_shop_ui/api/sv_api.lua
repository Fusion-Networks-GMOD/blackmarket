function LShop:CreateInitSQL()
    ARGON.Driver:Query("CREATE TABLE IF NOT EXISTS blackmarket (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), class VARCHAR(255), price INT, stock INT, history TEXT);")
    MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Loading / Creating SQL...\n")
end

function LShop:CreateItem(t)
    local query = string.format("INSERT IGNORE INTO blackmarket (name, class, price, stock, history) VALUES ('%s', '%s', %s, %s, '%s');" , t.name , t.class , t.price , t.stock , util.TableToJSON(t.history))
    ARGON.Driver:Query(query)
end

function LShop:GetStock(name , callback)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) .. ";")
    ARGON.Driver:Query(query , function(data)
        callback(data or {})
    end)
end

function LShop:GetItemData(name , callback)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) .. ";")
    --local data_
    ARGON.Driver:Query(query , function(data)
        callback(data)
    end)
end

function LShop:SetStock(name , down)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) ..";")
    ARGON.Driver:Query(query , function(data)
        data = data[1].stock - down
        local q = string.format("UPDATE blackmarket SET stock = ".. data .." WHERE name = "..sql.SQLStr(name) .. ";")
        ARGON.Driver:Query(q)
    end)
end

function LShop:UpdateStockSold(name)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) ..";")
    ARGON.Driver:Query(query , function(data)
        data = data[1].stock + 1
        local q = string.format("UPDATE blackmarket SET stock = ".. data .." WHERE name = "..sql.SQLStr(name) .. ";")
        ARGON.Driver:Query(q)
    end)
end

function LShop:SetHistory(json, name)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) ..";")
    ARGON.Driver:Query(query , function(data)
        local q = string.format("UPDATE blackmarket SET history = '%s' WHERE name = %s ;" , json , sql.SQLStr(name))
        ARGON.Driver:Query(q)
    end)
end

function LShop:SetPrice(int, name)
    local query = string.format("SELECT * FROM blackmarket WHERE name = ".. sql.SQLStr(name) ..";")
    ARGON.Driver:Query(query , function(data)
        local q = string.format("UPDATE blackmarket SET price = '%s' WHERE name = %s ;" , int , sql.SQLStr(name))
        ARGON.Driver:Query(q)
    end)
end


LShop:CreateItem({
    name = "Red Gaster Blaster",
    class = "weapon_supreme_badtime_bm_gblaster",
    price = 2250,
    stock = 10,
    history = {
        [1] = 1950,
        [2] = 2000,
    }
})

LShop:CreateItem({
    name = "Ak-47 Vulkan",
    class = "clt_akvlcn",
    price = 7 * (10^9),
    stock = 10,
    history = {}
})

LShop:CreateItem({
    name = "Lighting Gaster Blaster",
    class = "blue-gblaster",
    price = 5 * (10^12),
    stock = 2,
    history = {}
})

LShop:CreateItem({
    name = "Black Gaster Blaster",
    class = "black-gblaster",
    price = 1.85 * (10^11),
    stock = 5,
    history = {}
})

LShop:CreateItem({
    name = "Travis Scott Gaster Blaster",
    class = "travis_scott_gblaster",
    price = 4.5 * (10^11),
    stock = 0,
    history = {}
})

LShop:CreateItem({
    name = "Shadow Gaster Blaster",
    class = "shadow-gblaster",
    price = 5.5 * (10^11),
    stock = 0,
    history = {}
})

LShop:CreateItem({
    name = "Police Cuffs",
    class = "weapon_cuff_police",
    price = 5.5 * (10^11),
    stock = 1,
    history = {}
})



LShop:CreateInitSQL()