local Constants = require(script.Parent:WaitForChild("Constants"))

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

local function generateTextLabel(text: string, parent: Instance): TextLabel
	local textLabel: TextLabel = Instance.new("TextLabel")
	textLabel.Name = "SketchedText"
	textLabel.Text = text
	textLabel.TextColor3 = Constants.SKETCHED_TEXT_COLOR
	textLabel.TextSize = Constants.SKETCHED_TEXT_SIZE
	textLabel.Font = Constants.SKETCHED_TEXT_FONT
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = parent

	return textLabel
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
	generateTextLabel = generateTextLabel,
	generateHolderPart = generateHolderPart,
}
