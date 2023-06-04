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

--[=[
	Retrieve the value of a computable value.
]=]
local function retrieveComputableValue<T>(computable: Computable<T>): T
	if typeof(computable) == "function" then
		return computable()
	else
		return computable
	end
end

--[=[
	A renderer is a class that can be used to render a drawing in the world.

	@class Renderer
]=]
local Renderer
do
	Renderer = {}
	Renderer.__index = Renderer

	function Renderer.new(drawing: Drawing, drawingType: DrawingType): Renderer
		local self = setmetatable({}, Renderer)

		self.drawing = drawing
		self.drawingType = drawingType

		self.cachedInstance = nil

		return self 
	end

	function Renderer:render(drawing: Drawing): Instance
		error("Abstract method not implemented")
	end

	function Renderer:setCachedInstance<T>(instance: T?)
		error("Abstract method not implemented")
	end

	function Renderer:getCachedInstance<T>(): T?
		error("Abstract method not implemented")
	end

	function Renderer:cleanup()
		warn("Abstract method not implemented")
		setmetatable(self, nil)
	end
end

--[=[
	A renderer that uses the built-in Drawing API to render a text drawing in the world.

	@extends Renderer
	@class TextRenderer
]=]
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

return {
	Renderer = Renderer,
	TextRenderer = TextRenderer,
}
