local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sketch = require(ReplicatedStorage:WaitForChild("Sketch"))

type Computable<T> = Sketch.Computable<T>
type Drawing = Sketch.Drawing

local sketchbook: Sketch.Sketchbook = Sketch.createSketchbook()

RunService:BindToRenderStep("Sketch", Enum.RenderPriority.First.Value, function()
	Sketch.render(sketchbook)
end)

local drawings: { [Model]: Drawing } = {}

local function characterAdded(character: Model)
	local humanoid: Instance? = character:WaitForChild("Humanoid", 10)

	assert(humanoid ~= nil and humanoid:IsA("Humanoid"))

	local rootPart: BasePart? = humanoid.RootPart

	assert(rootPart, "Humanoid must have a RootPart")

	local text: Computable<string> = function()
		return `({rootPart.Position.X}, {rootPart.Position.Y}, {rootPart.Position.Z})`
	end

	local position: Computable<Vector3> = function()
		return rootPart.Position + Vector3.new(0, 3, 0)
	end

	local drawing: Drawing = Sketch.drawText(sketchbook, text, position)
end

local function characterRemoving(character: Model)
	local drawing: Drawing? = drawings[character]

	if drawing then
		Sketch.removeDrawing(sketchbook, drawing)
	end
end

local function playerAdded(player: Player)
	if player.Character then
		characterAdded(player.Character)
	end

	player.CharacterAdded:Connect(characterAdded)
end

Players.PlayerAdded:Connect(playerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	playerAdded(player)
end
