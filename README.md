> # CustomTweenService

## Available types:
<table>
  <tr>
    <th>CFrame</th>
  </tr>
  <tr>
    <td>Vector3</td>
  </tr>
  <tr>
    <td>Color3</td>
  </tr>
  <tr>
    <td>Vector2</td>
  </tr>
  <tr>
    <td>UDim2</td>
  </tr>
  <tr>
    <td>Rect</td>
  </tr>
  <tr>
    <td>UDim</td>
  </tr>
  <tr>
    <td>number</td>
  </tr>
</table>

## Class structures
All variables with _ are internal and should not be changed manually, hence no documentation provided. Types are copied directly from the Classes file


CustomTween definition:
```luau
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
```
<table>
    <tr>
        <td>Name</td>
        <td>Info</td>
    </tr>
    <tr>
        <td>new</td>
        <td>
            Creates a new CustomTween <br/> <br/>
            Arguments:
            <table>
                <tr>
                    <td>Name</td>
                    <td>Type</td>
                    <td>Optional?</td>
                </tr>
                <tr>
                    <td>self</td>
                    <td>CustomTween</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>object</td>
                    <td>Instance or table</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>goal</td>
                    <td>table</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>tweenInfo</td>
                    <td>CustomTweenInfo</td>
                    <td>Yes</td>
                </tr>
            </table> <br/>
            Returns: CustomTween
    </td>
    <tr>
        <td>new</td>
        <td>
            Creates a new CustomTween
            Arguments:
            <table>
                <tr>
                    <td>Name</td>
                    <td>Type</td>
                    <td>Optional?</td>
                </tr>
                <tr>
                    <td>self</td>
                    <td>CustomTween</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>object</td>
                    <td>Instance or table</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>goal</td>
                    <td>table</td>
                    <td>No</td>
                </tr>
                <tr>
                    <td>tweenInfo</td>
                    <td>CustomTweenInfo</td>
                    <td>Yes</td>
                </tr>
            </table>
            Returns: CustomTween
    </td>
</table>

CustomTweenInfo definition:
```luau
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
```

