function LShop:OpenMenu()
    if IsValid(LShop.Menu) then LShop.Menu:Remove() end
    LShop.Menu = vgui.Create("PIXEL.Frame")
    LShop.Menu:SetSize(PIXEL.Scale(800 * 1.5), PIXEL.Scale(450* 1.5))
    LShop.Menu:Center()
    --LShop.Menu:Open()
    LShop.Menu:MakePopup()
    LShop.Menu:SetTitle(LShop.CFG.Title or "...")
    LShop.Menu.Think = function(...)
        if input.IsKeyDown(KEY_TAB) or input.IsKeyDown(KEY_ESCAPE) then
            if IsValid(LShop.Menu) then LShop.Menu:Close() end
        end
    end

    local panel = LShop.Menu:Add("LShop:Main")
    panel:Dock(FILL)
end

concommand.Add("_test" , function()
    LShop:ApiTestResponse()
    LShop:OpenMenu()
end )