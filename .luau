-- Modern UI Library Configuration
local ui_options = {
	main_color = Color3.fromRGB(88, 101, 242), -- Discord-like purple
	accent_color = Color3.fromRGB(114, 137, 218),
	bg_color = Color3.fromRGB(32, 34, 37),
	secondary_bg = Color3.fromRGB(47, 49, 54),
	min_size = Vector2.new(500, 400),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
	window_transparency = 0.05,
	animation_speed = 0.25,
}

-- Clean up existing UI
do
	local imgui = game:GetService("CoreGui"):FindFirstChild("imgui")
	if imgui then imgui:Destroy() end
end

-- Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")

-- Create main container
local imgui = Instance.new("ScreenGui")
imgui.Name = "imgui"
imgui.Parent = game:GetService("CoreGui")
imgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Prefabs = Instance.new("Folder")
Prefabs.Name = "Prefabs"
Prefabs.Parent = imgui

local Windows = Instance.new("Frame")
Windows.Name = "Windows"
Windows.Parent = imgui
Windows.BackgroundTransparency = 1
Windows.Size = UDim2.new(1, 0, 1, 0)

-- Utility Functions
local function Tween(obj, props, duration)
	duration = duration or ui_options.animation_speed
	local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	tween:Play()
	return tween
end

local function CreateRipple(parent, x, y, color)
	spawn(function()
		local ripple = Instance.new("ImageLabel")
		ripple.Name = "Ripple"
		ripple.Parent = parent
		ripple.BackgroundTransparency = 1
		ripple.Image = "rbxassetid://266543268"
		ripple.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
		ripple.ImageTransparency = 0.5
		ripple.ZIndex = parent.ZIndex + 100
		
		local relX = x - parent.AbsolutePosition.X
		local relY = y - parent.AbsolutePosition.Y
		ripple.Position = UDim2.new(0, relX, 0, relY)
		
		local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
		
		Tween(ripple, {
			Size = UDim2.new(0, size, 0, size),
			Position = UDim2.new(0, relX - size/2, 0, relY - size/2),
			ImageTransparency = 1
		}, 0.6)
		
		task.wait(0.6)
		ripple:Destroy()
	end)
end

local function CreateGlow(parent)
	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.Parent = parent
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://2592362371"
	glow.ImageColor3 = ui_options.main_color
	glow.ImageTransparency = 0.8
	glow.ScaleType = Enum.ScaleType.Slice
	glow.SliceCenter = Rect.new(8, 8, 247, 247)
	glow.Size = UDim2.new(1, 20, 1, 20)
	glow.Position = UDim2.new(0, -10, 0, -10)
	glow.ZIndex = parent.ZIndex - 1
	return glow
end

