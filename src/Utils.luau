local Constants = require(script.Parent:WaitForChild("Constants"))
local Types = require(script.Parent:WaitForChild("Types"))

type Computable<T> = Types.Computable<T>
type Array<T> = Types.Array<T>

local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local TextService = game:GetService("TextService")

local Utils = {}

function Utils.isComputable(value: unknown, expectedType: string): boolean
	return typeof(value) == expectedType 
		or typeof(value) == "function"
end

function Utils.retrieveComputableValue<T>(computable: Computable<T>, expectedType: string?): T
	if expectedType ~= nil then
		assert(Utils.isComputable(computable, expectedType), "Expected computable to be a computable value")
	end

	if typeof(computable) == "function" then
		return computable()
	else
		return computable
	end
end

return Utils
