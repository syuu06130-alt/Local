-- [[ Ultimate FPS & FOV Tool - Ultra Light Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- // UI作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFPSGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 190)
MainFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- 虹色アニメーションボーダー
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
    ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1))
})
UIGradient.Parent = UIStroke

RunService.RenderStepped:Connect(function()
    UIGradient.Rotation = (UIGradient.Rotation + 2) % 360
end)

-- タイトル & FPS表示（省略せずそのまま）

-- ...（FPS表示部分は変更なし、前のコードと同じでOK）

-- // FPSブースターボタン（2段階式）
local BoostButton = Instance.new("TextButton")
BoostButton.Size = UDim2.new(0.8, 0, 0, 35)
BoostButton.Position = UDim2.new(0.1, 0, 0.35, 0)
BoostButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
BoostButton.Text = "BOOST FPS (OFF)"
BoostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostButton.Font = Enum.Font.GothamBold
BoostButton.TextSize = 14
BoostButton.Parent = MainFrame

local BoostCorner = Instance.new("UICorner")
BoostCorner.CornerRadius = UDim.new(0, 6)
BoostCorner.Parent = BoostButton

local boostLevel = 0  -- 0: OFF, 1: Normal Boost, 2: Ultra Light (120~240狙い)

-- 超軽量ブースト関数
local function applyUltraLight()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
            v.Transparency = v.Name == "HumanoidRootPart" and v.Transparency or 0  -- 自分は見えるように
            if v:FindFirstChildOfClass("SurfaceAppearance") then v:FindFirstChildOfClass("SurfaceAppearance"):Destroy() end
            if v:FindFirstChildOfClass("MeshPart") then v.Size = v.Size end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("Light") then
            v.Enabled = false
        end
    end

    -- Lighting 完全殺し
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    Lighting.ClockTime = 12
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    -- 追加でサーバー負荷軽減（可能な範囲）
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

BoostButton.MouseButton1Click:Connect(function()
    boostLevel = (boostLevel + 1) % 3

    if boostLevel == 0 then
        BoostButton.Text = "BOOST FPS (OFF)"
        BoostButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        -- リセットはしない（一度軽くしたら戻せないゲームが多いため）
    elseif boostLevel == 1 then
        BoostButton.Text = "BOOSTED (Normal)"
        BoostButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)

        -- 通常ブースト（前のコード相当）
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

    elseif boostLevel == 2 then
        BoostButton.Text = "ULTRA LIGHT (120~240)"
        BoostButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        applyUltraLight()
    end
end)

-- // FOVスライダー（60〜180）は変更なし（前のコードそのまま）

-- // UIドラッグ機能も変更なし

-- 初期化もそのまま