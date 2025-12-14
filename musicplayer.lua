-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AudioPlayerGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(0.25, 0.18)
frame.Position = UDim2.fromScale(0.375, 0.41)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local playButton = Instance.new("TextButton")
playButton.Size = UDim2.fromScale(0.8, 0.45)
playButton.Position = UDim2.fromScale(0.1, 0.275)
playButton.Text = "▶ Play Audio"
playButton.TextScaled = true
playButton.Font = Enum.Font.GothamBold
playButton.BackgroundColor3 = Color3.fromRGB(40, 170, 255)
playButton.TextColor3 = Color3.new(1, 1, 1)
playButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = playButton

-- Sound object
local sound = Instance.new("Sound")
sound.Volume = 1
sound.Looped = false
sound.Parent = game.SoundService

-- Function to fetch SoundId from server
local function fetchSoundId()
    local success, result = pcall(function()
        return HttpService:GetAsync("http://192.168.18.73:5000/audio") -- replace with your URL
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        if data.SoundId then
            return data.SoundId
        end
    end
    warn("Failed to fetch SoundId")
    return nil
end

-- Button click
playButton.MouseButton1Click:Connect(function()
    local soundId = fetchSoundId()
    if soundId then
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound:Play()
    end
end)
