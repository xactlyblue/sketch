-- @type Computable<T> T | (() -> T)
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
		size: Computable<number>,
		font: Computable<Font?>,
		position: Computable<Vector3>,
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
