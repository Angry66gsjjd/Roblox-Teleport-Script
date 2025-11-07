-- Trade Strength Simulator Teleport Script with Cloud Key System
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Настройки облачной ключ-системы
local KEY_SYSTEM = {
    ENABLED = true,
    -- Ваш ключ для проверки
    MASTER_KEY = "ANGRY666",
    -- URL к вашему файлу с ключами на GitHub или другом хостинге
    KEYS_URL = "https://raw.githubusercontent.com/Angry66gsjjd/Roblox-Teleport-Script/main/keys.json",
    -- Резервный URL (можно использовать Pastebin, Discord Webhook и т.д.)
    BACKUP_URL = "https://pastebin.com/raw/YourPasteID",
    -- Вайтлист ников
    WHITELIST = {
        "Angry66gsjjdYT",
        "DDOSLANDOX",
        "MRlegenda63",
        "TestUser"
    }
}

-- Функция для загрузки ключей с веб-хостинга
local function loadKeysFromWeb()
    local success, keysData = pcall(function()
        -- Пробуем основной URL
        local response = game:HttpGet(KEY_SYSTEM.KEYS_URL, true)
        return HttpService:JSONDecode(response)
    end)
    
    if not success then
        -- Если основной URL не работает, пробуем резервный
        success, keysData = pcall(function()
            local response = game:HttpGet(KEY_SYSTEM.BACKUP_URL, true)
            return HttpService:JSONDecode(response)
        end)
    end
    
    if success and keysData then
        return keysData
    end
    
    return nil
end

-- Проверка ключа через облако
local function validateKeyCloud(key)
    if not KEY_SYSTEM.ENABLED then
        return true
    end
    
    local keysData = loadKeysFromWeb()
    
    if keysData and keysData.valid_keys then
        for _, validKey in ipairs(keysData.valid_keys) do
            if key:upper() == validKey:upper() then
                return true
            end
        end
    end
    
    -- Резервная проверка локальным ключом
    return key:upper() == KEY_SYSTEM.MASTER_KEY
end

-- Проверка вайтлиста через облако
local function checkWhitelistCloud()
    if not KEY_SYSTEM.ENABLED then
        return true
    end
    
    local playerName = Player.Name
    local keysData = loadKeysFromWeb()
    
    -- Проверка облачного вайтлиста
    if keysData and keysData.whitelist then
        for _, whitelistedName in ipairs(keysData.whitelist) do
            if playerName:lower() == whitelistedName:lower() then
                return true
            end
        end
    end
    
    -- Проверка локального вайтлиста
    for _, whitelistedName in ipairs(KEY_SYSTEM.WHITELIST) do
        if playerName:lower() == whitelistedName:lower() then
            return true
        end
    end
    
    return false
end

-- Создание GUI для ввода ключа
local function createKeyGUI()
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystemGUI"
    KeyGui.Parent = Player:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame
    
    -- Градиентный фон
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 75))
    })
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    Title.Text = "🔐 PREMIUM KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = Title
    
    -- Описание
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -40, 0, 80)
    Desc.Position = UDim2.new(0, 20, 0, 80)
    Desc.BackgroundTransparency = 1
    Desc.Text = "Для доступа к скрипту требуется ключ\n\nДоступные ключи: Test1, Test2, ANGRY666\nПолучите ключ у разработчика"
    Desc.TextColor3 = Color3.fromRGB(200, 200, 220)
    Desc.TextSize = 14
    Desc.Font = Enum.Font.Gotham
    Desc.TextWrapped = true
    Desc.Parent = MainFrame
    
    -- Поле ввода ключа
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 45)
    KeyInput.Position = UDim2.new(0, 20, 0, 170)
    KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    KeyInput.PlaceholderText = "Введите ключ здесь..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.Parent = MainFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = KeyInput
    
    -- Кнопка подтверждения
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(1, -40, 0, 45)
    SubmitButton.Position = UDim2.new(0, 20, 0, 230)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    SubmitButton.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = SubmitButton
    
    -- Сообщение об ошибке
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Size = UDim2.new(1, -40, 0, 25)
    ErrorLabel.Position = UDim2.new(0, 20, 0, 285)
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ErrorLabel.TextSize = 12
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.Parent = MainFrame
    
    local function showError(message)
        ErrorLabel.Text = message
        wait(3)
        ErrorLabel.Text = ""
    end
    
    local function showSuccess(message)
        ErrorLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        ErrorLabel.Text = message
        wait(2)
        ErrorLabel.Text = ""
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    SubmitButton.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text:gsub("%s+", ""):upper()
        
        if inputKey == "" then
            showError("❌ Введите ключ!")
            return
        end
        
        if validateKeyCloud(inputKey) or checkWhitelistCloud() then
            showSuccess("✅ Ключ принят! Загрузка...")
            wait(1)
            KeyGui:Destroy()
            loadMainScript()
        else
            showError("❌ Неверный ключ! Попробуйте: Test1, Test2")
        end
    end)
    
    -- Автозаполнение при фокусе
    KeyInput.Focused:Connect(function()
        KeyInput.Text = ""
    end)
    
    -- Анимация кнопки
    SubmitButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 180, 255)}):Play()
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(SubmitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 160, 255)}):Play()
    end)
    
    return KeyGui
