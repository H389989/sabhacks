--// LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GiveAllItemsGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

--// Create the button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 60) -- make it big enough to see
button.Position = UDim2.new(0.5, -125, 0.5, -30) -- center of the screen
button.Text = "Give Me Everything!"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.AnchorPoint = Vector2.new(0.5, 0.5) -- properly center
button.Parent = screenGui
button.ZIndex = 10 -- make sure it's on top

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

--// Button click
button.MouseButton1Click:Connect(giveAllItems)
