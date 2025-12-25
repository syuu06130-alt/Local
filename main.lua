--[[
    Ultimate FPS & FOV Tool with Animated Rainbow Border
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

-- // UI作成 (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFPSGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // メインフレーム (背景)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 190) -- コンパクトなサイズ
MainFrame.Position = UDim2.new(0.05, 0, 0.6, 0) -- 初期位置
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- ダークテーマ
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 角丸設定
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- // ★虹色の光るボーダー (線に沿って動くアニメーション)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
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
    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1)) -- 0と同じ色に戻してループさせる
})
UIGradient.Parent = UIStroke

-- 虹色回転アニメーション
RunService.RenderStepped:Connect(function()
    UIGradient.Rotation = (UIGradient.Rotation + 2) % 360
end)

-- // タイトル
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SYSTEM CONTROL"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

-- // 1. FPS 表示機能
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 0, 20)
FPSLabel.Position = UDim2.new(0, 0, 0, 30)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: Waiting..."
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 128) -- 緑色
FPSLabel.Font = Enum.Font.Code
FPSLabel.TextSize = 16
FPSLabel.Parent = MainFrame

-- FPS計測ロジック
local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        local fps = frameCount
        FPSLabel.Text = "FPS: " .. fps
        frameCount = 0
        lastTime = currentTime
        
        -- FPSに応じて色を変える
        if fps >= 50 then
            FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        elseif fps >= 30 then
            FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        else
            FPSLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end)

-- // 2. FPSブースター (ボタン)
local BoostButton = Instance.new("TextButton")
BoostButton.Name = "BoostButton"
BoostButton.Size = UDim2.new(0.8, 0, 0, 35)
BoostButton.Position = UDim2.new(0.1, 0, 0.35, 0)
BoostButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
BoostButton.Text = "BOOST FPS"
BoostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostButton.Font = Enum.Font.GothamBold
BoostButton.TextSize = 14
BoostButton.AutoButtonColor = true
BoostButton.Parent = MainFrame

local BoostCorner = Instance.new("UICorner")
BoostCorner.CornerRadius = UDim.new(0, 6)
BoostCorner.Parent = BoostButton

local isBoosted = false

BoostButton.MouseButton1Click:Connect(function()
    if isBoosted then return end -- すでに実行済みなら何もしない
    isBoosted = true
    BoostButton.Text = "BOOSTED!"
    BoostButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    
    -- 軽量化処理 (テクスチャ削除・影削除・マテリアル簡易化)
    -- ※注: これはクライアント側のみの変更です
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
end)

-- // 3. FOV スライダー (60-180)
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0.6, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV: 70"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 12
SliderLabel.Parent = MainFrame

local SliderBg = Instance.new("Frame")
SliderBg.Name = "SliderBg"
SliderBg.Size = UDim2.new(0.8, 0, 0, 6)
SliderBg.Position = UDim2.new(0.1, 0, 0.75, 0)
SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = MainFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0, 0, 1, 0) -- 初期は0
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local TriggerBtn = Instance.new("TextButton") -- 操作用の透明ボタン
TriggerBtn.Size = UDim2.new(1, 0, 2, 0)
TriggerBtn.Position = UDim2.new(0, 0, -0.5, 0)
TriggerBtn.BackgroundTransparency = 1
TriggerBtn.Text = ""
TriggerBtn.Parent = SliderBg

-- スライダーの動作ロジック
local dragging = false
local minFov = 60
local maxFov = 180

local function updateSlider(input)
    local pos = input.Position.X
    local sliderX = SliderBg.AbsolutePosition.X
    local sliderWidth = SliderBg.AbsoluteSize.X
    
    -- マウス位置を0〜1に正規化
    local percent = math.clamp((pos - sliderX) / sliderWidth, 0, 1)
    
    -- FOV計算
    local newFov = minFov + (maxFov - minFov) * percent
    newFov = math.floor(newFov) -- 整数にする
    
    -- UI更新
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderLabel.Text = "FOV: " .. newFov
    
    -- カメラ更新
    TweenService:Create(Camera, TweenInfo.new(0.1), {FieldOfView = newFov}):Play()
end

TriggerBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

-- // UIをドラッグ可能にする機能
local draggingUI = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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
        update(input)
    end
end)

-- 起動時の初期FOV反映
SliderLabel.Text = "FOV: " .. math.floor(Camera.FieldOfView)
local initialPercent = math.clamp((Camera.FieldOfView - minFov) / (maxFov - minFov), 0, 1)
SliderFill.Size = UDim2.new(initialPercent, 0, 1, 0)
