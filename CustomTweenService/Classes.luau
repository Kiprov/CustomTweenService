--!strict
--!optimize 2

local RunService = game:GetService("RunService")

local Enums = require(script.Parent:WaitForChild("Enums"))
local RawTweens = require(script.Parent:WaitForChild("RawTweens"))

--do not use
local function empty()
	
end

--[[
	Creates new CustomTweenInfo from the provided arguments

	<strong>self</strong> : <strong>INTERNAL</strong>, if you see this argument please call this function by : and not .
	<strong>Duration</strong> : Duration of the tween in seconds
	<strong>Direction</strong> : Direction of the tween, see Enums module for directions
	<strong>Style</strong> : Style of the tween, see Enums module for styles
	<strong>Reverses</strong> : When tween finishes it's cycle it will run in reverse to it's orign value
	<strong>Count</strong> : Amount of cycles tween
	<strong>DelayTime</strong> : Amount of time in seconds between the cycles
]]
local function CustomTweenInfo_new(
	self:CustomTweenInfo,
	Duration:number?,
	Direction:number?,
	Style:number?,
	Reverses:boolean?,
	Count:number?,
	DelayTime:number?,
	Amplitude:number?,
	Period:number?
) : CustomTweenInfo
	local newSelf = table.clone(self)

	newSelf.Duration = Duration or newSelf.Duration
	newSelf.Direction = Direction or newSelf.Direction
	newSelf.Style = Style or newSelf.Style 
	newSelf.Reverses = Reverses or newSelf.Reverses
	newSelf.Count = Count or newSelf.Count
	newSelf.Delay = DelayTime or newSelf.Delay
	newSelf.Amplitude = Amplitude or newSelf.Amplitude
	newSelf.Period = Period or newSelf.Period

	return newSelf
end

--[[
	Constructs CustomTweenInfo from the normal TweenInfo
	
	<strong>self</strong> : <strong>INTERNAL</strong>, if you see this argument please call this function by : and not .
	<strong>tweenInfo</strong> : TweenInfo
]]
local function CustomTweenInfo_new_fromTweenInfo(self:CustomTweenInfo,tweenInfo:TweenInfo) : CustomTweenInfo
	local newSelf = table.clone(self)

	newSelf.Direction = newSelf._robloxEnumToCustom[tweenInfo.EasingDirection]
	newSelf.Style = newSelf._robloxEnumToCustom[tweenInfo.EasingStyle]
	newSelf.Reverses = tweenInfo.Reverses
	newSelf.Count = tweenInfo.RepeatCount
	newSelf.Delay = tweenInfo.DelayTime
	newSelf.Duration = tweenInfo.Time

	return newSelf
end

export type CustomTweenInfo = {
	new:typeof(CustomTweenInfo_new); 
	fromTweenInfo:typeof(CustomTweenInfo_new_fromTweenInfo);
	
	Direction:number;
	Style:number;
	Reverses:boolean;
	Count:number;
	Delay:number;
	Duration:number;
	Amplitude:number;
	Period:number;
	
	_robloxEnumToCustom:{
		[Enum.EasingStyle|Enum.EasingDirection]:number;
	};
}

local CustomTweenInfo = {
	new = CustomTweenInfo_new;
	fromTweenInfo = CustomTweenInfo_new_fromTweenInfo;
	
	Direction = Enums.CustomTweenDirection.In;
	Style = Enums.CustomTweenStyle.Sine;
	Reverses = false;
	Count = 0;
	Delay = 0;
	Duration = 1;
	Amplitude = 1;
	Period = 1;
	
	_robloxEnumToCustom = {
		[Enum.EasingStyle.Linear] = 1;
		[Enum.EasingStyle.Quad] = 2;
		[Enum.EasingStyle.Cubic] = 3;
		[Enum.EasingStyle.Quart] = 4;
		[Enum.EasingStyle.Quint] = 5;
		[Enum.EasingStyle.Sine] = 6;
		[Enum.EasingStyle.Exponential] = 7;
		[Enum.EasingStyle.Circular] = 8;
		[Enum.EasingStyle.Elastic] = 9;
		[Enum.EasingStyle.Back] = 10;
		[Enum.EasingStyle.Bounce] = 11;

		[Enum.EasingDirection.In] = 1;
		[Enum.EasingDirection.Out] = 2;
		[Enum.EasingDirection.InOut] = 3;
	}
}::CustomTweenInfo

--[[
	<strong>YIELDS</strong>

	Prepares custom tween for garbage collection, reassures some of the variables will be properly disposed
]]
local function CustomTween_PrepareGC(self:CustomTween)
	self.Completed = nil
	(self._event::BindableEvent):Destroy()
	self._event = nil
	self:Cancel()
	RunService.PostSimulation:Wait()
	if coroutine.status(self._runTime::thread) ~= "dead" then
		coroutine.close(self._runTime::thread)
	end
	self._runTime = nil
