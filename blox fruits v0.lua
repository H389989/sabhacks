--// LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create a simple visible ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Create a simple button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 60)
button.Position = UDim2.new(0.5, -125, 0.5, -30)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "I AM VISIBLE!"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Parent = screenGui