end

-- Основная функция загрузки скрипта
function loadMainScript()
    -- Альтернативная библиотека для GUI
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("🚀 Trade Strength Teleporter | Premium", "Midnight")

    -- Позиции для телепортации
    local teleportPositions = {
        {name = "📍 Стартовая позиция", position = Vector3.new(28.120019912719727, 7.735681056976318, -354.760009765625)},
        {name = "📍 Высокая точка 1", position = Vector3.new(-296.6466979980469, 87.49390411376953, -349.0245056152344)},
        {name = "📍 Центральная зона", position = Vector3.new(-294.8343811035156, 88.18395233154297, -377.1786804199219)},
        {name = "📍 Конечная точка", position = Vector3.new(-281.97833251953125, 88.0938720703125, -386.9106750488281)}
    }

    local currentPositionIndex = 1
    local autoTeleportActive = false

    -- Функция для радужного текста
    local function createRainbowText()
        local colors = {
            Color3.fromRGB(255, 0, 0),    -- Красный
            Color3.fromRGB(255, 165, 0),  -- Оранжевый
            Color3.fromRGB(255, 255, 0),  -- Желтый
            Color3.fromRGB(0, 255, 0),    -- Зеленый
            Color3.fromRGB(0, 0, 255),    -- Синий
            Color3.fromRGB(75, 0, 130),   -- Индиго
            Color3.fromRGB(238, 130, 238) -- Фиолетовый
        }
        
        local currentColorIndex = 1
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if Window then
                -- Обновляем название окна с радужным эффектом
                Window:ChangeText("🚀 Trade Strength Teleporter | Premium | by Angry66gsjjdYT")
            end
        end)
        
        return connection
    end

    -- Запускаем радужный текст
    local rainbowConnection = createRainbowText()

    -- Функция телепортации
    function teleportToPosition(position, positionName)
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Плавная телепортация
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
                tween:Play()
                
                print("✅ Телепортирован: " .. positionName)
            else
                warn("HumanoidRootPart не найден!")
            end
        else
            warn("Персонаж не найден!")
        end
    end

    -- Функция последовательной телепортации
    function teleportToNextPosition()
        if currentPositionIndex <= #teleportPositions then
            local nextPosition = teleportPositions[currentPositionIndex].position
            local positionName = teleportPositions[currentPositionIndex].name
            teleportToPosition(nextPosition, positionName)
            currentPositionIndex = currentPositionIndex + 1
            
            if currentPositionIndex > #teleportPositions then
                currentPositionIndex = 1
                print("🔁 Цикл завершен. Начинаем сначала.")
            end
        end
    end

    -- Функция автоматической телепортации
    function autoTeleportAll()
        print("🚀 Запуск автоматической телепортации...")
        autoTeleportActive = true
        
        for i, posData in ipairs(teleportPositions) do
            if not autoTeleportActive then break end
            teleportToPosition(posData.position, posData.name .. " (" .. i .. "/" .. #teleportPositions .. ")")
            wait(2)
        end
        
        if autoTeleportActive then
            print("✅ Автоматическая телепортация завершена!")
            autoTeleportActive = false
        end
    end

    -- Создание вкладок
    local MainTab = Window:NewTab("🎯 Телепорт")
    local PositionsSection = MainTab:NewSection("Быстрая телепортация")

    -- Создание кнопок для каждой позиции
    for i, posData in ipairs(teleportPositions) do
        PositionsSection:NewButton(posData.name, "Телепортироваться в " .. posData.name, function()
            teleportToPosition(posData.position, posData.name)
        end)
    end

    local AutoSection = MainTab:NewSection("Автоматизация")

    AutoSection:NewButton("🔄 Следующая позиция (F)", "Телепортироваться к следующей точке", function()
        teleportToNextPosition()
    end)

    AutoSection:NewToggle("⚡ Авто-телепорт всех точек", "Автоматически телепортироваться по всем точкам", function(state)
        autoTeleportActive = state
        if state then
            autoTeleportAll()
        end
    end)

    local SettingsTab = Window:NewTab("⚙️ Настройки")
    local ControlSection = SettingsTab:NewSection("Управление")

    ControlSection:NewKeybind("Открыть/Закрыть меню", "Показать или скрыть интерфейс", Enum.KeyCode.RightShift, function()
        Library:ToggleUI()
    end)

    local InfoTab = Window:NewTab("📱 Информация")
    local InfoSection = InfoTab:NewSection("О программе")

    -- Радужный текст в информации
    InfoSection:NewLabel("🎨 Trade Strength Teleporter v2.0")
    InfoSection:NewLabel("🌈 by Angry66gsjjdYT")
    InfoSection:NewLabel("🔐 Premium Version")
    InfoSection:NewLabel("👑 Whitelisted Users: DDOSLANDOX, MRlegenda63")
    InfoSection:NewLabel("")
    InfoSection:NewLabel("✨ Особенности:")
    InfoSection:NewLabel("• Плавная телепортация")
    InfoSection:NewLabel("• Автоматический цикл")
    InfoSection:NewLabel("• Радужный дизайн")
    InfoSection:NewLabel("• Горячие клавиши")
    InfoSection:NewLabel("• Защита ключом")
    InfoSection:NewLabel("")
    InfoSection:NewLabel("🎮 Управление:")
    InfoSection:NewLabel("F - Следующая позиция")
    InfoSection:NewLabel("G - Авто-телепорт")
    InfoSection:NewLabel("RightShift - Меню")

    -- Обработчики клавиш
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            teleportToNextPosition()
        elseif input.KeyCode == Enum.KeyCode.G then
            autoTeleportActive = not autoTeleportActive
            if autoTeleportActive then
                autoTeleportAll()
            else
                print("⏹️ Авто-телепортация остановлена")
            end
        end
    end)

    -- Функция для красивого вывода в консоль
    local function printRainbowText()
        local rainbowText = [[
        
     🎭┌────────────────────────────────────────┐
      │   🚀 TRADE STRENGTH TELEPORTER v2.0   │
      │           🌈 by Angry66gsjjdYT         │
      │           🔐 PREMIUM VERSION           │
      │        👑 WHITELIST: DDOSLANDOX        │
      │             MRlegenda63               │
      └────────────────────────────────────────┘
        ]]
        print(rainbowText)
    end

    printRainbowText()
    print("📋 Управление:")
    print("   F - Следующая позиция")
    print("   G - Авто-телепорт всех точек") 
    print("   RightShift - Открыть/закрыть меню")
    print("")
    print("   🎨 Радужный интерфейс активирован!")
    print("   🔐 Премиум версия активирована!")
    print("   👑 Вайтлист: DDOSLANDOX, MRlegenda63")
    print("   made by Angry66gsjjdYT")

    -- Очистка при выходе
    game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
        if leavingPlayer == Player then
            if rainbowConnection then
                rainbowConnection:Disconnect()
            end
        end
    end)
end

-- Основная инициализация
if KEY_SYSTEM.ENABLED then
    if checkWhitelistCloud() then
        -- Если пользователь в вайтлисте
        print("👑 Вайтлист пользователь обнаружен!")
        loadMainScript()
    else
        -- Показываем GUI для ввода ключа
        createKeyGUI()
    end
else
    -- Если ключ-система отключена
    loadMainScript()
end

-- Функция для создания файла keys.json для GitHub
local function generateKeysTemplate()
    local keysTemplate = {
        valid_keys = {
            "ANGRY666",
            "TEST1",
            "TEST2",
            "PREMIUM123"
        },
        whitelist = {
            "Angry66gsjjdYT",
            "DDOSLANDOX",
            "MRlegenda63",
            "TestUser"
        },
        settings = {
            version = "2.0",
            author = "Angry66gsjjdYT",
            game = "Trade Strength Simulator"
        }
    }
    
    print("📁 Template for keys.json (for GitHub):")
    print(HttpService:JSONEncode(keysTemplate))
end

-- Генерируем шаблон при запуске (можно убрать потом)
generateKeysTemplate()
