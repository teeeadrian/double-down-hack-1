
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- 原神风 UI 主框架
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "GenshinCheatHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 230, 210)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 16)

-- 顶部栏
local TopBar = Instance.new("TextLabel", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(200, 180, 160)
TopBar.Text = "原神风秒赢外挂 Hub"
TopBar.TextColor3 = Color3.fromRGB(50, 30, 10)
TopBar.Font = Enum.Font.SourceSansBold
TopBar.TextSize = 20
TopBar.BorderSizePixel = 0

local HideButton = Instance.new("TextButton", TopBar)
HideButton.Size = UDim2.new(0, 36, 0, 36)
HideButton.Position = UDim2.new(1, -36, 0, 0)
HideButton.Text = "-"
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 24
HideButton.TextColor3 = Color3.fromRGB(80, 60, 40)
HideButton.BackgroundTransparency = 1

HideButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- 展示按钮
local ShowButton = Instance.new("TextButton", ScreenGui)
ShowButton.Size = UDim2.new(0, 80, 0, 30)
ShowButton.Position = UDim2.new(0, 20, 0.5, -15)
ShowButton.Text = "外挂"
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.TextSize = 20
ShowButton.BackgroundColor3 = Color3.fromRGB(200, 180, 160)
ShowButton.TextColor3 = Color3.fromRGB(50, 30, 10)
local ShowUICorner = Instance.new("UICorner", ShowButton)
ShowUICorner.CornerRadius = UDim.new(0, 12)

ShowButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
end)

-- 标签页栏
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 120, 1, -36)
TabFrame.Position = UDim2.new(0, 0, 0, 36)
TabFrame.BackgroundColor3 = Color3.fromRGB(220, 210, 190)
local TabLayout = Instance.new("UIListLayout", TabFrame)
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 内容页
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, -36)
ContentFrame.Position = UDim2.new(0, 120, 0, 36)
ContentFrame.BackgroundColor3 = Color3.fromRGB(250, 240, 225)

-- 工具函数
local function createTab(name)
	local button = Instance.new("TextButton", TabFrame)
	button.Size = UDim2.new(1, -12, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(240, 220, 200)
	button.Text = name
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.TextColor3 = Color3.fromRGB(60, 40, 20)
	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)
	return button
end

local function createButton(text, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.BackgroundColor3 = Color3.fromRGB(255, 245, 230)
	btn.TextColor3 = Color3.fromRGB(60, 40, 20)
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local pages = {}
local function showPage(page)
	for _, p in pairs(pages) do p.Visible = false end
	page.Visible = true
end

-- Obby 页面
local ObbyPage = Instance.new("Frame", ContentFrame)
ObbyPage.Size = UDim2.new(1,0,1,0)
ObbyPage.BackgroundTransparency = 1
pages[#pages+1] = ObbyPage

createTab("Obby").MouseButton1Click:Connect(function()
	showPage(ObbyPage)
end)

createButton("Obby 秒通关", ObbyPage, function()
	local obbyWin = ReplicatedStorage:FindFirstChild("WinObby")
	if obbyWin then obbyWin:FireServer() end
end)

-- Jump Rope 页面
local JumpPage = Instance.new("Frame", ContentFrame)
JumpPage.Size = UDim2.new(1,0,1,0)
JumpPage.BackgroundTransparency = 1
pages[#pages+1] = JumpPage

createTab("Jump Rope").MouseButton1Click:Connect(function()
	showPage(JumpPage)
end)

createButton("跳绳直接获胜", JumpPage, function()
	local evt = ReplicatedStorage:FindFirstChild("WinJump")
	if evt then evt:FireServer() end
end)

-- Rush Tic Tac Toe 页面
local RushTTTPage = Instance.new("Frame", ContentFrame)
RushTTTPage.Size = UDim2.new(1,0,1,0)
RushTTTPage.BackgroundTransparency = 1
pages[#pages+1] = RushTTTPage

createTab("Rush TTT").MouseButton1Click:Connect(function()
	showPage(RushTTTPage)
end)

createButton("Rush TTT 秒赢", RushTTTPage, function()
	local evt = ReplicatedStorage:FindFirstChild("WinRushTTTEvent")
	if evt then evt:FireServer() end
end)

-- 默认显示 Obby
showPage(ObbyPage)
