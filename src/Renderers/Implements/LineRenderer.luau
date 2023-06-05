--!nonstrict
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Utils = require(script.Parent.Parent:WaitForChild("Utils"))
local Renderer = require(script.Parent:WaitForChild("Renderer"))

--#region Type Definitions
type Computable<T> = Types.Computable<T>
type Enum<T> = Types.Enum<T>

type DrawingParameters = Types.DrawingParameters
type DrawingType = Types.DrawingType
type Renderer = Types.Renderer
type Drawing = Types.Drawing
--#endregion

local LineRenderer = {}
LineRenderer.__index = LineRenderer

setmetatable(LineRenderer, Renderer)

function LineRenderer.new(drawing: Drawing): Renderer
	error("The 'Line' drawing type has not yet been implemented")
end

function LineRenderer:render(drawing: Drawing): Instance
	error("The 'Line' drawing type has not yet been implemented")
end

function LineRenderer:cleanup()
	setmetatable(self, nil)
end

return LineRenderer
