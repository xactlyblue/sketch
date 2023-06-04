local library = script.Parent :: Instance
local Constants = require(library:WaitForChild("Constants"))
local Utils	= require(library:WaitForChild("Utils"))

type Array<T> = {[number]: T}


--#region Services
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
--#endregion

local globalIdCount: number = 0
local sketchbookRegistry: { Sketchbook } = {}

--[=[
	Generates a unique identifier.

	@return string
]=]
local function generateUUID(): string
	return (HttpService:GenerateGUID(false):gsub("-", ""):lower())
end

--[=[
	Creates a read-only table that acts as an enum.
]=]
local function createEnum<T>(values: { T }): Enum<T> 
	local enum: Enum<T> = {}

	for _, value: T in ipairs(values) do
		enum[tostring(value)] = value
	end

	return table.freeze(enum)
end

--[=[
	A computable value that runs the given function (if provided) to get the result.
]=]
type Computable<T> = T | (() -> T)

--[=[
	An enum value that can be used to specify specific enum values.
]=]
type Enum<T> = { [string]: T }

--[=[
	Get whether the given value is a computable value.
]=]
local function isComputable(value: unknown, expectedType: string): boolean
	return typeof(value) == expectedType 
		or typeof(value) == "function"
end

-- The status of the sketchbook
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"

-- A sketchbook that holds sketches, which can then be rendered in the world at runtime
export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus
}

-- A drawing that can be rendered in the world at runtime
export type DrawingType = "Line" | "Circle" | "Rectangle" | "Triangle" | "Text"
export type DrawingParameters = {
	lineParams: ({ 
		thickness: number,
		points: { 
			first: Vector3,
			second: Vector3
		}
	})?,

	circleParams: ({
		radius: number,
		filled: boolean,
		position: Vector3,
	})?,

	rectangleParams: ({
		size: { 
			width: number,
			height: number
		},

		filled: boolean,
		position: Vector3,
	})?,

	triangleParams: ({
		points: { 
			first: Vector3,
			second: Vector3,
			third: Vector3
		},

		filled: boolean,
		position: Vector3,
	})?,

	textParams: ({
		text: Computable<string>,
		size: number,
		font: Font?,
		position: Vector3,
	})?
}
export type Drawing = {
	uuid: string,
	sketchbook: Sketchbook,
	type: DrawingType,
	color: Color3,
	transparency: number?,
	parameters: DrawingParameters
}

type Callback = () -> ()
type Connection = RBXScriptConnection | Instance | Callback
type Connections = { [number]: Connection }

