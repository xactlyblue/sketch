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

local RectangleRenderer = {}
RectangleRenderer.__index = RectangleRenderer

setmetatable(RectangleRenderer, Renderer)

function RectangleRenderer.new(drawing: Drawing): Renderer
	error("The 'Rectangle' drawing type has not yet been implemented")
end

function RectangleRenderer:render(drawing: Drawing): Instance
	error("The 'Rectangle' drawing type has not yet been implemented")
end

function RectangleRenderer:cleanup()
	setmetatable(self, nil)
end

return RectangleRenderer
