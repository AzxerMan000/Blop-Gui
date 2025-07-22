local BlopGui = {}

function BlopGui.CreateLib(titleText, theme)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlopGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, -60, 0, 28)
    titleBar.Position = UDim2.new(0, 8, 0, 4)
    titleBar.BackgroundTransparency = 1
    titleBar.Text = titleText or "Blop GUI"
    titleBar.Font = Enum.Font.FredokaOne
    titleBar.TextSize = 20
    titleBar.TextColor3 = Color3.new(1, 1, 1)
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Parent = mainFrame

    -- Minimize and Destroy buttons
    local function createTopButton(txt, pos)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 24)
        b.Position = UDim2.new(1, -30 * pos, 0, 4)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -110, 1, -48)
    contentFrame.Position = UDim2.new(0, 100, 0, 36)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = contentFrame

    local tabContent = {}
    local currentTab = nil
    local firstTab = true

    local Window = {}

    function Window:NewTab(tabName)
        local Tab = {}
        tabContent[Tab] = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -8, 0, 28)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.FredokaOne
            b.TextSize = 14
            b.Text = name
            b.BorderSizePixel = 0
            b.Visible = false
            b.Parent = contentFrame
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
            b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.FredokaOne
            b.TextSize = 14
            b.Text = "[OFF] " .. name
            b.BorderSizePixel = 0
            b.Visible = false
            b.Parent = contentFrame
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

    minimizeBtn.MouseButton1Click:Connect(function()
        local isVisible = contentFrame.Visible
        contentFrame.Visible = not isVisible
        tabButtons.Visible = not isVisible
    end)

    destroyBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return Window
end

return BlopGui
