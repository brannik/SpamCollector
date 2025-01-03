---@diagnostic disable: undefined-field, duplicate-set-field, undefined-global, redundant-parameter, deprecated, inject-field
SCollector = LibStub("AceAddon-3.0"):NewAddon("SCollector", "AceConsole-3.0")
local AceGUI2 = LibStub("AceGUI-3.0")

local AceAddon = LibStub("AceAddon-3.0")
local EVENTSSC = AceAddon:NewAddon("EVENTSSC", "AceEvent-3.0")


local LFM_scroll = AceGUI2:Create("ScrollFrame")
LFM_scroll:SetLayout("Flow") -- probably?
LFM_scroll:SetFullWidth(true)
--scroll:SetFullHeight(true)
LFM_scroll:SetHeight(420)
LFM_scroll:SetWidth(500)

local WTS_scroll = AceGUI2:Create("ScrollFrame")
WTS_scroll:SetLayout("Flow") -- probably?
WTS_scroll:SetFullWidth(true)
--scroll:SetFullHeight(true)
WTS_scroll:SetHeight(420)
WTS_scroll:SetWidth(500)

local scroll = AceGUI2:Create("ScrollFrame")
scroll:SetLayout("Flow") -- probably?
scroll:SetFullWidth(true)
--scroll:SetFullHeight(true)
scroll:SetHeight(420)
scroll:SetWidth(500)


local frameShown = false
local LFM_PHRASE = "LFM"
local WTS_PHRASE = "WTS"
local CHANNEL_TO_LISTEN = "global"
local messages = {}
local SellMessages = {}
local GroupMessages = {}
local activeTab = 1

local function containsPhrase(str, phrase)
    return string.find(str, phrase, 1, true) ~= nil
end

local function MessageExsists(table,message)
    local sender = message[1]
    local found = false -- Flag to indicate if a match has been found
    for _, row in ipairs(table) do
        if row[1] == sender then -- Check the first element of the row for the sender
            found = true
            break -- Exit the loop after finding the first match
        end
    end
    return found
end
local function convertTimestampToHHMM(timestamp)
    local hour = tonumber(date("%H", timestamp))
    local minute = tonumber(date("%M", timestamp))
    return string.format("%02d:%02d", hour, minute)
end
local function UpdateMessage(table,message)

end
local function UpdateWTSList()
    WTS_scroll:ReleaseChildren()
    for _, row in ipairs(SellMessages) do
        local simpleInnerGroup2 = AceGUI2:Create("SimpleGroup")
        simpleInnerGroup2:SetLayout("Flow")
        simpleInnerGroup2:SetFullWidth(true)
        simpleInnerGroup2:SetHeight(50)
    
        local buttonPM = AceGUI2:Create("Button")
        buttonPM:SetText("PM")
        buttonPM:SetWidth(50)
        buttonPM:SetCallback("OnClick", function()
            print("PM to sender")
        end)
        simpleInnerGroup2:AddChild(buttonPM)

        local charName = AceGUI2:Create("Label")
        charName:SetWidth(200)
        charName:SetHeight(200)
        charName:SetText(row[1] .. " " .. convertTimestampToHHMM(row[3]))
        charName:SetColor(1, 1, 0)
        charName:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup2:AddChild(charName)

        -- create inner grp
        local msg = AceGUI2:Create("Label")
        msg:SetWidth(430)
        msg:SetHeight(200)
        msg:SetText(row[2])
        msg:SetColor(1, 1, 0)
        msg:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup2:AddChild(msg)
        WTS_scroll:AddChild(simpleInnerGroup2)
    end
end
local function UpdateLFMList()
    LFM_scroll:ReleaseChildren()
    for _, row in ipairs(GroupMessages) do
        local simpleInnerGroup = AceGUI2:Create("SimpleGroup")
        simpleInnerGroup:SetLayout("Flow")
        simpleInnerGroup:SetFullWidth(true)
        simpleInnerGroup:SetHeight(50)
    
        local buttonPM = AceGUI2:Create("Button")
        buttonPM:SetText("PM")
        buttonPM:SetWidth(50)
        buttonPM:SetCallback("OnClick", function()
            print("PM to sender")
        end)
        simpleInnerGroup:AddChild(buttonPM)

        local charName = AceGUI2:Create("Label")
        charName:SetWidth(200)
        charName:SetHeight(200)
        charName:SetText(row[1] .. " " .. convertTimestampToHHMM(row[3]))
        charName:SetColor(1, 1, 0)
        charName:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup:AddChild(charName)

        -- create inner grp
        local msg = AceGUI2:Create("Label")
        msg:SetWidth(430)
        msg:SetHeight(200)
        msg:SetText(row[2])
        msg:SetColor(1, 1, 0)
        msg:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup:AddChild(msg)
        LFM_scroll:AddChild(simpleInnerGroup)
    end
