--!nonstrict
local Types = require(script:FindFirstAncestor("Sketch"):WaitForChild("Types"))
local Utils = require(script:FindFirstAncestor("Sketch"):WaitForChild("Utils"))

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


--#region Implementations
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
