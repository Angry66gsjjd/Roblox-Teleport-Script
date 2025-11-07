-- Trade Strength Teleporter by Angry66gsjjdYT
local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- KEY SYSTEM CONFIG
local KEY_CONFIG = {
    Enabled = true,
    MasterKey = "ANGRY666",
    KeyList = {"TEST1", "TEST2", "ANGRY666", "PREMIUM123"},
    Whitelist = {"Angry66gsjjdYT", "DDOSLANDOX", "MRlegenda63", "TestUser"},
    KeyUrl = "https://raw.githubusercontent.com/Angry66gsjjd/Roblox-Teleport-Script/main/keys.json",
    BackupUrl = "https://pastebin.com/fG0y3XEW"
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

-- Whitelist check
local function CheckWhitelist()
    local playerName = Player.Name:lower()
    for _, name in ipairs(KEY_CONFIG.Whitelist) do
        if playerName == name:lower() then return true end
    end
    return false
end

-- Create key GUI
local function CreateKeyGUI()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystemGUI"
    KeyGui.Parent = Player.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header

    -- Info
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -40, 0, 60)
    Info.Position = UDim2.new(0, 20, 0, 60)
    Info.BackgroundTransparency = 1
    Info.Text = "Trade Strength Teleporter v2.0\nby Angry66gsjjdYT\n\nKeys: TEST1, TEST2, ANGRY666"
    Info.TextColor3 = Color3.fromRGB(200, 200, 220)
    Info.TextSize = 14
    Info.Font = Enum.Font.Gotham
    Info.TextWrapped = true
    Info.Parent = MainFrame

    -- Key input
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 40)
    KeyBox.Position = UDim2.new(0, 20, 0, 130)
    KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyBox.PlaceholderText = "Enter key..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 16
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.Parent = MainFrame

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 8)
    KeyCorner.Parent = KeyBox

    -- Submit button
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 40)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 180)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    SubmitBtn.Text = "✅ ACTIVATE"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 16
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = SubmitBtn

    -- Status
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 30)
    Status.Position = UDim2.new(0, 20, 0, 230)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
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
            Status.Text = "❌ Please enter a key"
            return
        end

        if ValidateKey(key) or CheckWhitelist() then
            Status.TextColor3 = Color3.fromRGB(50, 255, 50)
            Status.Text = "✅ Access granted! Loading..."
            wait(1)
            KeyGui:Destroy()
            LoadMainScript()
        else
            Status.Text = "❌ Invalid key! Try: TEST1, TEST2"
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
    -- Simple GUI like Speed Hub X
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TradeStrengthHub"
    ScreenGui.Parent = Player.PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0, 20, 0, 20)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🚀 TRADE STRENGTH HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 50)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "by Angry66gsjjdYT | Whitelist: DDOSLANDOX, MRlegenda63"
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    SubTitle.TextSize = 11
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Parent = MainFrame

    -- Teleport positions
    local Positions = {
        {name = "📍 Start Position", pos = Vector3.new(28.12, 7.73, -354.76)},
        {name = "📍 High Point 1", pos = Vector3.new(-296.65, 87.49, -349.02)},
        {name = "📍 Central Zone", pos = Vector3.new(-294.83, 88.18, -377.18)},
        {name = "📍 End Point", pos = Vector3.new(-281.98, 88.09, -386.91)}
    }

    local currentIndex = 1

    -- Teleport function
    local function TeleportTo(position, name)
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(position)})
            tween:Play()
            print("✅ Teleported: " .. name)
        end
    end

    -- Create buttons
    local ButtonsFrame = Instance.new("ScrollingFrame")
    ButtonsFrame.Size = UDim2.new(1, -20, 0, 280)
    ButtonsFrame.Position = UDim2.new(0, 10, 0, 80)
    ButtonsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    ButtonsFrame.BorderSizePixel = 0
    ButtonsFrame.ScrollBarThickness = 4
    ButtonsFrame.Parent = MainFrame

    local ButtonsCorner = Instance.new("UICorner")
    ButtonsCorner.CornerRadius = UDim.new(0, 8)
    ButtonsCorner.Parent = ButtonsFrame

    for i, pos in ipairs(Positions) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.Position = UDim2.new(0, 5, 0, (i-1) * 45)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Btn.Text = pos.name
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 14
        Btn.Font = Enum.Font.Gotham
        Btn.Parent = ButtonsFrame
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(function()
            TeleportTo(pos.pos, pos.name)
        end)
    end

    ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, #Positions * 45)

    -- Next position button
    local NextBtn = Instance.new("TextButton")
    NextBtn.Size = UDim2.new(1, -20, 0, 35)
    NextBtn.Position = UDim2.new(0, 10, 0, 370)
    NextBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    NextBtn.Text = "🔄 Next Position (F)"
    NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NextBtn.TextSize = 14
    NextBtn.Font = Enum.Font.Gotham
    NextBtn.Parent = MainFrame

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

    -- Key bind
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            NextBtn.MouseButton1Click:Fire()
        end
    end)

    print("🚀 Trade Strength Hub loaded!")
    print("👑 Whitelist: DDOSLANDOX, MRlegenda63")
    print("🎯 Controls: F - Next position")
end

-- INIT
if KEY_CONFIG.Enabled then
    if CheckWhitelist() then
        print("👑 Whitelist access granted for: " .. Player.Name)
        LoadMainScript()
    else
        CreateKeyGUI()
    end
else
    LoadMainScript()
end
