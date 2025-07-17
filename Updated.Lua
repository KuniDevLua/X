repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Egg-to-pets data
local eggToPets = {
    ["Common Egg"] = {"Dog", "Golden Lab", "Bunny"},
    ["Uncommon Egg"] = {"Black Bunny", "Cat", "Chicken", "Deer"},
    ["Rare Egg"] = {"Monkey", "Orange Tabby", "Pig", "Rooster", "Spotted Deer"},
    ["Legendary Egg"] = {"Cow", "Silver Monkey", "Sea Otter", "Turtle", "Polar Bear"},
    ["Mythical Egg"] = {"Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox"},
    ["Bug Egg"] = {"Snail", "Giant Ant", "Caterpillar", "Praying Mantis", "Dragonfly"},
    ["Bee Egg"] = {"Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"},
    ["Paradise Egg"] = {"Ostrich", "Peacock", "Capybara", "Scarlet Macaw", "Mimic Octopus"},
    ["Oasis Egg"] = {"Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw"},
    ["Grow a Garden Egg"] = {"Sprout", "Tiny Flower", "Green Caterpillar", "Garden Snail", "Mystic Gnome"}
}

-- GUI Cleanup and ESP
local espList = {}
local function clearESP()
    for _, gui in ipairs(espList) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espList = {}
end

-- ESP Tag Creation
local function createESP(part, eggName, petName)
    if part:FindFirstChild("EggESP") then return end

    local gui = Instance.new("BillboardGui", part)
    gui.Name = "EggESP"
    gui.Size = UDim2.new(0, 150, 0, 40)
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true
    gui.Adornee = part

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = eggName .. " | " .. petName
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    local stroke = Instance.new("UIStroke", label)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 0, 0)

    if petName == eggToPets[eggName][#eggToPets[eggName]] then
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
    end

    table.insert(espList, gui)
end

-- Pet Selection
local function getRandomPet(eggName, forceRare, blockRare)
    local pool = eggToPets[eggName]
    if not pool then return "Unknown" end
    if forceRare then return pool[#pool] end
    if blockRare then return pool[math.random(1, #pool - 1)] end
    return pool[math.random(1, #pool)]
end

-- Egg Randomization
local function randomizeEggs(forceRare, blockRare)
    clearESP()
    local raresFound = {}
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and eggToPets[model.Name] then
            local part = model:FindFirstChildWhichIsA("BasePart")
            if part then
                local pet = getRandomPet(model.Name, forceRare, blockRare)
                createESP(part, model.Name, pet)
                if pet == eggToPets[model.Name][#eggToPets[model.Name]] then
                    table.insert(raresFound, model.Name .. " | " .. pet)
                end
            end
        end
    end
    return raresFound
end

-- Loading GUI
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "KuniLoading"
loadingGui.IgnoreGuiInset = true

local box = Instance.new("Frame", loadingGui)
box.Size = UDim2.new(0, 280, 0, 100)
box.Position = UDim2.new(0.5, -140, 0.5, -50)
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", box)
title.Size = UDim2.new(1, 0, 0.5, 0)
title.Text = "Kuni Hub Loading..."
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true

wait(2)
loadingGui:Destroy()

-- Main GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "KuniHubGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Header
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 24)
header.Position = UDim2.new(0, 0, 0, 0)
header.Text = "Egg Randomizer"
header.Font = Enum.Font.GothamBold
header.TextColor3 = Color3.fromRGB(255, 215, 0)
header.BackgroundTransparency = 1
header.TextScaled = true

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, -20, 0, 20)
footer.Position = UDim2.new(0, 10, 1, -22)
footer.Text = "Made by Kuni Hub"
footer.Font = Enum.Font.Gotham
footer.TextColor3 = Color3.fromRGB(120, 120, 120)
footer.BackgroundTransparency = 1
footer.TextScaled = true

-- Status Label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true

-- Manual Randomizer
local manualBtn = Instance.new("TextButton", frame)
manualBtn.Size = UDim2.new(0.9, 0, 0, 30)
manualBtn.Position = UDim2.new(0.05, 0, 0, 60)
manualBtn.Text = "Manual Randomizer"
manualBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
manualBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
manualBtn.Font = Enum.Font.GothamBold
manualBtn.TextScaled = true
Instance.new("UICorner", manualBtn).CornerRadius = UDim.new(0, 8)

-- Auto Randomizer
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoBtn.Position = UDim2.new(0.05, 0, 0, 100)
autoBtn.Text = "Auto Randomizer"
autoBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
autoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

-- RGB Blinking Animation
local function blinkEffect()
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 0, 255),
    }
    for i = 1, #colors do
        autoBtn.BackgroundColor3 = colors[i]
        wait(0.1)
    end
end

-- Button Logic
local canClick = true

manualBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Randomizing..."
    randomizeEggs(false, false)
    wait(2)
    statusLabel.Text = ""
    canClick = true
end)

autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    local start = tick()
    while tick() - start < 40 do
        blinkEffect()
        randomizeEggs(false, true)
        wait(2)
    end
    local rares = randomizeEggs(true, false)
    statusLabel.Text = (#rares > 0 and "✅ Found:\n" .. table.concat(rares, "\n")) or "✅ Found Rare Pet!"
    wait(4)
    statusLabel.Text = ""
    canClick = true
end)
