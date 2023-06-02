local Constants = require(script:WaitForChild("Constants"))

type Array<T> = {[number]: T}

export type SketchedText = {
	id: number,
	options: SketchedTextOptions,
	holder: Instance?,
	billboard: BillboardGui?,
}

export type SketchedTextOptions = {
	position: Vector3,
	text: string,
	color: Color3?,
}

local Sketch = {}

--#region Services
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
--#endregion

local globalIdCount: number = 0
local sketchedTextRegistry: Array<SketchedText> = {}

local function generateBillboardForText(text: string, parent: Instance): BillboardGui
	local calculatedSize: Vector2 = TextService:GetTextSize(text, 
		Constants.SKETCHED_TEXT_SIZE,
		Constants.SKETCHED_TEXT_FONT, 
		Constants.SKETCHED_TEXT_CONTAINER_SIZE
	)

	local billboard: BillboardGui = Instance.new("BillboardGui")
	billboard.Name = "SketchedText"
	billboard.AlwaysOnTop = false
	billboard.LightInfluence = 0
	billboard.Size = UDim2.new(0, calculatedSize.X, 0, calculatedSize.Y)
	billboard.Enabled = true
	
	Debris:AddItem(billboard)

	return billboard
end

local function generateHolderPart(): Part
	local holder: Part = Instance.new("Part")
	holder.Name = "SketchedText"
	holder.Anchored = true
	holder.CanCollide = false
	holder.Transparency = 1
	
	CollectionService:AddTag(holder, Constants.SKETCHED_TAG)

	return holder
end

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
local function createEnum(values: { [string]: number })
	local enum: { [string]: unknown } = {}

	for key: string, value: number in pairs(values) do

	end

	return setmetatable(enum, {
		__index = function(self, key)

			error(string.format("%s is not a valid member of this enum", tostring(key)), 2)
		
			return rawget(self, key)
		end,

		__newindex = function(self, key, value)
			error(string.format("Attempt to modify read-only table"), 2)
		end,
	}) 
end

--[=[
	A computable value that runs the given function (if provided) to get the result.
]=]
type Computable<T> = T | (() -> T)

--[=[
	Get whether the given value is a computable value.
]=]
local function isComputable(value: unknown, expectedType: string): boolean
	return typeof(value) == expectedType 
		or typeof(value) == "function"
end

--[=[
	An enum value to represent a sketchboard's status.
	@interface Status
	@tag enum
	@within Sketchbook
	.Alive "Alive" -- The sketchboard is alive and visible in the world.
	.Hidden "Hidden" -- The sketchboard is hidden and cannot be seen in the world.
	.Dead "Dead" -- The sketchboard is dead and can no longer be used.
]=]
--[=[
	A sketchboard is essentially a container that can hold sketched objects (which will then be rendered to the world at runtime).
	Each sketchboard has a unique ID that can be used to identify it, and can be be modified when necessary.
	
	@class Sketchbook
]=]
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"
export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus
}

local Sketchbook
do
	Sketchbook = {}
	Sketchbook.__index = Sketchbook

	function Sketchbook.new(): Sketchbook
		local self = setmetatable({}, Sketchbook)

		self.uuid = generateUUID()
		self.status = "Alive"
		
		self.maid = Maid.new()

		return self
	end

	function Sketchbook:setHidden(hidden: boolean)
		self.status = (hidden and "Hidden" or "Alive")
	end

	function Sketchbook:cleanup()
		self.status = "Dead"
	end
end

--[=[
	Creates a sketchboard that can then contain other sketchable objects.
	
	```lua
	local sketchboard: Sketch.Sketchbook = Sketch.createSketchbook()
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
		color = Color3.new(1, 1, 1),
	}, sketchboard)
	```

	@param options SketchedTextOptions
	@return SketchedText
]=]
function Sketch.drawText(options: SketchedTextOptions): SketchedText
	local holder: Part = generateHolderPart()

	globalIdCount += 1

	local sketch: SketchedText = {
		id = globalIdCount,
		options = options,
		holder = holder,
		billboard = generateBillboardForText(options.text, holder),
	}

	table.insert(sketchedTextRegistry, sketch)

	return sketch
end

function Sketch.drawComputedText(options: SketchedTextOptions): SketchedText?
	return nil
end

return Sketch