-- Create Window Prefab
local function CreateWindowPrefab()
	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.BackgroundColor3 = ui_options.bg_color
	Window.BorderSizePixel = 0
	Window.Size = UDim2.new(0, 500, 0, 400)
	Window.Position = UDim2.new(0.5, -250, 0.5, -200)
	Window.ClipsDescendants = false
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Window
	
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = ui_options.main_color
	UIStroke.Thickness = 2
	UIStroke.Transparency = 0.7
	UIStroke.Parent = Window
	
	-- Shadow
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Parent = Window
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://2592362371"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.5
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(8, 8, 247, 247)
	Shadow.Size = UDim2.new(1, 40, 1, 40)
	Shadow.Position = UDim2.new(0, -20, 0, -20)
	Shadow.ZIndex = Window.ZIndex - 1
	
	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = Window
	TitleBar.BackgroundColor3 = ui_options.secondary_bg
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 45)
	
	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 12)
	TitleCorner.Parent = TitleBar
	
	local TitleBarBottom = Instance.new("Frame")
	TitleBarBottom.Parent = TitleBar
	TitleBarBottom.BackgroundColor3 = ui_options.secondary_bg
	TitleBarBottom.BorderSizePixel = 0
	TitleBarBottom.Position = UDim2.new(0, 0, 0.5, 0)
	TitleBarBottom.Size = UDim2.new(1, 0, 0.5, 0)
	
	-- Accent Line
	local AccentLine = Instance.new("Frame")
	AccentLine.Name = "AccentLine"
	AccentLine.Parent = TitleBar
	AccentLine.BackgroundColor3 = ui_options.main_color
	AccentLine.BorderSizePixel = 0
	AccentLine.Position = UDim2.new(0, 0, 1, -2)
	AccentLine.Size = UDim2.new(1, 0, 0, 2)
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Parent = TitleBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.Size = UDim2.new(1, -80, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = "Window Title"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Close Button
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TitleBar
	CloseBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
	CloseBtn.BackgroundTransparency = 0.3
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
	CloseBtn.Size = UDim2.new(0, 20, 0, 20)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 18
	
	local CloseBtnCorner = Instance.new("UICorner")
	CloseBtnCorner.CornerRadius = UDim.new(1, 0)
	CloseBtnCorner.Parent = CloseBtn
	
	-- Tab Selection
	local TabSelection = Instance.new("Frame")
	TabSelection.Name = "TabSelection"
	TabSelection.Parent = Window
	TabSelection.BackgroundTransparency = 1
	TabSelection.Position = UDim2.new(0, 15, 0, 60)
	TabSelection.Size = UDim2.new(1, -30, 0, 35)
	
	local TabButtons = Instance.new("Frame")
	TabButtons.Name = "TabButtons"
	TabButtons.Parent = TabSelection
	TabButtons.BackgroundTransparency = 1
	TabButtons.Size = UDim2.new(1, 0, 1, 0)
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabButtons
	TabLayout.FillDirection = Enum.FillDirection.Horizontal
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 8)
	
	-- Content Area
	local Content = Instance.new("ScrollingFrame")
	Content.Name = "Content"
	Content.Parent = Window
	Content.BackgroundTransparency = 1
	Content.BorderSizePixel = 0
	Content.Position = UDim2.new(0, 15, 0, 105)
	Content.Size = UDim2.new(1, -30, 1, -120)
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)
	Content.ScrollBarThickness = 4
	Content.ScrollBarImageColor3 = ui_options.main_color
	
	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Parent = Content
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 10)
	
	ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
	end)
	
	-- Resizer
	local Resizer = Instance.new("Frame")
	Resizer.Name = "Resizer"
	Resizer.Parent = Window
	Resizer.BackgroundTransparency = 1
	Resizer.Position = UDim2.new(1, -20, 1, -20)
	Resizer.Size = UDim2.new(0, 20, 0, 20)
	Resizer.ZIndex = 10
	
	return Window
end

-- Create Tab Button Prefab
local function CreateTabButton()
	local TabButton = Instance.new("TextButton")
	TabButton.Name = "TabButton"
	TabButton.BackgroundColor3 = ui_options.secondary_bg
	TabButton.BackgroundTransparency = 0.5
	TabButton.BorderSizePixel = 0
	TabButton.Size = UDim2.new(0, 100, 1, 0)
	TabButton.Font = Enum.Font.GothamMedium
	TabButton.Text = "Tab"
	TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	TabButton.TextSize = 14
	TabButton.AutoButtonColor = false
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = TabButton
	
	return TabButton
end

-- Create UI Elements
local function CreateLabel()
	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(1, 0, 0, 25)
	Label.Font = Enum.Font.Gotham
	Label.Text = "Label"
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	return Label
end

local function CreateButton()
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.BackgroundColor3 = ui_options.main_color
	Button.BorderSizePixel = 0
	Button.Size = UDim2.new(1, 0, 0, 35)
	Button.Font = Enum.Font.GothamBold
	Button.Text = "Button"
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 14
	Button.AutoButtonColor = false
	Button.ClipsDescendants = true
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button
	
	return Button
end

