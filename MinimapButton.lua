local function createMinimapButton()
    if not SCollectorDB then
        SCollectorDB = {}
    end

    local button = CreateFrame("Button", "SCollectorMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-Chat-Up")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)  -- Default position

    -- Add a tracking border
    local minimapButtonBorder = button:CreateTexture(nil, "OVERLAY")
    minimapButtonBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    minimapButtonBorder:SetSize(54, 54)
    minimapButtonBorder:SetPoint("CENTER", button, "CENTER", 10, -10)

    button:SetMovable(true)
    button:EnableMouse(true)
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
        SCollectorDB.minimapButtonPosition = { point, relativePoint, xOfs, yOfs }
    end)

    button:SetScript("OnClick", function(self, btn)
        if btn == "LeftButton" then
            if _G["SpamCollectorFrame"] and _G["SpamCollectorFrame"]:IsShown() then
                _G["SpamCollectorFrame"]:Hide()
                frameShown = false
            else
                SCollector:ShowFrame()
            end
        end
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("Spam Collector")
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Restore position if saved
    if SCollectorDB.minimapButtonPosition then
        button:ClearAllPoints()
        button:SetPoint(unpack(SCollectorDB.minimapButtonPosition))
    end
end

createMinimapButton()
