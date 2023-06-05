--!nonstrict
local Types = require(script.Parent:WaitForChild("Types"))
local Utils = require(script.Parent:WaitForChild("Utils"))

--#region Type Definitions
export type Computable<T> = Types.Computable<T>
export type Enum<T> = Types.Enum<T>
export type Array<T> = Types.Array<T>

export type Callback = Types.Callback
export type Connection = Types.Connection
export type Connections = Types.Connections

export type SketchbookStatus = Types.SketchbookStatus
export type Sketchbook = Types.Sketchbook

export type Drawing = Types.Drawing
export type DrawingType = Types.DrawingType
export type DrawingParameters = Types.DrawingParameters
export type Renderer = Types.Renderer
--#endregion

--#region Services
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
--#endregion

--[=[
	An internal renderer class responsible for creating visual representations of drawings in the World.
	There's no need to create instances of, or interact with, this class directly.

	@class Renderer
	@tag component
]=]
local Renderer
do
	Renderer = {}
	Renderer.__index = Renderer

	--[=[
		Create a new renderer instance for the given drawing.

		@within Renderer 
		@param drawing Drawing -- The drawing to render
		@param drawingType DrawingType -- The type of drawing to render
		@return Renderer -- The new renderer
	]=]
	function Renderer.new(drawing: Drawing, drawingType: DrawingType): Renderer
		local self = setmetatable({}, Renderer)

		self.drawing = drawing
		self.drawingType = drawingType

		self.cachedInstance = nil

		return self 
	end

	--[=[
		Render the drawing in the world.

		@within Renderer 
		@error "Abstract method not implemented" -- This method must be implemented by subclasses
		@param drawing Drawing -- The drawing to render
		@return Instance -- The rendered drawing
	]=]
	function Renderer:render(drawing: Drawing): Instance
		error("Abstract method not implemented")
	end

	--[=[
		Clean up the renderer.

		@within Renderer 
	]=]
	function Renderer:cleanup()
		warn("Abstract method not implemented")
		setmetatable(self, nil)
	end
end

--#region Implementations
local TextRenderer
do
	TextRenderer = {}
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

		local params: any = self.drawing.parameters.textParams

		local text: string = Utils.retrieveComputableValue(params.text, "string")
		local color: Color3 = Utils.retrieveComputableValue(params.color, "Color3")
		local font: Font = Utils.retrieveComputableValue(params.font, "Font")
		local size: number = Utils.retrieveComputableValue(params.size, "number")
		local position: Vector3 = Utils.retrieveComputableValue(params.position, "Vector3")
		local alwaysOnTop: boolean = Utils.retrieveComputableValue(params.alwaysOnTop, "boolean")

		local holder: Part, billboardGui: BillboardGui, textLabel: TextLabel = self._holder, self._billboardGui, self._textLabel

		if holder == nil or billboardGui == nil or textLabel == nil then
			if holder ~= nil then
				holder:Destroy()
			end

			holder, billboardGui, textLabel = generateInstancesForText(text)

			self._holder = holder
			self._billboardGui = billboardGui
			self._textLabel = textLabel
		end

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
end

local LineRenderer
do
	LineRenderer = {}
	LineRenderer.__index = LineRenderer

	setmetatable(LineRenderer, Renderer)

	function LineRenderer.new(drawing: Drawing): Renderer
		local self = setmetatable( Renderer.new(drawing, "Line"), LineRenderer )

		return self
	end

	function LineRenderer:render(drawing: Drawing): Instance
		error("Not implemented")
	end
	
	function LineRenderer:cleanup()
		setmetatable(self, nil)
	end
end

local CircleRenderer
do
	CircleRenderer = {}
	CircleRenderer.__index = CircleRenderer

	setmetatable(CircleRenderer, Renderer)

	function CircleRenderer.new(drawing: Drawing): Renderer
		local self = setmetatable( Renderer.new(drawing, "Circle"), CircleRenderer )

		return self
	end

	function CircleRenderer:render(drawing: Drawing): Instance
		error("Not implemented")
	end
	
	function CircleRenderer:cleanup()
		setmetatable(self, nil)
	end
end

local RectangleRenderer
do
	RectangleRenderer = {}
	RectangleRenderer.__index = RectangleRenderer

	setmetatable(RectangleRenderer, Renderer)

	function RectangleRenderer.new(drawing: Drawing): Renderer
		local self = setmetatable( Renderer.new(drawing, "Rectangle"), RectangleRenderer )

		return self
	end

	function RectangleRenderer:render(drawing: Drawing): Instance
		error("Not implemented")
	end
	
	function RectangleRenderer:cleanup()
		setmetatable(self, nil)
	end
end

local TriangleRenderer
do
	TriangleRenderer = {}
	TriangleRenderer.__index = TriangleRenderer

	setmetatable(TriangleRenderer, Renderer)

	function TriangleRenderer.new(drawing: Drawing): Renderer
		local self = setmetatable( Renderer.new(drawing, "Triangle"), TriangleRenderer )

		return self
	end

	function TriangleRenderer:render(drawing: Drawing): Instance
		error("Not implemented")
	end
	
	function TriangleRenderer:cleanup()
		setmetatable(self, nil)
	end
end
--#endregion

return {
	Renderer = Renderer,
	TextRenderer = TextRenderer,
	LineRenderer = LineRenderer,
	CircleRenderer = CircleRenderer,
	RectangleRenderer = RectangleRenderer,
	TriangleRenderer = TriangleRenderer
}
