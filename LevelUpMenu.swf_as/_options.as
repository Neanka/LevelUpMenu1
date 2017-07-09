package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.events.Event;
	import flash.events.FocusEvent;
	//import flash.display.InteractiveObject;
	import flash.text.*;
	
	public class _options extends MovieClip {
	
	
		private const filterFlag_elig:int = 1;
		private const filterFlag_notelig:int = 2;
		private const filterFlag_highlvl:int = 4;
		private const filterFlag_S:int = 8;
		private const filterFlag_P:int = 16;
		private const filterFlag_E:int = 32;
		private const filterFlag_C:int = 64;
		private const filterFlag_I:int = 128;
		private const filterFlag_A:int = 256;
		private const filterFlag_L:int = 512;
		private const filterFlag_NonSpecial:int = 1024;
		private const filterFlag_Other:int = 2048;
		public var S_cb: def_controls_cb;
		public var P_cb: def_controls_cb;
		public var E_cb: def_controls_cb;
		public var C_cb: def_controls_cb;
		public var I_cb: def_controls_cb;
		public var A_cb: def_controls_cb;
		public var L_cb: def_controls_cb;
		public var nonspec_cb: def_controls_cb;
		public var another_cb: def_controls_cb;
		public var filterCb: def_controls_cb;
		public var filter_mc: filterbox;
		//public var PreviousStageFocus:flash.display.InteractiveObject;
		
		
		public function _options() {
			S_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			P_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			E_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			C_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			I_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			A_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			L_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			nonspec_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			another_cb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			filterCb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			filter_mc.addEventListener(MouseEvent.CLICK, this.onFilterClick);
			filter_mc.search_tf.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			filter_mc.search_tf.addEventListener(Event.CHANGE, changeHandler);
			S_cb.settext("S");
			P_cb.settext("P");
			E_cb.settext("E");
			C_cb.settext("C");
			I_cb.settext("I");
			A_cb.settext("A");
			L_cb.settext("L");
			nonspec_cb.settext("Non SPECIAL");
			another_cb.settext("Another");
			filterCb.settext("Ineligible");
			nonspec_cb.tunewidth(50);
			another_cb.tunewidth(25);
			filterCb.tunewidth(25);
		}
		
		private function onFilterClick(event: Event) {
			StartEditText();
		}
		
        private function changeHandler(e:Event):void {
            //parent.Options_mc.visible=false;
			parent.PerkList_mc.filterer.itemFilterString = filter_mc.search_tf.text;
			parent.PerkList_mc.InvalidateData();
        }
		
		public function StartEditText()
		{
			//FeaturePanel_mc.List_mc.disableInput = true;
			filter_mc.search_tf.type = TextFieldType.INPUT;
			filter_mc.search_tf.selectable = true;
			filter_mc.search_tf.maxChars = 100;
			//PreviousStageFocus = stage.focus;
			stage.focus = filter_mc.search_tf;
			filter_mc.search_tf.setSelection(0, filter_mc.search_tf.text.length);
			try
			{
				root.f4se.AllowTextInput(true);
			}
			catch(e:Error)
			{
				trace("Failed to enable text input");
			}
		}
		
		public function EndEditText()
		{			
			//FeaturePanel_mc.List_mc.disableInput = false;
			filter_mc.search_tf.type = TextFieldType.DYNAMIC;
			filter_mc.search_tf.setSelection(0,0);
			filter_mc.search_tf.selectable = false;
			filter_mc.search_tf.maxChars = 0;
			//stage.focus = PreviousStageFocus;
			try
			{
				root.f4se.AllowTextInput(false);
			}
			catch(e:Error)
			{
				trace("Failed to disable text input");
			}
		}
		
        private function focusOutHandler(event:FocusEvent):void {
			EndEditText();
		}
		
		private function onCbClick(event: Event) {
			var tempflag: int = 0;
			switch (event.currentTarget) {
				case S_cb:
					tempflag = filterFlag_S;
					break;
				case P_cb:
					tempflag = filterFlag_P;
					break;
				case E_cb:
					tempflag = filterFlag_E;
					break;
				case C_cb:
					tempflag = filterFlag_C;
					break;
				case I_cb:
					tempflag = filterFlag_I;
					break;
				case A_cb:
					tempflag = filterFlag_A;
					break;
				case L_cb:
					tempflag = filterFlag_L;
					break;
				case nonspec_cb:
					tempflag = filterFlag_NonSpecial;
					break;
				case another_cb:
					tempflag = filterFlag_Other;
					break;
				case filterCb:
					tempflag = filterFlag_notelig;
					break;
				default:
					break;
			}
			event.currentTarget.togglecheck();
			if (event.currentTarget.bChecked) parent.addflag(tempflag) else parent.remflag(tempflag);
		}
		
		
	}
	
}
