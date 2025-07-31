--!strict
--!optimize 2

local CustomTweenDirection = {
	In = 1;
	Out = 2;
	InOut = 3;
	OutIn = 4;
};

local CustomTweenStyle = {
	Linear = 1;
	Quad = 2;
	Cubic = 3;
	Quart = 4;
	Quint = 5;
	Sine = 6;
	Expo = 7;
	Circ = 8;
	Elastic = 9;
	Back = 10;
	Bounce = 11;
}

export type CustomTweenDirection = typeof(CustomTweenDirection)
export type CustomTweenStyle = typeof(CustomTweenStyle)
export type CustomTweenEnums = {
	CustomTweenDirection:CustomTweenDirection;
	CustomTweenStyle:CustomTweenStyle;
}

return {
	CustomTweenDirection = CustomTweenDirection;
	CustomTweenStyle = CustomTweenStyle;
}::CustomTweenEnums
