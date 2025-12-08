-- StarterPlayerScripts > LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI creation
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "AdminSpawnGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.5, -150, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = false
main.Parent = gui

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -20, 0, 40)
textbox.Position = UDim2.new(0, 10, 0, 10)
textbox.PlaceholderText = "Enter object name..."
textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textbox.TextColor3 = Color3.new(1,1,1)
textbox.Parent = main

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -20, 0, 40)
spawnBtn.Position = UDim2.new(0, 10, 0, 60)
spawnBtn.Text = "Spawn at Location"
spawnBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
spawnBtn.TextColor3 = Color3.new(1,1,1)
spawnBtn.Parent = main

local inventoryBtn = Instance.new("TextButton")
inventoryBtn.Size = UDim2.new(1, -20, 0, 40)
inventoryBtn.Position = UDim2.new(0, 10, 0, 110)
inventoryBtn.Text = "Put Into Inventory"
inventoryBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
inventoryBtn.TextColor3 = Color3.new(1,1,1)
inventoryBtn.Parent = main

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
openBtn.Text = "Open Menu"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Parent = gui

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = main

-- Open/Close
openBtn.MouseButton1Click:Connect(function()
	main.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)


------------------------------------------------------
-- FUNCTION TO SEARCH ENTIRE GAME
------------------------------------------------------
local function searchGameFor(name)
	local function search(obj)
		for _, child in ipairs(obj:GetChildren()) do
			if child.Name == name then
				return child
			end
			local deeper = search(child)
			if deeper then return deeper end
		end
	end
	return search(game)
end


------------------------------------------------------
-- SPAWN AT LOCATION
------------------------------------------------------
spawnBtn.MouseButton1Click:Connect(function()
	local name = textbox.Text
	if name == "" then return end

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local found = searchGameFor(name)
	if not found then
		warn("Object not found: " .. name)
		return
	end

	local clone
	pcall(function()
		clone = found:Clone()
	end)

	if clone then
		clone.Parent = workspace
		clone:PivotTo(CFrame.new(root.Position + Vector3.new(0, 3, 0)))
	end
end)


------------------------------------------------------
-- PUT INTO INVENTORY
------------------------------------------------------
inventoryBtn.MouseButton1Click:Connect(function()
	local name = textbox.Text
	if name == "" then return end

	local found = searchGameFor(name)
	if not found then
		warn("Object not found: " .. name)
		return
	end

	local clone
	pcall(function()
		clone = found:Clone()
	end)

	if clone then
		clone.Parent = player.Backpack
	end
end)
