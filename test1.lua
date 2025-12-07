-- Full Mobile-Friendly Admin GUI with Working Fly, Noclip, Collect/Duplicate, Vertical Control
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local cam = workspace.CurrentCamera

-- Wait for character
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- =========================
-- GUI SETUP
-- =========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Menu"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.35,0,0.6,0)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

-- Open/Close button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.15,0,0.06,0)
toggleBtn.Position = UDim2.new(0.02,0,0.02,0)
toggleBtn.Text = "Menu"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = screenGui

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Helper to create buttons
local function createButton(name,posYScale)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0.12,0)
    btn.Position = UDim2.new(0.05,0,posYScale,0)
    btn.Text = name
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = frame
    return btn
end

-- Buttons
local flyBtn = createButton("Fly: OFF",0.02)
local noclipBtn = createButton("Noclip: OFF",0.16)
local wsBtn = createButton("Set WalkSpeed",0.3)
local jpBtn = createButton("Set JumpPower",0.44)
local collectBtn = createButton("Collect Wood/Log",0.58)
local duplicateBtn = createButton("Duplicate Wood/Log",0.72)

-- TextBoxes
local wsInput = Instance.new("TextBox")
wsInput.Size = UDim2.new(0.9,0,0.08,0)
wsInput.Position = UDim2.new(0.05,0,0.36,0)
wsInput.PlaceholderText = tostring(humanoid.WalkSpeed)
wsInput.TextScaled = true
wsInput.Parent = frame

local jpInput = Instance.new("TextBox")
jpInput.Size = UDim2.new(0.9,0,0.08,0)
jpInput.Position = UDim2.new(0.05,0,0.5,0)
jpInput.PlaceholderText = tostring(humanoid.JumpPower)
jpInput.TextScaled = true
jpInput.Parent = frame

-- =========================
-- VARIABLES
-- =========================
local flying = false
local noclipping = false
local flySpeed = 50
local moveDown = false
local bv -- BodyVelocity

-- =========================
-- BUTTON FUNCTIONS
-- =========================
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
    humanoid.PlatformStand = flying

    if flying then
        -- Create BodyVelocity for smooth flying
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.zero
        bv.P = 1250
        bv.Parent = hrp
    else
        if bv then
            bv:Destroy()
            bv = nil
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    noclipBtn.Text = "Noclip: "..(noclipping and "ON" or "OFF")
end)

wsBtn.MouseButton1Click:Connect(function()
    local val = tonumber(wsInput.Text)
    if val then humanoid.WalkSpeed = val end
end)

jpBtn.MouseButton1Click:Connect(function()
    local val = tonumber(jpInput.Text)
    if val then humanoid.JumpPower = val end
end)

collectBtn.MouseButton1Click:Connect(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:match("Wood") or obj.Name:match("Log")) then
            obj.CFrame = hrp.CFrame * CFrame.new(math.random(-3,3),2,math.random(-3,3))
        elseif obj:IsA("Model") and (obj.Name:match("Wood") or obj.Name:match("Log")) then
            local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if primary then obj:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(math.random(-3,3),2,math.random(-3,3))) end
        end
    end
end)

duplicateBtn.MouseButton1Click:Connect(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name:match("Wood") or obj.Name:match("Log")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local clone = obj:Clone()
            clone.Parent = workspace
            if clone:IsA("BasePart") then
                clone.CFrame = hrp.CFrame * CFrame.new(math.random(-3,3),2,math.random(-3,3))
            elseif clone:IsA("Model") then
                local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
                if primary then clone:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(math.random(-3,3),2,math.random(-3,3))) end
            end
        end
    end
end)

-- =========================
-- MOBILE VERTICAL FLY BUTTON
-- =========================
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0.12, 0, 0.12, 0)
downBtn.Position = UDim2.new(0.7, 0, 0.82, 0)
downBtn.Text = "Down"
downBtn.TextScaled = true
downBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
downBtn.TextColor3 = Color3.fromRGB(255,255,255)
downBtn.Parent = screenGui

downBtn.MouseButton1Down:Connect(function() moveDown = true end)
downBtn.MouseButton1Up:Connect(function() moveDown = false end)
downBtn.TouchLongPress:Connect(function() moveDown = true end)
downBtn.TouchEnded:Connect(function() moveDown = false end)

-- =========================
-- MAIN LOOP
-- =========================
runService.RenderStepped:Connect(function(dt)
    -- Fly with mobile joystick
    if flying and bv then
        local moveDir = humanoid.MoveDirection
        local camCF = cam.CFrame
        local dir = Vector3.new(moveDir.X * camCF.RightVector.X + moveDir.Z * camCF.LookVector.X, 0, moveDir.X * camCF.RightVector.Z + moveDir.Z * camCF.LookVector.Z)

        -- Vertical control
        if humanoid.Jump then dir += Vector3.new(0, flySpeed/2, 0) end
        if moveDown then dir -= Vector3.new(0, flySpeed/2, 0) end

        if dir.Magnitude > 0 then dir = dir.Unit * flySpeed end
        bv.Velocity = dir
    end

    -- Noclip
    if noclipping then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
