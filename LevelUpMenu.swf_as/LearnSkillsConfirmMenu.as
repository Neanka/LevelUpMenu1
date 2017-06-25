package
{
   import Shared.AS3.BSUIComponent;
	import Shared.AS3.BSScrollingList;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import Shared.GlobalFunc;
	
   public dynamic class LearnSkillsConfirmMenu extends BSUIComponent
   {
		public static const CONFIRM_TYPE_NONE:uint = 0;
		public static const CONFIRM_TYPE_PERK:uint = 1;
		public static const CONFIRM_TYPE_SKILL:uint = 2;
		public var confirmtype: uint;
		public var confirmlist_mc: confirmlist;
		public var opened: Boolean;
		public var confirmtext_tf: TextField;
		public var itemtext_tf: TextField;
		protected var prevFocusObj:InteractiveObject;
		public var tttarget: Object;

		public function LearnSkillsConfirmMenu()
      {
         super();
		 setprops();
		 opened = false;
		 visible = false;
      }
	  
	  public function Open(aPrevFocusObj:InteractiveObject, atext: String, ttarget: Object = null){
		this.prevFocusObj = aPrevFocusObj;
		GlobalFunc.SetText(this.confirmtext_tf,atext,false);
		if (ttarget) {
			GlobalFunc.SetText(this.itemtext_tf,ttarget.text,false);
			tttarget = ttarget;
		}

		visible = true;
		opened = true;
	  }
	  
		public function get prevFocus():InteractiveObject{
            return (this.prevFocusObj);
        }
		
	  public function Close(){
	  //stage.focus = this.prevFocusObj;
		this.prevFocusObj = null;
		this.tttarget = null;
		visible = false;
		opened = false;
		confirmtype = CONFIRM_TYPE_NONE;
	  }
	  
	  function setprops(){
	  			try {
				this.confirmlist_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.confirmlist_mc.listEntryClass = "confirm_listentry";
			this.confirmlist_mc.numListItems = 2;
			this.confirmlist_mc.restoreListIndex = false;
			this.confirmlist_mc.textOption = "None";
			this.confirmlist_mc.verticalSpacing = 0;
			try {
				this.confirmlist_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}

   }
}