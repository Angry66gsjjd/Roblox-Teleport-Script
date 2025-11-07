-- Trade Strength Teleporter Premium by Angry66gsjjdYT
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- KEY SYSTEM CONFIG
local KEY_CONFIG = {
    Enabled = true,
    MasterKey = "ANGRY666",
    KeyList = {"TEST1", "TEST2", "ANGRY666", "PREMIUM123"},
    Whitelist = {"Angry66gsjjdYT", "DDOSLANDOX", "MRlegenda63", "TestUser"},
    KeyUrl = "https://raw.githubusercontent.com/Angry66gsjjd/Roblox-Teleport-Script/main/keys.json",
    BackupUrl = "https://pastebin.com/raw/fG0y3XEW"
}

-- Load keys from web
local function LoadWebKeys()
    local function tryLoad(url)
        local success, data = pcall(function()
            local response = game:HttpGet(url)
            return HttpService:JSONDecode(response)
        end)
        return success and data or nil
    end
    
    return tryLoad(KEY_CONFIG.KeyUrl) or tryLoad(KEY_CONFIG.BackupUrl)
end

-- Key validation
local function ValidateKey(inputKey)
    if not KEY_CONFIG.Enabled then return true end
    
    inputKey = inputKey:upper():gsub("%s+", "")
    
    -- Check web keys first
    local webKeys = LoadWebKeys()
    if webKeys and webKeys.valid_keys then
        for _, key in ipairs(webKeys.valid_keys) do
            if inputKey == key:upper() then return true end
        end
    end
    
    -- Check local keys
    for _, key in ipairs(KEY_CONFIG.KeyList) do
        if inputKey == key:upper() then return true end
    end
    
    return inputKey == KEY_CONFIG.MasterKey
end

-- Create key GUI (показывается ВСЕМ)
local function CreateKeyGUI()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystemGUI"
    KeyGui.Parent = Player.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 KEY SYSTEM REQUIRED"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header

    -- Info
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -40, 0, 80)
    Info.Position = UDim2.new(0, 20, 0, 80)
    Info.BackgroundTransparency = 1
    Info.Text = "Trade Strength Teleporter Premium\nby Angry66gsjjdYT\n\nДоступные ключи: TEST1, TEST2, ANGRY666"
    Info.TextColor3 = Color3.fromRGB(200, 200, 220)
    Info.TextSize = 14
    Info.Font = Enum.Font.Gotham
    Info.TextWrapped = true
    Info.Parent = MainFrame

    -- Key input
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 50)
    KeyBox.Position = UDim2.new(0, 20, 0, 170)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyBox.PlaceholderText = "Введите ключ..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 18
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextXAlignment = Enum.TextXAlignment.Center
    KeyBox.Parent = MainFrame

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 10)
    KeyCorner.Parent = KeyBox

    -- Submit button
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 50)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 230)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    SubmitBtn.Text = "✅ АКТИВИРОВАТЬ"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 18
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = SubmitBtn

    -- Status
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 40)
    Status.Position = UDim2.new(0, 20, 0, 290)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.Parent = MainFrame

    -- Button animations
    SubmitBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
    end)

    SubmitBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 100, 255)}):Play()
    end)

    -- Submit handler
    SubmitBtn.MouseButton1Click:Connect(function()
        local key = KeyBox.Text:gsub("%s+", "")
        if key == "" then
            Status.Text = "❌ Пожалуйста, введите ключ"
            return
        end

        if ValidateKey(key) then
            Status.TextColor3 = Color3.fromRGB(50, 255, 50)
            Status.Text = "✅ Ключ принят! Загрузка..."
            wait(1.5)
            KeyGui:Destroy()
            LoadMainScript()
        else
            Status.Text = "❌ Неверный ключ! Попробуйте: TEST1, TEST2"
        end
    end)

    -- Enter key support
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitBtn.MouseButton1Click:Fire()
        end
    end)

    return KeyGui
end

