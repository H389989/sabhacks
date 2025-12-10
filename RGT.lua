local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

------------------------------------------------------
-- CREATE GUI
------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- OPEN MENU BUTTON
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 130, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.8, 0)
openButton.Text = "ADMIN MENU"
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 22
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openButton.Parent = screenGui
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Admin Menu"
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Helper functions for TextBoxes and Buttons
local function makeBox(yPos, placeholder)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 40)
	box.Position = UDim2.new(0, 10, 0, yPos)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextSize = 20
	box.Font = Enum.Font.Gotham
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.BackgroundColor3 = Color3.fromRGB(60,60,60)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = box
	box.Parent = frame
	return box
end

local function makeButton(yPos, text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 45)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 22
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.BackgroundColor3 = color
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = btn
	btn.Parent = frame
	return btn
end

------------------------------------------------------
-- UI ELEMENTS
------------------------------------------------------
-- Team
local teamBox = makeBox(50, "Team name")
local teamButton = makeButton(100, "Switch Team", Color3.fromRGB(0,170,255))

-- WalkSpeed
local speedBox = makeBox(150, "WalkSpeed (e.g., 16)")
local speedButton = makeButton(200, "Set WalkSpeed", Color3.fromRGB(0,120,255))

-- JumpPower
local jumpBox = makeBox(250, "JumpPower (e.g., 50)")
local jumpButton = makeButton(300, "Set JumpPower", Color3.fromRGB(0,200,125))

-- Fly & Noclip
local flyButton = makeButton(350, "Toggle Fly", Color3.fromRGB(200,150,0))
local noclipButton = makeButton(400, "Toggle Noclip", Color3.fromRGB(180,0,180))

------------------------------------------------------
-- OPEN BUTTON
------------------------------------------------------
openButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

------------------------------------------------------
-- TEAM SWITCH FUNCTION
------------------------------------------------------
local function switchTeam(teamName)
	if teamName == "" then return end
	local team = Teams:FindFirstChild(teamName)
	if not team then
		warn("Team not found:", teamName)
		return
	end

	for _, t in pairs(Teams:GetChildren()) do
		t.AutoAssignable = false
	end

	team.AutoAssignable = true
	player:LoadCharacter()
	task.wait(0.1)
	team.AutoAssignable = false
end

teamButton.MouseButton1Click:Connect(function()
	switchTeam(teamBox.Text)
end)

------------------------------------------------------
-- WalkSpeed & JumpPower
------------------------------------------------------
speedButton.MouseButton1Click:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then humanoid.WalkSpeed = num end
end)

jumpButton.MouseButton1Click:Connect(function()
	local num = tonumber(jumpBox.Text)
	if num then humanoid.JumpPower = num end
end)

------------------------------------------------------
-- FLY
------------------------------------------------------
local flying = false
local flySpeed = 2

local function startFly()
	flying = true
	RunService.RenderStepped:Connect(function()
		if flying then
			local move = Vector3.new(0,0,0)
			local cam = workspace.CurrentCamera
			if UIS:IsKeyDown(Enum.KeyCode.W) or UIS.TouchEnabled then
				move = move + (cam.CFrame.LookVector * flySpeed)
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				move = move - (cam.CFrame.LookVector * flySpeed)
			end
			rootPart.Velocity = move * 40
		end
	end)
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
	else
		rootPart.Velocity = Vector3.new(0,0,0)
	end
end)

------------------------------------------------------
-- NOCLIP
------------------------------------------------------
local noclip = false

noclipButton.MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
