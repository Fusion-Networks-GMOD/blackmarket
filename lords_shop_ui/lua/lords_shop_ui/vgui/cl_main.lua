local function FormatMoney(amount)
    local formattedAmount
    if amount >= 10^12 then
        formattedAmount = string.format("%.2f", amount / 10^12) .. " Trillion"
    elseif amount >= 10^9 then
        formattedAmount = string.format("%.2f", amount / 10^9) .. " Billion"
    elseif amount >= 10^6 then
        formattedAmount = string.format("%.2f", amount / 10^6) .. " Million"
    else
        formattedAmount = string.Comma(amount)
    end
    
    formattedAmount = formattedAmount:gsub("%.00", "")

    if amount > 8 * 10^12 then
        return "Above Money Cap!"
    else
        return "$" .. formattedAmount
    end
end

local PANEL = {}
function PANEL:Init()
    self.margin = PIXEL.Scale(6)
    self.Loaded = false
    self.Sidebar = nil 

    self.Sidebar = self:Add("LShop:SidebarItem")
    self.Sidebar:Dock(RIGHT)
    self.Sidebar.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Header)
        
        if not self.Loaded then
            PIXEL.DrawSimpleText("waiting for items...", "UI.FrameTitle", w/2, h/2, color_white, 1, 1)
        end
    end

    self.Scroll = self:Add("PIXEL.ScrollPanel")
    self.Scroll:Dock(FILL)
    self.Scroll:DockMargin(0, 0, self.margin, 0)

    local t = util.JSONToTable(_blackmarket_json_response)
    /*
    Format!
    [id] = {
        name(string),
        price(int),
        class(string),
        stock(int),
        history(string:JSON),
    }
    */
    --self:RemoveAllItem()
    for k , v in pairs(t) do
        print("Loading Items??#2")
        print(v.history , k)
        PrintTable(util.JSONToTable(v.history))
        --print(k);PrintTable(t)
        self:AddItem({
            name = v.name or "?",
            price = v.price or 0,
            class = v.class or "stunstick",
            stock = v.stock or 1,
            history = util.JSONToTable(v.history), // Need to turn the json back into a table!@1
        })
    end
end

function PANEL:RemoveAllItem()
    --self.Sidebar:ClearItem()
end

function PANEL:AddItem(data)
    --[[
    data needs to contain the following
    data.name
    data.price
    data.class
    data.history = {
        -- add as many of these as u want the graph will scale / reformat
        [1] = 1500, -- this would be the most recent sale
        [2] = 2000, -- the rest can be nil it will default to 0
        [3] = 250,
        [4] = 750,
        [5] = 1000,
    }
    ]]--

    self:StopLoading()
    self.Sidebar:SetItem(data)

    local panel = self.Scroll:Add("DPanel")
    panel:Dock(TOP)
    panel:DockMargin(0, 0, self.margin, self.margin)
    panel:SetTall(PIXEL.Scale(80))
    panel.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Header)
    end
    panel.PerformLayout = function(s, w, h)
        panel.model:SetWide(panel.model:GetTall())
    
        surface.SetFont(PIXEL.GetRealFont("UI.FrameTitle"))
        local w2, h2 = surface.GetTextSize("yZTtl")
        panel.topBar:SetTall(h2 + self.margin)
    end
    Color( 0, 60, 255)
    panel.model = panel:Add("DModelPanel")
    panel.model:Dock(LEFT)
    panel.model:DockMargin(self.margin, self.margin, 0, self.margin)
    panel.model:SetModel(weapons.Get(data.class).WorldModel)

    local old = panel.model.Paint
    panel.model.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Scroller)
        old(s, w, h)
    end

    local mn, mx = panel.model.Entity:GetRenderBounds()
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    panel.model:SetFOV(45)
    panel.model:SetCamPos(Vector(size, size, size))
    panel.model:SetLookAt((mn + mx) * 0.5)

    panel.topBar = panel:Add("DPanel")
    panel.topBar:Dock(TOP)
    panel.topBar:DockMargin(self.margin, self.margin, self.margin, 0)
    panel.topBar.Paint = function(s, w, h)
        PIXEL.DrawSimpleText(data.name, "UI.FrameTitle", 0, h/2, color_white, 0, 1)
        PIXEL.DrawSimpleText("Stock: " .. data.stock .. " | " .. FormatMoney(data.price), "UI.FrameTitle", w, h/2, LocalPlayer():getDarkRPVar("money") >= data.price and PIXEL.Colors.Positive or PIXEL.Colors.Negative, TEXT_ALIGN_RIGHT, 1)
    end

    local buttonBox = panel:Add("DPanel")
    buttonBox:Dock(FILL)
    buttonBox:DockMargin(self.margin, 0, self.margin, self.margin)
    buttonBox.Paint = nil
    buttonBox.PerformLayout = function(s, w, h)
        w2 = w - 5
        buttonBox.Buy:SetSize(w2/2, h*.8)
        buttonBox.Buy:SetY(h - (h*.8))        

        buttonBox.Sell:SetSize(w2/2, h*.8)
        buttonBox.Sell:SetPos(w/2 + 2.5, h - (h*.8))
    end

    buttonBox.Buy = buttonBox:Add("PIXEL.TextButton")
    buttonBox.Buy:SetText("View")
    buttonBox.Buy.DoClick = function(s)
        self.Sidebar:SetItem(data)
    end
    print("P")
    buttonBox.Sell = buttonBox:Add("PIXEL.TextButton")
    buttonBox.Sell:SetText("Sell")
    buttonBox.Sell.DoClick = function()
        print("Want To Sel :noted:")
        local name = data.name
        net.Start( LShop.CFG.Misc.netName )
        net.WriteUInt( LShop.WriteAction("Sell") , 2 )
        net.WriteUInt( LShop.WriteBit(name) , 5 )
        net.SendToServer()
    end
end

function PANEL:StopLoading()
    -- makes the loading circle go away
    self.Loaded = true
end

function PANEL:Paint(w, h)
    if not self.Loaded then
        local w2, h2 = w/4, h/4
        PIXEL.DrawProgressWheel(w/2 - (w2/2), h/2 - (h2/2), w2, h2, PIXEL.Colors.Primary)
        return
    end
end

function PANEL:PerformLayout(w, h)
    self.Sidebar:SetWide(w*.35)
end
vgui.Register("LShop:Main", PANEL, "EditablePanel")