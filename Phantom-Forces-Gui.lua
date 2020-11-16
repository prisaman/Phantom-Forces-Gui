--[[
made by prisaman

]]

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local PhantomForcesgui = Instance.new("TextLabel")
local esp = Instance.new("TextButton")
local close = Instance.new("TextButton")
local owlhub = Instance.new("TextButton")
local InfiniteYield = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.216262996, 0, 0.399665564, 0)
Frame.Size = UDim2.new(0, 408, 0, 261)
Frame.Active = true
Frame.draggable = true

PhantomForcesgui.Name = "Phantom Forces gui"
PhantomForcesgui.Parent = Frame
PhantomForcesgui.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
PhantomForcesgui.Size = UDim2.new(0, 408, 0, 50)
PhantomForcesgui.Font = Enum.Font.SourceSans
PhantomForcesgui.Text = "Phantom Forces gui"
PhantomForcesgui.TextColor3 = Color3.fromRGB(0, 0, 0)
PhantomForcesgui.TextSize = 14.000

esp.Name = "esp"
esp.Parent = Frame
esp.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
esp.Position = UDim2.new(0.0171568636, 0, 0.249042138, 0)
esp.Size = UDim2.new(0, 178, 0, 49)
esp.Font = Enum.Font.SourceSans
esp.Text = "esp"
esp.TextColor3 = Color3.fromRGB(0, 0, 0)
esp.TextSize = 14.000
esp.MouseButton1Down:connect(function()
	local Camera = game:GetService("Workspace").CurrentCamera
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local FontValue = 3
	local Visibility = true

	local function CycleFont()
		if FontValue + 1 > 3 then
			FontValue = 1
		else
			FontValue = FontValue + 1
		end
	end

	local function ModelTemplate()
		local Objects = {
			Box = Drawing.new("Quad"),
			Name = Drawing.new("Text"),
		} 

		return Objects
	end

	local function GetPartCorners(Part)
		local Size = Part.Size * Vector3.new(1, 1.5)
		return {
			TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
			BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
			TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
			BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
		}
	end

	local function ApplyModel(Model)
		local Objects = ModelTemplate()
		local CurrentParent = Model.Parent

		spawn(function()
			Objects.Name.Center = true
			Objects.Name.Visible = true
			Objects.Name.Outline = true
			Objects.Name.Transparency = 1
			Objects.Box.Visible = true
			Objects.Box.Transparency = 1

			while Model.Parent == CurrentParent do
				local Vector, OnScreen = Camera:WorldToScreenPoint(Model.Head.Position)
				local Distance = (Camera.CFrame.Position - Model.HumanoidRootPart.Position).Magnitude

				if OnScreen and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and Visibility then
					Objects.Name.Position = Vector2.new(Vector.X, Vector.Y + math.clamp(Distance / 10, 10, 30) - 10)
					Objects.Name.Size = math.clamp(30 - Distance / 10, 10, 30)
					Objects.Name.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
					Objects.Name.Visible = true
					Objects.Name.Font = FontValue
					Objects.Name.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
				else
					Objects.Name.Visible = false 
				end

				Objects.Name.Text = string.format("[%s sd] [%s] Enemy", tostring(math.floor(Distance)), Model:FindFirstChildOfClass("Model") and Model:FindFirstChildOfClass("Model").Name or "NONE")

				local PartCorners = GetPartCorners(Model.HumanoidRootPart)
				local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
				local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
				local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
				local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)

				if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and Visibility then
					Objects.Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
					Objects.Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
					Objects.Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
					Objects.Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
					Objects.Box.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
					Objects.Box.Thickness = math.clamp(3 - (Distance / 100), 0, 3)
					Objects.Box.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
					Objects.Box.Visible = true
				else
					Objects.Box.Visible = false
				end

				RunService.RenderStepped:Wait()
			end

			Objects.Name:Remove()
			Objects.Box:Remove()
		end)
	end

	for _, Player in next, game:GetService("Workspace").Players.Phantoms:GetChildren() do
		ApplyModel(Player)
	end

	for _, Player in next, game:GetService("Workspace").Players.Ghosts:GetChildren() do
		ApplyModel(Player)
	end

	game:GetService("Workspace").Players.Phantoms.ChildAdded:Connect(function(Player)
		delay(0.5, function()
			ApplyModel(Player)
		end)
	end)

	game:GetService("Workspace").Players.Ghosts.ChildAdded:Connect(function(Player)
		delay(0.5, function()
			ApplyModel(Player)
		end)
	end)

	UserInputService.InputBegan:Connect(function(Input, GP)
		if not GP and Input.KeyCode == Enum.KeyCode.Five then
			Visibility = not Visibility
		end 

		if not GP and Input.KeyCode == Enum.KeyCode.Four then
			CycleFont()
		end
	end)
end)

close.Name = "close"
close.Parent = Frame
close.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
close.BorderColor3 = Color3.fromRGB(255, 0, 255)
close.Position = UDim2.new(0.824795723, 0, 0.0114942528, 0)
close.Size = UDim2.new(0, 65, 0, 44)
close.Font = Enum.Font.PermanentMarker
close.Text = "X"
close.TextColor3 = Color3.fromRGB(170, 0, 0)
close.TextScaled = true
close.TextSize = 14.000
close.TextStrokeColor3 = Color3.fromRGB(170, 0, 0)
close.TextWrapped = true
close.MouseButton1Down:connect(function()
	Frame.Visible = false
end)

owlhub.Name = "owl hub"
owlhub.Parent = Frame
owlhub.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
owlhub.Position = UDim2.new(0.487745106, 0, 0.249042138, 0)
owlhub.Size = UDim2.new(0, 196, 0, 49)
owlhub.Font = Enum.Font.SourceSans
owlhub.Text = "owl hub"
owlhub.TextColor3 = Color3.fromRGB(0, 0, 0)
owlhub.TextSize = 14.000
owlhub.MouseButton1Down:connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
end)


InfiniteYield.Name = "InfiniteYield"
InfiniteYield.Parent = Frame
InfiniteYield.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
InfiniteYield.Position = UDim2.new(0.477941185, 0, 0.555555582, 0)
InfiniteYield.Size = UDim2.new(0, 200, 0, 50)
InfiniteYield.Font = Enum.Font.SourceSans
InfiniteYield.Text = "InfiniteYield"
InfiniteYield.TextColor3 = Color3.fromRGB(0, 0, 0)
InfiniteYield.TextSize = 14.000
InfiniteYield.MouseButton1Down:connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/prisaman/InfiniteYield/main/InfiniteYield.lua'))()
end)
