-- Load instance icons from the separate file
local GetInstanceIcon = _G.GetInstanceIcon

local classColors = {
    ["WARRIOR"] = "C79C6E",
    ["PALADIN"] = "F58CBA",
    ["HUNTER"] = "ABD473",
    ["ROGUE"] = "FFF569",
    ["PRIEST"] = "FFFFFF",
    ["DEATHKNIGHT"] = "C41F3B",
    ["SHAMAN"] = "0070DE",
    ["MAGE"] = "69CCF0",
    ["WARLOCK"] = "9482C9",
    ["MONK"] = "00FF96",
    ["DRUID"] = "FF7D0A",
    ["DEMONHUNTER"] = "A330C9"
}

local pvpKeywords = { "arena", "battleground", "bg", "pvp" }
local pvpIcons = {
    ["Horde"] = "Interface\\Icons\\Achievement_PVP_H_01",
    ["Alliance"] = "Interface\\Icons\\Achievement_PVP_A_01"
}

local function removeOldMessages(messageList)
    local currentTime = time()
    for i = #messageList, 1, -1 do
        if currentTime - messageList[i].timestamp > 240 then  -- 4 minutes
            table.remove(messageList, i)
        end
    end
end

local function sortMessagesByTimestamp(messageList)
    table.sort(messageList, function(a, b) return a.timestamp > b.timestamp end)
end

local function messageContainsKeywords(message, keywords)
    for _, keyword in ipairs(keywords) do
        if message:lower():find(keyword:lower(), 1, true) then
            return true
        end
    end
    return false
end

local function getPvpIcon(message)
    if messageContainsKeywords(message, pvpKeywords) then
        local faction = UnitFactionGroup("player")
        return pvpIcons[faction] or "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    return nil
end

function SCollector:ShowLFMContent()
    local frame = _G["SpamCollectorFrame"]
    if not frame then return end

    -- Hide other content
    if frame.wtsContent then frame.wtsContent:Hide() end
    if frame.otherContent then frame.otherContent:Hide() end
    if frame.settingsContent then frame.settingsContent:Hide() end

    -- Create LFM content if it doesn't exist
    if not frame.lfmContent then
        frame.lfmContent = CreateFrame("Frame", nil, frame)
        frame.lfmContent:SetSize(680, 460)
        frame.lfmContent:SetPoint("TOP", frame, "TOP", 0, -40)

        local scrollFrame = CreateFrame("ScrollFrame", "SpamCollectorLFMScrollFrame", frame.lfmContent, "UIPanelScrollFrameTemplate")
        scrollFrame:SetSize(660, 430)  -- Adjust height to leave 10 space from the bottom
        scrollFrame:SetPoint("TOP", frame.lfmContent, "TOP", 0, -10)
        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local newValue = self:GetVerticalScroll() - (delta * 20)  -- Lower scroll speed by half
            if newValue < 0 then
                newValue = 0
            elseif newValue > self:GetVerticalScrollRange() then
                newValue = self:GetVerticalScrollRange()
            end
            self:SetVerticalScroll(newValue)
        end)

        local content = CreateFrame("Frame", nil, scrollFrame)
        content:SetSize(640, 800)  -- Initial size, will adjust dynamically
        scrollFrame:SetScrollChild(content)

        frame.lfmContent.messageList = {}
        frame.lfmContent.content = content
    end

    -- Register event to capture chat messages
    frame.lfmContent:RegisterEvent("CHAT_MSG_CHANNEL")
    frame.lfmContent:RegisterEvent("CHAT_MSG_SAY")
    frame.lfmContent:RegisterEvent("CHAT_MSG_YELL")
    frame.lfmContent:RegisterEvent("CHAT_MSG_EMOTE")
    frame.lfmContent:SetScript("OnEvent", function(self, event, message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
        local channel = event == "CHAT_MSG_CHANNEL" and channelName or event:match("CHAT_MSG_(%w+)")
        local keywords = SCollectorDB and SCollectorDB.LFMKeyWords and { strsplit(",", SCollectorDB.LFMKeyWords) } or {}
        if SCollectorDB and (SCollectorDB[channel:lower()] or event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL") and (messageContainsKeywords(message, keywords) or messageContainsKeywords(message, pvpKeywords)) then
            local found = false
            for _, msg in ipairs(self.messageList) do
                if msg.sender == sender then
                    msg.message = message
                    msg.timestamp = time()
                    found = true
                    break
                end
            end
            if not found then
                local _, englishClass = GetPlayerInfoByGUID(guid)
                local color = englishClass and classColors[englishClass] or "FFFFFF"
                local icon = GetInstanceIcon(message) or getPvpIcon(message) or "Interface\\Icons\\INV_Misc_QuestionMark"
                table.insert(self.messageList, 1, { sender = sender, message = message, color = color, timestamp = time(), icon = icon })  -- Insert at the beginning
            end
            removeOldMessages(self.messageList)
            sortMessagesByTimestamp(self.messageList)
            self:UpdateMessages()
        end
    end)

    function frame.lfmContent:UpdateMessages()
        -- Clear existing message frames
        for _, child in ipairs({self.content:GetChildren()}) do
            child:Hide()
            child:SetParent(nil)
        end

        local yOffset = -10
        for _, msg in ipairs(self.messageList) do
            local messageFrame = CreateFrame("Frame", nil, self.content)
            messageFrame:SetSize(620, 40)
            messageFrame:SetPoint("TOPLEFT", self.content, "TOPLEFT", 10, yOffset)
            messageFrame:SetBackdropColor(0, 0, 0, 0.5)

            local icon = messageFrame:CreateTexture(nil, "ARTWORK")
            icon:SetTexture(msg.icon)
            icon:SetSize(30, 30)
            icon:SetPoint("LEFT", messageFrame, "LEFT", 0, 0)

            local senderText = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            senderText:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            senderText:SetText("|cff" .. msg.color .. msg.sender .. "|r:")
            senderText:SetWidth(130)
            senderText:SetJustifyH("LEFT")

            local messageText = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            messageText:SetPoint("LEFT", senderText, "RIGHT", 5, 0)
            messageText:SetText(msg.message)
            messageText:SetWordWrap(true)
            messageText:SetWidth(500)
            messageText:SetJustifyH("LEFT")

            yOffset = yOffset - 40
        end
    end

    frame.lfmContent:Show()
end

function SCollector:HideLFMContent()
    local frame = _G["SpamCollectorFrame"]
    if frame and frame.lfmContent then
        frame.lfmContent:UnregisterEvent("CHAT_MSG_CHANNEL")
        frame.lfmContent:UnregisterEvent("CHAT_MSG_SAY")
        frame.lfmContent:UnregisterEvent("CHAT_MSG_YELL")
        frame.lfmContent:UnregisterEvent("CHAT_MSG_EMOTE")
        frame.lfmContent:Hide()
    end
end
