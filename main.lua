-- ButtonStatusScript.lua
local mainFrame = script.Parent.Parent
local buttonsFrame = mainFrame.ButtonsFrame
local statusFrame = mainFrame.StatusFrame
local statusDot = statusFrame.StatusDot
local statusLabel = statusFrame.StatusLabel

-- 初期設定
local buttonStates = {}

for _, btn in pairs(buttonsFrame:GetChildren()) do
	if btn:IsA("TextButton") then
		buttonStates[btn] = false -- OFF状態
		btn.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- 赤: OFF
	end
end

local function updateStatus(btn)
	if buttonStates[btn] then
		statusDot.BackgroundColor3 = Color3.fromRGB(60, 180, 120) -- 緑: ON
		statusLabel.Text = btn.Name .. ": ON"
	else
		statusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- 赤: OFF
		statusLabel.Text = btn.Name .. ": OFF"
	end
end

-- ボタン押下処理
for btn, _ in pairs(buttonStates) do
	btn.MouseButton1Click:Connect(function()
		-- 状態反転
		buttonStates[btn] = not buttonStates[btn]

		-- ボタン色変更
		if buttonStates[btn] then
			btn.BackgroundColor3 = Color3.fromRGB(60, 180, 120) -- 緑
		else
			btn.BackgroundColor3 = Color3.fromRGB(180, 60, 60) -- 赤
		end

		-- Status表示更新
		updateStatus(btn)
	end)
end
