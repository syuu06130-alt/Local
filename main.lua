--[[
    Ultimate FPS & UI Tool V2 (Scrollable)
    Created by Gemini
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // 設定値の初期化
local SETTINGS = {
    RainbowSpeed = 2, -- 初期スピード
    TargetFPS = 60,
    SuperLowEnabled = false
}

-- // UI作成 (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFPSGui_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // メインフレーム (外枠)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 320) -- 高さを少し拡張
MainFrame.Position = UDim2.new(0.05, 0, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false -- 光が枠外に出るように
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- // ★虹色の光るボーダー
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 4
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(0.20, Color3.fromHSV(0.2, 1, 1)),
    ColorSequenceKeypoint.new(0.40, Color3.fromHSV(0.4, 1, 1)),
    ColorSequenceKeypoint.new(0.60, Color3.fromHSV(0.6, 1, 1)),
    ColorSequenceKeypoint.new(0.80, Color3.fromHSV(0.8, 1, 1)),
    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1))
})
UIGradient.Parent = UIStroke

-- 虹色回転アニメーション (スピード可変)
RunService.RenderStepped:Connect(function()
    UIGradient.Rotation = (UIGradient.Rotation + SETTINGS.RainbowSpeed) % 360
end)

-- // タイトルバー
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SYSTEM CONTROL V2"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- // スクロールフレーム (コンテンツ用)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "Content"
ScrollFrame.Size = UDim2.new(1, -10, 1, -50) -- タイトル分を引く
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450) -- 中身の高さに合わせて調整
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ==========================================
-- 共通関数: スライダー作成
-- ==========================================
local function createSlider(name, minVal, maxVal, defaultVal, suffix, callback)
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "Frame"
    Frame.Size = UDim2.new(0.9, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScrollFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. defaultVal .. suffix
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 6)
    SliderBg.Position = UDim2.new(0, 0, 0.6, 0)
    SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Frame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Trigger = Instance.new("TextButton")
    Trigger.Size = UDim2.new(1, 0, 3, 0)
    Trigger.Position = UDim2.new(0, 0, -1, 0)
    Trigger.BackgroundTransparency = 1
    Trigger.Text = ""
    Trigger.Parent = SliderBg

    -- 初期値の反映
    local startPercent = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    Fill.Size = UDim2.new(startPercent, 0, 1, 0)

    local dragging = false
    
    local function update(input)
        local pos = input.Position.X
        local sliderX = SliderBg.AbsolutePosition.X
        local width = SliderBg.AbsoluteSize.X
        local percent = math.clamp((pos - sliderX) / width, 0, 1)
        
        local value = minVal + (maxVal - minVal) * percent
        value = math.floor(value)
        
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Label.Text = name .. ": " .. value .. suffix
        
        callback(value)
    end

    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- ==========================================
-- コンテンツ配置
-- ==========================================

-- 1. FPS 表示
local FPSContainer = Instance.new("Frame")
FPSContainer.Size = UDim2.new(0.9, 0, 0, 30)
FPSContainer.BackgroundTransparency = 1
FPSContainer.Parent = ScrollFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 1, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
FPSLabel.Font = Enum.Font.Code
FPSLabel.TextSize = 20
FPSLabel.Parent = FPSContainer

-- FPS計測
local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        local fps = frameCount
        FPSLabel.Text = "FPS: " .. fps
        frameCount = 0
        lastTime = currentTime
        
        if fps >= 50 then FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        elseif fps >= 30 then FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        else FPSLabel.TextColor3 = Color3.fromRGB(255, 50, 50) end
    end
end)

-- 2. 通常ブーストボタン
local BoostBtn = Instance.new("TextButton")
BoostBtn.Size = UDim2.new(0.9, 0, 0, 40)
BoostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
BoostBtn.Text = "BOOST FPS (Basic)"
BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostBtn.Font = Enum.Font.GothamBold
BoostBtn.TextSize = 14
BoostBtn.AutoButtonColor = true
BoostBtn.Parent = ScrollFrame

Instance.new("UICorner", BoostBtn).CornerRadius = UDim.new(0, 8)

local boosted = false
BoostBtn.MouseButton1Click:Connect(function()
    if boosted then return end
    boosted = true
    BoostBtn.Text = "BOOSTED!"
    BoostBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    
    -- 基本的な軽量化
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Texture") or v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end
end)

-- 3. スーパー軽量化トグル (Toggle)
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleFrame.Parent = ScrollFrame
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.Position = UDim2.new(0.05, 0, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Super Low Mode"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.GothamMedium
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
ToggleBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- OFF色
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.Parent = ToggleBtn
Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

ToggleBtn.MouseButton1Click:Connect(function()
    SETTINGS.SuperLowEnabled = not SETTINGS.SuperLowEnabled
    
    if SETTINGS.SuperLowEnabled then
        -- ON: アニメーションとさらなる軽量化
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        
        -- 超軽量化処理
        Lighting.FogStart = 0
        Lighting.FogEnd = 0 -- 遠くを真っ白/真っ黒にして描画を減らす試み(ゲームによる)
        -- 空などを消す
        if Lighting:FindFirstChildOfClass("Sky") then
            Lighting:FindFirstChildOfClass("Sky").Parent = nil 
        end
        -- 他のプレイヤーのエフェクト等を消す等は複雑になるため、ここでは簡易的にLighting操作
        
    else
        -- OFF
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        
        -- ※完全に元に戻すのは難しいが、Lighting設定をある程度戻す
        Lighting.FogEnd = 100000
    end
end)

-- 4. FOV スライダー (60 - 180)
createSlider("FOV", 60, 180, math.floor(Camera.FieldOfView), "", function(val)
    TweenService:Create(Camera, TweenInfo.new(0.1), {FieldOfView = val}):Play()
end)

-- 5. FPS Cap スライダー (30 - 240)
createSlider("Max FPS", 30, 240, 60, " FPS", function(val)
    -- setfpscap関数が存在するかチェック (Exploit環境向け)
    if setfpscap then
        setfpscap(val)
    else
        -- 通常のRoblox環境ではPrintするのみ
        -- (標準機能ではFPS上限変更APIは公開されていません)
        -- warn("FPS Cap is not supported in standard Roblox executor.")
    end
end)

-- 6. 虹色アニメーション速度 (0 - 20)
createSlider("Rainbow Spd", 0, 20, 2, "", function(val)
    SETTINGS.RainbowSpeed = val
end)


-- // UIドラッグ機能 (MainFrame全体)
local draggingUI, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingUI = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and draggingUI then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