-- Main script loader
function LoadMainScript()
    local MainGUI = Instance.new("ScreenGui")
    MainGUI.Name = "TradeStrengthHub"
    MainGUI.ResetOnSpawn = false -- GUI не исчезает при смерти
    MainGUI.Parent = Player.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0, 20, 0, 20)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainGUI

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🚀 TRADE STRENGTH HUB PREMIUM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 80, 0, 30)
    CloseBtn.Position = UDim2.new(1, -90, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseBtn.Text = "Close (RShift)"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    -- Tabs
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0, 40)
    TabsFrame.Position = UDim2.new(0, 0, 0, 50)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = MainFrame

    local TabButtons = {}
    local TabContents = {}

    -- Create tabs
    local tabs = {"MAIN", "LOCAL PLAYER", "SETTINGS", "INFO"}

    for i, tabName in ipairs(tabs) do
        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        TabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 12
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.Parent = TabsFrame
        
        -- Tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -20, 0, 350)
        TabContent.Position = UDim2.new(0, 10, 0, 100)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = (i == 1)
        TabContent.Parent = MainFrame
        
        TabButtons[tabName] = TabBtn
        TabContents[tabName] = TabContent

        -- Tab click handler
        TabBtn.MouseButton1Click:Connect(function()
            for name, content in pairs(TabContents) do
                content.Visible = (name == tabName)
            end
            for name, btn in pairs(TabButtons) do
                if name == tabName then
                    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end)
    end

    -- Set first tab as active
    TabButtons["MAIN"].BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    TabButtons["MAIN"].TextColor3 = Color3.fromRGB(255, 255, 255)

    -- ========== MAIN TAB ==========
    local MainTab = TabContents["MAIN"]
    MainTab.CanvasSize = UDim2.new(0, 0, 0, 600)

    -- Teleport positions
    local Positions = {
        {name = "📍 Start Position", pos = Vector3.new(28.12, 7.73, -354.76)},
        {name = "📍 High Point 1", pos = Vector3.new(-296.65, 87.49, -349.02)},
        {name = "📍 Central Zone", pos = Vector3.new(-294.83, 88.18, -377.18)},
        {name = "📍 End Point", pos = Vector3.new(-281.98, 88.09, -386.91)}
    }

    local currentIndex = 1
    local autoFarmEnabled = false

    -- Teleport function
    local function TeleportTo(position, name)
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(position)})
            tween:Play()
            print("✅ Teleported: " .. name)
        end
    end

    -- Create position buttons
    local yPos = 10
    for i, pos in ipairs(Positions) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.Position = UDim2.new(0, 5, 0, yPos)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Btn.Text = pos.name
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 14
        Btn.Font = Enum.Font.Gotham
        Btn.Parent = MainTab
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            TeleportTo(pos.pos, pos.name)
        end)
        
        yPos = yPos + 45
    end

    -- Auto Farm Toggle
    local AutoFarmToggle = Instance.new("TextButton")
    AutoFarmToggle.Size = UDim2.new(1, -10, 0, 35)
    AutoFarmToggle.Position = UDim2.new(0, 5, 0, yPos + 10)
    AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    AutoFarmToggle.Text = "⚡ Auto Farm: OFF"
    AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmToggle.TextSize = 14
    AutoFarmToggle.Font = Enum.Font.Gotham
    AutoFarmToggle.Parent = MainTab

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = AutoFarmToggle

    AutoFarmToggle.MouseButton1Click:Connect(function()
        autoFarmEnabled = not autoFarmEnabled
        if autoFarmEnabled then
            AutoFarmToggle.Text = "⚡ Auto Farm: ON"
            AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
        else
            AutoFarmToggle.Text = "⚡ Auto Farm: OFF"
            AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
    end)

    -- Next position button
    local NextBtn = Instance.new("TextButton")
    NextBtn.Size = UDim2.new(1, -10, 0, 35)
    NextBtn.Position = UDim2.new(0, 5, 0, yPos + 50)
    NextBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    NextBtn.Text = "🔄 Next Position (F)"
    NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NextBtn.TextSize = 14
    NextBtn.Font = Enum.Font.Gotham
    NextBtn.Parent = MainTab

    local NextCorner = Instance.new("UICorner")
    NextCorner.CornerRadius = UDim.new(0, 6)
    NextCorner.Parent = NextBtn

    NextBtn.MouseButton1Click:Connect(function()
        if currentIndex <= #Positions then
            local pos = Positions[currentIndex]
            TeleportTo(pos.pos, pos.name)
            currentIndex = currentIndex + 1
            if currentIndex > #Positions then currentIndex = 1 end
        end
    end)

    -- ========== LOCAL PLAYER TAB ==========
    local LocalTab = TabContents["LOCAL PLAYER"]
    LocalTab.CanvasSize = UDim2.new(0, 0, 0, 400)

    local scripts = {
        {name = "Infinite Yield", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {name = "Dex Explorer", url = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"},
        {name = "SimpleSpy", url = "https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"},
        {name = "RemoteSpy", url = "https://raw.githubusercontent.com/FilteringEnabled/NilLib/main/RemoteSpy.lua"},
        {name = "ChatBypass", url = "https://raw.githubusercontent.com/LuaXPL/luaxploit/main/ChatBypass.lua"},
        {name = "Fly Script", url = "https://raw.githubusercontent.com/XNEOFF/FlyScriptV3/main/FlyScriptV3.txt"},
        {name = "Speed Hack", url = "https://raw.githubusercontent.com/XNEOFF/SpeedScript/main/Speed.txt"}
    }

    local yPosLocal = 10
    for i, script in ipairs(scripts) do
        local ScriptBtn = Instance.new("TextButton")
        ScriptBtn.Size = UDim2.new(1, -10, 0, 35)
        ScriptBtn.Position = UDim2.new(0, 5, 0, yPosLocal)
        ScriptBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        ScriptBtn.Text = "📜 " .. script.name
        ScriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ScriptBtn.TextSize = 13
        ScriptBtn.Font = Enum.Font.Gotham
        ScriptBtn.Parent = LocalTab
        
        local ScriptCorner = Instance.new("UICorner")
        ScriptCorner.CornerRadius = UDim.new(0, 6)
        ScriptCorner.Parent = ScriptBtn
        
        ScriptBtn.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(script.url))()
            end)
            if success then
                print("✅ " .. script.name .. " loaded!")
            else
                print("❌ Failed to load " .. script.name)
            end
        end)
        
        yPosLocal = yPosLocal + 40
    end

    -- ========== SETTINGS TAB ==========
    local SettingsTab = TabContents["SETTINGS"]
    SettingsTab.CanvasSize = UDim2.new(0, 0, 0, 300)

    local yPosSettings = 10

    -- WalkSpeed Slider
    local WalkSpeedLabel = Instance.new("TextLabel")
    WalkSpeedLabel.Size = UDim2.new(1, -10, 0, 25)
    WalkSpeedLabel.Position = UDim2.new(0, 5, 0, yPosSettings)
    WalkSpeedLabel.BackgroundTransparency = 1
    WalkSpeedLabel.Text = "Walk Speed: 16"
    WalkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WalkSpeedLabel.TextSize = 14
    WalkSpeedLabel.Font = Enum.Font.Gotham
    WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    WalkSpeedLabel.Parent = SettingsTab

    local WalkSpeedSlider = Instance.new("Frame")
    WalkSpeedSlider.Size = UDim2.new(1, -10, 0, 20)
    WalkSpeedSlider.Position = UDim2.new(0, 5, 0, yPosSettings + 25)
    WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    WalkSpeedSlider.Parent = SettingsTab

    local WalkSpeedFill = Instance.new("Frame")
    WalkSpeedFill.Size = UDim2.new(0.5, 0, 1, 0)
    WalkSpeedFill.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    WalkSpeedFill.Parent = WalkSpeedSlider

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 4)
    SliderCorner.Parent = WalkSpeedSlider

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = WalkSpeedFill

    yPosSettings = yPosSettings + 55

    -- JumpPower Slider
    local JumpPowerLabel = Instance.new("TextLabel")
    JumpPowerLabel.Size = UDim2.new(1, -10, 0, 25)
    JumpPowerLabel.Position = UDim2.new(0, 5, 0, yPosSettings)
    JumpPowerLabel.BackgroundTransparency = 1
    JumpPowerLabel.Text = "Jump Power: 50"
    JumpPowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpPowerLabel.TextSize = 14
    JumpPowerLabel.Font = Enum.Font.Gotham
    JumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
    JumpPowerLabel.Parent = SettingsTab

    local JumpPowerSlider = Instance.new("Frame")
    JumpPowerSlider.Size = UDim2.new(1, -10, 0, 20)
    JumpPowerSlider.Position = UDim2.new(0, 5, 0, yPosSettings + 25)
    JumpPowerSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    JumpPowerSlider.Parent = SettingsTab

    local JumpPowerFill = Instance.new("Frame")
    JumpPowerFill.Size = UDim2.new(0.5, 0, 1, 0)
    JumpPowerFill.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    JumpPowerFill.Parent = JumpPowerSlider

    local SliderCorner2 = Instance.new("UICorner")
    SliderCorner2.CornerRadius = UDim.new(0, 4)
    SliderCorner2.Parent = JumpPowerSlider

    local FillCorner2 = Instance.new("UICorner")
    FillCorner2.CornerRadius = UDim.new(0, 4)
    FillCorner2.Parent = JumpPowerFill

    yPosSettings = yPosSettings + 55

    -- Noclip Toggle
    local NoclipToggle = Instance.new("TextButton")
    NoclipToggle.Size = UDim2.new(1, -10, 0, 35)
    NoclipToggle.Position = UDim2.new(0, 5, 0, yPosSettings)
    NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    NoclipToggle.Text = "👻 Noclip: OFF"
    NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoclipToggle.TextSize = 14
    NoclipToggle.Font = Enum.Font.Gotham
    NoclipToggle.Parent = SettingsTab

    local NoclipCorner = Instance.new("UICorner")
    NoclipCorner.CornerRadius = UDim.new(0, 6)
    NoclipCorner.Parent = NoclipToggle

    local noclipEnabled = false
    local noclipConnection

    NoclipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then
            NoclipToggle.Text = "👻 Noclip: ON"
            NoclipToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            -- Noclip logic here
        else
            NoclipToggle.Text = "👻 Noclip: OFF"
            NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            if noclipConnection then
                noclipConnection:Disconnect()
            end
        end
    end)

    -- ========== INFO TAB ==========
    local InfoTab = TabContents["INFO"]
    InfoTab.CanvasSize = UDim2.new(0, 0, 0, 200)

    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -10, 1, -10)
    InfoText.Position = UDim2.new(0, 5, 0, 5)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = "Trade Strength Hub Premium\nby Angry66gsjjdYT\n\nVersion: 2.0\nKey System: ACTIVE\n\nFeatures:\n• 4 Teleport Positions\n• Auto Farm System\n• Local Player Scripts\n• Custom Settings\n• Noclip & Speed Hacks\n\nControls:\nF - Next Position\nRightShift - Toggle GUI"
    InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoText.TextSize = 12
    InfoText.Font = Enum.Font.Gotham
    InfoText.TextWrapped = true
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.Parent = InfoTab

    -- ========== KEY BINDS ==========
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            NextBtn.MouseButton1Click:Fire()
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            MainGUI.Enabled = not MainGUI.Enabled
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        MainGUI.Enabled = false
    end)

    print("🚀 Trade Strength Hub Premium loaded!")
    print("🔐 Key System: ACTIVE")
    print("🎯 Controls: F - Next Position, RightShift - Toggle GUI")
    print("📱 Tabs: Main, Local Player, Settings, Info")
end

-- INIT - Ключ-система показывается ВСЕМ
if KEY_CONFIG.Enabled then
    CreateKeyGUI()
else
    LoadMainScript()
end
