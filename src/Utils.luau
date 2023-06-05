local Constants = require(script.Parent:WaitForChild("Constants"))
local Types = require(script.Parent:WaitForChild("Types"))

--#region Type Definitions
type Computable<T> = Types.Computable<T>
type Array<T> = Types.Array<T>

type Drawing = Types.Drawing
type DrawingParameters = Types.DrawingParameters

type TriangleDrawingParameters = Types.TriangleDrawingParameters
type RectangleDrawingParameters = Types.RectangleDrawingParameters
type CircleDrawingParameters = Types.CircleDrawingParameters
type LineDrawingParameters = Types.LineDrawingParameters
type TextDrawingParameters = Types.TextDrawingParameters
--#endregion

local Utils = {}

function Utils.isComputable(value: unknown, expectedType: string): boolean
	return typeof(value) == expectedType 
		or typeof(value) == "function"
end

function Utils.retrieveComputableValue<T>(computable: Computable<T>, expectedType: string?): T
	if expectedType ~= nil then
		assert(Utils.isComputable(computable, expectedType), "Expected computable to be a computable value")
	end

	if typeof(computable) == "function" then
		return computable()
	else
		return computable
	end
end

function Utils.generateDefaultTextParameters(): DrawingParameters
	local params: TextDrawingParameters = {
		text = "Undefined", 
		position = Vector3.new(0, 0, 0),
		size = 1,
		font = Font.fromEnum(Enum.Font.RobotoMono),
		color = Color3.fromRGB(255, 255, 255),
		alwaysOnTop = false,
	}

	return params
end

function Utils.generateDefaultLineParameters(): DrawingParameters
	local params: LineDrawingParameters = {
		thickness = 1,
		points = {
			first = Vector3.new(0, 0, 0),
			second = Vector3.new(0, 0, 0)
		},
		color = Color3.fromRGB(255, 255, 255),
	}

	return params
end

function Utils.generateDefaultCircleParameters(): DrawingParameters
	local params: CircleDrawingParameters = {
		radius = 1,
		position = Vector3.new(0, 0, 0),
		color = Color3.fromRGB(255, 255, 255),
		filled = false,
	}

	return params
end

function Utils.generateDefaultRectangleParameters(): DrawingParameters
	local params: RectangleDrawingParameters = {
		size = {
			width = 1,
			height = 1
		},

		filled = false,
		position = Vector3.new(0, 0, 0),
		color = Color3.fromRGB(255, 255, 255),
	}

	return params
end

function Utils.generateDefaultTriangleParameters(): DrawingParameters
	local params: TriangleDrawingParameters = {
		points = {
			first = Vector3.new(0, 0, 0),
			second = Vector3.new(0, 0, 0),
			third = Vector3.new(0, 0, 0)
		},

		filled = false,
		position = Vector3.new(0, 0, 0),
		color = Color3.fromRGB(255, 255, 255),
	}

	return params
end

function Utils.generateDefaultParameters(drawing: Drawing): DrawingParameters
	if drawing.type == "Line" then
		return Utils.generateDefaultLineParameters()
	elseif drawing.type == "Circle" then
		return Utils.generateDefaultCircleParameters()
	elseif drawing.type == "Rectangle" then
		return Utils.generateDefaultRectangleParameters()
	elseif drawing.type == "Triangle" then
		return Utils.generateDefaultTriangleParameters()
	elseif drawing.type == "Text" then
		return Utils.generateDefaultTextParameters()
	end

	error(("Invalid drawing type (%s)"):format(drawing.type))
end

return Utils
