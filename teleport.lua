-- Trade Strength Simulator Teleport Script with Secure Key System
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Настройки ключ-системы
local KEY_SYSTEM = {
    ENABLED = true,
    KEY = "ANGRY666",  -- Основной ключ
    VALID_KEYS = {"TEST1", "TEST2", "ANGRY666", "PREMIUM123"},
    WHITELIST = {
        "Angry66gsjjdYT",
        "DDOSLANDOX", 
        "MRlegenda63"
    }
}

-- Проверка ключа
local function validateKey(key)
    key = key:upper():gsub("%s+", "")
    for _, validKey in ipairs(KEY_SYSTEM.VALID_KEYS) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Проверка вайтлиста
local function checkWhitelist()
    local playerName = Player.Name
    for _, whitelistedName in ipairs(KEY_SYSTEM.WHITELIST) do
        if playerName:lower() == whitelistedName:lower() then
            return true
        end
    end
    return false
end

-- Создание GUI для ключ-системы
local function createKeyGUI()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "SecureKeySystem"
    KeyGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Основной фрейм
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = MainFrame
    
    -- Градиентный фон
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 80))
    })
    Gradient.Rotation = 135
    Gradient.Parent = MainFrame
    
    -- Верхняя панель
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 80)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 20)
    TopCorner.Parent = TopBar
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 SECURE ACCESS SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TopBar
    
    -- Подзаголовок
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -40, 0, 60)
    SubTitle.Position = UDim2.new(0, 20, 0, 90)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Trade Strength Teleporter v2.0\nby Angry66gsjjdYT"
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
    SubTitle.TextSize = 16
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextWrapped = true
    SubTitle.Parent = MainFrame
    
    -- Информация о ключах
    local KeyInfo = Instance.new("TextLabel")
    KeyInfo.Size = UDim2.new(1, -40, 0, 50)
    KeyInfo.Position = UDim2.new(0, 20, 0, 160)
    KeyInfo.BackgroundTransparency = 1
    KeyInfo.Text = "Доступные ключи: TEST1, TEST2, ANGRY666\nВайтлист: DDOSLANDOX, MRlegenda63"
    KeyInfo.TextColor3 = Color3.fromRGB(180, 180, 200)
    KeyInfo.TextSize = 14
    KeyInfo.Font = Enum.Font.Gotham
    KeyInfo.TextWrapped = true
    KeyInfo.Parent = MainFrame
    
    -- Поле ввода ключа
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 50)
    KeyInput.Position = UDim2.new(0, 20, 0, 220)
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyInput.PlaceholderText = "Введите ключ доступа..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 18
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextXAlignment = Enum.TextXAlignment.Center
    KeyInput.Parent = MainFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 12)
    InputCorner.Parent = KeyInput
    
    -- Кнопка подтверждения
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(1, -40, 0, 50)
    SubmitButton.Position = UDim2.new(0, 20, 0, 285)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    SubmitButton.Text = "🚀 АКТИВИРОВАТЬ ДОСТУП"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = SubmitButton
    
    -- Статус
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 30)
    StatusLabel.Position = UDim2.new(0, 20, 0, 345)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = MainFrame
    
    local function showStatus(message, isSuccess)
        StatusLabel.Text = message
        if isSuccess then
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
    
    -- Анимации кнопки
    SubmitButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(100, 180, 255),
            Size = UDim2.new(1, -30, 0, 55)
        }):Play()
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(80, 160, 255),
            Size = UDim2.new(1, -40, 0, 50)
        }):Play()
    end)
    
    -- Обработчик ввода
    SubmitButton.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text
        
        if inputKey == "" then
            showStatus("❌ Введите ключ доступа!", false)
            return
        end
        
        if validateKey(inputKey) or checkWhitelist() then
            showStatus("✅ Доступ разрешен! Загрузка...", true)
            
            -- Анимация успеха
            game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.5), {
                BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            }):Play()
            
            wait(1.5)
            KeyGui:Destroy()
            loadMainScript()
        else
            showStatus("❌ Неверный ключ! Попробуйте: TEST1, TEST2", false)
            
            -- Анимация ошибки
            local originalColor = KeyInput.BackgroundColor3
            game:GetService("TweenService"):Create(KeyInput, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            }):Play()
            wait(0.5)
            game:GetService("TweenService"):Create(KeyInput, TweenInfo.new(0.2), {
                BackgroundColor3 = originalColor
            }):Play()
        end
    end)
    
    -- Автоочистка при фокусе
    KeyInput.Focused:Connect(function()
        if KeyInput.Text == "Введите ключ доступа..." then
            KeyInput.Text = ""
        end
    end)
    
    -- Enter для подтверждения
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
    
    return KeyGui
end

