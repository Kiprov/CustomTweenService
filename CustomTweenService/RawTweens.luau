--!optimize 2
--!strict
--!native

--
-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and http://code.google.com/p/tweener/ (jstweener javascript version)
--

--[[
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning

local HALF_PI = math.pi*0.5
local TAU = math.pi*2

local function linear(t:number, b:number, c:number) : number
	return c * t + b
end

local function inQuad(t:number, b:number, c:number) : number
	return c * (t*t) + b
end

local function outQuad(t:number, b:number, c:number) : number
	return -c * t * (t - 2) + b
end

local function inOutQuad(t:number, b:number, c:number) : number
	t = t * 2
	c = c*0.5
	if t < 1 then
		return c * (t*t) + b
	else
		return -c * ((t - 1) * (t - 3) - 1) + b
	end
end

local function outInQuad(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outQuad (t * 2, b, c)
	else
		return inQuad((t * 2) - 1, b + c, c)
	end
end

local function inCubic (t:number, b:number, c:number) : number
	return c * (t*t*t) + b
end

local function outCubic(t:number, b:number, c:number) : number
	t = t - 1
	return c * ((t*t*t) + 1) + b
end

local function inOutCubic(t:number, b:number, c:number) : number
	t = t * 2
	c = c*0.5
	if t < 1 then
		return c * t * t * t + b
	else
		t = t - 2
		return c * (t * t * t + 2) + b
	end
end

local function outInCubic(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outCubic(t * 2, b, c)
	else
		return inCubic((t * 2) - 1, b + c, c)
	end
end

local function inQuart(t:number, b:number, c:number) : number
	return c * (t*t*t*t) + b
end

local function outQuart(t:number, b:number, c:number) : number
	t = t - 1
	return -c * ((t*t*t*t) - 1) + b
end

local function inOutQuart(t:number, b:number, c:number) : number
	t = t * 2
	c = c*0.5
	if t < 1 then
		return c * (t*t*t*t) + b
	else
		t = t - 2
		return -c * ((t*t*t*t) - 2) + b
	end
end

local function outInQuart(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outQuart(t * 2, b, c)
	else
		return inQuart((t * 2) - 1, b + c, c)
	end
end

local function inQuint(t:number, b:number, c:number) : number
	return c * (t*t*t*t*t) + b
end

local function outQuint(t:number, b:number, c:number) : number
	t = t - 1
	return c * ((t*t*t*t*t) + 1) + b
end

local function inOutQuint(t:number, b:number, c:number) : number
	t = t * 2
	c = c*0.5
	if t < 1 then
		return c * (t*t*t*t*t) + b
	else
		t = t - 2
		return c * ((t*t*t*t*t) + 2) + b
	end
end

local function outInQuint(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outQuint(t * 2, b, c)
	else
		return inQuint((t * 2) - 1, b + c, c)
	end
end

local function inSine(t:number, b:number, c:number) : number
	return -c * math.cos(t * HALF_PI) + c + b
end

local function outSine(t:number, b:number, c:number) : number
	return c * math.sin(t * HALF_PI) + b
end

local function inOutSine(t:number, b:number, c:number) : number
	return -(c * 0.5) * (math.cos(math.pi * t) - 1) + b
end

local function outInSine(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outSine(t * 2, b, c)
	else
		return inSine((t * 2) - 1, b + c, c)
	end
end

local function inExpo(t:number, b:number, c:number) : number
	if t == 0 then
		return b
	else
		return c * math.pow(2, 10 * (t - 1)) + b - c * 0.001
	end
end

local function outExpo(t:number, b:number, c:number) : number
	if t == 1 then
		return b + c
	else
		return c * 1.001 * (-math.pow(2, -10 * t) + 1) + b
	end
end

local function inOutExpo(t:number, b:number, c:number) : number
	if t == 0 then return b end
	if t == 1 then return b + c end
	t = t * 2
	if t < 1 then
		return (c * 0.5) * math.pow(2, 10 * (t - 1)) + b - c * 0.0005
	else
		t = t - 1
		return (c * 0.5) * 1.0005 * (-math.pow(2, -10 * t) + 2) + b
	end
end

local function outInExpo(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outExpo(t * 2, b, c)
	else
		return inExpo((t * 2) - 1, b + c, c)
	end
end

local function inCirc(t:number, b:number, c:number) : number
	return(-c * (math.sqrt(1 - (t*t)) - 1) + b)
end

local function outCirc(t:number, b:number, c:number) : number
	t = t - 1
	return(c * math.sqrt(1 - (t*t)) + b)
end

local function inOutCirc(t:number, b:number, c:number) : number
	t = t * 2
	if t < 1 then
		return -(c * 0.5) * (math.sqrt(1 - t * t) - 1) + b
	else
		t = t - 2
		return (c * 0.5) * (math.sqrt(1 - t * t) + 1) + b
	end
end

local function outInCirc(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outCirc(t * 2, b, c)
	else
		return inCirc((t * 2) - 1, b + c, c)
	end
end

local function inElastic(t:number, b:number, c:number, a:number, p:number) : number
	if t == 0 then return b end

	if t == 1  then return b + c end

	p = p or 0.3

	local s:number

	if not a or a < math.abs(c) then
		a = c
		s = p * 0.25
	else
		s = p / TAU * math.asin(c/a)
	end

	t = t - 1

	return -(a * math.pow(2, 10 * t) * math.sin((t - s) * TAU / p)) + b
end

-- a: amplitud
-- p: period
local function outElastic(t:number, b:number, c:number, a:number, p:number) : number
	if t == 0 then return b end

	if t == 1 then return b + c end

	p = p or 0.3

	local s:number

	if not a or a < math.abs(c) then
		a = c
		s = p * 0.25
	else
		s = p / TAU * math.asin(c/a)
	end

	return a * math.pow(2, -10 * t) * math.sin((t - s) * TAU / p) + c + b
end

-- p = period
-- a = amplitud
local function inOutElastic(t:number, b:number, c:number, a:number, p:number) : number
	if t == 0 then return b end

	t = t * 2

	if t == 2 then return b + c end

	p = p or 0.45
	a = a or 0

	local s

	if not a or a < math.abs(c) then
		a = c
		s = p * 0.25
	else
		s = p / TAU * math.asin(c / a)
	end

	if t < 1 then
		t = t - 1
		return -0.5 * (a * math.pow(2, 10 * t) * math.sin((t - s) * TAU / p)) + b
	else
		t = t - 1
		return a * math.pow(2, -10 * t) * math.sin((t - s) * TAU / p ) * 0.5 + c + b
	end
end

-- a: amplitud
-- p: period
local function outInElastic(t:number, b:number, c:number, a:number, p:number) : number
	c = c*0.5
	if t < 0.5 then
		return outElastic(t * 2, b, c, a, p)
	else
		return inElastic((t * 2) - 1, b + c, c, a, p)
	end
end

-- s: size
local function inBack(t:number, b:number, c:number, s:number) : number
	s = s or 1.70158
	return c * t * t * ((s + 1) * t - s) + b
end

-- s: size
local function outBack(t:number, b:number, c:number, s:number) : number
	s = s or 1.70158
	t = t - 1
	return c * (t * t * ((s + 1) * t + s) + 1) + b
end

-- s: size
local function inOutBack(t:number, b:number, c:number, s:number) : number
	s = s or 1.70158
	s = s * 1.525
	t = t * 2
	if t < 1 then
		return (c * 0.5) * (t * t * ((s + 1) * t - s)) + b
	else
		t = t - 2
		return (c * 0.5) * (t * t * ((s + 1) * t + s) + 2) + b
	end
end

-- s: size
local function outInBack(t:number, b:number, c:number, s:number) : number
	c = c*0.5
	if t < 0.5 then
		return outBack(t * 2, b, c, s)
	else
		return inBack((t * 2) - 1, b + c, c, s)
	end
end

local function outBounce(t:number, b:number, c:number) : number
	if t < 0.36363636363 then
		return c * (7.5625 * t * t) + b
	elseif t < 0.72727272727 then
		t = t - 0.54545454545
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 0.90909090909 then
		t = t - 0.81818181818
		return c * (7.5625 * t * t + 0.9375) + b
	else
		t = t - 0.95454545454
		return c * (7.5625 * t * t + 0.984375) + b
	end
end

local function inBounce(t:number, b:number, c:number) : number
	return c - outBounce(1 - t, 0, c) + b
end

local function inOutBounce(t:number, b:number, c:number) : number
	if t < 0.5 then
		return inBounce(t * 2, 0, c) * 0.5 + b
	else
		return outBounce(t * 2 - 1, 0, c) * 0.5 + c * 0.5 + b
	end
end

local function outInBounce(t:number, b:number, c:number) : number
	c = c*0.5
	if t < 0.5 then
		return outBounce(t * 2, b, c)
	else
		return inBounce((t * 2) - 1, b + c, c)
	end
end

export type Tweens = {
	linear:typeof(linear);
	inQuad:typeof(inQuad);
	outQuad:typeof(outQuad);
	inOutQuad:typeof(inOutQuad);
	outInQuad:typeof(outInQuad);
	inCubic:typeof(inCubic);
	outCubic:typeof(outCubic);
	inOutCubic:typeof(inOutCubic);
	outInCubic:typeof(outInCubic);
	inQuart:typeof(inQuart);
	outQuart:typeof(outQuart);
	inOutQuart:typeof(inOutQuart);
	outInQuart:typeof(outInQuart);
	inQuint:typeof(inQuint);
	outQuint:typeof(outQuint);
	inOutQuint:typeof(inOutQuint);
	outInQuint:typeof(outInQuint);
	inSine:typeof(inSine);
	outSine:typeof(outSine);
	inOutSine:typeof(inOutSine);
	outInSine:typeof(outInSine);
	inExpo:typeof(inExpo);
	outExpo:typeof(outExpo);
	inOutExpo:typeof(inOutExpo);
	outInExpo:typeof(outInExpo);
	inCirc:typeof(inCirc);
	outCirc:typeof(outCirc);
	inOutCirc:typeof(inOutCirc);
	outInCirc:typeof(outInCirc);
	inElastic:typeof(inElastic);
	outElastic:typeof(outElastic);
	inOutElastic:typeof(inOutElastic);
	outInElastic:typeof(outInElastic);
	inBack:typeof(inBack);
	outBack:typeof(outBack);
	inOutBack:typeof(inOutBack);
	outInBack:typeof(outInBack);
	inBounce:typeof(inBounce);
	outBounce:typeof(outBounce);
	inOutBounce:typeof(inOutBounce);
	outInBounce:typeof(outInBounce);
}

return {
	linear = linear,
	inQuad = inQuad,
	outQuad = outQuad,
	inOutQuad = inOutQuad,
	outInQuad = outInQuad,
	inCubic  = inCubic ,
	outCubic = outCubic,
	inOutCubic = inOutCubic,
	outInCubic = outInCubic,
	inQuart = inQuart,
	outQuart = outQuart,
	inOutQuart = inOutQuart,
	outInQuart = outInQuart,
	inQuint = inQuint,
	outQuint = outQuint,
	inOutQuint = inOutQuint,
	outInQuint = outInQuint,
	inSine = inSine,
	outSine = outSine,
	inOutSine = inOutSine,
	outInSine = outInSine,
	inExpo = inExpo,
	outExpo = outExpo,
	inOutExpo = inOutExpo,
	outInExpo = outInExpo,
	inCirc = inCirc,
	outCirc = outCirc,
	inOutCirc = inOutCirc,
	outInCirc = outInCirc,
	inElastic = inElastic,
	outElastic = outElastic,
	inOutElastic = inOutElastic,
	outInElastic = outInElastic,
	inBack = inBack,
	outBack = outBack,
	inOutBack = inOutBack,
	outInBack = outInBack,
	inBounce = inBounce,
	outBounce = outBounce,
	inOutBounce = inOutBounce,
	outInBounce = outInBounce,
}::Tweens
