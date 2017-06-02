package {

	import flash.display.MovieClip;
	import flash.events.*;
	import debug.Log;


	public dynamic
	class rooot_levelup extends MovieClip {
		public static const F4SE_INITIALIZED:String = "F4SE::Initialized";
		private static var _instance:rooot_levelup;
		
		public var f4seinit: Boolean = false;
		
		public var Menu_mc: LevelUpMenu;


		public function rooot_levelup() {
			Log.info("constructor starting")
			rooot_levelup._instance = this;
			this.addEventListener(F4SE_INITIALIZED, this.initialized);
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
		}
		
      private function init(e:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);

      }
      public static function get instance() : rooot_levelup
      {
         return _instance;
      }

		private function initialized(e: Event): void {
			removeEventListener(F4SE_INITIALIZED, this.initialized);
			Log.info("f4se initialized")
			trace("root.f4se "+root.f4se);
			f4seinit = true;
			stage.dispatchEvent(new Event(F4SE_INITIALIZED));
			root.f4se.SendExternalEvent("LevelUpInit");
		}

	}

}