-- Основная функция загрузки скрипта
function loadMainScript()
    -- Используем простую библиотеку для GUI
    local function createSimpleGUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "TradeStrengthTeleporter"
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 400, 0, 500)
        MainFrame.Position = UDim2.new(0, 20, 0, 20)
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 15)
        UICorner.Parent = MainFrame
        
        -- Градиент
        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 85))
        })
        Gradient.Rotation = 45
        Gradient.Parent = MainFrame
        
        -- Заголовок
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 60)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Title.Text = "🚀 TRADE STRENGTH TELEPORTER"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.Parent = MainFrame
        
        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 15)
        TitleCorner.Parent = Title
        
        -- Позиции для телепортации
        local teleportPositions = {
            {name = "📍 Стартовая позиция", position = Vector3.new(28.120019912719727, 7.735681056976318, -354.760009765625)},
            {name = "📍 Высокая точка 1", position = Vector3.new(-296.6466979980469, 87.49390411376953, -349.0245056152344)},
            {name = "📍 Центральная зона", position = Vector3.new(-294.8343811035156, 88.18395233154297, -377.1786804199219)},
            {name = "📍 Конечная точка", position = Vector3.new(-281.97833251953125, 88.0938720703125, -386.9106750488281)}
        }

        local currentPositionIndex = 1
        local autoTeleportActive = false

        -- Функция телепортации
        local function teleportToPosition(position, positionName)
            local character = Player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
                    tween:Play()
                    print("✅ Телепортирован: " .. positionName)
                end
            end
        end

        -- Создание кнопок телепортации
        local PositionsFrame = Instance.new("ScrollingFrame")
        PositionsFrame.Size = UDim2.new(1, -20, 0, 300)
        PositionsFrame.Position = UDim2.new(0, 10, 0, 70)
        PositionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        PositionsFrame.BorderSizePixel = 0
        PositionsFrame.ScrollBarThickness = 6
        PositionsFrame.Parent = MainFrame
        
        local PositionsCorner = Instance.new("UICorner")
        PositionsCorner.CornerRadius = UDim.new(0, 10)
        PositionsCorner.Parent = PositionsFrame

        for i, posData in ipairs(teleportPositions) do
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 50)
            Button.Position = UDim2.new(0, 5, 0, (i-1) * 55)
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
            Button.Text = posData.name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Parent = PositionsFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                teleportToPosition(posData.position, posData.name)
            end)
        end

        PositionsFrame.CanvasSize = UDim2.new(0, 0, 0, #teleportPositions * 55)

        -- Кнопка следующей позиции
        local NextButton = Instance.new("TextButton")
        NextButton.Size = UDim2.new(1, -20, 0, 40)
        NextButton.Position = UDim2.new(0, 10, 0, 385)
        NextButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        NextButton.Text = "🔄 Следующая позиция (F)"
        NextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        NextButton.TextSize = 14
        NextButton.Font = Enum.Font.Gotham
        NextButton.Parent = MainFrame
        
        local NextCorner = Instance.new("UICorner")
        NextCorner.CornerRadius = UDim.new(0, 8)
        NextCorner.Parent = NextButton

        NextButton.MouseButton1Click:Connect(function()
            if currentPositionIndex <= #teleportPositions then
                local nextPosition = teleportPositions[currentPositionIndex].position
                local positionName = teleportPositions[currentPositionIndex].name
                teleportToPosition(nextPosition, positionName)
                currentPositionIndex = currentPositionIndex + 1
                if currentPositionIndex > #teleportPositions then
                    currentPositionIndex = 1
                end
            end
        end)

        -- Информация
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Size = UDim2.new(1, -20, 0, 40)
        InfoLabel.Position = UDim2.new(0, 10, 0, 435)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Text = "by Angry66gsjjdYT | 👑 DDOSLANDOX, MRlegenda63"
        InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        InfoLabel.TextSize = 12
        InfoLabel.Font = Enum.Font.Gotham
        InfoLabel.Parent = MainFrame

        -- Обработчики клавиш
        UIS.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F then
                NextButton.MouseButton1Click:Fire()
            end
        end)

        return ScreenGui
    end

    -- Запускаем простой GUI
    createSimpleGUI()
    
    print("🎮 Trade Strength Teleporter v2.0 активирован!")
    print("👑 Премиум доступ: DDOSLANDOX, MRlegenda63")
    print("🔑 Ключ-система: TEST1, TEST2")
    print("🎯 Управление: F - Следующая позиция")
end

-- Основная инициализация
if KEY_SYSTEM.ENABLED then
    if checkWhitelist() then
        print("👑 Вайтлист пользователь обнаружен: " .. Player.Name)
        loadMainScript()
    else
        print("🔐 Запуск ключ-системы...")
        createKeyGUI()
    end
else
    loadMainScript()
end
