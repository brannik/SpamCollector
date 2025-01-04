function SCollector:ShowSettingsContent()
    local frame = _G["SpamCollectorFrame"]
    if not frame then return end

    -- Hide other content
    if frame.lfmContent then frame.lfmContent:Hide() end
    if frame.wtsContent then frame.wtsContent:Hide() end
    if frame.otherContent then frame.otherContent:Hide() end

    -- Create Settings content if it doesn't exist
    if not frame.settingsContent then
        frame.settingsContent = CreateFrame("ScrollFrame", "SpamCollectorSettingsScrollFrame", frame, "UIPanelScrollFrameTemplate")
        frame.settingsContent:SetSize(640, 420)  -- Adjust width and height to leave space for the save button and scrollbar
        frame.settingsContent:SetPoint("TOP", frame, "TOP", 0, -40)
        frame.settingsContent:SetScript("OnMouseWheel", function(self, delta)
            local newValue = self:GetVerticalScroll() - (delta * 20)  -- Lower scroll speed by half
            if newValue < 0 then
                newValue = 0
            elseif newValue > self:GetVerticalScrollRange() then
                newValue = self:GetVerticalScrollRange()
            end
            self:SetVerticalScroll(newValue)
        end)

        local content = CreateFrame("Frame", nil, frame.settingsContent)
        content:SetSize(620, 800)  -- Initial size, will adjust dynamically
        frame.settingsContent:SetScrollChild(content)

        local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", content, "TOP", 0, -10)
        title:SetText("Settings")

        -- Create a group for channels
        local channelsGroup = CreateFrame("Frame", nil, content)
        channelsGroup:SetPoint("TOPLEFT", content, "TOPLEFT", 10, -40)
        channelsGroup:SetPoint("TOPRIGHT", content, "TOPRIGHT", -10, -40)
        channelsGroup:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
        channelsGroup:SetBackdropColor(0, 0, 0, 1)

        local channelsTitle = channelsGroup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        channelsTitle:SetPoint("TOP", channelsGroup, "TOP", 0, -10)
        channelsTitle:SetText("Channels")

        local xOffset = 10
        local yOffset = -40
        local maxColumns = 3
        local columnCount = 0

        -- Add General, Trade, Say, Yell, and Emote chat channels
        local channels = { "General", "Trade", "Say", "Yell", "Emote" }
        for i, channel in ipairs(channels) do
            local checkbox = CreateFrame("CheckButton", "SpamCollectorSettingsCheckbox" .. i, channelsGroup, "UICheckButtonTemplate")
            checkbox:SetPoint("TOPLEFT", channelsGroup, "TOPLEFT", xOffset, yOffset)
            _G[checkbox:GetName() .. "Text"]:SetText(channel)
            checkbox:SetChecked(SCollectorDB and SCollectorDB[channel] or false)
            checkbox:SetScript("OnClick", function(self)
                SCollectorDB[channel] = self:GetChecked()
            end)
            xOffset = xOffset + 200
            columnCount = columnCount + 1
            if columnCount >= maxColumns then
                xOffset = 10
                yOffset = yOffset - 25  -- Shrink the space between checkboxes
                columnCount = 0
            end
        end

        -- Add dynamically joined channels
        for i = 1, 20 do
            local channelNumber, channelName = GetChannelName(i)
            if channelName and channelName ~= "" and not tContains(channels, channelName) then
                local checkbox = CreateFrame("CheckButton", "SpamCollectorSettingsCheckbox" .. (i + #channels), channelsGroup, "UICheckButtonTemplate")
                checkbox:SetPoint("TOPLEFT", channelsGroup, "TOPLEFT", xOffset, yOffset)
                _G[checkbox:GetName() .. "Text"]:SetText(channelName)
                checkbox:SetChecked(SCollectorDB and SCollectorDB[channelName] or false)
                checkbox:SetScript("OnClick", function(self)
                    SCollectorDB[channelName] = self:GetChecked()
                end)
                xOffset = xOffset + 200
                columnCount = columnCount + 1
                if columnCount >= maxColumns then
                    xOffset = 10
                    yOffset = yOffset - 25  -- Shrink the space between checkboxes
                    columnCount = 0
                end
            end
        end

        -- Adjust channels group height based on the number of checkboxes
        local channelsGroupHeight = math.abs(yOffset) + 50  -- Shrink the height by 20 more
        channelsGroup:SetHeight(channelsGroupHeight)

        -- Add a textbox with a caption text under the channels
        local captionText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        captionText:SetPoint("TOPLEFT", channelsGroup, "BOTTOMLEFT", 10, -10)
        captionText:SetText("Enter LFM Keywords (comma separated):")

        local keywordsEditBox = CreateFrame("EditBox", nil, content, "InputBoxTemplate")
        keywordsEditBox:SetSize(580, 30)
        keywordsEditBox:SetPoint("TOPLEFT", captionText, "BOTTOMLEFT", 0, -10)
        keywordsEditBox:SetAutoFocus(false)
        keywordsEditBox:SetText(SCollectorDB and SCollectorDB.LFMKeyWords or "")
        keywordsEditBox:SetScript("OnTextChanged", function(self)
            SCollectorDB.LFMKeyWords = self:GetText()
        end)

        -- Adjust content height based on the number of checkboxes and keywords textbox
        local totalHeight = channelsGroupHeight + 120
        content:SetHeight(totalHeight)

        -- Add save button
        frame.saveButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        frame.saveButton:SetSize(100, 30)
        frame.saveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
        frame.saveButton:SetText("Save")
        frame.saveButton:SetScript("OnClick", function()
            -- Save settings to SCollectorDB
            for i = 1, 20 do
                local checkbox = _G["SpamCollectorSettingsCheckbox" .. i]
                if checkbox then
                    local channelName = _G[checkbox:GetName() .. "Text"]:GetText()
                    SCollectorDB[channelName] = checkbox:GetChecked()
                end
            end
            SCollectorDB.LFMKeyWords = keywordsEditBox:GetText()
        end)
    end

    frame.saveButton:Show()

    -- Load settings and join channels if not already joined
    for i = 1, 20 do
        local checkbox = _G["SpamCollectorSettingsCheckbox" .. i]
        if checkbox then
            local channelName = _G[checkbox:GetName() .. "Text"]:GetText()
            local isChecked = SCollectorDB and SCollectorDB[channelName] or false
            checkbox:SetChecked(isChecked)
            if isChecked then
                local channelNumber = GetChannelName(channelName)
                if channelNumber == 0 then
                    JoinChannelByName(channelName)
                end
            end
        end
    end

    frame.settingsContent:Show()
end