end

--[[
	Returns raw tween from tweening style

	<strong>self</strong> : <strong>INTERNAL</strong>, if you see this argument please call this function by : and not .
	<strong>info</strong> : Optional argument to get raw tween from other CustomTweenInfo
]]
local function CustomTween_GetTweenFunc(self:CustomTween,info:CustomTweenInfo?) : (t:number, b:number, c:number,as:number?,p:number?) -> number
	info = info or self._customTweenInfo
	return self._enumToFunc[info.Style][info.Direction]
end

--[[
	Returns raw tween from tweening style

	<strong>self</strong> : <strong>INTERNAL</strong>, if you see this argument please call this function by : and not .
	<strong>value</strong> : Value to get the lerp func type for
]]
local function CustomTween_GetLerpFunc(self:CustomTween,value:any) : <T>(self:T,goal:T,alpha:number) -> T
	return self._stringToLerp[typeof(value)]
end

--Inits internal states and makes the tween run, is not intended for outside use
local function CustomTween_RunTime(self:CustomTween)
	local delta = 0
	local lerpTypes = {}
	local reverse = 1
	local count = self._customTweenInfo.Count
	for i,v in self._goal do
		lerpTypes[i] = self:GetLerpFunc(v)
	end
	
	self._optimalValue = 1/self._customTweenInfo.Duration
	
	while true do
		delta = RunService.PreSimulation:Wait() * reverse
		if self.State == Enum.PlaybackState.Playing then
			self._tweenPercent += delta*self._optimalValue
			if self._tweenPercent > 1 then
				self._tweenPercent = 1
				if self._customTweenInfo.Reverses then
					reverse = -1
				else
					if count == 0 then
						self.State = Enum.PlaybackState.Completed
					else
						count -= 1
					end
				end
				if self._customTweenInfo.Delay > 0 and count > 0 and reverse ~= -1 then
					self.State = Enum.PlaybackState.Delayed
					task.wait(self._customTweenInfo.Delay)
					self.State = Enum.PlaybackState.Playing
				end
			elseif self._tweenPercent < 0 then
				reverse = 1
				if count == 0 then
					self.State = Enum.PlaybackState.Completed
				else
					count -= 1
				end
				if self._customTweenInfo.Delay > 0 and count > 0 then
					self.State = Enum.PlaybackState.Delayed
					task.wait(self._customTweenInfo.Delay)
					self.State = Enum.PlaybackState.Playing
				end
			end
			
			self._tweenValue = self._func(self._tweenPercent,0,1,self._customTweenInfo.Amplitude,self._customTweenInfo.Period)
			
			for i,v in lerpTypes do
				(self._object::{[any]:any})[i] = v(self._initValues[i],self._goal[i],self._tweenValue) --??!?
			end
		elseif self.State == Enum.PlaybackState.Completed or self.State == Enum.PlaybackState.Cancelled then
			self._tweenPercent = 0
			self._tweenValue = 0
			self._optimalValue = 1
			(self._event::BindableEvent):Fire(self.State)
			break
		elseif self.State == Enum.PlaybackState.Paused then
			break
		end
	end
end

--Starts the tween
local function CustomTween_Play(self:CustomTween)
	self.State = Enum.PlaybackState.Playing
	if coroutine.status(self._runTime::thread) == "dead"  then
		self._initValues = {}
		for i,v in self._goal do
			self._initValues[i] = (self._object::{[any]:any})[i]
		end
		self._runTime = coroutine.create(self._runTimeFunc)
		coroutine.resume(self._runTime::thread,self)
	end
end

--Pauses tween, does not resets it's variables or fires completed event
local function CustomTween_Pause(self:CustomTween)
	self.State = Enum.PlaybackState.Paused
end

--Cancels tween,resets it's internal variables and fires Completed event
local function CustomTween_Cancel(self:CustomTween)
	self.State = Enum.PlaybackState.Cancelled
end

--Creates new CustomTween
local function CustomTween_new(self:CustomTween,object:Instance|{[any]:any},goal:{[any]:any},tweenInfo:CustomTweenInfo?) : CustomTween
	local newSelf = table.clone(self)
	
	newSelf._customTweenInfo = tweenInfo or newSelf._customTweenInfo
	newSelf._func = newSelf._enumToFunc[newSelf._customTweenInfo.Style][newSelf._customTweenInfo.Direction]
	newSelf._goal = goal
	newSelf._object = object
	newSelf._event = Instance.new("BindableEvent")
	newSelf.Completed = (newSelf._event::BindableEvent).Event
	newSelf._initValues = {}
	for i,v in newSelf._goal do
		newSelf._initValues[i] = (newSelf._object::{[any]:any})[i]
	end
	
	newSelf._runTime = coroutine.create(newSelf._runTimeFunc)
	coroutine.resume(newSelf._runTime::thread,newSelf)
	return newSelf
end

