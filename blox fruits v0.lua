--// LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GiveAllItemsGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

--// Frame to hold the main button
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 80)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Visible = false -- hidden by default
mainFrame.Parent = screenGui
mainFrame.ZIndex = 10

--// Main "Give All Items" Button
local giveButton = Instance.new("TextButton")
giveButton.Size = UDim2.new(1, -20, 1, -20)
giveButton.Position = UDim2.new(0, 10, 0, 10)
giveButton.Text = "Give Me Everything!"
giveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
giveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
giveButton.TextScaled = true
giveButton.Parent = mainFrame

--// Toggle Button to open/close GUI
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0.9, -20) -- bottom center
toggleButton.Text = "Open GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 85)
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleButton.Parent = screenGui
toggleButton.ZIndex = 10

--// Paths to search for items
local searchLocations = {
    game:GetService("ReplicatedStorage"),
    game:GetService("Workspace"),
    game:GetService("StarterPack"),
    game:GetService("ServerStorage"),
    game:GetService("ServerScriptService")
}

--// Function to give all items
local function giveAllItems()
    local count = 0
    for _, location in pairs(searchLocations) do
        for _, item in pairs(location:GetDescendants()) do
            if item:IsA("Tool") then
                local cloned = item:Clone()
                cloned.Parent = player.Backpack
                count = count + 1
            end
        end
    end
    print("All items given! Total items:", count)
end

--// Connect button click
giveButton.MouseButton1Click:Connect(giveAllItems)

--// Connect toggle button
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "Close GUI" or "Open GUI"
end)
