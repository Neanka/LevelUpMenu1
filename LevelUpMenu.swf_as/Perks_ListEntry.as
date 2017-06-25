package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class Perks_ListEntry extends BSScrollingListEntry
   {
      
      public function Perks_ListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
        super.SetEntryText(param1,param2);
		if (param1.level > 1) {
			GlobalFunc.SetText(this.textField,param1.text +" "+param1.level,true);
		}
		//GlobalFunc.SetText(this.textField,param1.text +" "+param1.filterFlag,true);
		//this.textField.textColor = 0xCCCCCC;
		    var _local_3:* = border.alpha;
            if ((param1.filterFlag & 2) != 0)
            {
                border.alpha = ((this.selected) ? 0.35 : 0);
                textField.textColor = ((this.selected) ? 0x222222 : 0x444444);
            } else
            {
                border.alpha = ((this.selected) ? _local_3 : 0);
                textField.textColor = ((this.selected) ? 0 : 0xFFFFFF);
            };
      }
   }
}
