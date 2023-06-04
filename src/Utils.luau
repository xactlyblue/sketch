local Sketch = script:FindFirstAncestor("Sketch") :: Instance
local Constants = require(Sketch:WaitForChild("Constants"))

local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local TextService = game:GetService("TextService")

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

return {
	generateBillboardForText = generateBillboardForText,
	generateHolderPart = generateHolderPart,
}