--[=[
	Cleans up the given connection (somewhat like Quenty's Maid class)

	@param Connection
]=]
local function cleanupConnection(connection: Connection): ()
	if typeof(connection) == "RBXScriptConnection" then
		connection:Disconnect()
	elseif typeof(connection) == "Instance" then
		connection:Destroy()
	elseif typeof(connection) == "function" then
		connection()
	end
end

--[=[
	An enum value to represent a sketchbook's status.

	@interface Status
	@tag enum
	@within Sketchbook
	.Alive "Alive" -- The sketchbook is alive and visible in the world.
	.Hidden "Hidden" -- The sketchbook is hidden and cannot be seen in the world.
	.Dead "Dead" -- The sketchbook is dead and can no longer be used.
]=]
local Status: Enum<SketchbookStatus> = createEnum<SketchbookStatus>({ "Alive", "Hidden", "Dead" })

--[=[
	A drawing is essentially a container of information and types that can be used to render a "Drawing" in the world at runtime.

	@class Drawing
	@tag type
]=]
local Drawing
do
	Drawing = {}
	Drawing.__index = Drawing


	--[=[
		Generates the default drawing parameters for a line.
	]=]
	local function generateLineParameters(): DrawingParameters
		return {
			lineParams = {
				thickness = 1,
				points = {
					first = Vector3.new(0, 0, 0),
					second = Vector3.new(0, 0, 0)
				}
			}
		}
	end

	--[=[
		Generates the default drawing parameters for a circle.
	]=]
	local function generateCircleParameters(): DrawingParameters
		return {
			circleParams = {
				radius = 1,
				filled = false,
				position = Vector3.new(0, 0, 0)
			}
		}
	end

	--[=[
		Generates the default drawing parameters for a rectangle.
	]=]
	local function generateRectangleParameters(): DrawingParameters
		return {
			rectangleParams = {
				size = {
					width = 1,
					height = 1
				},

				filled = false,
				position = Vector3.new(0, 0, 0)
			}
		}
	end

	--[=[
		Generates the default drawing parameters for a triangle.
	]=]
	local function generateTriangleParameters(): DrawingParameters
		return {
			triangleParams = {
				points = {
					first = Vector3.new(0, 0, 0),
					second = Vector3.new(0, 0, 0),
					third = Vector3.new(0, 0, 0)
				},

				filled = false,
				position = Vector3.new(0, 0, 0)
			}
		}
	end

	--[=[
		Generates the default drawing parameters for a text object.
	]=]
	local function generateTextParameters(): DrawingParameters
		return {
			textParams = {
				text = "Undefined", 
				position = Vector3.new(0, 0, 0),
				size = 1,
				font = Font.fromEnum(Enum.Font.SourceSans),
			}
		}
	end

	--[=[
		Creates a new drawing.

		@param string name The name of the drawing.
		@param string type The type of the drawing.
		@returns Drawing
	]=]
	function Drawing.new(sketchbook: Sketchbook, type: DrawingType): Drawing
		local self = setmetatable({}, Drawing)

		self.uuid = generateUUID()
		self.sketchbook = sketchbook

		self.type = type
		self.color = Color3.new(1, 1, 1)
		self.transparency = 0
		self.parameters = self:_generateParameters() 

		self._connections = {} :: Connections
		self._renderedHolder = nil :: Instance?

		return self
	end

	function Drawing:_generateParameters(): DrawingParameters
		local parameters: DrawingParameters

		if self.type == "Line" then
			parameters = generateLineParameters()
		elseif self.type == "Circle" then
			parameters = generateCircleParameters()
		elseif self.type == "Rectangle" then
			parameters = generateRectangleParameters()
		elseif self.type == "Triangle" then
			parameters = generateTriangleParameters()
		elseif self.type == "Text" then
			parameters = generateTextParameters()
		end

		return parameters
	end

	function Drawing:setLineThickness(thickness: number): Drawing
		assert(self.type == "Line", "Cannot set line thickness of non-line drawing.")

		self.parameters.lineParams.thickness = thickness

		return self 
	end

end

--[=[
	A sketchbook is essentially a container that can hold sketched objects (which will then be rendered to the world at runtime).
	Each sketchbook has a unique ID that can be used to identify it, and can be be modified when necessary.
	
	@class Sketchbook
]=]
local Sketchbook
do
	Sketchbook = {}
	Sketchbook.__index = Sketchbook

	function Sketchbook.new(): Sketchbook
		local self = setmetatable({}, Sketchbook)

		self.uuid = generateUUID()
		self.status = "Alive"

		self._connections = ({} :: Connections)
		self._drawings = ({} :: Array<Drawing>)

		return self
	end

	function Sketchbook:registerDrawing(drawing: Drawing): Connection
		assert(drawing, "Cannot register nil drawing.")

		return function() end
	end

	function Sketchbook:setHidden(hidden: boolean)
		self.status = (hidden and "Hidden" or "Alive")
	end

	function Sketchbook:cleanup()
		self.status = "Dead"
		
		for _, connection: Connection in ipairs(self._connections) do
			cleanupConnection(connection)
		end

		setmetatable(self, nil)
	end
end

--[=[
	A sketch is the API that is used to create and modify drawings. It is essentially a wrapper around a sketchbook that allows for
	creation of drawings and other sketchable objects.

	@class Sketch
]=]
local Sketch = {}

--[=[
	Creates a sketchbook that can then contain other sketchable objects.
	
	```lua
	local sketchbook: Sketch.Sketchbook = Sketch.createSketchbook()
	```

	@returns Sketchbook
]=]
function Sketch.createSketchbook(): Sketchbook
	return Sketchbook.new()
end

--[=[
	Creates a new sketched text object and registers it in the sketched text registry.
	This will then be drawn and updated every frame automatically.
	
	```lua
	Sketch.drawText({
		position = Vector3.new(0, 5, 0),
		text = "Hello, world!",
		color = Color3.new(1, 1, 1)
	}, sketchbook)
	```

	@param Sketchbook sketchbook The sketchbook to draw the text on.
	@param string | Computable text The text to draw.
	@param Vector3 position The position to draw the text at.
	@param Color3 color The color to draw the text in.
	@return Drawing 
]=]
function Sketch.drawText(sketchbook: Sketchbook, text: Computable<string>, position: Vector3, color: Color3): Drawing
	assert(isComputable(text, "string"), "Invalid argument #2, expected Computable<string>")
	
	local holder: Part = Utils.generateHolderPart()

	globalIdCount += 1

	local drawing = Drawing.new(sketchbook, "Text")

	sketchbook:registerDrawing(drawing)

	return drawing 
end

return Sketch
