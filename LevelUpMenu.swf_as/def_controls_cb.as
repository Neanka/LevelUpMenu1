package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class def_controls_cb extends MovieClip {
	
		public var text_tf: TextField;
		public var cb_x: MovieClip;
		public var bChecked: Boolean;
		public var bg: MovieClip;
		
		public function def_controls_cb() {
			// constructor code
			super();
			//cb_x.visible = false;
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
			text_tf.text = par1;
		}	
		public function tunewidth(par1: int): *
		{
			text_tf.width += par1;
			bg.width += par1;
		}	
	}
	
}
