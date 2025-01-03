local SCollector = LibStub("AceAddon-3.0"):GetAddon("SCollector")
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local miniButton = LDB:NewDataObject("SCollectorIcon", {
    type = "data source",
    text = "Spam Collector",
    icon = "Interface\\HELPFRAME\\HelpIcon-KnowledgeBase",
    OnClick = function(self, btn)
        SCollector:ShowFrame()
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("Spam Collector")
    end,
})

if not SCollectorDB then
    SCollectorDB = {}
end

LDBIcon:Register("SCollectorIcon", miniButton, SCollectorDB)

-- Add support for MinimapButtonFrame
if IsAddOnLoaded("MinimapButtonFrame") then
    MinimapButtonFrame:AddButton(miniButton)
end

function SCollector:ShowFrame()
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Spam Collector")
    frame:SetStatusText("Addon Initialized")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("Flow")
end
