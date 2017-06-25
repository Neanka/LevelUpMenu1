package
{
   import Shared.AS3.BSUIComponent;
	import Shared.AS3.BSScrollingList;
	
   public dynamic class Intense_training_menu extends BSUIComponent
   {
		public var stats_list: Stats_List;
		public var opened: Boolean;

		public function Intense_training_menu()
      {
         super();
		 setprops();
		 opened = false;
		 visible = false;
      }
	  
	  public function Open(){
		visible = true;
		opened = true;
	  }
	  
	  public function Close(){
		visible = false;
		opened = false;
	  }
	  
	  function setprops(){
	  			try {
				this.stats_list["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.stats_list.listEntryClass = "Stats_ListEntry";
			this.stats_list.numListItems = 13;
			this.stats_list.restoreListIndex = false;
			this.stats_list.textOption = "None";
			this.stats_list.verticalSpacing = 0;
			try {
				this.stats_list["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}
   }
}