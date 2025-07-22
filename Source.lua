local BlopGui = {}

function BlopGui.CreateLib(titleText, theme)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")


    local themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Blop-Gui/main/Themes.lua"))()
    local selectedTheme = themes[themeName] or themes["Dark"]
    

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlopGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = selectedTheme.BackgroundColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local originalSize = UDim2.new(0, 350, 0, 250)
local minimizedSize = UDim2.new(0, 350, 0, 32)
mainFrame.Size = originalSize
local isMinimized = false

    
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, -60, 0, 28)
    titleBar.Position = UDim2.new(0, 8, 0, 4)
    titleBar.BackgroundTransparency = 1
    titleBar.Text = titleText or "Blop GUI"
    titleBar.Font = Enum.Font.FredokaOne
    titleBar.TextSize = 20
    titleBar.TextColor3 = Color3.new(1,1,1)
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Parent = mainFrame

    -- Minimize and Destroy buttons
    local function createTopButton(txt, pos)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 24)
        b.Position = UDim2.new(1, -30 * pos, 0, 4)
        b.BackgroundColor3 = selectedTheme.BackgroundColor
        b.Text = txt
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.FredokaOne
        b.TextSize = 16
        b.BorderSizePixel = 0
        b.Parent = mainFrame
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    local minimizeBtn = createTopButton("-", 2)
    local destroyBtn = createTopButton("X", 1)

    local tabButtons = Instance.new("Frame")
    tabButtons.Size = UDim2.new(0, 90, 1, -40)
    tabButtons.Position = UDim2.new(0, 8, 0, 36)
    tabButtons.BackgroundTransparency = 1
    tabButtons.Parent = mainFrame

    Instance.new("UIListLayout", tabButtons).Padding = UDim.new(0, 4)

    local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -110, 1, -48)
scrollFrame.Position = UDim2.new(0, 100, 0, 36)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

    local tabContent = {}
    local currentTab = nil
    local firstTab = true

    local Window = {}

    function Window:NewTab(tabName)
        local Tab = {}
        tabContent[Tab] = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -8, 0, 28)
        tabBtn.BackgroundColor3 = selectedTheme.BackgroundColor
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
        tabBtn.Font = Enum.Font.FredokaOne
        tabBtn.TextSize = 14
        tabBtn.Text = tabName
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabButtons
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local function selectTab()
            for tab, buttons in pairs(tabContent) do
                for _, btn in ipairs(buttons) do
                    btn.Visible = (tab == Tab)
                end
            end
            currentTab = Tab
        end

        tabBtn.MouseButton1Click:Connect(selectTab)

        if firstTab then
            task.defer(selectTab)
            firstTab = false
        end

        function Tab:NewButton(name, info, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -6, 0, 28)
            b.BackgroundColor3 = selectedTheme.BackgroundColorr
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.FredokaOne
            b.TextSize = 14
            b.Text = name
            b.BorderSizePixel = 0
            b.Visible = false
            b.Parent = scrollFrame
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            table.insert(tabContent[Tab], b)
        end

        function Tab:NewToggle(name, info, callback)
            local state = false
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -6, 0, 28)
            b.BackgroundColor3 = selectedTheme.BackgroundColor
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.FredokaOne
            b.TextSize = 14
            b.Text = "[OFF] " .. name
            b.BorderSizePixel = 0
            b.Visible = false
            b.Parent = scrollFrame
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function()
                state = not state
                b.Text = (state and "[ON] " or "[OFF] ") .. name
                b.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
                if callback then callback(state) end
            end)
            table.insert(tabContent[Tab], b)
        end

        return Tab
    end

    local isMinimized = false
local originalSize = UDim2.new(0, 350, 0, 250)
local minimizedSize = UDim2.new(0, 350, 0, 32)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    if isMinimized then
        mainFrame.Size = minimizedSize
        tabButtons.Visible = false
        if scrollFrame then scrollFrame.Visible = false end -- or contentFrame if you're still using that
    else
        mainFrame.Size = originalSize
        tabButtons.Visible = true
        if scrollFrame then scrollFrame.Visible = true end
    end
end)
    destroyBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return Window
end

return BlopGui
