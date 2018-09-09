package  {
	
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	
	public class def_controls_cb extends MovieClip {
	
		public var text_tf: TextField;
		public var cb_x: MovieClip;
		public var bChecked: Boolean;
		public var bg: MovieClip;
		
		public function def_controls_cb() {
			// constructor code
			super();
			//cb_x.visible = false;
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.text_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			bChecked = true;
		}		
		public function togglecheck(): *
		{
			bChecked = !bChecked;
			cb_x.visible = bChecked;
		}	
		public function setcheck(par1: Boolean): *
		{
			bChecked = par1;
			cb_x.visible = bChecked;
		}
		
		public function settext(par1: String): *
		{
			//
			//text_tf.text = par1;
			GlobalFunc.SetText(this.text_tf, par1, true);
		}	
		public function tunewidth(par1: int): *
		{
			text_tf.width += par1;
			bg.width += par1;
		}	
	}
	
}
