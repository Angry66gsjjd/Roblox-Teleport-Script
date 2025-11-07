-- Trade Strength Simulator Teleport Script with GUI Menu
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
 
-- Позиции для телепортации с названиями
local teleportPositions = {
    {name = "📍 Стартовая позиция", position = Vector3.new(28.120019912719727, 7.735681056976318, -354.760009765625)},
    {name = "📍 Высокая точка 1", position = Vector3.new(-296.6466979980469, 87.49390411376953, -349.0245056152344)},
    {name = "📍 Центральная зона", position = Vector3.new(-294.8343811035156, 88.18395233154297, -377.1786804199219)},
    {name = "📍 Конечная точка", position = Vector3.new(-281.97833251953125, 88.0938720703125, -386.9106750488281)}
}
 
local currentPositionIndex = 1
 
-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportMenu"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
 
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
 
-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame
 
-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.Text = "🚀 Trade Strength Teleporter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
 
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title
 
-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Title
 
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton
 
-- Область с кнопками позиций
local PositionsFrame = Instance.new("ScrollingFrame")
PositionsFrame.Size = UDim2.new(1, -20, 0, 250)
PositionsFrame.Position = UDim2.new(0, 10, 0, 60)
PositionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PositionsFrame.BorderSizePixel = 0
PositionsFrame.ScrollBarThickness = 6
PositionsFrame.Parent = MainFrame
 
local PositionsCorner = Instance.new("UICorner")
PositionsCorner.CornerRadius = UDim.new(0, 6)
PositionsCorner.Parent = PositionsFrame
 
-- Создание кнопок для каждой позиции
for i, posData in ipairs(teleportPositions) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (i-1) * 45)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Button.Text = posData.name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = PositionsFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Анимация при наведении
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        teleportToPosition(posData.position, posData.name)
    end)
end
 
PositionsFrame.CanvasSize = UDim2.new(0, 0, 0, #teleportPositions * 45)
 
-- Панель управления
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 120)
ControlFrame.Position = UDim2.new(0, 10, 0, 320)
ControlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ControlFrame.BorderSizePixel = 0
ControlFrame.Parent = MainFrame
 
local ControlCorner = Instance.new("UICorner")
ControlCorner.CornerRadius = UDim.new(0, 6)
ControlCorner.Parent = ControlFrame
 
-- Кнопка последовательной телепортации
local SequenceButton = Instance.new("TextButton")
SequenceButton.Size = UDim2.new(1, -20, 0, 35)
SequenceButton.Position = UDim2.new(0, 10, 0, 10)
SequenceButton.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
SequenceButton.Text = "🔄 Следующая позиция (F)"
SequenceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SequenceButton.TextSize = 14
SequenceButton.Font = Enum.Font.Gotham
SequenceButton.Parent = ControlFrame
 
local SeqCorner = Instance.new("UICorner")
SeqCorner.CornerRadius = UDim.new(0, 6)
SeqCorner.Parent = SequenceButton
 
-- Кнопка автоматической телепортации
local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(1, -20, 0, 35)
AutoButton.Position = UDim2.new(0, 10, 0, 55)
AutoButton.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
AutoButton.Text = "⚡ Авто-телепорт всех точек (G)"
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.TextSize = 14
AutoButton.Font = Enum.Font.Gotham
AutoButton.Parent = ControlFrame
 
local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoButton
 
-- Текст с информацией
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 0, 30)
InfoText.Position = UDim2.new(0, 10, 1, -60)
InfoText.BackgroundTransparency = 1
InfoText.Text = "💡 Открыть/закрыть меню: H"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.TextSize = 12
InfoText.Font = Enum.Font.Gotham
InfoText.Parent = MainFrame
 
-- Подпись создателя
local CreatorText = Instance.new("TextLabel")
CreatorText.Size = UDim2.new(1, -20, 0, 20)
CreatorText.Position = UDim2.new(0, 10, 1, -35)
CreatorText.BackgroundTransparency = 1
CreatorText.Text = "made by Angry66gsjjdYT"
CreatorText.TextColor3 = Color3.fromRGB(150, 150, 200)
CreatorText.TextSize = 11
CreatorText.Font = Enum.Font.Gotham
CreatorText.TextXAlignment = Enum.TextXAlignment.Right
CreatorText.Parent = MainFrame
 
-- Функция для телепортации персонажа
function teleportToPosition(position, positionName)
    local character = Player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Плавная телепортация
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
            tween:Play()
            
            if positionName then
                print("✅ Телепортирован: " .. positionName)
            else
                print("✅ Телепортирован в позицию: " .. tostring(position))
            end
        else
            warn("HumanoidRootPart не найден!")
        end
    else
        warn("Персонаж не найден!")
    end
end
 
-- Функция для телепортации к следующей позиции
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
    for i, posData in ipairs(teleportPositions) do
        teleportToPosition(posData.position, posData.name .. " (" .. i .. "/" .. #teleportPositions .. ")")
        wait(2) -- Задержка 2 секунды между телепортами
    end
    print("✅ Автоматическая телепортация завершена!")
end
 
-- Обработчики кнопок
SequenceButton.MouseButton1Click:Connect(teleportToNextPosition)
AutoButton.MouseButton1Click:Connect(autoTeleportAll)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)
 
-- Обработчики клавиш
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        teleportToNextPosition()
    elseif input.KeyCode == Enum.KeyCode.G then
        autoTeleportAll()
    elseif input.KeyCode == Enum.KeyCode.H then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
 
-- Анимации кнопок
local function setupButtonAnimation(button)
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 160, 220)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 200)}):Play()
    end)
end
 
setupButtonAnimation(SequenceButton)
 
AutoButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(AutoButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 140, 100)}):Play()
end)
 
AutoButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(AutoButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 120, 80)}):Play()
end)
 
print("🎮 Скрипт телепортации загружен!")
print("📋 Управление:")
print("   F - Следующая позиция")
print("   G - Авто-телепорт всех точек") 
print("   H - Показать/скрыть меню")
print("   👆 Кликай по позициям в меню!")
print("")
print("   made by Angry66gsjjdYT")
 
-- Открыть меню при запуске
wait(1)
print("📱 Меню телепортации открыто!")
