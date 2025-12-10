-- Ultimate Admin UI StarterPlayerScript

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local TS = game:GetService("TweenService")

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateAdminUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "Ultimate Admin UI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = mainFrame

-- Open/close button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 150, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -75, 0, 10)
toggleBtn.Text = "Open Admin UI"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = screenGui

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Helper function: create buttons
local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = name
    btn.Parent = mainFrame
    btn.MouseButton1Click:Connect(callback)
end

-- Walkspeed adjust
local walkspeedBox = Instance.new("TextBox")
walkspeedBox.Size = UDim2.new(0, 280, 0, 40)
walkspeedBox.Position = UDim2.new(0,10,0,70)
walkspeedBox.PlaceholderText = "Enter Walkspeed"
walkspeedBox.Text = ""
walkspeedBox.TextColor3 = Color3.fromRGB(255,255,255)
walkspeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkspeedBox.Font = Enum.Font.SourceSans
walkspeedBox.TextSize = 18
walkspeedBox.Parent = mainFrame

createButton("Set Walkspeed", 120, function()
    local speed = tonumber(walkspeedBox.Text)
    if speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

-- Fly toggle
local flying = false
local flySpeed = 50
createButton("Toggle Fly", 170, function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flying = not flying
    if flying then
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "FlyVelocity"
        bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.Parent = hrp

        local conn
        conn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            local vel = Vector3.new(0,0,0)
            if input.KeyCode == Enum.KeyCode.W then
                vel = hrp.CFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                vel = -hrp.CFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then
                vel = Vector3.new(0, flySpeed,0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                vel = Vector3.new(0,-flySpeed,0)
            end
            bodyVel.Velocity = vel
        end)
    else
        if hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end)

-- Move object to player
local moveBox = Instance.new("TextBox")
moveBox.Size = UDim2.new(0, 280, 0, 220)
moveBox.Position = UDim2.new(0,10,0,220)
moveBox.PlaceholderText = "Object name to move to you"
moveBox.Text = ""
moveBox.TextColor3 = Color3.fromRGB(255,255,255)
moveBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
moveBox.Font = Enum.Font.SourceSans
moveBox.TextSize = 18
moveBox.Parent = mainFrame

createButton("Move Object", 270, function()
    local targetName = moveBox.Text
    if targetName == "" then return end
    local found = WS:FindFirstChild(targetName,true)
    if found and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        found.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
    end
end)

-- Advanced spawn system
local itemBox = Instance.new("TextBox")
itemBox.Size = UDim2.new(0, 280, 0, 320)
itemBox.Position = UDim2.new(0,10,0,320)
itemBox.PlaceholderText = "Enter item name to give"
itemBox.Text = ""
itemBox.TextColor3 = Color3.fromRGB(255,255,255)
itemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
itemBox.Font = Enum.Font.SourceSans
itemBox.TextSize = 18
itemBox.Parent = mainFrame

local spawnAtPlayer = Instance.new("TextButton")
spawnAtPlayer.Size = UDim2.new(0, 280, 0, 40)
spawnAtPlayer.Position = UDim2.new(0,10,0,370)
spawnAtPlayer.Text = "Spawn at Player"
spawnAtPlayer.Font = Enum.Font.SourceSans
spawnAtPlayer.TextSize = 18
spawnAtPlayer.TextColor3 = Color3.fromRGB(255,255,255)
spawnAtPlayer.BackgroundColor3 = Color3.fromRGB(70,70,70)
spawnAtPlayer.Parent = mainFrame

local spawnInBackpack = Instance.new("TextButton")
spawnInBackpack.Size = UDim2.new(0, 280, 0, 40)
spawnInBackpack.Position = UDim2.new(0,10,0,420)
spawnInBackpack.Text = "Give to Backpack"
spawnInBackpack.Font = Enum.Font.SourceSans
spawnInBackpack.TextSize = 18
spawnInBackpack.TextColor3 = Color3.fromRGB(255,255,255)
spawnInBackpack.BackgroundColor3 = Color3.fromRGB(70,70,70)
spawnInBackpack.Parent = mainFrame

local function findItemByName(root,name)
    name = name:lower()
    for _, obj in ipairs(root:GetDescendants()) do
        if obj.Name:lower() == name then
            return obj
        end
    end
end

spawnAtPlayer.MouseButton1Click:Connect(function()
    local itemName = itemBox.Text
    if itemName == "" then return end
    local found = findItemByName(WS,itemName) or findItemByName(RS,itemName)
    if found and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local clone = found:Clone()
        clone.Parent = WS
        clone.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
    end
end)

spawnInBackpack.MouseButton1Click:Connect(function()
    local itemName = itemBox.Text
    if itemName == "" then return end
    local found = findItemByName(WS,itemName) or findItemByName(RS,itemName)
    if found then
        local clone = found:Clone()
        clone.Parent = player:WaitForChild("Backpack")
    end
end)

print("Ultimate Admin UI loaded!")
