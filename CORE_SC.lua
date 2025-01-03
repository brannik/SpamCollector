SCollector = LibStub("AceAddon-3.0"):NewAddon("SCollector", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local function showFrame()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Spam Collector")
    frame:SetStatusText("Addon Initialized")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("Flow")
end

local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("SCollectorIcon", {
    type = "data source",
    text = "Spam Collector",
    icon = "Interface\\HELPFRAME\\HelpIcon-KnowledgeBase",
    OnClick = function(self, btn)
        showFrame()
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("Spam Collector")
    end,
})

local icon = LibStub("LibDBIcon-1.0", true)
if not SCollectorDB then
    SCollectorDB = {}
end
icon:Register("SCollectorIcon", miniButton, SCollectorDB)

function SCollector:OnInitialize()
    -- Called when the addon is loaded
end

function SCollector:OnEnable()
    -- Called when the addon is enabled
end

function SCollector:OnDisable()
    -- Called when the addon is disabled
end

SCollector:RegisterChatCommand("scshow", showFrame)
