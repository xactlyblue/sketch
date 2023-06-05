--!nonstrict
local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))
local Utils = require(script.Parent.Parent.Parent:WaitForChild("Utils"))
local Renderer = require(script.Parent.Parent:WaitForChild("Renderer"))

--#region Type Definitions
type Computable<T> = Types.Computable<T>
type Enum<T> = Types.Enum<T>

type DrawingParameters = Types.DrawingParameters
type DrawingType = Types.DrawingType
type Renderer = Types.Renderer
type Drawing = Types.Drawing
--#endregion

local TextRenderer = {}
TextRenderer.__index = TextRenderer

setmetatable(TextRenderer, Renderer)

local function generateInstancesForText(text): (Part, BillboardGui, TextLabel)
	local holder: Part = Instance.new("Part")
	holder.Name = "TextRenderer"
	holder.Anchored = true
	holder.CanCollide = false
	holder.Transparency = 1
	holder.Size = Vector3.new(0.2, 0.2, 0.2)
	holder.CFrame = CFrame.new(Vector3.new(0, 0, 0))
	holder.Parent = game.Workspace

	local billboard: BillboardGui = Instance.new("BillboardGui")
	billboard.Name = "Render"
	billboard.Size = UDim2.new(100, 0, 1, 0)
	billboard.LightInfluence = 0
	billboard.MaxDistance = 100
	billboard.Adornee = holder 
	billboard.Parent = holder

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Text = text
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.RobotoMono
	textLabel.TextTransparency = 0.1
	textLabel.RichText = true
	textLabel.TextScaled = true
	textLabel.TextStrokeTransparency = 1
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = billboard

	return holder, billboard, textLabel
end

function TextRenderer.new(drawing: Drawing): Renderer
	local self = setmetatable( Renderer.new(drawing, "Text"), TextRenderer )

	return self
end

function TextRenderer:render(): Instance
	assert(self.drawing.type == "Text", "TextRenderer can only render Text drawings")

	local params: any = self.drawing.parameters

	local text: string = Utils.retrieveComputableValue(params.text, "string")
	local color: Color3 = Utils.retrieveComputableValue(params.color, "Color3")
	local font: Font = Utils.retrieveComputableValue(params.font, "Font")
	local size: number = Utils.retrieveComputableValue(params.size, "number")
	local position: Vector3 = Utils.retrieveComputableValue(params.position, "Vector3")
	local alwaysOnTop: boolean = Utils.retrieveComputableValue(params.alwaysOnTop, "boolean")

	local holder: Part?, billboardGui: BillboardGui?, textLabel: TextLabel? = self._holder, self._billboardGui, self._textLabel

	if not holder then
		holder, billboardGui, textLabel = generateInstancesForText(text)

		self._holder = holder
		self._billboardGui = billboardGui
		self._textLabel = textLabel
	end

	assert(holder and billboardGui and textLabel, "Failed to generate instances for TextRenderer")

	textLabel.Text = text
	textLabel.TextColor3 = color
	textLabel.FontFace = font

	billboardGui.Size = UDim2.new(100, 0, size, 0)
	billboardGui.Adornee = holder
	billboardGui.AlwaysOnTop = alwaysOnTop

	holder.CFrame = CFrame.new(position)

	return holder
end

function TextRenderer:cleanup()
	self._holder:Destroy()
	self._billboardGui:Destroy()
	self._textLabel:Destroy()

	setmetatable(self, nil)
end

return TextRenderer
