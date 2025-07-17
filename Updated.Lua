-- Wait until the game is fully loaded
repeat wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Pet pools for each egg
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

local espList = {}

local function clearESP()
    for _, gui in ipairs(espList) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espList = {}
end

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
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true

    if petName == eggToPets[eggName][#eggToPets[eggName]] then
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
    end

    table.insert(espList, gui)
end

local function getRandomPet(eggName, forceRare, blockRare)
    local pool = eggToPets[eggName]
    if not pool then return "Unknown" end
    if forceRare then return pool[#pool] end
    if blockRare then return pool[math.random(1, #pool - 1)] end
    return pool[math.random(1, #pool)]
end

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

-- GUI Setup
local gui = Instance.new("ScreenGui", PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 180)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🐣 Egg Randomizer"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true

def createButton(name, posY, text, color)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, posY)
    button.Text = text
    button.Name = name
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

local manualBtn = createButton("ManualRandomizer", 40, "Manual Randomizer", Color3.fromRGB(50, 50, 50))
local autoBtn = createButton("AutoRandomizer", 80, "Auto Randomizer", Color3.fromRGB(70, 40, 40))

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 120)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextStrokeTransparency = 0.2
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextScaled = true

local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.Text = "Made by Kuni Hub"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.Font = Enum.Font.GothamSemibold
footer.BackgroundTransparency = 1
footer.TextScaled = true

local canClick = true

manualBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Rolling manually..."
    randomizeEggs(false, false)
    wait(2)
    statusLabel.Text = ""
    canClick = true
end)

autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Auto rolling..."
    local start = tick()
    while tick() - start < 40 do
        randomizeEggs(false, true)
        frame.BackgroundColor3 = Color3.fromRGB(math.random(30,60), math.random(30,60), math.random(30,60))
        wait(2)
    end
    local rares = randomizeEggs(true, false)
    if #rares > 0 then
        statusLabel.Text = "✅ Rare: " .. table.concat(rares, ", ")
    else
        statusLabel.Text = "✅ Rare pet found"
    end
    wait(3)
    statusLabel.Text = ""
    canClick = true
end)

-- Loading Screen (2 seconds)
local loadingGui = Instance.new("ScreenGui", PlayerGui)
local box = Instance.new("Frame", loadingGui)
box.Size = UDim2.new(0, 280, 0, 100)
box.Position = UDim2.new(0.5, -140, 0.5, -50)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel", box)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "Loading Kuni Hub..."
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.TextScaled = true

wait(2)
loadingGui:Destroy()
