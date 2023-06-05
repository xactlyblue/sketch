--!nonstrict
local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))
local Utils = require(script.Parent.Parent.Parent:WaitForChild("Utils"))
local Renderer = require(script.Parent.Parent:WaitForChild("Renderer"))

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

local CircleRenderer = {}
CircleRenderer.__index = CircleRenderer

setmetatable(CircleRenderer, Renderer)

function CircleRenderer.new(drawing: Drawing): Renderer
	error("The 'Circle' drawing type has not yet been implemented")
end

function CircleRenderer:render(drawing: Drawing): Instance
	error("The 'Circle' drawing type has not yet been implemented")
end

function CircleRenderer:cleanup()
	setmetatable(self, nil)
end

return CircleRenderer
