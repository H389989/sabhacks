-- Ultimate Admin UI - Fully Scrollable, Mobile-Friendly, Draggable

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateAdminUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Open/close button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.3,0,0.08,0)
toggleBtn.Position = UDim2.new(0.35,0,0.01,0)
toggleBtn.Text = "Open Admin UI"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = screenGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8,0,0.8,0)
mainFrame.Position = UDim2.new(0.1,0,0.1,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title bar (draggable)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "Ultimate Admin UI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = mainFrame

-- Scrollable content (below title)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,-10,1,-60) -- subtract title height
scrollFrame.Position = UDim2.new(0,5,0,50)
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,10)
layout.Parent = scrollFrame

-- Auto-update canvas size
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- Toggle open/close
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Dragging functionality (title bar only)
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    mainFrame.Position = UDim2.new(
        0,
        framePos.X + delta.X,
        0,
        framePos.Y + delta.Y
    )
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Helper functions
local function createTextBox(placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-20,0,40)
    box.BackgroundColor3 = Color3.fromRGB(50,50,50)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 18
    box.PlaceholderText = placeholder
    box.Text = ""
    box.Parent = scrollFrame
    return box
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 20
    btn.Text = text
    btn.Parent = scrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Walkspeed
local walkspeedBox = createTextBox("Enter Walkspeed")
createButton("Set Walkspeed", function()
    local speed = tonumber(walkspeedBox.Text)
    if speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

-- Fly toggle
local flying = false
local flySpeed = 50
createButton("Toggle Fly", function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp

        local conn
        conn = UIS.InputBegan:Connect(function(input,gpe)
            if gpe then return end
            local vel = Vector3.new(0,0,0)
            if input.KeyCode == Enum.KeyCode.W then vel = hrp.CFrame.LookVector*flySpeed
            elseif input.KeyCode == Enum.KeyCode.S then vel = -hrp.CFrame.LookVector*flySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then vel = Vector3.new(0,flySpeed,0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then vel = Vector3.new(0,-flySpeed,0)
            end
            bv.Velocity = vel
        end)
    else
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
    end
end)

-- Move object
local moveBox = createTextBox("Object name to move to you")
createButton("Move Object", function()
    local name = moveBox.Text
    if name == "" then return end
    local obj = WS:FindFirstChild(name,true)
    if obj and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        obj.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
    end
end)

-- Advanced spawn system
local itemBox = createTextBox("Item name to spawn/give")
createButton("Spawn at Player", function()
    local name = itemBox.Text:lower()
    if name == "" then return end
    local function findItem(root)
        for _,obj in ipairs(root:GetDescendants()) do
            if obj.Name:lower() == name then return obj end
        end
    end
    local found = findItem(WS) or findItem(RS)
    if found and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local clone = found:Clone()
        clone.Parent = WS
        clone.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
    end
end)

createButton("Give to Backpack", function()
    local name = itemBox.Text:lower()
    if name == "" then return end
    local function findItem(root)
        for _,obj in ipairs(root:GetDescendants()) do
            if obj.Name:lower() == name then return obj end
        end
    end
    local found = findItem(WS) or findItem(RS)
    if found then
        local clone = found:Clone()
        clone.Parent = player:WaitForChild("Backpack")
    end
end)

print("Ultimate Admin UI loaded - Fully Scrollable, Mobile-Friendly, Draggable!")