local function CreateSwitch()
	local Container = Instance.new("Frame")
	Container.Name = "Switch"
	Container.BackgroundColor3 = ui_options.secondary_bg
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, 0, 0, 40)
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Container
	
	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.Parent = Container
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.Size = UDim2.new(1, -80, 1, 0)
	Label.Font = Enum.Font.Gotham
	Label.Text = "Switch"
	Label.TextColor3 = Color3.fromRGB(220, 220, 220)
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	
	local Toggle = Instance.new("Frame")
	Toggle.Name = "Toggle"
	Toggle.Parent = Container
	Toggle.BackgroundColor3 = Color3.fromRGB(60, 63, 68)
	Toggle.Position = UDim2.new(1, -55, 0.5, -10)
	Toggle.Size = UDim2.new(0, 45, 0, 20)
	
	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(1, 0)
	ToggleCorner.Parent = Toggle
	
	local Knob = Instance.new("Frame")
	Knob.Name = "Knob"
	Knob.Parent = Toggle
	Knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	Knob.Position = UDim2.new(0, 2, 0.5, -8)
	Knob.Size = UDim2.new(0, 16, 0, 16)
	
	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob
	
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Parent = Container
	Button.BackgroundTransparency = 1
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.Text = ""
	Button.ZIndex = 2
	
	return Container
end

local function CreateTextBox()
	local TextBox = Instance.new("TextBox")
	TextBox.Name = "TextBox"
	TextBox.BackgroundColor3 = ui_options.secondary_bg
	TextBox.BorderSizePixel = 0
	TextBox.Size = UDim2.new(1, 0, 0, 35)
	TextBox.Font = Enum.Font.Gotham
	TextBox.PlaceholderText = "Enter text..."
	TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
	TextBox.TextSize = 14
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.ClearTextOnFocus = false
	
	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 12)
	Padding.PaddingRight = UDim.new(0, 12)
	Padding.Parent = TextBox
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = TextBox
	
	return TextBox
end

local function CreateDropdown()
	local Container = Instance.new("Frame")
	Container.Name = "Dropdown"
	Container.BackgroundColor3 = ui_options.secondary_bg
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, 0, 0, 35)
	Container.ClipsDescendants = false
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Container
	
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Parent = Container
	Button.BackgroundTransparency = 1
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.Font = Enum.Font.Gotham
	Button.Text = "  Dropdown"
	Button.TextColor3 = Color3.fromRGB(220, 220, 220)
	Button.TextSize = 14
	Button.TextXAlignment = Enum.TextXAlignment.Left
	
	local Arrow = Instance.new("TextLabel")
	Arrow.Name = "Arrow"
	Arrow.Parent = Container
	Arrow.BackgroundTransparency = 1
	Arrow.Position = UDim2.new(1, -30, 0, 0)
	Arrow.Size = UDim2.new(0, 30, 1, 0)
	Arrow.Font = Enum.Font.GothamBold
	Arrow.Text = "▼"
	Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
	Arrow.TextSize = 12
	
	local List = Instance.new("ScrollingFrame")
	List.Name = "List"
	List.Parent = Container
	List.BackgroundColor3 = ui_options.bg_color
	List.BorderSizePixel = 0
	List.Position = UDim2.new(0, 0, 1, 5)
	List.Size = UDim2.new(1, 0, 0, 0)
	List.Visible = false
	List.CanvasSize = UDim2.new(0, 0, 0, 0)
	List.ScrollBarThickness = 4
	List.ScrollBarImageColor3 = ui_options.main_color
	List.ZIndex = 10
	
	local ListCorner = Instance.new("UICorner")
	ListCorner.CornerRadius = UDim.new(0, 8)
	ListCorner.Parent = List
	
	local ListStroke = Instance.new("UIStroke")
	ListStroke.Color = ui_options.main_color
	ListStroke.Thickness = 1
	ListStroke.Transparency = 0.8
	ListStroke.Parent = List
	
	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Parent = List
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Padding = UDim.new(0, 2)
	
	return Container
end

local function CreateFolder()
	local Container = Instance.new("Frame")
	Container.Name = "Folder"
	Container.BackgroundColor3 = ui_options.secondary_bg
	Container.BackgroundTransparency = 0.5
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, 0, 0, 35)
	Container.ClipsDescendants = true
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Container
	
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Parent = Container
	Button.BackgroundTransparency = 1
	Button.Size = UDim2.new(1, 0, 0, 35)
	Button.Font = Enum.Font.GothamBold
	Button.Text = "  ▶ Folder"
	Button.TextColor3 = Color3.fromRGB(220, 220, 220)
	Button.TextSize = 14
	Button.TextXAlignment = Enum.TextXAlignment.Left
	
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Parent = Container
	Content.BackgroundTransparency = 1
	Content.Position = UDim2.new(0, 10, 0, 40)
	Content.Size = UDim2.new(1, -10, 1, -40)
	Content.Visible = false
	
	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.Parent = Content
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Padding = UDim.new(0, 8)
	
	return Container
