-- ==========================================
-- 追加: 上部設定バー (開閉/カラー/テーマ)
-- ==========================================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TopBar.Parent = MainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 8)
UICornerTop.Parent = TopBar

-- UI 開閉ボタン
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0.7, 0)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ToggleBtn.Text = "閉じる"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamMedium
ToggleBtn.TextSize = 12
ToggleBtn.Parent = TopBar
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

-- カラーテーマ変更
local ColorThemeBtn = Instance.new("TextButton")
ColorThemeBtn.Size = UDim2.new(0, 100, 0.7, 0)
ColorThemeBtn.Position = UDim2.new(0.3, 0, 0.15, 0)
ColorThemeBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
ColorThemeBtn.Text = "テーマ変更"
ColorThemeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorThemeBtn.Font = Enum.Font.GothamMedium
ColorThemeBtn.TextSize = 12
ColorThemeBtn.Parent = TopBar
Instance.new("UICorner", ColorThemeBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- 追加: カラーテーマシステム
-- ==========================================
local THEMES = {
    {
        name = "デフォルト",
        main = Color3.fromRGB(20, 20, 25),
        accent = Color3.fromRGB(80, 160, 255),
        text = Color3.fromRGB(220, 220, 220)
    },
    {
        name = "ダーク",
        main = Color3.fromRGB(10, 10, 15),
        accent = Color3.fromRGB(120, 80, 200),
        text = Color3.fromRGB(200, 200, 200)
    },
    {
        name = "グリーン",
        main = Color3.fromRGB(15, 25, 20),
        accent = Color3.fromRGB(0, 200, 100),
        text = Color3.fromRGB(220, 240, 220)
    },
    {
        name = "レッド",
        main = Color3.fromRGB(25, 15, 15),
        accent = Color3.fromRGB(255, 80, 80),
        text = Color3.fromRGB(240, 220, 220)
    }
}

local currentTheme = 1

ColorThemeBtn.MouseButton1Click:Connect(function()
    currentTheme = currentTheme % #THEMES + 1
    local theme = THEMES[currentTheme]
    
    -- メインフレーム色変更
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        BackgroundColor3 = theme.main
    }):Play()
    
    -- スライダー色変更
    for _, frame in pairs(ScrollFrame:GetChildren()) do
        if frame:IsA("Frame") then
            local fill = frame:FindFirstChild("SliderBg")
            if fill then
                local fillInner = fill:FindFirstChild("Fill")
                if fillInner then
                    TweenService:Create(fillInner, TweenInfo.new(0.3), {
                        BackgroundColor3 = theme.accent
                    }):Play()
                end
            end
        end
    end
    
    ColorThemeBtn.Text = THEMES[currentTheme].name
end)

-- ==========================================
-- 追加: UI開閉アニメーション
-- ==========================================
local isUIVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    if isUIVisible then
        -- 閉じる
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 60, 0, 30)
        }):Play()
        
        -- 内容を非表示
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TopBar then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    Transparency = 1
                }):Play()
            end
        end
        
        ToggleBtn.Text = "開く"
        isUIVisible = false
    else
        -- 開く
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 240, 0, 320)
        }):Play()
        
        -- 内容を表示
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TopBar then
                TweenService:Create(child, TweenInfo.new(0.2), {
                    Transparency = 0
                }):Play()
            end
        end
        
        ToggleBtn.Text = "閉じる"
        isUIVisible = true
    end
end)

-- ==========================================
-- 追加: キーバインド (右Ctrlで表示/非表示)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ==========================================
-- 追加: ピン留め機能
-- ==========================================
local PinBtn = Instance.new("TextButton")
PinBtn.Size = UDim2.new(0, 30, 0.7, 0)
PinBtn.Position = UDim2.new(0.8, 0, 0.15, 0)
PinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
PinBtn.Text = "📌"
PinBtn.TextSize = 16
PinBtn.Parent = TopBar
Instance.new("UICorner", PinBtn).CornerRadius = UDim.new(0, 6)

local isPinned = false
PinBtn.MouseButton1Click:Connect(function()
    isPinned = not isPinned
    if isPinned then
        PinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        MainFrame.Active = false
        MainFrame.Selectable = false
    else
        PinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        MainFrame.Active = true
        MainFrame.Selectable = true
    end
end)

-- ==========================================
-- 追加: 視覚効果設定
-- ==========================================
local EffectsFrame = Instance.new("Frame")
EffectsFrame.Size = UDim2.new(0.9, 0, 0, 100)
EffectsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
EffectsFrame.Parent = ScrollFrame
Instance.new("UICorner", EffectsFrame).CornerRadius = UDim.new(0, 8)

local EffectsLabel = Instance.new("TextLabel")
EffectsLabel.Size = UDim2.new(1, 0, 0, 30)
EffectsLabel.BackgroundTransparency = 1
EffectsLabel.Text = "視覚効果"
EffectsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EffectsLabel.Font = Enum.Font.GothamBold
EffectsLabel.TextSize = 14
EffectsLabel.Parent = EffectsFrame

