local library = script.Parent :: Instance
local Constants = require(library:WaitForChild("Constants"))
local Utils	= require(library:WaitForChild("Utils"))

type Array<T> = {[number]: T}


--#region Services
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
--#endregion

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

--#region Type Definitions

-- The status of the sketchbook
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"

-- A sketchbook that holds sketches, which can then be rendered in the world at runtime
export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus,

	registerDrawing: (Sketchbook, Drawing) -> (),
	removeDrawing: (Sketchbook, Drawing) -> (),

	getDrawings: (Sketchbook) -> Array<Drawing>,
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
	parameters: DrawingParameters,

	getSketchbook: (Drawing) -> Sketchbook,
	getRenderer: (Drawing) -> Renderer,
}
export type Renderer = {
	new: (DrawingType) -> Renderer,
	render: (Drawing) -> Instance
}

type Callback = () -> ()
type Connection = RBXScriptConnection | Instance | Callback
type Connections = { [number]: Connection }

--#endregion

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

		return self
	end

	function Renderer:render(drawing: Drawing): Instance
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
		return setmetatable(Renderer.new("Text", drawing), TextRenderer)
	end

	function TextRenderer:render(drawing: Drawing): Instance
		assert(drawing.type == "Text", "TextRenderer can only render Text drawings")

		local params: any = drawing.parameters.textParams

		local text: string = params.text
		local color: Color3 = params.color
		local font: Enum.Font = params.font
		local size: number = params.size
		
		local parent: Instance = workspace.CurrentCamera
		local billboardGui: BillboardGui = Utils.generateBillboardForText(text, parent)

		local textLabel: TextLabel = Instance.new("TextLabel")
		textLabel.Text = text
		textLabel.TextColor3 = color
		textLabel.Font = font
		textLabel.TextSize = size

		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		textLabel.Parent = billboardGui

		return textLabel
	end
	
	function TextRenderer:cleanup()
		setmetatable(self, nil)
	end

end

--[=[
	A drawing is essentially a container of information and types that can be used to render a "Drawing" in the world at runtime.

	@class Drawing
	@tag type
]=]
local Drawing
do
	Drawing = {}
	Drawing.__index = Drawing

	--#region Generate Drawing Parameters
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
	--#endregion

	local function createRenderer(drawing: Drawing): Renderer
		if drawing.type == "Line" then
			return LineRenderer.new(drawing, drawing:getSketchbook())
		elseif drawing.type == "Circle" then
			return CircleRenderer.new(drawing)
		elseif drawing.type == "Rectangle" then
		elseif drawing.type == "Triangle" then
		elseif drawing.type == "Text" then
		end
		
		error(("Drawing type %s is not supported."):format(drawing.type))
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

		self.renderer = createRenderer(self)

		self._connections = {} :: Connections

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

	function Drawing:getSketchbook(): Sketchbook
		return self.sketchbook
	end

	--#region Drawing Parameter Getters/Setters
	function Drawing:setLineThickness(thickness: number): Drawing
		assert(self.type == "Line", "Cannot set line thickness of non-line drawing")

		self.parameters.lineParams.thickness = thickness

		return self 
	end

	function Drawing:getLineThickness(): number
		assert(self.type == "Line", "Cannot get line thickness of non-line drawing")

		return self.parameters.lineParams.thickness
	end
	--#endregion

	function Drawing:cleanup()
		self:getSketchbook():removeDrawing(self)
		self:getRenderer():cleanup()

		for _, connection in pairs(self._connections) do
			connection:disconnect()
		end

		self._connections = nil

		setmetatable(self, nil)
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

		table.insert(sketchbookRegistry, self)

		return self
	end

	-- TODO!
	function Sketchbook:registerDrawing(drawing: Drawing): Drawing 
		assert(drawing, "Cannot register nil drawing.")

		local alreadyRegistered: boolean = false

		for _, entry: Drawing in ipairs(self._drawings) do
			if entry.uuid == drawing.uuid then
				alreadyRegistered = true
				break
			end
		end

		assert(not alreadyRegistered, "Cannot register drawing that is already registered.")

		table.insert(self._drawings, drawing)

		return drawing
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
function Sketch.drawText(sketchbook: Sketchbook, text: Computable<string>, position: Vector3?, color: Color3?): Drawing
	assert(isComputable(text, "string"), "Invalid argument #2, expected Computable<string>")

	local drawing = Drawing.new(sketchbook, "Text")

	sketchbook:registerDrawing(drawing)

	drawing:setText(text)
	drawing:setColor(color or Color3.new(1, 1, 1))

	if position ~= nil then
		drawing:setTextPosition(position)
	end

	return drawing 
end

--[=[
	Renders a sketchbook to the screen. Although not necessary, it is recommended that this function
	be called each frame instead of manually after each change to the sketchbook or its drawings.
	
	```lua
	local sketchbook = Sketch.createSketchbook()
	local drawing = Sketch.drawText(sketchbook, function()
		return "Hello, world!"
	end, Vector3.new(0, 5, 0), Color3.new(1, 1, 1))

	Sketch.render(sketchbook)
	```

	@param Sketchbook sketchbook The sketchbook to render.
	@return nil
]=]
function Sketch.render(sketchbook: Sketchbook): ()
	for _, drawing: Drawing in pairs(sketchbook:getDrawings()) do
		local renderer: Renderer = drawing:getRenderer()
	end
end

return Sketch
