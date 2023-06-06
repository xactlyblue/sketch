"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[176],{62713:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new drawing.\\n\\n\\t","params":[{"name":"sketchbook","desc":"The sketchbook to create the drawing in","lua_type":"Sketchbook"},{"name":"type","desc":"The type of the drawing","lua_type":"DrawingType"}],"returns":[{"desc":"","lua_type":"Drawing"}],"function_type":"static","source":{"line":113,"path":"src/init.luau"}},{"name":"getSketchbook","desc":"Get the sketchbook the drawing is in.\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Sketchbook"}],"function_type":"method","source":{"line":134,"path":"src/init.luau"}},{"name":"getRenderer","desc":"Get the renderer designated for the drawing.\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Renderer"}],"function_type":"method","private":true,"source":{"line":145,"path":"src/init.luau"}},{"name":"getParameters","desc":"Get the drawing\'s parameters.\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"DrawingParameters"}],"function_type":"method","private":true,"source":{"line":156,"path":"src/init.luau"}},{"name":"getText","desc":"Get the drawing\'s text.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<string>"}],"function_type":"method","tags":["parameter"],"source":{"line":175,"path":"src/init.luau"}},{"name":"setText","desc":"Set the drawing\'s text.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"text","desc":"The text to set","lua_type":"Computable<string>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":199,"path":"src/init.luau"}},{"name":"getTextSize","desc":"Get the drawing\'s text size.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<number>"}],"function_type":"method","tags":["parameter"],"source":{"line":222,"path":"src/init.luau"}},{"name":"setTextSize","desc":"Set the drawing\'s text size.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"size","desc":"","lua_type":"Computable<number>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":243,"path":"src/init.luau"}},{"name":"getTextPosition","desc":"Get the drawing\'s text position.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<Vector3>"}],"function_type":"method","tags":["parameter"],"source":{"line":266,"path":"src/init.luau"}},{"name":"setTextPosition","desc":"Set the drawing\'s text position.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"position","desc":"","lua_type":"Computable<Vector3>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":288,"path":"src/init.luau"}},{"name":"getTextFont","desc":"Get the drawing\'s text font.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<Font>"}],"function_type":"method","tags":["parameter"],"source":{"line":311,"path":"src/init.luau"}},{"name":"setTextFont","desc":"Set the drawing\'s text font.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"font","desc":"","lua_type":"Computable<Font>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":333,"path":"src/init.luau"}},{"name":"getTextColor","desc":"Get the drawing\'s text color.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<Color3>"}],"function_type":"method","tags":["parameter"],"source":{"line":356,"path":"src/init.luau"}},{"name":"setTextColor","desc":"Set the drawing\'s text color.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"color","desc":"","lua_type":"Computable<Color3>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":378,"path":"src/init.luau"}},{"name":"getTextTransparency","desc":"Get the drawing\'s text transparency.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<number>"}],"function_type":"method","tags":["parameter"],"source":{"line":401,"path":"src/init.luau"}},{"name":"setTextTransparency","desc":"Set the drawing\'s text transparency.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"transparency","desc":"The transparency to set","lua_type":"Computable<number>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":423,"path":"src/init.luau"}},{"name":"getTextOffsetX","desc":"Get the drawing\'s text offsetX.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<number>"}],"function_type":"method","tags":["parameter"],"source":{"line":446,"path":"src/init.luau"}},{"name":"setTextOffsetX","desc":"Set the drawing\'s text offsetX.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"offsetX","desc":"The pixel offset (on the X axis) to set","lua_type":"Computable<number>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":468,"path":"src/init.luau"}},{"name":"getTextOffsetY","desc":"Get the drawing\'s text offsetY.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<number>"}],"function_type":"method","tags":["parameter"],"source":{"line":491,"path":"src/init.luau"}},{"name":"setTextOffsetY","desc":"Set the drawing\'s text offsetY.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"offsetY","desc":"The pixel offset (on the Y axis) to set","lua_type":"Computable<number>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":513,"path":"src/init.luau"}},{"name":"getMaxDistance","desc":"Get the drawing\'s text maximum display distance.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Computable<number>"}],"function_type":"method","tags":["parameter"],"source":{"line":536,"path":"src/init.luau"}},{"name":"setTextMaxDistance","desc":"Set the drawing\'s text offsetY.\\n\\n:::warning\\nThis function only supports the `Text` drawing type - other drawing types will immediately error.\\n:::\\n\\n:::caution\\nIt\'s recommended, though not enforced and though it doesn\'t make much of a difference, that you use computable functions as opposed directly interfacing with the drawing.\\n:::\\n\\n\\t","params":[{"name":"maxDistance","desc":"The maximum distance","lua_type":"Computable<number>"}],"returns":[{"desc":"The drawing object","lua_type":"Drawing"}],"function_type":"method","tags":["parameter"],"source":{"line":558,"path":"src/init.luau"}},{"name":"cleanup","desc":"Cleans up the drawing, removing it from the sketchbook, cleaning up the renderer, and disconnecting all events.\\n\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":572,"path":"src/init.luau"}}],"properties":[],"types":[],"name":"Drawing","desc":"A drawing is, as you might expect, a representation of data that will be drawn to the screen in each call of the render function.\\nEach drawing is attached to a sketchbook, which is a collection of drawings that are all rendered together; it also acts as a container for\\ndifferent types of drawings, helping to keep your code nice and organized.\\n\\n```lua\\nlocal sketchbook = Sketch.createSketchbook() -- Create a new sketchbook to hold our drawings\\nlocal drawing = Sketch.drawText(sketchbook, \\"Hello, world!\\") -- Create a new drawing to draw some text\\n```","tags":["component"],"source":{"line":84,"path":"src/init.luau"}}')}}]);