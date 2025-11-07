-- Trade Strength Simulator Teleport Script with Beautiful GUI
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Альтернативная библиотека для GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🚀 Trade Strength Teleporter", "Midnight")

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
            Window:ChangeText("🚀 Trade Strength Teleporter | " .. "by Angry66gsjjdYT")
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
InfoSection:NewLabel("")
InfoSection:NewLabel("✨ Особенности:")
InfoSection:NewLabel("• Плавная телепортация")
InfoSection:NewLabel("• Автоматический цикл")
InfoSection:NewLabel("• Радужный дизайн")
InfoSection:NewLabel("• Горячие клавиши")
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
print("   made by Angry66gsjjdYT")

-- Очистка при выходе
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        if rainbowConnection then
            rainbowConnection:Disconnect()
        end
    end
end)
