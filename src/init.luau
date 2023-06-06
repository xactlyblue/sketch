--!nonstrict
local Types = require(script:WaitForChild("Types"))
local Constants = require(script:WaitForChild("Constants"))
local Utils = require(script:WaitForChild("Utils"))

local Renderers = script:WaitForChild("Renderers")
local TextRenderer = require(Renderers.Implements.TextRenderer)
local LineRenderer = require(Renderers.Implements.LineRenderer)
local CircleRenderer = require(Renderers.Implements.CircleRenderer)
local RectangleRenderer = require(Renderers.Implements.RectangleRenderer)
local TriangleRenderer = require(Renderers.Implements.TriangleRenderer)

--#region Services
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
--#endregion

--#region Type Definitions
type Enum<T> = Types.Enum<T>
type Array<T> = Types.Array<T>

export type Computable<T> = Types.Computable<T>

export type Callback = Types.Callback
export type Connection = Types.Connection
export type Connections = Types.Connections

export type SketchbookStatus = Types.SketchbookStatus
export type Sketchbook = Types.Sketchbook

export type Drawing = Types.Drawing
export type DrawingType = Types.DrawingType
export type DrawingParameters = Types.DrawingParameters

export type TriangleDrawingParameters = Types.TriangleDrawingParameters
export type RectangleDrawingParameters = Types.RectangleDrawingParameters
export type CircleDrawingParameters = Types.CircleDrawingParameters
export type LineDrawingParameters = Types.LineDrawingParameters
export type TextDrawingParameters = Types.TextDrawingParameters

export type Renderer = Types.Renderer
--#endregion

local sketchbookRegistry: { Sketchbook } = {}

local function generateUUID(): string
	return (HttpService:GenerateGUID(false):gsub("-", ""):lower())
end

local function createEnum<T>(values: Array<T>): Enum<T> 
	local enum: Enum<T> = {}

	for _, value: T in ipairs(values) do
		enum[tostring(value)] = value
	end

	return table.freeze(enum)
