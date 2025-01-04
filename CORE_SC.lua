SCollector = {}
local frameShown = false

function SCollector:ShowFrame()
    local frame = _G["SpamCollectorFrame"]
    if not frame then
        frame = CreateFrame("Frame", "SpamCollectorFrame", UIParent)
        frame:SetSize(700, 500)
        frame:SetPoint("CENTER")
        frame:Hide()

        frame:SetBackdrop({
            bgFile = "Interface\\CHARACTERFRAME\\UI-Party-Background",  -- Character frame background
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = false,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }
        })

        frame:SetBackdropColor(0, 0, 0, 1)  -- Set background color to black
        frame:SetBackdropBorderColor(1, 1, 1, 1)  -- Ensure border is not transparent

        local titleFrame = CreateFrame("Frame", nil, frame)
        titleFrame:SetSize(256, 64)
        titleFrame:SetPoint("TOP", frame, "TOP", 0, 30)

        local titleTexture = titleFrame:CreateTexture(nil, "ARTWORK")
        titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
        titleTexture:SetAllPoints(titleFrame)

        local leftGryphon = frame:CreateTexture(nil, "ARTWORK")
        leftGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
        leftGryphon:SetSize(90, 90)
        leftGryphon:SetPoint("RIGHT", titleFrame, "LEFT", 80, 39)

        local rightGryphon = frame:CreateTexture(nil, "ARTWORK")
        rightGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
        rightGryphon:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
        rightGryphon:SetSize(90, 90)
        rightGryphon:SetPoint("LEFT", titleFrame, "RIGHT", -80, 39)

        local topLeftCorner = frame:CreateTexture(nil, "OVERLAY")
        topLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
        topLeftCorner:SetSize(32, 32)
        topLeftCorner:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

        local topRightCorner = frame:CreateTexture(nil, "OVERLAY")
        topRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
        topRightCorner:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
        topRightCorner:SetSize(32, 32)
        topRightCorner:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

        local bottomLeftCorner = frame:CreateTexture(nil, "OVERLAY")
        bottomLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
        bottomLeftCorner:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
        bottomLeftCorner:SetSize(32, 32)
        bottomLeftCorner:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

        local bottomRightCorner = frame:CreateTexture(nil, "OVERLAY")
        bottomRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
        bottomRightCorner:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
        bottomRightCorner:SetSize(32, 32)
        bottomRightCorner:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

        local topMetal = frame:CreateTexture(nil, "OVERLAY")
        topMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
        topMetal:SetSize(256, 16)
        topMetal:SetPoint("TOP", frame, "TOP", 0, 8)

        local bottomMetal = frame:CreateTexture(nil, "OVERLAY")
        bottomMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
        bottomMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
        bottomMetal:SetSize(256, 16)
        bottomMetal:SetPoint("BOTTOM", frame, "BOTTOM", 0, -8)

        local leftMetal = frame:CreateTexture(nil, "OVERLAY")
        leftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
        leftMetal:SetTexCoord(0, 1, 1, 0)  -- Rotate the texture 90 degrees
        leftMetal:SetSize(16, 256)
        leftMetal:SetPoint("LEFT", frame, "LEFT", -8, 0)

        local rightMetal = frame:CreateTexture(nil, "OVERLAY")
        rightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
        rightMetal:SetTexCoord(0, 1, 0, 1)  -- Rotate the texture 90 degrees and flip horizontally
        rightMetal:SetSize(16, 256)
        rightMetal:SetPoint("RIGHT", frame, "RIGHT", 8, 0)

        local topLeftMetal = frame:CreateTexture(nil, "OVERLAY")
        topLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
        topLeftMetal:SetSize(32, 32)
        topLeftMetal:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

        local topRightMetal = frame:CreateTexture(nil, "OVERLAY")
        topRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
        topRightMetal:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
        topRightMetal:SetSize(32, 32)
        topRightMetal:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

        local bottomLeftMetal = frame:CreateTexture(nil, "OVERLAY")
        bottomLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
        bottomLeftMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
        bottomLeftMetal:SetSize(32, 32)
        bottomLeftMetal:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

        local bottomRightMetal = frame:CreateTexture(nil, "OVERLAY")
        bottomRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
        bottomRightMetal:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
        bottomRightMetal:SetSize(32, 32)
        bottomRightMetal:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

        frame:SetMovable(true)
        frame:EnableMouse(true)

        titleFrame:SetMovable(true)
        titleFrame:EnableMouse(true)
        titleFrame:RegisterForDrag("LeftButton")
        titleFrame:SetScript("OnDragStart", function() frame:StartMoving() end)
        titleFrame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)

        frame.title = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        frame.title:SetPoint("CENTER", titleFrame, "CENTER", 0, 12)
        frame.title:SetText("Spam Collector")

        -- Add content to the frame
        local content = CreateFrame("Frame", nil, frame)
        content:SetSize(680, 460)
        content:SetPoint("TOP", frame, "TOP", 0, -40)

        -- Add close button
        frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
        frame.closeButton:SetScript("OnClick", function()
            frame:Hide()
            frameShown = false
            SCollector:HideLFMContent()
            if frame.saveButton then
                frame.saveButton:Hide()
            end
        end)

        -- Add tabs
        local tab1 = CreateFrame("Button", "SpamCollectorFrameTab1", frame, "CharacterFrameTabButtonTemplate")
        tab1:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 5, 7)
        tab1:SetText("LFM")
        tab1:SetID(1)
        tab1:SetScript("OnClick", function(self)
            PanelTemplates_SetTab(frame, self:GetID())
            SCollector:ShowLFMContent()
            if frame.saveButton then
                frame.saveButton:Hide()
            end
        end)

        local tab2 = CreateFrame("Button", "SpamCollectorFrameTab2", frame, "CharacterFrameTabButtonTemplate")
        tab2:SetPoint("LEFT", tab1, "RIGHT", -15, 0)
        tab2:SetText("WTS")
        tab2:SetID(2)
        tab2:SetScript("OnClick", function(self)
            PanelTemplates_SetTab(frame, self:GetID())
            SCollector:ShowWTSContent()
            if frame.saveButton then
                frame.saveButton:Hide()
            end
        end)

        local tab3 = CreateFrame("Button", "SpamCollectorFrameTab3", frame, "CharacterFrameTabButtonTemplate")
        tab3:SetPoint("LEFT", tab2, "RIGHT", -15, 0)
        tab3:SetText("Other")
        tab3:SetID(3)
        tab3:SetScript("OnClick", function(self)
            PanelTemplates_SetTab(frame, self:GetID())
            SCollector:ShowOtherContent()
            if frame.saveButton then
                frame.saveButton:Hide()
            end
        end)

        local tab4 = CreateFrame("Button", "SpamCollectorFrameTab4", frame, "CharacterFrameTabButtonTemplate")
        tab4:SetPoint("LEFT", tab3, "RIGHT", -15, 0)
        tab4:SetText("Settings")
        tab4:SetID(4)
        tab4:SetScript("OnClick", function(self)
            PanelTemplates_SetTab(frame, self:GetID())
            SCollector:ShowSettingsContent()
        end)

        PanelTemplates_SetNumTabs(frame, 4)
        PanelTemplates_SetTab(frame, 1)
        SCollector:ShowLFMContent()
    end

    frame:Show()
    frameShown = true
end

local function OnInitialize()
    -- Called when the addon is loaded
end

local function OnEnable()
    -- Called when the addon is enabled
end

local function OnDisable()
    -- Called when the addon is disabled
end

SLASH_SCOLLECTOR1 = "/scshow"
SlashCmdList["SCOLLECTOR"] = function() SCollector:ShowFrame() end

OnInitialize()
