package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Skills_ListEntry extends BSScrollingListEntry
	{
		
		public var Value_tf:TextField;
		
		public var NameLabel_tf:TextField;
		
		public var IncrementArrow:MovieClip;
		
		public var DecrementArrow:MovieClip;
		
		public var IsNameEntry:Boolean = true;
		
		public var tag_mc:MovieClip;
		
		public function Skills_ListEntry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textField, TextFieldEx.TEXTAUTOSZ_SHRINK)
		}
		
		override public function SetEntryText(param1:Object, param2:String):*
		{
			super.SetEntryText(param1, param2);
			GlobalFunc.SetText(this.Value_tf, param1.value, false);
			this.Value_tf.textColor = !!this.selected ? uint(0) : uint(16777215);
			var _loc3_:ColorTransform = this.IncrementArrow.transform.colorTransform;
			_loc3_.redOffset = !!this.selected ? Number(-255) : Number(0);
			_loc3_.greenOffset = !!this.selected ? Number(-255) : Number(0);
			_loc3_.blueOffset = !!this.selected ? Number(-255) : Number(0);
			this.IncrementArrow.transform.colorTransform = _loc3_;
			_loc3_ = this.DecrementArrow.transform.colorTransform;
			_loc3_.redOffset = !!this.selected ? Number(-255) : Number(0);
			_loc3_.greenOffset = !!this.selected ? Number(-255) : Number(0);
			_loc3_.blueOffset = !!this.selected ? Number(-255) : Number(0);
			this.DecrementArrow.transform.colorTransform = _loc3_;
			this.tag_mc.visible = param1.tagged;
			this.tag_mc.transform.colorTransform = _loc3_;
			this.DecrementArrow.visible = (param1.value > param1.basevalue);
			this.IncrementArrow.visible = (LevelUpMenu.instance.SPCount > 0 && param1.value < LevelUpMenu._instance.maxSkillLevel);
		}
	}
}
