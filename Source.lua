local BlopGui = {}

function BlopGui.CreateLib(titleText, theme)
	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local bgColor = Color3.fromRGB(15, 15, 15)
	local tabColor = Color3.fromRGB(30, 30, 30)
	local accentColor = Color3.fromRGB(60, 60, 60)
	local textColor = Color3.new(1, 1, 1)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "BlopGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 450, 0, 300)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
	mainFrame.BackgroundColor3 = bgColor
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

	local titleBar = Instance.new("TextLabel")
	titleBar.Size = UDim2.new(1, 0, 0, 30)
	titleBar.BackgroundTransparency = 1
	titleBar.Text = titleText or "Blop GUI"
	titleBar.Font = Enum.Font.FredokaOne
	titleBar.TextSize = 22
	titleBar.TextColor3 = textColor
	titleBar.TextXAlignment = Enum.TextXAlignment.Left
	titleBar.Padding = Enum.Padding or nil
	titleBar.Parent = mainFrame

	local function createTopButton(text, posOffset)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 24, 0, 24)
		btn.Position = UDim2.new(1, -28 * posOffset, 0, 3)
		btn.BackgroundColor3 = tabColor
		btn.TextColor3 = textColor
		btn.Font = Enum.Font.FredokaOne
		btn.TextSize = 16
		btn.Text = text
		btn.BorderSizePixel = 0
		btn.Parent = mainFrame
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		return btn
	end

	local minimizeBtn = createTopButton("-", 2)
	local destroyBtn = createTopButton("X", 1)

	local tabButtons = Instance.new("Frame")
	tabButtons.Size = UDim2.new(0, 100, 1, -40)
	tabButtons.Position = UDim2.new(0, 0, 0, 30)
	tabButtons.BackgroundTransparency = 1
	tabButtons.Parent = mainFrame
	Instance.new("UIListLayout", tabButtons).Padding = UDim.new(0, 5)

	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -120, 1, -40)
	contentFrame.Position = UDim2.new(0, 110, 0, 30)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame

	local currentTab = nil
	local tabContent = {}
	local firstTabCreated = false

	local Window = {}

	function Window:NewTab(tabName)
		local Tab = {}
		tabContent[Tab] = {}

		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1, -10, 0, 32)
		tabButton.BackgroundColor3 = tabColor
		tabButton.TextColor3 = textColor
		tabButton.Font = Enum.Font.FredokaOne
		tabButton.TextSize = 16
		tabButton.Text = tabName
		tabButton.BorderSizePixel = 0
		tabButton.Parent = tabButtons
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

		local function selectTab()
			for tab, elements in pairs(tabContent) do
				for _, obj in pairs(elements) do
					obj.Visible = (tab == Tab)
				end
			end
			currentTab = Tab
		end

		tabButton.MouseButton1Click:Connect(selectTab)

		if not firstTabCreated then
			firstTabCreated = true
			task.defer(selectTab)
		end

		function Tab:NewButton(name, info, callback)
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 32)
			button.BackgroundColor3 = tabColor
			button.TextColor3 = textColor
			button.Font = Enum.Font.FredokaOne
			button.TextSize = 16
			button.Text = name
			button.BorderSizePixel = 0
			button.Visible = false
			button.Parent = contentFrame
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

			table.insert(tabContent[Tab], button)

			button.MouseEnter:Connect(function()
				TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = accentColor}):Play()
			end)
			button.MouseLeave:Connect(function()
				TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = tabColor}):Play()
			end)
			button.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		function Tab:NewToggle(name, info, callback)
			local state = false
			local toggle = Instance.new("TextButton")
			toggle.Size = UDim2.new(1, -10, 0, 32)
			toggle.BackgroundColor3 = tabColor
			toggle.TextColor3 = textColor
			toggle.Font = Enum.Font.FredokaOne
			toggle.TextSize = 16
			toggle.Text = "[OFF] " .. name
			toggle.BorderSizePixel = 0
			toggle.Visible = false
			toggle.Parent = contentFrame
			Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

			table.insert(tabContent[Tab], toggle)

			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = (state and "[ON] " or "[OFF] ") .. name
				toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or tabColor
				if callback then callback(state) end
			end)
		end

		return Tab
	end

	-- Minimize toggles visibility of content
	local minimized = false
	minimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		tabButtons.Visible = not minimized
		contentFrame.Visible = not minimized
	end)

	destroyBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	return Window
end

return BlopGui
