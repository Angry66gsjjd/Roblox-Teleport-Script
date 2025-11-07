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

-- Остальной код скрипта...
-- (вставь полную версию которую ты использовал в Pastebin)
