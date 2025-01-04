function SCollector:ShowOtherContent()
    local frame = _G["SpamCollectorFrame"]
    if not frame then return end

    -- Hide other content
    if frame.lfmContent then frame.lfmContent:Hide() end
    if frame.wtsContent then frame.wtsContent:Hide() end
    if frame.settingsContent then frame.settingsContent:Hide() end

    -- Create Other content if it doesn't exist
    if not frame.otherContent then
        frame.otherContent = CreateFrame("Frame", nil, frame)
        frame.otherContent:SetSize(680, 460)
        frame.otherContent:SetPoint("TOP", frame, "TOP", 0, -40)

        local text = frame.otherContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("TOPLEFT", frame.otherContent, "TOPLEFT", 10, -10)
        text:SetText("Other Content")
    end

    frame.otherContent:Show()
end
