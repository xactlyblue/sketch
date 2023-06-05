--[=[
	A computable value that can be assigned either a static unchanging value (of T type), or a function that returns a value of T type.
	When the value is a function, it is called every time the value is needed and is accessed (pretty much exclusively when you call the Sketch.render(...) function on the sketchbook.

	@type Computable<T> T | (() -> T)
	@within Sketch
]=]
export type Computable<T> = T | (() -> T)

-- @type Enum<T> { [string]: T }
export type Enum<T> = { [string]: T }

--[=[
	The current status of the sketchbook, with 
	* **Alive** - default state, indicates sketchbook is currently rendered on the screen
	* **Hidden** - sketchbook is not rendered on the screen, but still exists in memory
	* **Dead** - sketchbook is not rendered on the screen, and has been removed from memory

	@type SketchbookStatus "Alive" | "Hidden" | "Dead"
	@within Sketch
]=]
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"

--[=[
	@type DrawingType "Line" | "Circle" | "Rectangle" | "Triangle" | "Text" 
	@within Sketch
]=]
export type DrawingType = "Line" | "Circle" | "Rectangle" | "Triangle" | "Text"

export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus,

	registerDrawing: (Sketchbook, Drawing) -> (),
	unregisterDrawing: (Sketchbook, Drawing) -> (),

	getDrawings: (Sketchbook) -> Array<Drawing>,
}

export type DrawingParameters = {
	lineParams: ({ 
		thickness: Computable<number>,
		points: { 
			first: Computable<Vector3>,
			second: Computable<Vector3>
		},
		color: Computable<Color3>,
	})?,

	circleParams: ({
		radius: Computable<number>,
		filled: Computable<boolean>,
		position: Computable<Vector3>,
		color: Computable<Color3>,
	})?,

	rectangleParams: ({
		size: { 
			width: Computable<number>,
			height: Computable<number>
		},

		filled: Computable<boolean>,
		position: Computable<Vector3>,
		color: Computable<Color3>,
	})?,

	triangleParams: ({
		points: {
			first: Computable<Vector3>,
			second: Computable<Vector3>,
			third: Computable<Vector3>,
		},

		filled: Computable<boolean>,
		position: Computable<Vector3>,
		color: Computable<Color3>,
	})?,

	textParams: ({
		text: Computable<string>,
		size: Computable<number>,
		font: Computable<Font?>,
		position: Computable<Vector3>,
		color: Computable<Color3>,
		alwaysOnTop: Computable<boolean>,
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
	cleanup: (Drawing) -> (),
}


export type Renderer = {
	new: (Drawing, DrawingType) -> Renderer,
	render: (Drawing) -> Instance,
}

-- @type Array<T> { [number]: T }
export type Array<T> = {[number]: T}
-- @type Callback () -> ()
export type Callback = () -> ()
-- @type Connection RBXScriptConnection | Instance | Callback 
export type Connection = RBXScriptConnection | Instance | Callback
-- @type Connections Array<Connection>
export type Connections = Array<Connection>

return {}