end
local function UpdateTheList()
    -- clear scroll frame 
    scroll:ReleaseChildren()
    for _, row in ipairs(messages) do
        local simpleInnerGroup3 = AceGUI2:Create("SimpleGroup")
        simpleInnerGroup3:SetLayout("Flow")
        simpleInnerGroup3:SetFullWidth(true)
        simpleInnerGroup3:SetHeight(50)
    
        local buttonPM3 = AceGUI2:Create("Button")
        buttonPM3:SetText("PM")
        buttonPM3:SetWidth(50)
        buttonPM3:SetCallback("OnClick", function()
            print("PM to sender")
        end)
        simpleInnerGroup3:AddChild(buttonPM3)

        local charName3 = AceGUI2:Create("Label")
        charName3:SetWidth(200)
        charName3:SetHeight(200)
        charName3:SetText(row[1] .. " " .. convertTimestampToHHMM(row[3]))
        charName3:SetColor(1, 1, 0)
        charName3:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup3:AddChild(charName3)

        -- create inner grp
        local msg3 = AceGUI2:Create("Label")
        msg3:SetWidth(430)
        msg3:SetHeight(200)
        msg3:SetText(row[2])
        msg3:SetColor(1, 1, 0)
        msg3:SetFont("Fonts\\FRIZQT__.TTF", 12)
        --charName:SetJustifyH("LEFT")
        simpleInnerGroup3:AddChild(msg3)
        scroll:AddChild(simpleInnerGroup3)
    end
end

function ManageMessages()
    --sort the messages
    if activeTab == 1 then
        UpdateWTSList()
    elseif activeTab == 2 then
        UpdateLFMList()
    elseif activeTab == 3 then
        UpdateTheList()
    end
    
    
    
end

local function OnChatMessage(event, message, sender, param1, param2, param3, param4, param5, param6, channelName, param8, param9, param10, param11, param12) 
    -- Check if the event is a chat message in the desired channel
    if event == "CHAT_MSG_CHANNEL" and channelName == CHANNEL_TO_LISTEN then
        --print("Received message in channel "..channelName..": "..message)
        local timestamp = GetTime()
        local innerTable = {sender,message,timestamp}

        if containsPhrase(message,LFM_PHRASE) then
            if MessageExsists(GroupMessages,innerTable) == false then
                table.insert(GroupMessages,innerTable)
            else
                UpdateMessage(GroupMessages,innerTable)
            end
        elseif containsPhrase(message,WTS_PHRASE) then
            if MessageExsists(SellMessages,innerTable) == false then
                table.insert(SellMessages,innerTable)
            else
                UpdateMessage(SellMessages,innerTable)
            end
        elseif containsPhrase(message,WTS_PHRASE) == false and containsPhrase(message,LFM_PHRASE) == false then
            if MessageExsists(messages,innerTable) == false then
                table.insert(messages,innerTable)
            else
                UpdateMessage(messages,innerTable)
            end
        end
        
        
        ManageMessages()
        -- Your code to handle the message goes here
    end
end

function PMToPlayer(plrName)
    SendChatMessage(" ","WHISPER",nil,plrName);
end
local function WTSSpam(container)
    container:AddChild(WTS_scroll)
    
end
local function LFMSpam(container)
    container:AddChild(LFM_scroll)
end
local function OtherSpam(container)
    container:AddChild(scroll)
end
-- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        activeTab = 1
        WTSSpam(container)
    elseif group == "tab2" then
        activeTab = 2
        LFMSpam(container)
    elseif group == "tab3" then
        activeTab = 3
        OtherSpam(container)
    end
end

-- Create the frame container
local function showFrame()
    if frameShown then
      return
    end
    frameShown = true
    local frame2 = AceGUI2:Create("Frame")
    frame2:SetHeight(550)
    frame2:SetWidth(550)
    frame2:SetTitle("Spam Collector")

    EVENTSSC.RegisterEvent("SCollector", "CHAT_MSG_CHANNEL", OnChatMessage)

    --frame2:AddChild(scroll)

    frame2:SetLayout("Fill")
    frame2:SetCallback("OnClose",function(widget2) AceGUI2:Release(widget2)  frameShown = false EVENTSSC.UnregisterEvent("SCollector", "CHAT_MSG_CHANNEL") messages = {} SellMessages = {} GroupMessages = {} end)
    local tab =  AceGUI2:Create("TabGroup")
    tab:SetLayout("List")
    -- Setup which tabs to show
    tab:SetTabs({{text="WTS", value="tab1"}, {text="LFM", value="tab2"},{text="Other",value="tab3"}})
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")
    -- add to the frame container
    frame2:AddChild(tab)

    --ShowBoard(frame)
  end
-- MINIMAP BUTTON
local miniButtonSC = LibStub("LibDataBroker-1.1"):NewDataObject("SCollectorIcon", {
    type = "data source",
    text = "Spam Collector",
    icon = "Interface\\HELPFRAME\\HelpIcon-KnowledgeBase",
    OnClick = function(self, btn)
        -- OnClick code goes here
        showFrame()
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("Spam Collector")
    end,
    })
    local icon2 = LibStub("LibDBIcon-1.0", true)
    icon2:Register("SCollectorIcon", miniButtonSC, SCollectorDB)
-- MINIMAP BUTTON
function SCollector:OnInitialize()
	-- Called when the addon is loaded
    
end
function SCollector:OnEnable()
	-- Called when the addon is enabled
    --EVENTSSC.UnregisterEvent("SCollector", "CHAT_MSG_CHANNEL")
    
end
function SCollector:OnDisable()
	-- Called when the addon is disabled
    EVENTSSC.UnregisterEvent("SCollector", "CHAT_MSG_CHANNEL")
    messages = {}
    SellMessages = {}
    GroupMessages = {}
end
function SCollector:HandleGMCommand(input)
    showFrame()
end
SCollector:RegisterChatCommand("scshow", "HandleGMCommand")

