-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "PerfUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 180)
main.Position = UDim2.fromScale(0.03, 0.35)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Stroke
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "Performance UI"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(230,230,230)
title.TextXAlignment = Left

-- FPS
local fpsLabel = Instance.new("TextLabel", main)
fpsLabel.Size = UDim2.new(1, -20, 0, 24)
fpsLabel.Position = UDim2.fromOffset(10, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 13
fpsLabel.TextColor3 = Color3.fromRGB(200,200,200)
fpsLabel.TextXAlignment = Left

-- Booster
local booster = Instance.new("TextButton", main)
booster.Size = UDim2.fromOffset(120, 28)
booster.Position = UDim2.fromOffset(10, 70)
booster.Text = "FPS BOOST"
booster.Font = Enum.Font.GothamBold
booster.TextSize = 12
booster.TextColor3 = Color3.fromRGB(255,255,255)
booster.BackgroundColor3 = Color3.fromRGB(40,40,40)
booster.BorderSizePixel = 0
Instance.new("UICorner", booster).CornerRadius = UDim.new(0,10)

-- FOV
local fovLabel = Instance.new("TextLabel", main)
fovLabel.Size = UDim2.new(1, -20, 0, 20)
fovLabel.Position = UDim2.fromOffset(10, 110)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70"
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 12
fovLabel.TextColor3 = Color3.fromRGB(200,200,200)
fovLabel.TextXAlignment = Left

-- Slider
local bar = Instance.new("Frame", main)
bar.Size = UDim2.fromOffset(220, 6)
bar.Position = UDim2.fromOffset(10, 135)
bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", bar)
knob.Size = UDim2.fromOffset(14, 14)
knob.Position = UDim2.fromScale(0.1, -0.5)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
knob.BorderSizePixel = 0
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

-- FPS counter
local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fpsLabel.Text = "FPS: "..frames
		frames = 0
		last = tick()
	end
end)

-- Booster logic
local boosted = false
booster.MouseButton1Click:Connect(function()
	boosted = not boosted
	if boosted then
		Lighting.GlobalShadows = false
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		booster.Text = "BOOST ON"
	else
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		booster.Text = "FPS BOOST"
	end
end)

-- Slider (PC + Mobile)
local dragging = false

local function update(input)
	local x = math.clamp(
		(input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
		0,1
	)
	knob.Position = UDim2.fromScale(x, -0.5)
	local fov = math.floor(60 + (180-60)*x)
	camera.FieldOfView = fov
	fovLabel.Text = "FOV: "..fov
end

knob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1
	or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging then
		if i.UserInputType == Enum.UserInputType.MouseMovement
		or i.UserInputType == Enum.UserInputType.Touch then
			update(i)
		end
	end
end)

-- Rainbow border
task.spawn(function()
	local h = 0
	while true do
		h = (h + 0.004) % 1
		stroke.Color = Color3.fromHSV(h,1,1)
		RunService.RenderStepped:Wait()
	end
end)
