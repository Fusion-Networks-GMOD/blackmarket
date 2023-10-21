local PANEL = {}
function PANEL:Init()
    self.margin = PIXEL.Scale(6)
    self.name = ""
    self.price = 0
    self.amount = 1 
    self.stock = 0

    self.InfoPanel = self:Add("DPanel")
    self.InfoPanel:Dock(TOP)
    self.InfoPanel.Paint = nil

    self.ModelPanel = self.InfoPanel:Add("DModelPanel")
    self.ModelPanel:Dock(LEFT)
    self.ModelPanel:DockMargin(self.margin, self.margin, 0, self.margin)
    self.ModelPanel:SetModel("")

    local old = self.ModelPanel.Paint
    self.ModelPanel.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Scroller)
        old(s, w, h)
    end
    self.InfoPanel.topBar = self.InfoPanel:Add("DPanel")
    self.InfoPanel.topBar:Dock(FILL)
    self.InfoPanel.topBar:DockMargin(self.margin, self.margin, self.margin, 0)
    self.InfoPanel.topBar.Paint = function(s, w, h)
        local w2, h2 = PIXEL.DrawSimpleText(self.name, "UI.FrameTitle", 0, 0, color_white)
        PIXEL.DrawSimpleText(self.stock >= 0 and DarkRP.formatMoney(self.price) or "SOLD OUT", "UI.FrameTitle", 0, h2 + self.margin,LocalPlayer():getDarkRPVar("money") >= self.price and PIXEL.Colors.Positive or PIXEL.Colors.Negative)
    end
    -- i hate math doing this ma self
    self.History = self:Add("DPanel")
    self.History:Dock(TOP)
    self.History:DockMargin(self.margin, 0, self.margin, 0)
    self.History.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Scroller)

        if not self.history then return end
        if self.history == {} then return end
        local maxnum = math.max(unpack(self.history))
        local minnum = math.min(unpack(self.history))
        local range = (maxnum - minnum) * 1.2
        local size = self.margin/2

        local lines = {}
        for int, price in ipairs(self.history) do
            local x, y = (w/(#self.history+1))*int, (h/range) * (maxnum-price)
            local offsetX, offsetY = 0, h
            y = h - (offsetY-size-y)
            table.Add(lines, {{offsetX-size+x, y}})
        end

        for int, data in ipairs(lines) do
            if not lines[int+1] then continue end
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawLine(data[1], data[2], lines[int+1][1], lines[int+1][2])
        end

        for int, price in ipairs(self.history) do
            local x, y = (w/(#self.history+1))*int, (h/range) * (maxnum-price)
            local offsetX, offsetY = 0, h
            y = h - (offsetY-size-y)

            draw.RoundedBox(size, offsetX-size+x, y, size*2, size*2, color_black)
            PIXEL.DrawSimpleText(DarkRP.formatMoney(price), "UI.Label", offsetX-size+x, y, PIXEL.Colors.Positive, 1, 1)
        end
    end

    self.Purchase = self:Add("PIXEL.TextButton")
    self.Purchase:Dock(BOTTOM)
    self.Purchase:DockMargin(self.margin, 0, self.margin, self.margin)
    self.Purchase:SetText("Purchase")
    self.Purchase:SetTall(PIXEL.Scale(25))
    self.Purchase.DoClick = function()
        print("Bought SomethingZ?")
        print(self.name)
        net.Start( LShop.CFG.Misc.netName )
        net.WriteUInt( LShop.WriteAction("Buy") , 2 )
        net.WriteUInt( LShop.WriteBit(self.name) , 5 )
        net.WriteUInt( self.amount , 8 )
        net.SendToServer()
        --self.stock = self.stock - self.amount
    end

    local panel = self:Add("DPanel")
    panel:Dock(BOTTOM)
    panel:DockMargin(self.margin, 0, self.margin, self.margin)
    panel:SetTall(PIXEL.Scale(25))
    panel.PerformLayout = function(s, w, h)
        panel.add:SetWide(h)
        panel.takeaway:SetWide(h)
    end
    panel.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Scroller)
        PIXEL.DrawSimpleText(self.amount.." ("..DarkRP.formatMoney(self.amount*(self.price or 0))..")", "UI.FrameTitle", w/2, h/2, color_white, 1, 1)
    end

    panel.add = panel:Add("PIXEL.TextButton")
    panel.add:Dock(LEFT)
    panel.add.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Positive)
        PIXEL.DrawSimpleText("+", "UI.FrameTitle", w/2, h/2, color_white, 1, 1)
        if s:IsHovered() then
            PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, Color(0, 0, 0, 100))
        end
    end
    panel.add.DoClick = function(s)
        if self.amount + 1 > self.stock then return end
        self.amount = self.amount + 1
    end

    panel.takeaway = panel:Add("PIXEL.TextButton")
    panel.takeaway:Dock(RIGHT)
    panel.takeaway.Paint = function(s, w, h)
        PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, PIXEL.Colors.Negative)
        PIXEL.DrawSimpleText("-", "UI.FrameTitle", w/2, h/2, color_white, 1, 1)
        if s:IsHovered() then
            PIXEL.DrawRoundedBox(self.margin, 0, 0, w, h, Color(0, 0, 0, 100))
        end
    end
    panel.takeaway.DoClick = function(s)
        if self.amount - 1 < 0 then return end
        self.amount = self.amount - 1
    end
    
end

function PANEL:ClearItem()
    self.name = ""
    self.stock = 0
    self.price = 0
    self.amount = 1
    self.history = nil

    self.ModelPanel:SetModel("")

    if IsValid(self.ModelPanel.Entity) then
        self.ModelPanel:SetCamPos(Vector(0, 0, 64))
        self.ModelPanel:SetLookAt(Vector(0, 0, 0))
    end
    self:InvalidateLayout(true)
end


function PANEL:SetItem(data)
    self.name = data.name
    self.stock = data.stock
    self.price = data.price
    self.history = table.Reverse(data.history)
    --print(self.history)
    --if istable(self.history) then
    --    PrintTable(self.history)
    --end

    self.ModelPanel:SetModel(weapons.Get(data.class).WorldModel)
    if IsValid(self.ModelPanel.Entity) then
        local mn, mx = self.ModelPanel.Entity:GetRenderBounds()
        local size = 0
        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
        self.ModelPanel:SetFOV(45)
        self.ModelPanel:SetCamPos(Vector(size, size, size))
        self.ModelPanel:SetLookAt((mn + mx) * 0.5)
    end
end

function PANEL:PerformLayout(w, h)
    self.InfoPanel:SetTall(h*.25)
    self.ModelPanel:SetWide(self.ModelPanel:GetTall())
    self.History:SetTall(h*.3)
end
vgui.Register("LShop:SidebarItem", PANEL, "EditablePanel")