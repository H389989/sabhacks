--// LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GiveAllItemsGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Give Me Everything!"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextScaled = true
button.Parent = screenGui

--// Paths to search for items
local searchLocations = {
    game:GetService("ReplicatedStorage"),
    game:GetService("ServerStorage"),
    game:GetService("StarterPack"),
    game:GetService("Workspace"), -- sometimes items are parented directly here
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

--// Button click
button.MouseButton1Click:Connect(giveAllItems)
