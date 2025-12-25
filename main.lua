--[[
    Ultimate FPS & UI Tool V3 (Grok Edition)
    Enhanced by Grok
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // 設定値
local SETTINGS = {
    RainbowSpeed = 3,
    TargetFPS = 60,
    SuperLowEnabled = false,
    Minimized = false
}

-- // ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrokFPSGui_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // メインフレーム
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local UIShadow = Instance.new("ImageLabel")
UIShadow.Size = UDim2.new(1, 20, 1, 20)
UIShadow.Position = UDim2.new(0, -10, 0, -10)
UIShadow.BackgroundTransparency = 1
UIShadow.Image = "rbxassetid://1316045217" -- Soft shadow
UIShadow.ImageTransparency = 0.6
UIShadow.ZIndex = 0
UIShadow.Parent = MainFrame

-- // 虹色ボーダー
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 5
UIStroke.Transparency = 0.2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
})
UIGradient.Rotation = 0
UIGradient.Parent = UIStroke

RunService.RenderStepped:Connect(function(dt)
    UIGradient.Rotation = (UIGradient.Rotation + SETTINGS.RainbowSpeed * dt * 50) % 360
end)

-- // 背景パーティクル風エフェクト（軽量）
local Particles = Instance.new("Frame")
Particles.Size = UDim2.new(1, 0, 1, 0)
Particles.BackgroundTransparency = 1
Particles.Parent = MainFrame

for i = 1, 8 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2,6), 0, math.random(20,60))
    p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.5, 1)
    p.BorderSizePixel = 0
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.Parent = Particles
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = p
    
    TweenService:Create(p, TweenInfo.new(math.random(10,20), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        Rotation = math.random(-30,30)
    }):Play()
end

-- // タイトルバー
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "GROK SYSTEM CONTROL"
TitleLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- // 閉じるボタン
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

-- // スクロールフレーム
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 680)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollFrame

-- // 共通スライダー関数（改良版）
local function createSlider(name, minVal, maxVal, defaultVal, suffix, callback)
    -- 省略（前のコードと同じだが、デザインを少し強化）
    -- ここは元のcreateSliderを流用しつつ、色をネオン風に変更してもOK
end

-- （以下、前のコードのコンテンツをほぼそのまま流用しつつ、追加機能を挿入）

-- FPS表示、ブーストボタン、スーパーローモード、FOV、Max FPS、Rainbow Spdはそのまま

-- 新機能：明るさスライダー
createSlider("Brightness", 0, 200, 100, "%", function(val)
    Lighting.Brightness = val / 50
end)

-- 新機能：彩度スライダー
createSlider("Saturation", -100, 100, 0, "", function(val)
    Lighting.ColorCorrection.Saturation = val / 100
end)

-- （createSlider関数は前のをそのまま使ってね！）

-- // UIドラッグ機能（改良）
-- （前のドラッグコードをそのまま使用）

-- ミニマイズ機能（タイトルバー長押しでミニマイズとかも可能だけど、今回はシンプルに）