--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MiniPerformanceUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 170)
main.Position = UDim2.fromScale(0.02, 0.35)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 14)

--// Rainbow Stroke
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = main

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "Performance Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(220,220,220)
title.TextXAlignment = Left
title.Parent = main

--// FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -20, 0, 24)
fpsLabel.Position = UDim2.fromOffset(10, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 13
fpsLabel.TextColor3 = Color3.fromRGB(200,200,200)
fpsLabel.TextXAlignment = Left
fpsLabel.Parent = main

--// Booster Button
local booster = Instance.new("TextButton")
booster.Size = UDim2.fromOffset(110, 26)
booster.Position = UDim2.fromOffset(10, 70)
booster.Text = "FPS BOOSTER"
booster.Font = Enum.Font.GothamBold
booster.TextSize = 12
booster.TextColor3 = Color3.fromRGB(255,255,255)
booster.BackgroundColor3 = Color3.fromRGB(45,45,45)
booster.BorderSizePixel = 0
booster.Parent = main
Instance.new("UICorner", booster).CornerRadius = UDim.new(0,8)

--// FOV Label
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -20, 0, 20)
fovLabel.Position = UDim2.fromOffset(10, 105)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70"
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 12
fovLabel.TextColor3 = Color3.fromRGB(200,200,200)
fovLabel.TextXAlignment = Left
fovLabel.Parent = main

--// Slider Bar
local bar = Instance.new("Frame")
bar.Size = UDim2.fromOffset(200, 6)
bar.Position = UDim2.fromOffset(10, 130)
bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
bar.BorderSizePixel = 0
bar.Parent = main
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(12, 12)
knob.Position = UDim2.fromOffset(0, -3)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
knob.BorderSizePixel = 0
knob.Parent = bar
Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

--// FPS Counter
local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		fpsLabel.Text = "FPS: "..frames
		frames = 0
		last = tick()
	end
end)

--// FPS Booster
local boosted = false
booster.MouseButton1Click:Connect(function()
	boosted = not boosted
	if boosted then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e9
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		booster.Text = "BOOSTED"
	else
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		booster.Text = "FPS BOOSTER"
	end
end)

--// FOV Slider
local dragging = false
knob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local x = math.clamp(
			(i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,1
		)
		knob.Position = UDim2.fromScale(x, -0.5)
		local fov = math.floor(60 + (180-60)*x)
		camera.FieldOfView = fov
		fovLabel.Text = "FOV: "..fov
	end
end)

--// Rainbow Stroke Animation
task.spawn(function()
	local hue = 0
	while true do
		hue = (hue + 0.002) % 1
		stroke.Color = Color3.fromHSV(hue, 1, 1)
		RunService.RenderStepped:Wait()
	end
end)
