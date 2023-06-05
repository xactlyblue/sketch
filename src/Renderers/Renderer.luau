--!nonstrict
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Utils = require(script.Parent.Parent:WaitForChild("Utils"))

--#region Type Definitions
type Computable<T> = Types.Computable<T>
type Enum<T> = Types.Enum<T>
type Array<T> = Types.Array<T>

type Drawing = Types.Drawing
type DrawingParameters = Types.DrawingParameters
type DrawingType = Types.DrawingType

type Renderer = Types.Renderer
--#endregion

--[=[
	An internal renderer class responsible for creating visual representations of drawings in the World.
	There's no need to create instances of, or interact with, this class directly.

	@class Renderer
	@tag component
]=]
local Renderer = {}
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

return Renderer