end

-- Store prefabs
Prefabs:SetAttribute("WindowPrefab", "Created")
Prefabs:SetAttribute("TabButtonPrefab", "Created")
Prefabs:SetAttribute("LabelPrefab", "Created")
Prefabs:SetAttribute("ButtonPrefab", "Created")
Prefabs:SetAttribute("SwitchPrefab", "Created")
Prefabs:SetAttribute("TextBoxPrefab", "Created")
Prefabs:SetAttribute("DropdownPrefab", "Created")
Prefabs:SetAttribute("FolderPrefab", "Created")

-- Library
local library = {}
local windows_count = 0

function library:CreateWindow(title)
	windows_count = windows_count + 1
	local window_data = {}
	
	local Window = CreateWindowPrefab()
	Window.Parent = Windows
	Window:FindFirstChild("TitleBar"):FindFirstChild("Title").Text = title or "Window"
	Window.Size = UDim2.new(0, ui_options.min_size.X, 0, ui_options.min_size.Y)
	
	-- Dragging
	local dragging, dragInput, dragStart, startPos
	local TitleBar = Window:FindFirstChild("TitleBar")
	
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Window.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Tween(Window, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
		end
	end)
	
	-- Close button
	Window:FindFirstChild("TitleBar"):FindFirstChild("CloseBtn").MouseButton1Click:Connect(function()
		Tween(Window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
		task.wait(0.3)
		Window:Destroy()
	end)
	
	-- Resizing
	if ui_options.can_resize then
		local Resizer = Window:FindFirstChild("Resizer")
		local resizing = false
		
		Resizer.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = true
			end
		end)
		
		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = false
			end
		end)
		
		UIS.InputChanged:Connect(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mousePos = UIS:GetMouseLocation()
				local newX = math.max(ui_options.min_size.X, mousePos.X - Window.AbsolutePosition.X)
				local newY = math.max(ui_options.min_size.Y, mousePos.Y - Window.AbsolutePosition.Y)
				Tween(Window, {Size = UDim2.new(0, newX, 0, newY)}, 0.1)
			end
		end)
	end
	
	-- Tab management
	local tabs = {}
	local current_tab = nil
	
	function window_data:AddTab(tab_name)
		local tab_data = {}
		
		local TabButton = CreateTabButton()
		TabButton.Parent = Window:FindFirstChild("TabSelection"):FindFirstChild("TabButtons")
		TabButton.Text = tab_name
		
		local Content = Instance.new("Frame")
		Content.Name = "TabContent_" .. tab_name
		Content.Parent = Window:FindFirstChild("Content")
		Content.BackgroundTransparency = 1
		Content.Size = UDim2.new(1, 0, 0, 0)
		Content.Visible = false
		
		local Layout = Instance.new("UIListLayout")
		Layout.Parent = Content
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Padding = UDim.new(0, 10)
		
		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Content.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
		end)
		
		tabs[tab_name] = {button = TabButton, content = Content}
		
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(tabs) do
				tab.content.Visible = false
				Tween(tab.button, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 200)})
			end
			Content.Visible = true
			Tween(TabButton, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
			current_tab = tab_name
		end)
		
		-- Auto-select first tab
		if not current_tab then
			TabButton.MouseButton1Click:Fire()
		end
		
		-- Tab functions
		function tab_data:AddLabel(text)
			local Label = CreateLabel()
			Label.Parent = Content
			Label.Text = text
			return Label
		end
		
		function tab_data:AddButton(text, callback)
			local Button = CreateButton()
			Button.Parent = Content
			Button.Text = text
			
			Button.MouseEnter:Connect(function()
				Tween(Button, {BackgroundColor3 = ui_options.accent_color}, 0.2)
			end)
			
			Button.MouseLeave:Connect(function()
				Tween(Button, {BackgroundColor3 = ui_options.main_color}, 0.2)
			end)
			
			Button.MouseButton1Click:Connect(function()
				CreateRipple(Button, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
				if callback then callback() end
			end)
			
			return Button
		end
		
		function tab_data:AddSwitch(text, default, callback)
			local Container = CreateSwitch()
			Container.Parent = Content
			Container:FindFirstChild("Label").Text = text
			
			local Toggle = Container:FindFirstChild("Toggle")
			local Knob = Toggle:FindFirstChild("Knob")
			local Button = Container:FindFirstChild("Button")
			local toggled = default or false
			
			local function UpdateSwitch()
				if toggled then
					Tween(Knob, {Position = UDim2.new(1, -18, 0.5, -8)})
					Tween(Toggle, {BackgroundColor3 = ui_options.main_color})
					Tween(Knob, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
				else
					Tween(Knob, {Position = UDim2.new(0, 2, 0.5, -8)})
					Tween(Toggle, {BackgroundColor3 = Color3.fromRGB(60, 63, 68)})
					Tween(Knob, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
				end
			end
			
			UpdateSwitch()
			
			Button.MouseButton1Click:Connect(function()
				toggled = not toggled
				UpdateSwitch()
				if callback then callback(toggled) end
			end)
			
			return Container
		end
		
		function tab_data:AddTextBox(placeholder, callback)
			local TextBox = CreateTextBox()
			TextBox.Parent = Content
			TextBox.PlaceholderText = placeholder or "Enter text..."
			
			TextBox.Focused:Connect(function()
				Tween(TextBox, {BackgroundColor3 = Color3.fromRGB(60, 63, 68)})
			end)
			
			TextBox.FocusLost:Connect(function(enter)
				Tween(TextBox, {BackgroundColor3 = ui_options.secondary_bg})
				if enter and callback then
					callback(TextBox.Text)
				end
			end)
			
			return TextBox
		end
		
		function tab_data:AddDropdown(text, options, callback)
			local Container = CreateDropdown()
			Container.Parent = Content
			
			local Button = Container:FindFirstChild("Button")
			local Arrow = Container:FindFirstChild("Arrow")
			local List = Container:FindFirstChild("List")
			local ListLayout = List:FindFirstChild("UIListLayout")
			
			Button.Text = "  " .. text
			local selected = nil
			local is_open = false
			
			local function UpdateList()
				List:ClearAllChildren()
				
				local NewLayout = Instance.new("UIListLayout")
				NewLayout.Parent = List
				NewLayout.SortOrder = Enum.SortOrder.LayoutOrder
				NewLayout.Padding = UDim.new(0, 2)
				
				local Padding = Instance.new("UIPadding")
				Padding.PaddingTop = UDim.new(0, 5)
				Padding.PaddingBottom = UDim.new(0, 5)
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.PaddingRight = UDim.new(0, 5)
				Padding.Parent = List
				
				for _, option in ipairs(options) do
					local OptionBtn = Instance.new("TextButton")
					OptionBtn.Parent = List
					OptionBtn.BackgroundColor3 = ui_options.secondary_bg
					OptionBtn.BorderSizePixel = 0
					OptionBtn.Size = UDim2.new(1, -10, 0, 30)
					OptionBtn.Font = Enum.Font.Gotham
					OptionBtn.Text = option
					OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
					OptionBtn.TextSize = 13
					OptionBtn.AutoButtonColor = false
					
					local OptCorner = Instance.new("UICorner")
					OptCorner.CornerRadius = UDim.new(0, 6)
					OptCorner.Parent = OptionBtn
					
					OptionBtn.MouseEnter:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = ui_options.main_color}, 0.15)
					end)
					
					OptionBtn.MouseLeave:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = ui_options.secondary_bg}, 0.15)
					end)
					
					OptionBtn.MouseButton1Click:Connect(function()
						selected = option
						Button.Text = "  " .. option
						is_open = false
						Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
						Tween(Arrow, {Rotation = 0}, 0.2)
						task.wait(0.2)
						List.Visible = false
						if callback then callback(option) end
					end)
				end
				
				NewLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					List.CanvasSize = UDim2.new(0, 0, 0, NewLayout.AbsoluteContentSize.Y + 10)
				end)
			end
			
			UpdateList()
			
			Button.MouseButton1Click:Connect(function()
				is_open = not is_open
				
				if is_open then
					List.Visible = true
					local height = math.min(#options * 32 + 10, 150)
					Tween(List, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
					Tween(Arrow, {Rotation = 180}, 0.2)
				else
					Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
					Tween(Arrow, {Rotation = 0}, 0.2)
					task.wait(0.2)
					List.Visible = false
				end
			end)
			
			return Container
		end
		
		function tab_data:AddMultiDropdown(text, options, callback)
			local Container = CreateDropdown()
			Container.Parent = Content
			
			local Button = Container:FindFirstChild("Button")
			local Arrow = Container:FindFirstChild("Arrow")
			local List = Container:FindFirstChild("List")
			
			Button.Text = "  " .. text
			local selected = {}
			local is_open = false
			
			local function UpdateText()
				local count = 0
				for _ in pairs(selected) do count = count + 1 end
				
				if count == 0 then
					Button.Text = "  " .. text
				elseif count == 1 then
					for k in pairs(selected) do
						Button.Text = "  " .. k
					end
				else
					Button.Text = "  " .. count .. " Selected"
				end
			end
			
			local function UpdateList()
				List:ClearAllChildren()
				
				local NewLayout = Instance.new("UIListLayout")
				NewLayout.Parent = List
				NewLayout.SortOrder = Enum.SortOrder.LayoutOrder
				NewLayout.Padding = UDim.new(0, 2)
				
				local Padding = Instance.new("UIPadding")
				Padding.PaddingTop = UDim.new(0, 5)
				Padding.PaddingBottom = UDim.new(0, 5)
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.PaddingRight = UDim.new(0, 5)
				Padding.Parent = List
				
				for _, option in ipairs(options) do
					local OptionBtn = Instance.new("TextButton")
					OptionBtn.Parent = List
					OptionBtn.BackgroundColor3 = ui_options.secondary_bg
					OptionBtn.BorderSizePixel = 0
					OptionBtn.Size = UDim2.new(1, -10, 0, 30)
					OptionBtn.Font = Enum.Font.Gotham
					OptionBtn.Text = "  " .. option
					OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
					OptionBtn.TextSize = 13
					OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
					OptionBtn.AutoButtonColor = false
					
					local OptCorner = Instance.new("UICorner")
					OptCorner.CornerRadius = UDim.new(0, 6)
					OptCorner.Parent = OptionBtn
					
					local Check = Instance.new("TextLabel")
					Check.Parent = OptionBtn
					Check.BackgroundTransparency = 1
					Check.Position = UDim2.new(1, -25, 0.5, -10)
					Check.Size = UDim2.new(0, 20, 0, 20)
					Check.Font = Enum.Font.GothamBold
					Check.Text = ""
					Check.TextColor3 = ui_options.main_color
					Check.TextSize = 16
					
					if selected[option] then
						Check.Text = "✓"
					end
					
					OptionBtn.MouseEnter:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = Color3.fromRGB(60, 63, 68)}, 0.15)
					end)
					
					OptionBtn.MouseLeave:Connect(function()
						Tween(OptionBtn, {BackgroundColor3 = ui_options.secondary_bg}, 0.15)
					end)
					
					OptionBtn.MouseButton1Click:Connect(function()
						if selected[option] then
							selected[option] = nil
							Check.Text = ""
						else
							selected[option] = true
							Check.Text = "✓"
						end
						UpdateText()
						if callback then callback(selected) end
					end)
				end
				
				NewLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					List.CanvasSize = UDim2.new(0, 0, 0, NewLayout.AbsoluteContentSize.Y + 10)
				end)
			end
			
			UpdateList()
			
			Button.MouseButton1Click:Connect(function()
				is_open = not is_open
				
				if is_open then
					List.Visible = true
					local height = math.min(#options * 32 + 10, 150)
					Tween(List, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
					Tween(Arrow, {Rotation = 180}, 0.2)
				else
					Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
					Tween(Arrow, {Rotation = 0}, 0.2)
					task.wait(0.2)
					List.Visible = false
				end
			end)
			
			return Container
		end
		
		function tab_data:AddFolder(folder_name)
			local folder_data = {}
			local Container = CreateFolder()
			Container.Parent = Content
			
			local Button = Container:FindFirstChild("Button")
			local FolderContent = Container:FindFirstChild("Content")
			local Layout = FolderContent:FindFirstChild("UIListLayout")
			
			Button.Text = "  ▶ " .. folder_name
			local is_open = false
			
			Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if is_open then
					Tween(Container, {Size = UDim2.new(1, 0, 0, 35 + Layout.AbsoluteContentSize.Y + 15)}, 0.2)
				end
			end)
			
			Button.MouseButton1Click:Connect(function()
				is_open = not is_open
				
				if is_open then
					Button.Text = "  ▼ " .. folder_name
					FolderContent.Visible = true
					Tween(Container, {Size = UDim2.new(1, 0, 0, 35 + Layout.AbsoluteContentSize.Y + 15)}, 0.25)
				else
					Button.Text = "  ▶ " .. folder_name
					Tween(Container, {Size = UDim2.new(1, 0, 0, 35)}, 0.25)
					task.wait(0.25)
					FolderContent.Visible = false
				end
			end)
			
			-- Folder can contain same elements as tab
			function folder_data:AddLabel(text)
				local Label = CreateLabel()
				Label.Parent = FolderContent
				Label.Text = text
				return Label
			end
			
			function folder_data:AddButton(text, callback)
				local Btn = CreateButton()
				Btn.Parent = FolderContent
				Btn.Text = text
				
				Btn.MouseEnter:Connect(function()
					Tween(Btn, {BackgroundColor3 = ui_options.accent_color}, 0.2)
				end)
				
				Btn.MouseLeave:Connect(function()
					Tween(Btn, {BackgroundColor3 = ui_options.main_color}, 0.2)
				end)
				
				Btn.MouseButton1Click:Connect(function()
					CreateRipple(Btn, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
					if callback then callback() end
				end)
				
				return Btn
			end
			
			function folder_data:AddSwitch(text, default, callback)
				local Switch = CreateSwitch()
				Switch.Parent = FolderContent
				Switch:FindFirstChild("Label").Text = text
				
				local Toggle = Switch:FindFirstChild("Toggle")
				local Knob = Toggle:FindFirstChild("Knob")
				local Btn = Switch:FindFirstChild("Button")
				local toggled = default or false
				
				local function UpdateSwitch()
					if toggled then
						Tween(Knob, {Position = UDim2.new(1, -18, 0.5, -8)})
						Tween(Toggle, {BackgroundColor3 = ui_options.main_color})
						Tween(Knob, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
					else
						Tween(Knob, {Position = UDim2.new(0, 2, 0.5, -8)})
						Tween(Toggle, {BackgroundColor3 = Color3.fromRGB(60, 63, 68)})
						Tween(Knob, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
					end
				end
				
				UpdateSwitch()
				
				Btn.MouseButton1Click:Connect(function()
					toggled = not toggled
					UpdateSwitch()
					if callback then callback(toggled) end
				end)
				
				return Switch
			end
			
			function folder_data:AddTextBox(placeholder, callback)
				local TB = CreateTextBox()
				TB.Parent = FolderContent
				TB.PlaceholderText = placeholder or "Enter text..."
				
				TB.Focused:Connect(function()
					Tween(TB, {BackgroundColor3 = Color3.fromRGB(60, 63, 68)})
				end)
				
				TB.FocusLost:Connect(function(enter)
					Tween(TB, {BackgroundColor3 = ui_options.secondary_bg})
					if enter and callback then
						callback(TB.Text)
					end
				end)
				
				return TB
			end
			
			return folder_data
		end
		
		return tab_data
	end
	
	return window_data
end

-- Toggle visibility
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == ui_options.toggle_key then
		imgui.Enabled = not imgui.Enabled
	end
end)

-- Entrance animation
task.wait(0.1)
for _, window in ipairs(Windows:GetChildren()) do
	if window:IsA("Frame") then
		window.Size = UDim2.new(0, 0, 0, 0)
		Tween(window, {Size = UDim2.new(0, ui_options.min_size.X, 0, ui_options.min_size.Y)}, 0.5)
	end
end

return library
