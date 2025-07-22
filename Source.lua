-- BlopGui ModuleScript

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
	mainFrame.Size = UDim2.new(0, 600, 0, 360)
	mainFrame.Position = UDim2.new(0.5, -300, 0.5, -180)
	mainFrame.BackgroundColor3 = bgColor
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = titleText or "Blop GUI"
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 24
	title.TextColor3 = textColor
	title.Parent = mainFrame

	local tabButtons = Instance.new("Frame")
	tabButtons.Size = UDim2.new(0, 120, 1, -40)
	tabButtons.Position = UDim2.new(0, 0, 0, 40)
	tabButtons.BackgroundTransparency = 1
	tabButtons.Parent = mainFrame
	Instance.new("UIListLayout", tabButtons).Padding = UDim.new(0, 6)

	local contentFrame = Instance.new("Frame")
	contentFrame.Size = UDim2.new(1, -140, 1, -50)
	contentFrame.Position = UDim2.new(0, 130, 0, 40)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Parent = mainFrame

	local function clearContent()
		for _, v in pairs(contentFrame:GetChildren()) do
			if v:IsA("GuiObject") then
				v:Destroy()
			end
		end
	end

	local Window = {}

	function Window:NewTab(tabName)
		local Tab = {}

		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1, -10, 0, 36)
		tabButton.BackgroundColor3 = tabColor
		tabButton.TextColor3 = textColor
		tabButton.Font = Enum.Font.FredokaOne
		tabButton.TextSize = 18
		tabButton.Text = tabName
		tabButton.BorderSizePixel = 0
		tabButton.Parent = tabButtons
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 10)

		tabButton.MouseButton1Click:Connect(function()
			clearContent()
		end)

		function Tab:NewButton(name, info, callback)
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 36)
			button.BackgroundColor3 = tabColor
			button.TextColor3 = textColor
			button.Font = Enum.Font.FredokaOne
			button.TextSize = 18
			button.Text = name
			button.BorderSizePixel = 0
			button.Parent = contentFrame
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

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
			toggle.Size = UDim2.new(1, -10, 0, 36)
			toggle.BackgroundColor3 = tabColor
			toggle.TextColor3 = textColor
			toggle.Font = Enum.Font.FredokaOne
			toggle.TextSize = 18
			toggle.Text = "[OFF] " .. name
			toggle.BorderSizePixel = 0
			toggle.Parent = contentFrame
			Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = (state and "[ON] " or "[OFF] ") .. name
				toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or tabColor
				if callback then callback(state) end
			end)
		end

		return Tab
	end

	return Window
end

return BlopGui
