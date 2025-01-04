function SCollector:ShowWTSContent()
    local frame = _G["SpamCollectorFrame"]
    if not frame then return end

    -- Hide other content
    if frame.lfmContent then frame.lfmContent:Hide() end
    if frame.otherContent then frame.otherContent:Hide() end
    if frame.settingsContent then frame.settingsContent:Hide() end

    -- Create WTS content if it doesn't exist
    if not frame.wtsContent then
        frame.wtsContent = CreateFrame("Frame", nil, frame)
        frame.wtsContent:SetSize(680, 460)
        frame.wtsContent:SetPoint("TOP", frame, "TOP", 0, -40)

        local text = frame.wtsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("TOPLEFT", frame.wtsContent, "TOPLEFT", 10, -10)
        text:SetText("WTS Content")
    end

    frame.wtsContent:Show()
end
