--// LocalScript inside StarterPlayerScripts

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

--// CREATE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 150, 0, 50)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Text = "Open Menu"
openButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.ZIndex = 5
openButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 20, 0, 80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Visible = false
mainFrame.ZIndex = 4
mainFrame.Parent = screenGui

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 260, 0, 50)
spawnButton.Position = UDim2.new(0, 20, 0, 20)
spawnButton.Text = "Give ALL Items"
spawnButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.ZIndex = 5
spawnButton.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 260, 0, 40)
closeButton.Position = UDim2.new(0, 20, 0, 150)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.ZIndex = 5
closeButton.Parent = mainFrame

--// TOGGLE MENU
openButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

--// GIVE ALL ITEMS TO BACKPACK
spawnButton.MouseButton1Click:Connect(function()
	for _, obj in ipairs(game:GetDescendants()) do

		-- Case 1: Real Tool with Handle
		if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
			local clone = obj:Clone()
			clone.Parent = backpack

		-- Case 2: Model with Handle → convert to Tool
		elseif obj:IsA("Model") and obj:FindFirstChild("Handle") then
			local tool = Instance.new("Tool")
			tool.Name = obj.Name
			tool.RequiresHandle = true

			local cloneModel = obj:Clone()
			local handle = cloneModel:FindFirstChild("Handle")
			handle.Parent = tool
			handle.Anchored = false
			handle.CanCollide = false

			for _, part in ipairs(cloneModel:GetDescendants()) do
				if part:IsA("BasePart") and part ~= handle then
					part.Parent = tool
					part.Anchored = false
					part.CanCollide = false
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = handle
					weld.Part1 = part
					weld.Parent = tool
				end
			end

			tool.Parent = backpack
		end
	end
end)
