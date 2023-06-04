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

local function retrieveComputableValue<T>(computable: Computable<T>): T
	if typeof(computable) == "function" then
		return computable()
	else
		return computable
	end
end

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
		Set the cached instance for the renderer.

		@within Renderer 
		@error "Abstract method not implemented" -- This method must be implemented by subclasses
		@param instance Instance? -- The instance to cache
	]=]
	function Renderer:setCachedInstance<T>(instance: T?)
		error("Abstract method not implemented")
	end

	--[=[
		Get the cached instance for the renderer.

		@within Renderer 
		@error "Abstract method not implemented" -- This method must be implemented by subclasses
		@return Instance? -- The cached instance
	]=]
	function Renderer:getCachedInstance<T>(): T?
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

	function TextRenderer.new(drawing: Drawing): Renderer
		local self = setmetatable( Renderer.new(drawing, "Text"), TextRenderer )

		return self
	end

	function TextRenderer:render(drawing: Drawing): Instance
		assert(drawing.type == "Text", "TextRenderer can only render Text drawings")

		local cachedInstance: BillboardGui? = self:getCachedInstance()

		if cachedInstance ~= nil then

		else
			local params: any = drawing.parameters.textParams

			local text: string = retrieveComputableValue(params.text)
			local color: Color3 = retrieveComputableValue(params.color)
			local font: Font = retrieveComputableValue(params.font)
			local size: number = retrieveComputableValue(params.size)

			local parent: Instance = workspace.CurrentCamera
			local billboardGui: BillboardGui = Utils.generateBillboardForText(text, parent)

			local textLabel: TextLabel = Instance.new("TextLabel")
			textLabel.Text = text
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.TextColor3 = color
			textLabel.FontFace = font
			textLabel.TextSize = size
			textLabel.BackgroundTransparency = 1
			textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			textLabel.Parent = billboardGui

			self:setCachedInstance(billboardGui)

			return billboardGui 
		end

		return self:getCachedInstance()
	end
	
	function TextRenderer:cleanup()
		setmetatable(self, nil)
	end
end
--#endregion

return {
	Renderer = Renderer,
	TextRenderer = TextRenderer,
}