end

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
	A drawing is, as you might expect, a representation of data that will be drawn to the screen in each call of the render function.
	Each drawing is attached to a sketchbook, which is a collection of drawings that are all rendered together; it also acts as a container for
	different types of drawings, helping to keep your code nice and organized.
	
	```lua
	local sketchbook = Sketch.createSketchbook() -- Create a new sketchbook to hold our drawings
	local drawing = Sketch.drawText(sketchbook, "Hello, world!") -- Create a new drawing to draw some text
	```

	@class Drawing
	@tag component 
]=]
local Drawing
do
	Drawing = {}
	Drawing.__index = Drawing

	local function createRenderer(drawing: Drawing): Renderer
		if drawing.type == "Line" then
			return LineRenderer.new(drawing)
		elseif drawing.type == "Circle" then
			return CircleRenderer.new(drawing)
		elseif drawing.type == "Rectangle" then
			return RectangleRenderer.new(drawing)
		elseif drawing.type == "Triangle" then
			return TriangleRenderer.new(drawing)
		elseif drawing.type == "Text" then
			return TextRenderer.new(drawing)
		end
		
		error(("Drawing type %s is not supported"):format(drawing.type))
	end

	--[=[
		Creates a new drawing.

		@param sketchbook Sketchbook -- The sketchbook to create the drawing in
		@param type DrawingType -- The type of the drawing
		@within Drawing
		@return Drawing
	]=]
	function Drawing.new(sketchbook: Sketchbook, type: DrawingType): Drawing
		local self = setmetatable({}, Drawing)

		self.uuid = generateUUID()
		self.sketchbook = sketchbook
		self.type = type

		self.parameters = Utils.generateDefaultParameters(self)
		self.renderer = createRenderer(self)

		self._connections = ({} :: Connections?)

		return self
	end

	--[=[
		Get the sketchbook the drawing is in.

		@within Drawing
		@return Sketchbook
	]=]
	function Drawing:getSketchbook(): Sketchbook
		return self.sketchbook
	end

	--[=[
		Get the renderer designated for the drawing.

		@private
		@within Drawing
		@return Renderer
	]=]
	function Drawing:getRenderer(): Renderer
		return self.renderer
	end

	--[=[
		Get the drawing's parameters.

		@private
		@within Drawing
		@return DrawingParameters
	]=]
	function Drawing:getParameters(): DrawingParameters
		return self.parameters
	end

	--[=[
		Get the drawing's text.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<string>
	]=]
	function Drawing:getText(): string
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		local parameter: Computable<string> = self:getParameter("text")

		return Utils.retrieveComputableValue(parameter)
	end

	--[=[
		Set the drawing's text.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param text Computable<string> -- The text to set
		@return Drawing -- The drawing object
	]=]
	function Drawing:setText(text: Computable<string>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.text = text

		return self
	end

	--[=[
		Get the drawing's text size.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<number>
	]=]
	function Drawing:getTextSize()
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		return self.parameters.size
	end

	--[=[
		Set the drawing's text size.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param size Computable<number>
		@return Drawing -- The drawing object
	]=]
	function Drawing:setTextSize(size: Computable<number>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.size = size

		return self
	end

	--[=[
		Get the drawing's text position.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<Vector3>
	]=]
	function Drawing:getTextPosition()
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		return self.parameters.position
	end

	--[=[
		Set the drawing's text position.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param position Computable<Vector3>
		@return Drawing -- The drawing object
	]=]
	function Drawing:setTextPosition(position: Computable<Vector3>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.position = position

		return self
	end

	--[=[
		Get the drawing's text font.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<Font>
	]=]
	function Drawing:getTextFont()
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		return self.parameters.font
	end

	--[=[
		Set the drawing's text font.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param font Computable<Font>
		@return Drawing -- The drawing object
	]=]
	function Drawing:setTextFont(font: Computable<Font>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.font = font

		return self
	end

	--[=[
		Get the drawing's text color.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<Color3>
	]=]
	function Drawing:getTextColor()
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		return self.parameters.color
	end

	--[=[
		Set the drawing's text color.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param color Computable<Color3>
		@return Drawing -- The drawing object
	]=]
	function Drawing:setTextColor(color: Computable<Color3>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.color = color

		return self
	end

	--[=[
		Get the drawing's text transparency.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@return Computable<number>
	]=]
	function Drawing:getTextTransparency()
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		return self.parameters.transparency
	end

	--[=[
		Set the drawing's text transparency.

		:::warning
		This function only supports the `Text` drawing type - other drawing types will immediately error.
		:::

		:::caution
		It is **highly recommended** you use computable functions as opposed directly interfacing with the drawing.
		Since this function is designed to be used internally, the behavior (although unlikely) may change in the future.
		:::

		@private
		@within Drawing
		@param transparency Computable<number> -- The transparency to set
		@return Drawing -- The drawing object
	]=]
	function Drawing:setTextTransparency(transparency: Computable<Color3>): Drawing
		assert(self.type == "Text", "Cannot set property from drawing type '" .. self.type .. "' -- Only accepts \"Text\" drawing type")
		
		self.parameters.transparency = transparency

		return self
	end

	--#endregion

	--[=[
		Cleans up the drawing, removing it from the sketchbook, cleaning up the renderer, and disconnecting all events.

		@within Drawing
	]=]
	function Drawing:cleanup()
		self:getSketchbook():unregisterDrawing(self)
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
	@tag component
]=]
local Sketchbook
do
	Sketchbook = {}
	Sketchbook.__index = Sketchbook

	--[=[
		Creates a new sketchbook.

		@within Sketchbook
		@return Sketchbook
	]=]
	function Sketchbook.new(): Sketchbook
		local self = setmetatable({}, Sketchbook)

		self.uuid = generateUUID()
		self.status = "Alive"

		self._connections = ({} :: Connections)
		self._drawings = ({} :: Array<Drawing>)

		table.insert(sketchbookRegistry, self)

		return self
	end

	--[=[
		Gets whether the sketchbook has the provided drawing registered within itself.

		@within Sketchbook
		@param drawing Drawing - The drawing to check for
		@return boolean
	]=]
	function Sketchbook:isDrawingRegistered(drawing: Drawing): boolean
		for _, entry: Drawing in ipairs(self._drawings) do
			if entry.uuid == drawing.uuid then
				return true
			end
		end

		return false
	end

	--[=[
		Registers a drawing to the sketchbook. This will also register the drawing's renderer and connect all events.

		@private
		@error "Cannot register drawing that is already registered" -- The drawing is already registered to the sketchbook
		@param drawing Drawing -- The drawing to register
		@within Sketchbook
		@return Drawing -- The drawing that was registered
	]=]
	function Sketchbook:registerDrawing(drawing: Drawing): Drawing 
		assert(drawing, "Cannot register nil drawing")
		assert(not self:isDrawingRegistered(drawing), "Cannot register drawing that is already registered")

		table.insert(self._drawings, drawing)

		return drawing
	end

	--[=[
		Unregisters a drawing from the sketchbook. This will also unregister the drawing's renderer and disconnect all events.

		@private
		@param drawing Drawing -- The drawing to unregister
		@within Sketchbook
	]=]
	function Sketchbook:unregisterDrawing(drawing: Drawing)
		assert(drawing, "Cannot unregister nil drawing")

		local index: number = 0

		for i, entry: Drawing in ipairs(self._drawings) do
			if entry.uuid == drawing.uuid then
				index = i
				break
			end
		end

		assert(index ~= 0, "Cannot unregister drawing that is not registered")

		table.remove(self._drawings, index)
	end

	--[=[
		Gets all drawings registered to the sketchbook.

		@within Sketchbook
		@return Array<Drawing>
	]=]
	function Sketchbook:getDrawings(): Array<Drawing>
		return self._drawings
	end

	--[=[
		Sets the state of the sketchbook to be hidden or not.

		@error "Cannot set status of dead sketchbook" -- The sketchbook is dead
		@param hidden boolean -- Whether the sketchbook should be hidden or not
		@within Sketchbook
	]=]
	function Sketchbook:setHidden(hidden: boolean)
		assert(self.status ~= "Dead", "Cannot set status of dead sketchbook")

		self.status = (hidden and "Hidden" or "Alive")
	end

	--[=[
		Gets the status of the sketchbook.

		@within Sketchbook
		@return SketchbookStatus -- The status of the sketchbook
	]=]
	function Sketchbook:getStatus(): SketchbookStatus 
		return self.status
	end

	--[=[
		Cleans up the sketchbook, removing all drawings and connections.

		@within Sketchbook
	]=]
	function Sketchbook:cleanup()
		self.status = "Dead"
		
		for _, drawing: Drawing in ipairs(self._drawings) do
			drawing:cleanup()
		end

		for _, connection: Connection in ipairs(self._connections) do
			cleanupConnection(connection)
		end

		setmetatable(self, nil)
	end
end

--[=[
	An enum value to represent a sketchbook's status.

	@interface Status
	@tag enum
	@within Sketch
	.Alive "Alive" -- The sketchbook is alive and visible in the world
	.Hidden "Hidden" -- The sketchbook is hidden and cannot be seen in the world
	.Dead "Dead" -- The sketchbook is dead and can no longer be used
]=]
--[=[
	This is the API that used to create and modify drawings. It's essentially a wrapper that allows for
	easy creation of drawings and sketchbooks to hold said drawings.

	```lua
	local Sketch = require("?")

	local sketchbook: Sketch.Sketchbook = Sketch.createSketchbook()
	local drawing: Sketch.Drawing = Sketch.drawText(sketchbook, "Hello, world!")

	Sketch.render(sketchbook)

	-- 🎉 Tada, you've created and rendered a drawing! 
	-- Also, although not necessary, it's **highly** recommended you call the Sketch.render(...) function each frame as opposed to manually after you make changes)
	```

	@class Sketch
]=]
local Sketch = {
	Status = ({
		Alive = "Alive",
		Hidden = "Hidden",
		Dead = "Dead",
	} :: {
		[string]: DrawingType 
	})
}

--[=[
	Creates a sketchbook that can then contain other sketchable objects.
	
	```lua
	local sketchbook: Sketch.Sketchbook = Sketch.createSketchbook()
	```

	@return Sketchbook
]=]
function Sketch.createSketchbook(): Sketchbook
	return Sketchbook.new()
end

--[=[
	Creates a new text drawing and registers it in the provided sketchbook.

	```lua
	-- Create computables for the position, text, and color;
	-- Computables can either be a static value or a function that will be called every render call
	local position: Computable<Vector3> = Vector3.new(0, 0, 0)
	local text: Computable<string> = function()
		return "Hello, world!"
	end
	local color: Computable<Color3> = Color3.new(1, 1, 1)

	-- Create a new sketchbook and drawing
	local sketchbook: Sketchbook = Sketch.createSketchbook()
	local drawing: Drawing = Sketch.drawText(sketchbook, text, position, color)

	-- Render the sketchbook (and, in turn, all of its drawings) to the screen
	Sketch.render(sketchbook)
	```

	@param sketchbook Sketchbook -- The sketchbook to draw the text on
	@param text Computable<string> -- The text to draw
	@param position Computable<Vector3>? -- The position to draw the text at
	@param size Computable<number>? -- The size of the text
	@param color Computable<Color3>? -- The color to draw the text in
	@param font Computable<Font>? -- The font to draw the text with
	@param transparency Computable<number>? -- The transparency to draw the text with
	@within Sketch
	@return Drawing 
]=]
function Sketch.drawText(sketchbook: Sketchbook, 
						text: Computable<string>, 
						position: Computable<Vector3>?, 
						size: Computable<number>?,
						color: Computable<Color3>?, 
						font: Computable<Font>?,
						transparency: Computable<number>?): Drawing

	assert(Utils.isComputable(text, "string"), "Invalid argument #2, expected Computable<string>")

	local drawing = Drawing.new(sketchbook, "Text")
	drawing:setText(text)

	if position ~= nil then
		drawing:setTextPosition(position)
	end

	if size ~= nil then
		drawing:setTextSize(size)
	end

	if color ~= nil then
		drawing:setTextColor(color)
	end
	
	if font ~= nil then
		drawing:setTextFont(font)
	end

	if transparency ~= nil then
		drawing:setTextTransparency(transparency)
	end

	sketchbook:registerDrawing(drawing)

	return drawing 
end


--[=[
	Creates a new line drawing and registers it in the provided sketchbook.

	```lua
	-- Create computables for the initial point XYZ, secondary point XYZ, color, and thickness;
	-- Computables can either be a static value or a function that will be called every render call
	local point1: Computable<Vector3> = function()
		return Vector3.new(0, math.sin(tick()), 0)
	end
	local point2: Computable<Vector3> = Vector3.new(1, math.cos(tick()), 0)
	local color: Computable<Color3> = Color3.new(1, 1, 1)
	local thickness: Computable<number> = 1

	-- Create a new sketchbook and drawing
	local sketchbook: Sketchbook = Sketch.createSketchbook()
	local drawing: Drawing = Sketch.drawLine(sketchbook, text, point1, point2, color, thickness)

	-- Render the sketchbook (and, in turn, all of its drawings) to the screen
	Sketch.render(sketchbook)
	```

	:::warning
	This feature has not yet been implemented, as the `Line` drawing type is not yet supported.
	:::

	@param sketchbook Sketchbook -- The sketchbook to draw the text on
	@param point1 Computable<Vector3> -- The first point to draw the line between
	@param point2 Computable<Vector3> -- The second point to draw the line between
	@param color Computable<Color3> -- The color to draw the line in
	@param thickness Computable<number> -- The thickness of the line
	@unreleased
	@within Sketch
]=]
function Sketch.drawLine(sketchbook: Sketchbook, point1: Computable<Vector3>, point2: Computable<Vector3>, color: Computable<Color3>, thickness: Computable<number>): Drawing
	error("Not implemented")
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

	@param sketchbook Sketchbook -- The sketchbook to render
	@return nil
]=]
function Sketch.render(sketchbook: Sketchbook): ()
	for _, drawing: Drawing in ipairs(sketchbook:getDrawings()) do
		local renderer: any = drawing:getRenderer()

		if renderer ~= nil then
			renderer:render()
		else
			warn(`No renderer found for drawing ({ drawing.uuid }, { drawing.type })`)
		end
	end
end

--[=[
	Removes a drawing from a sketchbook. This function should be called when you are done with a drawing and no longer
	want it to be rendered or used.

	@param sketchbook Sketchbook -- The sketchbook to remove the drawing from
	@param drawing Drawing -- The drawing to remove
	@return nil
]=]
function Sketch.removeDrawing(sketchbook: Sketchbook, drawing: Drawing): ()
	assert(sketchbook ~= nil, "Sketchbook cannot be nil")
	assert(drawing ~= nil, "Drawing cannot be nil")
	assert(sketchbook:isDrawingRegistered(drawing), "Drawing is not in sketchbook")

	drawing:cleanup()
end

return Sketch
