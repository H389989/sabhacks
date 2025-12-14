--// LocalScript inside StarterPlayerScripts
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileControlGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10

--// Open/Close Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Open GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

--// Scrollable Frame
local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
mainFrame.ScrollBarThickness = 10
mainFrame.Visible = false -- start hidden
mainFrame.Parent = screenGui

--// UI Layout
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = mainFrame
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 10)

-- Auto-adjust the scrolling canvas size
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mainFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end)

--// Open/Close functionality
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        toggleButton.Text = "Close GUI"
    else
        toggleButton.Text = "Open GUI"
    end
end)

--// Utility function to create buttons
local function createButton(name, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = UDim2.new(1, -20, 0, 60)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = mainFrame
    button.MouseButton1Click:Connect(callback)
end

--// WalkSpeed Buttons
createButton("WalkSpeed50", "WalkSpeed 50", function()
    humanoid.WalkSpeed = 50
end)
createButton("WalkSpeed100", "WalkSpeed 100", function()
    humanoid.WalkSpeed = 100
end)
createButton("WalkSpeedReset", "Reset WalkSpeed", function()
    humanoid.WalkSpeed = 16
end)

--// JumpPower Buttons
createButton("JumpPower50", "JumpPower 50", function()
    humanoid.JumpPower = 50
end)
createButton("JumpPower100", "JumpPower 100", function()
    humanoid.JumpPower = 100
end)
createButton("JumpPowerReset", "Reset JumpPower", function()
    humanoid.JumpPower = 50
end)

--// Flight Toggle
local flying = false
local flightSpeed = 50
local flightBody

createButton("ToggleFlight", "Toggle Flight", function()
    flying = not flying
    local root = character:FindFirstChild("HumanoidRootPart")
    if flying and root then
        flightBody = Instance.new("BodyVelocity")
        flightBody.MaxForce = Vector3.new(1e5,1e5,1e5)
        flightBody.Velocity = Vector3.new(0,0,0)
        flightBody.Parent = root
    elseif flightBody then
        flightBody:Destroy()
    end
end)

--// Flight Controls
createButton("FlightUp", "Fly Up", function()
    if flying and flightBody then
        flightBody.Velocity = Vector3.new(0, flightSpeed, 0)
    end
end)
createButton("FlightDown", "Fly Down", function()
    if flying and flightBody then
        flightBody.Velocity = Vector3.new(0, -flightSpeed, 0)
    end
end)
createButton("FlightForward", "Fly Forward", function()
    if flying and flightBody then
        local root = character:FindFirstChild("HumanoidRootPart")
        flightBody.Velocity = root.CFrame.LookVector * flightSpeed
    end
end)
createButton("FlightReset", "Stop Flight", function()
    if flightBody then
        flightBody.Velocity = Vector3.new(0,0,0)
    end
end)
