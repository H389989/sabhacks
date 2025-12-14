--// LocalScript
--// Place in StarterPlayer > StarterPlayerScripts
--// CLIENT-SIDE TOOL (LocalPlayer ONLY)
--// - Finds ANY value/label related to Cash or Beli
--// - Lets you EDIT them LOCALLY (visual/client values)
--// - Button to remove CLIENT-SIDE cooldowns across the game

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- KEYWORDS
-------------------------------------------------
local MONEY_KEYS = {"cash", "beli", "money", "coins", "gold", "currency", "$"}
local COOLDOWN_KEYS = {"cool", "cd", "delay", "wait"}

local function hasKey(str, keys)
	if not str then return false end
	str = tostring(str):lower()
	for _, k in ipairs(keys) do
		if string.find(str, k) then
			return true
		end
	end
	return false
end

-------------------------------------------------
-- CREATE CONTROL GUI (ALWAYS SHOWS)
-------------------------------------------------
local old = PlayerGui:FindFirstChild("LocalMoneyControlGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "LocalMoneyControlGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0, 20, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Local Cash / Beli Editor"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

-------------------------------------------------
-- MONEY INPUT
-------------------------------------------------
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -20, 0, 36)
box.Position = UDim2.new(0, 10, 0, 52)
box.PlaceholderText = "Enter amount (LOCAL)"
box.Text = ""
box.TextScaled = true
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(45,45,45)
box.TextColor3 = Color3.new(1,1,1)
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -20, 0, 36)
applyBtn.Position = UDim2.new(0, 10, 0, 96)
applyBtn.Text = "Apply Cash / Beli (LOCAL)"
applyBtn.TextScaled = true
applyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
applyBtn.TextColor3 = Color3.new(1,1,1)
applyBtn.Parent = frame
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,10)

-------------------------------------------------
-- COOLDOWN BUTTON
-------------------------------------------------
local cdBtn = Instance.new("TextButton")
cdBtn.Size = UDim2.new(1, -20, 0, 36)
cdBtn.Position = UDim2.new(0, 10, 0, 140)
cdBtn.Text = "Disable ALL Cooldowns (LOCAL)"
cdBtn.TextScaled = true
cdBtn.BackgroundColor3 = Color3.fromRGB(80,40,40)
cdBtn.TextColor3 = Color3.new(1,1,1)
cdBtn.Parent = frame
Instance.new("UICorner", cdBtn).CornerRadius = UDim.new(0,10)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 28)
info.Position = UDim2.new(0, 10, 1, -32)
info.BackgroundTransparency = 1
info.Text = "Client-side only"
info.TextColor3 = Color3.fromRGB(180,180,180)
info.TextScaled = true
info.Parent = frame

-------------------------------------------------
-- FIND & EDIT MONEY (LOCAL)
-------------------------------------------------
local function applyLocalMoney(value)
	for _, obj in ipairs(PlayerGui:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then
			if hasKey(obj.Name, MONEY_KEYS) or hasKey(obj.Text, MONEY_KEYS) then
				obj.Text = tostring(value)
			end
		end
	end

	for _, obj in ipairs(player:GetDescendants()) do
		if obj:IsA("NumberValue") or obj:IsA("IntValue") then
			if hasKey(obj.Name, MONEY_KEYS) then
				obj.Value = tonumber(value) or obj.Value
			end
		end
	end
end

applyBtn.MouseButton1Click:Connect(function()
	if box.Text ~= "" then
		applyLocalMoney(box.Text)
	end
end)

-------------------------------------------------
-- REMOVE COOLDOWNS (CLIENT SIDE ONLY)
-------------------------------------------------
local function clearCooldowns(container)
	for _, obj in ipairs(container:GetDescendants()) do
		if obj:IsA("NumberValue") and hasKey(obj.Name, COOLDOWN_KEYS) then
			obj.Value = 0
		end
		if obj:IsA("BoolValue") and hasKey(obj.Name, COOLDOWN_KEYS) then
			obj.Value = false
		end
	end
end

local noCooldowns = false

local function disableCooldowns()
	noCooldowns = true
	player:SetAttribute("NoCooldown", true)
	clearCooldowns(player)
	clearCooldowns(PlayerGui)
	if player.Character then clearCooldowns(player.Character) end
	cdBtn.Text = "Cooldowns Disabled (LOCAL)"
	cdBtn.BackgroundColor3 = Color3.fromRGB(40,100,40)
end

cdBtn.MouseButton1Click:Connect(disableCooldowns)

player.CharacterAdded:Connect(function()
	if noCooldowns then
		task.wait(0.3)
		disableCooldowns()
	end
end)

-------------------------------------------------
-- IMPORTANT
-------------------------------------------------
-- • This CANNOT bypass server-side checks
-- • Only affects what the LOCAL client sees/uses
-- • If your game enforces cooldowns on the server,
--   this will NOT override them
