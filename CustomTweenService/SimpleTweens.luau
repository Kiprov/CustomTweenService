--!native
--!strict
--!optimize 2

-- module for simple tweening, meant to be used as a high performance no-abstraction alternative
local RunService = game:GetService("RunService")

local RawTweens = require(script.Parent:WaitForChild("RawTweens"))

--[[
	<strong>YIELDS</strong>
	
	tweens number property of a table/instance using the provided function
]]
local function tweenNumber(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:number,
	sizeOrAmplitude:number?,
	period:number?
)
	local delta = 0
	local start = obj[prop]
	local optimalNumber = 1/duration
	repeat
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = func(delta,start,goal,sizeOrAmplitude,period)
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens CFrame property of a table/instance using the provided function
]]
local function tweenCFrame(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:CFrame,
	sizeOrAmplitude:number?,
	period:number?
)
	local delta = 0
	local start:CFrame = obj[prop]
	local optimalNumber = 1/duration
	repeat
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = start:Lerp(goal,func(delta,0,1,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens Vector3 property of a table/instance using the provided function
]]
local function tweenVector3(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:Vector3,
	sizeOrAmplitude:number?,
	period:number?
)
	local delta = 0
	local start:Vector3 = obj[prop]
	local optimalNumber = 1/duration
	repeat 
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = start:Lerp(goal,func(delta,0,1,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens Vector2 property of a table/instance using the provided function
]]
local function tweenVector2(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:Vector2,
	sizeOrAmplitude:number?,
	period:number?
)
	local delta = 0
	local start:Vector2 = obj[prop]
	local optimalNumber = 1/duration
	repeat 
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = start:Lerp(goal,func(delta,0,1,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens UDim2 property of a table/instance using the provided function
]]
local function tweenUDim2(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:UDim2,
	sizeOrAmplitude:number?,
	period:number?
) 
	local delta = 0
	local start:UDim2 = obj[prop]
	local optimalNumber = 1/duration
	repeat 
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = start:Lerp(goal,func(delta,0,1,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens UDim property of a table/instance using the provided function
]]
local function tweenUDim(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:UDim,
	sizeOrAmplitude:number?,
	period:number?
) 
	local delta = 0
	local start:UDim = obj[prop]
	local x1,y1 = start.Scale,start.Offset
	local x2,y2 = goal.Scale,goal.Offset
	local optimalNumber = 1/duration
	repeat 
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = UDim.new(func(delta,x1,x2,sizeOrAmplitude,period),func(delta,y1,y2,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

--[[
	<strong>YIELDS</strong>
	
	tweens Color3 property of a table/instance using the provided function
]]
local function tweenColor3(
	func:(t:number, b:number, c:number,as:number?,p:number?) -> number,
	duration:number,
	obj:{[any]:any}&Instance,
	prop:any,
	goal:Color3,
	sizeOrAmplitude:number?,
	period:number?
) 
	local delta = 0
	local start:Color3 = obj[prop]
	local optimalNumber = 1/duration
	repeat 
		delta += RunService.PreSimulation:Wait()*optimalNumber
		obj[prop] = start:Lerp(goal,func(delta,0,1,sizeOrAmplitude,period))
	until delta > 1
	obj[prop] = goal
end

export type SimpleTweens = {
	tweenNumber:typeof(tweenNumber);
	tweenCFrame:typeof(tweenCFrame);
	tweenVector3:typeof(tweenVector3);
	tweenVector2:typeof(tweenVector2);
	tweenUDim2:typeof(tweenUDim2);
	tweenUDim:typeof(tweenUDim);
	tweenColor3:typeof(tweenColor3);
}

return {
	tweenNumber = tweenNumber;
	tweenCFrame = tweenCFrame;
	tweenVector3 = tweenVector3;
	tweenVector2 = tweenVector2;
	tweenUDim2 = tweenUDim2;
	tweenUDim = tweenUDim;
	tweenColor3 = tweenColor3;
}::SimpleTweens
