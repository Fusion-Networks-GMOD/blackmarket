function LShop:InsertIntoHistory(t , value)

    table.insert(t , 1 , value)


    if Argon.Libary:TableLen(t) > 10 then // Don't Want to many in storage or showing up!
        table.remove(t , 10)
    end
end
net.Receive(LShop.CFG.Misc.netName , function(len , pl)
    local action = net.ReadUInt(2)
    action = LShop.CFG.FindAction(action) // Turn the int into the action string
    if action == "Buy" then
        local item = LShop.CFG.ReadBit(net.ReadUInt(5)) // Turns the name which was turned into a int back into the string
        local amt = net.ReadUInt(8)
        if amt < 1 then return end
        MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Player(".. pl:Nick() ..") Want's to buy ".. item .." x".. amt .." ...\n")
        LShop:GetStock(item , function(stock)
            if stock[1] == nil then return false end // Item Does Not Exists
            if stock[1].stock >= amt then
                local data = {} // Get Ready To get the items data!
                LShop:GetItemData(item , function(d)
                    data = d
                end)
                data = data[1] // Clean Up the data since its return format
                data.history = util.JSONToTable(data.history)
                LShop:InsertIntoHistory(data.history , data.price)
                data.history = util.TableToJSON(data.history)
                print(data.history)
                if pl:canAfford(data.price * amt) then
                    pl:addMoney(-math.abs(data.price * amt))
                    LShop:SetStock(item , amt)
                    LShop:SetHistory(data.history , item)
                    print("✅ Not brokie")
                    --hook.Run("LShop::BouhgtItem" , data.price * amt , pl)
                    hook.Run("LShop::BouhgtItem" , pl , pl , data.price * amt , data.price * amt)
                    local price_hike = math.random(1 , 3) * amt
                    price_hike = math.abs(data.price * (price_hike / 100))
                    print(price_hike , data.price)
                    --data.price = data.price + price_hike
                    LShop:SetPrice(data.price - price_hike, item)
                    --print(weapons.Get(data.class).PrintName)
                    local wep_name = weapons.Get(data.class).PrintName
                    for i = 1 , amt do
                        if istable(VNP) then
                        local data = VNP.Inventory:CreateItem(wep_name, "Common")
                        pl:AddInventoryItem(data)
                        end
                    end
                end
                --print(data.history)
                --print(data.price * amt, "<price>")

            end
        end)
    end

    if action == "Sell" then
        local item = LShop.CFG.ReadBit(net.ReadUInt(5))
        MsgC(Color(238 , 255 ,0) , "[SHOP]" , color_white , "Player(".. pl:Nick() ..") Want's to Sell ".. item .." ...\n")
        local data = {} // get ready for that d
        LShop:GetItemData(item , function(d)
            data = d
        end)
        data = data[1] // Clean <3
        local typer = data.class
        if pl:HasWeapon(typer) then
            pl:StripWeapon(typer)
            pl:addMoney(data.price)
            local price_hike = math.random(2 , 6)
            local cbt = data.price
            price_hike = math.abs(data.price * (price_hike / 100))
            --data.price = data.price - price_hike
            LShop:SetPrice(data.price + price_hike, item)
            LShop:UpdateStockSold(item)
            hook.Run("LShop::SouldItem" , pl , pl , cbt , cbt)
            --hook.Run("LShop::SouldItem" , cbt , pl)
        end
    end
end)


hook.Add("PlayerSay" , "_BlackMarket" , function(p , str)
    str = string.lower(str)
    if str == "!blackmarket" then
        p:ConCommand("_test")
    end
end)