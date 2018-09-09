package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public dynamic class BSUIComponentEx extends BSUIComponent
	{
		public function BSUIComponentEx()
		{
			super();
		}
	
		public function redrawCustomBrackets(param1:MovieClip)
		{
			this._bracketPair.height = param1.height;
		}
	}
}
