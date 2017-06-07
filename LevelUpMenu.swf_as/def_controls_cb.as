package  {
	
	import flash.display.MovieClip;
	
	
	public class def_controls_cb extends MovieClip {
		
		public var cb_x: MovieClip;
		public var bChecked: Boolean;
		
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
	}
	
}
