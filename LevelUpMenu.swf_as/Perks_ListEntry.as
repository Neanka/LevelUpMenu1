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
		//this.textField.textColor = 0xCCCCCC;
		    var _local_3:* = border.alpha;
            if (param1.filterFlag != 1)
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
