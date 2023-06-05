--[=[
	The collection of internal types used by the Sketch library.
	You can directly access and use these in your own code as they are exported by the library on require/load.

	@class Types
	@tag definitions
]=]

--[=[
	A computable value that can be assigned either a static unchanging value (of T type), or a function that returns a value of T type.
	When the value is a function, it is called every time the value is needed and is accessed (pretty much exclusively when you call the Sketch.render(...) function on the sketchbook.

	:::warning
	This type is not exported by the library, and is only used internally.
	:::

	@private
	@type Computable<T> T | (() -> T)
	@within Types
]=]
export type Computable<T> = T | (() -> T)

--[=[ 
	:::warning
	This type is not exported by the library, and is only used internally.
	:::

	@private
	@type Enum<T> { [string]: T } 
	@within Types
]=]
export type Enum<T> = { [string]: T }

--[=[
	The current status of the sketchbook, with 
	* **Alive** - default state, indicates sketchbook is currently rendered on the screen
	* **Hidden** - sketchbook is not rendered on the screen, but still exists in memory
	* **Dead** - sketchbook is not rendered on the screen, and has been removed from memory

	@type SketchbookStatus "Alive" | "Hidden" | "Dead"
	@within Types
]=]
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"
--

--[=[
	@type DrawingType "Line" | "Circle" | "Rectangle" | "Triangle" | "Text"
	@within Types
]=]
export type DrawingType = "Line" | "Circle" | "Rectangle" | "Triangle" | "Text"

export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus,

	registerDrawing: (Sketchbook, Drawing) -> (),
	unregisterDrawing: (Sketchbook, Drawing) -> (),

	getDrawings: (Sketchbook) -> Array<Drawing>,
}

--#region Drawing Parameters
export type LineDrawingParameters = {
	thickness: Computable<number>,
	points: { 
		first: Computable<Vector3>,
		second: Computable<Vector3>
	},
	color: Computable<Color3>,
}
export type CircleDrawingParameters = {
	radius: Computable<number>,
	filled: Computable<boolean>,
	position: Computable<Vector3>,
	color: Computable<Color3>,
}
export type RectangleDrawingParameters = {
	size: { 
		width: Computable<number>,
		height: Computable<number>
	},

	filled: Computable<boolean>,
	position: Computable<Vector3>,
	color: Computable<Color3>,
}
export type TriangleDrawingParameters = {
	points: {
		first: Computable<Vector3>,
		second: Computable<Vector3>,
		third: Computable<Vector3>,
	},

	filled: Computable<boolean>,
	position: Computable<Vector3>,
	color: Computable<Color3>,
}
export type TextDrawingParameters = {
	text: Computable<string>,
	size: Computable<number>,
	font: Computable<Font?>,
	position: Computable<Vector3>,
	color: Computable<Color3>,
	alwaysOnTop: Computable<boolean>,
}
export type DrawingParameters = LineDrawingParameters | CircleDrawingParameters | RectangleDrawingParameters | TriangleDrawingParameters | TextDrawingParameters
--#endregion

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

--[=[
	@type Array<T> { [number]: T }
	@within Types
]=]
export type Array<T> = {[number]: T}

--[=[
	@type Callback () -> ()
	@within Types
]=]
export type Callback = () -> ()

--[=[ 
	@type Connection RBXScriptConnection | Instance | Callback 
	@within Types
]=]
export type Connection = RBXScriptConnection | Instance | Callback

--[=[
	@type Connections Array<Connection>
	@within Types
]=]
export type Connections = Array<Connection>

return {}
