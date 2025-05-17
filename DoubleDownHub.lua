-- Roblox Double Down 秒赢外挂 Hub
-- 整合所有小游戏秒赢脚本，附带UI控制
-- 备注：执行前请确认执行器支持 loadstring 和 game:HttpGet

local LocalPlayer = game:GetService("Players").LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "DoubleDownHubGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 460, 0, 400)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 130, 1, -20)
TabFrame.Position = UDim2.new(0, 10, 0, 10)
TabFrame.BackgroundColor3 = Color3.fromRGB(26, 27, 38)
Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 10)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -160, 1, -20)
ContentFrame.Position = UDim2.new(0, 150, 0, 10)
ContentFrame.BackgroundColor3 = Color3.fromRGB(26, 27, 38)
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 10)

-- UI按钮样式
local function createButton(parent, text, y)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Garamond
    btn.Text = text
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createToggle(parent, text, y)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, y)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 48, 60)
    toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggle.Font = Enum.Font.Garamond
    toggle.Text = "关闭：" .. text
    toggle.AutoButtonColor = false
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
    toggle:SetAttribute("Enabled", false)
    return toggle
end

-- 功能配置
local games = {
    {
        name = "Obby",
        funcs = {"自动传送", "跳过平台"},
        run = function()
            spawn(function()
                while true do
                    if _G["Obby_自动传送"] or _G["Obby_跳过平台"] then
                        local obby = workspace:FindFirstChild("ObbyCourse")
                        if obby and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            if _G["Obby_自动传送"] then
                                local finish = obby:FindFirstChild("Finish")
                                if finish then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = finish.CFrame + Vector3.new(0,5,0)
                                end
                            elseif _G["Obby_跳过平台"] then
                                for _, part in pairs(obby:GetChildren()) do
                                    if part:IsA("BasePart") and part.Name:find("Platform") then
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,5,0)
                                        wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                    wait(1)
                end
            end)
        end
    },
    {
        name = "Jump Rope",
        funcs = {"自动跳绳"},
        run = function()
            spawn(function()
                while true do
                    if _G["Jump Rope_自动跳绳"] then
                        local event = game:GetService("ReplicatedStorage"):FindFirstChild("JumpRopeEvent")
                        if event then
                            event:FireServer()
                        end
                    end
                    wait(0.3)
                end
            end)
        end
    },
    {
        name = "Price is Right",
        funcs = {"自动出价"},
        run = function()
            spawn(function()
                while true do
                    if _G["Price is Right_自动出价"] then
                        local event = game:GetService("ReplicatedStorage"):FindFirstChild("PriceBidEvent")
                        if event then
                            event:FireServer(9999)
                        end
                    end
                    wait(1)
                end
            end)
        end
    },
}

-- UI制作及交互
local currentTab = nil
local toggles = {}

local function clearContent()
    for _, child in pairs(ContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local function createToggles(game)
    clearContent()
    toggles = {}
    for i, fname in ipairs(game.funcs) do
        local toggle = createToggle(ContentFrame, fname, (i - 1) * 40 + 10)
        toggle.MouseButton1Click:Connect(function()
            local key = game.name .. "_" .. fname
            local enabled = toggle:GetAttribute("Enabled")
            if enabled then
                _G[key] = false
                toggle.Text = "关闭：" .. fname
                toggle:SetAttribute("Enabled", false)
            else
                _G[key] = true
                toggle.Text = "开启：" .. fname
                toggle:SetAttribute("Enabled", true)
            end
        end)
        toggles[#toggles+1] = toggle
    end
end

local function createTabs()
    for i, game in ipairs(games) do
        local btn = createButton(TabFrame, game.name, (i-1)*40 + 10)
        btn.MouseButton1Click:Connect(function()
            currentTab = game
            createToggles(game)
        end)
        -- 自动启动各功能线程
        if game.run then
            game.run()
        end
    end
end

createTabs()
-- 默认打开第一个标签页
if #games > 0 then
    currentTab = games[1]
    createToggles(currentTab)
end

-- 可拖动UI
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
