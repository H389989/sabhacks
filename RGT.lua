local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ownerId = game.CreatorId

-- Only show menu if you're the owner
if player.UserId ~= ownerId then
	return
end

-- Create RemoteEvent if missing
local remote = ReplicatedStorage:FindFirstChild("SwitchTeamEvent")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "SwitchTeamEvent"
	remote.Parent = ReplicatedStorage
end


---------------------------------------------------------
-- GUI CREATION
---------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Name = "AdminMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- OPEN/CLOSE BUTTON
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 120, 0, 45)
openButton.Position = UDim2.new(0, 20, 0.85, 0)
openButton.Text = "ADMIN MENU"
openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openButton.TextScaled = true
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.Parent = screenGui


---------------------------------------------------------
-- MENU FRAME
---------------------------------------------------------
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 290, 0, 300)
frame.Position = UDim2.new(0, 20, 0.45, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

-- Draggable bar (touch friendly)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 35)
dragBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
dragBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Admin Menu"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = dragBar


---------------------------------------------------------
-- INPUT FIELDS (touch-friendly)
---------------------------------------------------------
local function makeTextBox(y, placeholder)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 35)
	box.Position = UDim2.new(0, 10, 0, y)
	box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	box.TextScaled = true
	box.PlaceholderText = placeholder
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.Parent = frame
	return box
end

local nameBox = makeTextBox(45, "Player Name")
local teamBox = makeTextBox(90, "Team Name")
local wsBox   = makeTextBox(135, "WalkSpeed")


---------------------------------------------------------
-- BUTTONS (touch-friendly)
---------------------------------------------------------
local function makeButton(y, text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = color
	btn.TextScaled = true
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Parent = frame
	return btn
end

local switchButton = makeButton(185, "Switch Team", Color3.fromRGB(0,120,255))
local wsButton = makeButton(235, "Set WalkSpeed", Color3.fromRGB(0,200,125))


---------------------------------------------------------
-- MENU OPEN/CLOSE
---------------------------------------------------------
openButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)


---------------------------------------------------------
-- DRAGGING SYSTEM (Supports Mobile + PC)
---------------------------------------------------------
local dragging = false
local dragStart, startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

dragBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)


---------------------------------------------------------
-- BUTTON LOGIC
---------------------------------------------------------
switchButton.MouseButton1Click:Connect(function()
	if nameBox.Text ~= "" and teamBox.Text ~= "" then
		remote:FireServer(nameBox.Text, teamBox.Text)
	end
end)

wsButton.MouseButton1Click:Connect(function()
	local speed = tonumber(wsBox.Text)
	if nameBox.Text ~= "" and speed then
		remote:FireServer(nameBox.Text, "SET_WALKSPEED", speed)
	end
end)


---------------------------------------------------------
-- SERVER LOGIC
---------------------------------------------------------
remote.OnServerEvent:Connect(function(admin, targetName, action, extra)
	if admin.UserId ~= ownerId then return end

	-- Find player by partial match
	local target
	for _, plr in ipairs(Players:GetPlayers()) do
		if string.lower(plr.Name):sub(1, #targetName) == string.lower(targetName) then
			target = plr
			break
		end
	end
	if not target then return end

	-- Team switching
	if action ~= "SET_WALKSPEED" then
		local team = Teams:FindFirstChild(action)
		if team then
			target.Team = team
			target:LoadCharacter()
		end
		return
	end

	-- WalkSpeed change
	local speed = tonumber(extra)
	if speed and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.WalkSpeed = speed
	end
end)