export type CustomTween = {
	new:typeof(CustomTween_new);
	Play:typeof(CustomTween_Play);
	Pause:typeof(CustomTween_Pause);
	Cancel:typeof(CustomTween_Cancel);
	PrepareGC:typeof(CustomTween_PrepareGC);
	GetTweenFunc:typeof(CustomTween_GetTweenFunc);
	GetLerpFunc:typeof(CustomTween_GetLerpFunc);
	
	State:Enum.PlaybackState;
	Completed:RBXScriptSignal?;
	
	_enumToFunc:{{(t:number, b:number, c:number,as:number?,p:number?) -> number}};
	_stringToLerp:{[string]:<T>(self:T,goal:T,alpha:number) -> T};
	
	_event:BindableEvent?;
	_initValues:{[any]:any};
	_object:Instance|{[any]:any};
	_goal:{[any]:any};
	_customTweenInfo:CustomTweenInfo;
	_optimalValue:number;
	_tweenPercent:number;
	_tweenValue:number;
	_runTime:thread?;
	_func:(t:number, b:number, c:number,as:number?,p:number?) -> number;
	_runTimeFunc:typeof(CustomTween_RunTime);
}

local event = Instance.new("BindableEvent")
local CustomTween = {
	new = CustomTween_new;
	Play = CustomTween_Play;
	Pause = CustomTween_Pause;
	Cancel = CustomTween_Cancel;
	PrepareGC = CustomTween_PrepareGC;
	GetTweenFunc = CustomTween_GetTweenFunc;
	GetLerpFunc = CustomTween_GetLerpFunc;
	
	State = Enum.PlaybackState.Begin;
	Completed = event.Event;
	
	_enumToFunc = {
		{
			RawTweens.linear;
			RawTweens.linear;
			RawTweens.linear;
			RawTweens.linear;
		};
		{
			RawTweens.inQuad;
			RawTweens.outQuad;
			RawTweens.inOutQuad;
			RawTweens.outInQuad;
		};
		{
			RawTweens.inCubic;
			RawTweens.outCubic;
			RawTweens.inOutCubic;
			RawTweens.outInCubic;
		};
		{
			RawTweens.inQuart;
			RawTweens.outQuart;
			RawTweens.inOutQuart;
			RawTweens.outInQuart;
		};
		{
			RawTweens.inQuint;
			RawTweens.outQuint;
			RawTweens.inOutQuint;
			RawTweens.outInQuint;
		};
		{
			RawTweens.inSine;
			RawTweens.outSine;
			RawTweens.inOutSine;
			RawTweens.outInSine;
		};
		{
			RawTweens.inExpo;
			RawTweens.outExpo;
			RawTweens.inOutExpo;
			RawTweens.outInExpo;
		};
		{
			RawTweens.inCirc;
			RawTweens.outCirc;
			RawTweens.inOutCirc;
			RawTweens.outInCirc;
		};
		{
			RawTweens.inElastic;
			RawTweens.outElastic;
			RawTweens.inOutElastic;
			RawTweens.outInElastic;
		};
		{
			RawTweens.inBack;
			RawTweens.outBack;
			RawTweens.inOutBack;
			RawTweens.outInBack;
		};
		{
			RawTweens.inBounce;
			RawTweens.outBounce;
			RawTweens.inOutBounce;
			RawTweens.outInBounce;
		};
	};
	_stringToLerp = {
		Vector3 = Vector3.zero.Lerp;
		CFrame = CFrame.identity.Lerp;
		UDim2 = UDim2.new().Lerp;
		Vector2 = Vector2.zero.Lerp;
		Color3 = Color3.new().Lerp;
		
		UDim = function(self:UDim,goal:UDim,alpha:number) : UDim 
			local x1,y1 = self.Scale,self.Offset
			local x2,y2 = goal.Scale,goal.Offset
			return UDim.new(x1+(x2-x1)*alpha,y1+(y2-y1)*alpha)
		end;
		
		Rect = function(self:Rect,goal:Rect,alpha:number) : Rect
			return Rect.new(self.Min:Lerp(goal.Min,alpha),self.Max:Lerp(goal.Max,alpha))
		end,
		
		number = function(self:number,goal:number,alpha:number) : number
			return self+(goal-self)*alpha
		end,
	};
	
	_event = event;
	_initValues = {};
	_goal = {};
	_object = {};
	_customTweenInfo = table.clone(CustomTweenInfo);
	_optimalValue = 1;
	_tweenPercent = 0;
	_tweenValue = 0;
	_func = RawTweens.inSine;
	_runTime = coroutine.create(empty);
	_runTimeFunc = CustomTween_RunTime;
}::CustomTween

type Classes = {
	CustomTweenInfo:CustomTweenInfo;
	CustomTween:CustomTween;
}

return {
	CustomTweenInfo = CustomTweenInfo;
	CustomTween = CustomTween;
}::Classes
