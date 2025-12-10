local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local player = Players.LocalPlayer

------------------------------------------------------
-- CREATE GUI
------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.5, -150, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Admin Menu"
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

------------------------------------------------------
-- TEAM SWITCH UI
------------------------------------------------------
local teamLabel = Instance.new("TextLabel")
teamLabel.Size = UDim2.new(1, -20, 0, 30)
teamLabel.Position = UDim2.new(0, 10, 0, 50)
teamLabel.BackgroundTransparency = 1
teamLabel.Text = "Enter Team Name:"
teamLabel.TextSize = 20
teamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
teamLabel.Font = Enum.Font.Gotham
teamLabel.Parent = frame

local teamBox = Instance.new("TextBox")
teamBox.Size = UDim2.new(1, -20, 0, 40)
teamBox.Position = UDim2.new(0, 10, 0, 80)
teamBox.PlaceholderText = "Team name here..."
teamBox.Text = ""
teamBox.TextSize = 20
teamBox.Font = Enum.Font.Gotham
teamBox.TextColor3 = Color3.fromRGB(255, 255, 255)
teamBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teamBox.ClearTextOnFocus = false
teamBox.Parent = frame

local teamBoxCorner = Instance.new("UICorner")
teamBoxCorner.CornerRadius = UDim.new(0, 10)
teamBoxCorner.Parent = teamBox

-- Switch Button
local switchButton = Instance.new("TextButton")
switchButton.Size = UDim2.new(1, -20, 0, 45)
switchButton.Position = UDim2.new(0, 10, 0, 130)
switchButton.Text = "Switch Team"
switchButton.Font = Enum.Font.GothamBold
switchButton.TextSize = 22
switchButton.TextColor3 = Color3.fromRGB(0, 0, 0)
switchButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
switchButton.Parent = frame

local switchButtonCorner = Instance.new("UICorner")
switchButtonCorner.CornerRadius = UDim.new(0, 10)
switchButtonCorner.Parent = switchButton

------------------------------------------------------
-- TEAM SWITCH FUNCTION (Fully Client-Side Method)
------------------------------------------------------
local function switchTeam(teamName)
    if teamName == "" then
        warn("No team entered.")
        return
    end

    local team = Teams:FindFirstChild(teamName)
    if not team then
        warn("Team not found:", teamName)
        return
    end

    -- Disable ALL teams so you don't join the wrong one
    for _, t in ipairs(Teams:GetChildren()) do
        t.AutoAssignable = false
    end

    -- Enable the team you want
    team.AutoAssignable = true

    -- Respawn your character (forces team switch)
    player:LoadCharacter()

    task.wait(0.1)

    -- Turn autoassign off again
    team.AutoAssignable = false
end

------------------------------------------------------
-- BUTTON CLICK
------------------------------------------------------
switchButton.MouseButton1Click:Connect(function()
    switchTeam(teamBox.Text)
end)
