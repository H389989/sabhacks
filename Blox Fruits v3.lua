-- StarterPlayerScripts/DevEquipAll.local.lua

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

-- === UI ===
local gui = Instance.new("ScreenGui")
gui.Name = "DevEquipAllGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.fromScale(0.28, 0.1)
button.Position = UDim2.fromScale(0.36, 0.85)
button.Text = "DEV: EQUIP ALL TOOLS"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
button.Parent = gui

-- === TOOL FINDER ===
local function getAllTools()
	local tools = {}

	local function scan(container)
		for _, obj in ipairs(container:GetDescendants()) do
			if obj:IsA("Tool") then
				table.insert(tools, obj)
			end
		end
	end

	-- Scan common tool locations
	scan(game:GetService("ReplicatedStorage"))
	scan(game:GetService("Workspace"))
	scan(player)

	return tools
end

-- === BUTTON ACTION ===
button.MouseButton1Click:Connect(function()
	for _, tool in ipairs(getAllTools()) do
		if tool.Parent ~= backpack and tool.Parent ~= character then
			local clone = tool:Clone()
			clone.Parent = backpack
		end
	end

	-- Auto-equip everything
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			tool.Parent = character
		end
	end
end)
