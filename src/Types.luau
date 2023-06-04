--[=[
	A computable value that runs the given function (if provided) to get the result.
]=]
export type Computable<T> = T | (() -> T)

--[=[
	An enum value that can be used to specify specific enum values.
]=]
export type Enum<T> = { [string]: T }

-- The status of the sketchbook
export type SketchbookStatus = "Alive" | "Hidden" | "Dead"

-- A sketchbook that holds sketches, which can then be rendered in the world at runtime
export type Sketchbook = {
	uuid: string,
	status: SketchbookStatus,

	registerDrawing: (Sketchbook, Drawing) -> (),
	unregisterDrawing: (Sketchbook, Drawing) -> (),

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

export type Array<T> = {[number]: T}
export type Callback = () -> ()
export type Connection = RBXScriptConnection | Instance | Callback
export type Connections = { [number]: Connection }

return {}