-- ブルーム効果トグル
local BloomToggle = Instance.new("TextButton")
BloomToggle.Size = UDim2.new(0.9, 0, 0, 25)
BloomToggle.Position = UDim2.new(0.05, 0, 0.4, 0)
BloomToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BloomToggle.Text = "ブルーム効果: OFF"
BloomToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
BloomToggle.Font = Enum.Font.GothamMedium
BloomToggle.TextSize = 12
BloomToggle.Parent = EffectsFrame
Instance.new("UICorner", BloomToggle).CornerRadius = UDim.new(0, 6)

local bloomEnabled = false
BloomToggle.MouseButton1Click:Connect(function()
    bloomEnabled = not bloomEnabled
    if bloomEnabled then
        BloomToggle.Text = "ブルーム効果: ON"
        BloomToggle.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        -- ブルーム効果の実装（ゲームによって異なる）
        warn("ブルーム効果を有効にしました（ゲーム依存）")
    else
        BloomToggle.Text = "ブルーム効果: OFF"
        BloomToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end)

-- モーションブラートグル
local MotionBlurToggle = Instance.new("TextButton")
MotionBlurToggle.Size = UDim2.new(0.9, 0, 0, 25)
MotionBlurToggle.Position = UDim2.new(0.05, 0, 0.7, 0)
MotionBlurToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MotionBlurToggle.Text = "モーションブラー: OFF"
MotionBlurToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
MotionBlurToggle.Font = Enum.Font.GothamMedium
MotionBlurToggle.TextSize = 12
MotionBlurToggle.Parent = EffectsFrame
Instance.new("UICorner", MotionBlurToggle).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- 追加: リセットボタン
-- ==========================================
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.9, 0, 0, 40)
ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ResetBtn.Text = "設定をリセット"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 14
ResetBtn.Parent = ScrollFrame
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 8)

ResetBtn.MouseButton1Click:Connect(function()
    -- 設定をデフォルトに戻す
    SETTINGS.RainbowSpeed = 2
    SETTINGS.TargetFPS = 60
    SETTINGS.SuperLowEnabled = false
    
    -- FOVをデフォルトに
    TweenService:Create(Camera, TweenInfo.new(0.3), {FieldOfView = 70}):Play()
    
    -- Lightingを元に戻す
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
    
    -- トグルをOFFに
    if SETTINGS.SuperLowEnabled then
        ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    
    -- スライダーをリセット（必要に応じて実装）
    warn("設定をリセットしました")
end)

-- ==========================================
-- 追加: ツールチップ機能
-- ==========================================
local ToolTip = Instance.new("Frame")
ToolTip.Size = UDim2.new(0, 200, 0, 60)
ToolTip.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToolTip.BorderSizePixel = 0
ToolTip.Visible = false
ToolTip.ZIndex = 10
ToolTip.Parent = ScreenGui

Instance.new("UICorner", ToolTip).CornerRadius = UDim.new(0, 8)

local ToolTipLabel = Instance.new("TextLabel")
ToolTipLabel.Size = UDim2.new(1, -10, 1, -10)
ToolTipLabel.Position = UDim2.new(0, 5, 0, 5)
ToolTipLabel.BackgroundTransparency = 1
ToolTipLabel.Text = "説明テキスト"
ToolTipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolTipLabel.Font = Enum.Font.GothamMedium
ToolTipLabel.TextSize = 12
ToolTipLabel.TextWrapped = true
ToolTipLabel.Parent = ToolTip

-- ツールチップ表示関数
local function showToolTip(text, position)
    ToolTipLabel.Text = text
    ToolTip.Position = UDim2.new(0, position.X, 0, position.Y)
    ToolTip.Visible = true
end

local function hideToolTip()
    ToolTip.Visible = false
end

-- ボタンにツールチップを追加（例）
BoostBtn.MouseEnter:Connect(function()
    showToolTip("基本的なFPSブーストを適用します\n（影の削除、テクスチャの簡略化）", 
        Vector2.new(Mouse.X + 20, Mouse.Y + 20))
end)

BoostBtn.MouseLeave:Connect(hideToolTip)

-- ==========================================
-- 追加: 設定保存機能（簡易版）
-- ==========================================
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.9, 0, 0, 30)
SaveBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
SaveBtn.Text = "設定を保存"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.TextSize = 12
SaveBtn.Parent = ScrollFrame
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 6)

SaveBtn.MouseButton1Click:Connect(function()
    -- ここに設定保存のロジックを追加
    -- （例: DataStoreServiceやファイルへの保存）
    warn("設定を保存しました（実装が必要）")
end)

-- ==========================================
-- 追加: 透明度スライダー
-- ==========================================
createSlider("UI透明度", 0.1, 1, 1, "", function(val)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {
        BackgroundTransparency = 1 - val
    }):Play()
end)

-- ScrollFrameのCanvasSizeを調整（追加した分だけ大きくする）
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 650)