"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[552],{84998:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a new sketchbook.\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Sketchbook"}],"function_type":"static","source":{"line":604,"path":"src/init.luau"}},{"name":"isDrawingRegistered","desc":"Gets whether the sketchbook has the provided drawing registered within itself.\\n\\n\\t","params":[{"name":"drawing","desc":"","lua_type":"Drawing - The drawing to check for"}],"returns":[{"desc":"","lua_type":"boolean"}],"function_type":"method","source":{"line":625,"path":"src/init.luau"}},{"name":"registerDrawing","desc":"Registers a drawing to the sketchbook. This will also register the drawing\'s renderer and connect all events.\\n\\n\\t","params":[{"name":"drawing","desc":"The drawing to register","lua_type":"Drawing"}],"returns":[{"desc":"The drawing that was registered","lua_type":"Drawing"}],"function_type":"method","errors":[{"lua_type":"\\"Cannot register drawing that is already registered\\"","desc":"The drawing is already registered to the sketchbook"}],"private":true,"source":{"line":644,"path":"src/init.luau"}},{"name":"unregisterDrawing","desc":"Unregisters a drawing from the sketchbook. This will also unregister the drawing\'s renderer and disconnect all events.\\n\\n\\t","params":[{"name":"drawing","desc":"The drawing to unregister","lua_type":"Drawing"}],"returns":[],"function_type":"method","private":true,"source":{"line":660,"path":"src/init.luau"}},{"name":"getDrawings","desc":"Gets all drawings registered to the sketchbook.\\n\\n\\t","params":[],"returns":[{"desc":"","lua_type":"Array<Drawing>"}],"function_type":"method","source":{"line":683,"path":"src/init.luau"}},{"name":"setHidden","desc":"Sets the state of the sketchbook to be hidden or not.\\n\\n\\t","params":[{"name":"hidden","desc":"Whether the sketchbook should be hidden or not","lua_type":"boolean"}],"returns":[],"function_type":"method","errors":[{"lua_type":"\\"Cannot set status of dead sketchbook\\"","desc":"The sketchbook is dead"}],"source":{"line":694,"path":"src/init.luau"}},{"name":"getStatus","desc":"Gets the status of the sketchbook.\\n\\n\\t","params":[],"returns":[{"desc":"The status of the sketchbook","lua_type":"SketchbookStatus"}],"function_type":"method","source":{"line":706,"path":"src/init.luau"}},{"name":"cleanup","desc":"Cleans up the sketchbook, removing all drawings and connections.\\n\\n\\t","params":[],"returns":[],"function_type":"method","source":{"line":715,"path":"src/init.luau"}}],"properties":[],"types":[],"name":"Sketchbook","desc":"A sketchbook is essentially a container that can hold sketched objects (which will then be rendered to the world at runtime).\\nEach sketchbook has a unique ID that can be used to identify it, and can be be modified when necessary.","tags":["component"],"source":{"line":593,"path":"src/init.luau"}}')}}]);