package
{
   import Shared.AS3.BSUIComponent;
	import flash.geom.ColorTransform;
   
   public dynamic class XPMeter_Holder extends BSUIComponent
   {
       
      
      public function XPMeter_Holder()
      {
         super();
      }
	  
        public function onApplyColorChange(r, g, b, multiplier): Array
        {
            var rint:uint = r * 255;
            var gint:uint = g * 255;
            var bint:uint = b * 255;
            var mint:uint = multiplier * 255;

            var ct: ColorTransform = new ColorTransform(0.0, 0.0, 0.0, 1.0, rint, gint, bint, 0);

			LevelUpMenu.instance.applycolor();
            return [r, g, b, multiplier];
        }
   }
}
