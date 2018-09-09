package
{
	import Shared.AS3.BSUIComponent;
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import Shared.GlobalFunc;
	
	public dynamic class InfoWindow extends BSUIComponentEx
	{
		public var confirmlist_mc:confirmlist;
		public var opened:Boolean;
		public var text_tf:TextField;
		public var bg_mc: MovieClip;
		
		public function InfoWindow()
		{
			super();
			setprops();
			confirmlist_mc.border.height = 35;
			confirmlist_mc.y += 35;
			opened = false;
			visible = false;
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.text_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
		
		public function Open(aPrevFocusObj:InteractiveObject, atext:String, ttarget:Object = null)
		{
			root.f4se.plugins.PRKF.PlaySound2("UIMenuPopUpGeneric");
			this.prevFocusObj = aPrevFocusObj;
			var tempstring: String;
			tempstring = atext.replace(/\$Rank:/g, LevelUpMenu.Translator("$Rank:"));
			tempstring = tempstring.replace(/\$PRKF_Requires/g, LevelUpMenu.Translator("$PRKF_Requires"));
			tempstring = tempstring.replace(/\$PRKF_Level/g, LevelUpMenu.Translator("$PRKF_Level"));
			tempstring = tempstring.replace(/\$PRKF_Learned/g, LevelUpMenu.Translator("$PRKF_Learned"));
			tempstring = tempstring.replace(/\$PRKF_NotLearned/g, LevelUpMenu.Translator("$PRKF_NotLearned"));
			tempstring = tempstring.replace(/\$PRKF_or/g, LevelUpMenu.Translator("$PRKF_or"));
			
			GlobalFunc.SetText(this.text_tf, tempstring, true);
			this.bg_mc.height = this.text_tf.textHeight + 55;
			confirmlist_mc.y = this.text_tf.textHeight + 20;
			this.y = (720 - (this.text_tf.textHeight + 55)) / 2;
			this.redrawCustomBrackets(bg_mc);			
			visible = true;
			opened = true;
			this.confirmlist_mc.selectedIndex = 0;
		}
		
		public function get prevFocus():InteractiveObject
		{
			return (this.prevFocusObj);
		}
		
		public function Close()
		{
			//stage.focus = this.prevFocusObj;
			this.prevFocusObj = null;
			visible = false;
			opened = false;
		}
		
		function setprops()
		{
			try
			{
				this.confirmlist_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.confirmlist_mc.listEntryClass = "confirm_listentry";
			this.confirmlist_mc.numListItems = 1;
			this.confirmlist_mc.restoreListIndex = false;
			this.confirmlist_mc.textOption = "None";
			this.confirmlist_mc.verticalSpacing = 0;
			try
			{
				this.confirmlist_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
	
	}
}