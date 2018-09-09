package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	import flash.geom.ColorTransform;
	import com.greensock.*;
	
	public class LevelUpMenu extends IMenu
	{
		
		private var debugmode:Boolean = false;
		private static var _instance:LevelUpMenu;
		public var bgholder_mc:def_BG_Holder;
		public var Intense_training_menu_mc:Intense_training_menu;
		public var LearnSkillsConfirmMenu_mc:LearnSkillsConfirmMenu;
		public var InfoWindow_mc:InfoWindow;
		public var List_mc:BSScrollingList;
		public var PerkList_mc:BSScrollingList;
		private var _SampleList:Array;
		private var _SampleList1:Array;
		private var _SampleList3:Array;
		
		private var _Specials:Array;
		
		public var specials_mc:MovieClip;
		
		public var Options_mc:MovieClip;
		public var gear_mc:MovieClip;
		public var VBHolder_mc:MovieClip;
		public var Description_tf:TextField;
		public var countField:TextField;
		public var countField1:TextField;
		public var textField:TextField;
		public var textField1:TextField;
		public var info_textField:TextField;
		
		public var Reqs_tf:TextField;
		public var atf:TextField;
		//private const SkillsClipNameMap: Array = ["Barter", "Energy Weapons", "Explosives", "Guns", "LockPick", "Medicine", "Melee Weapons", "Repair", "Science", "Sneak", "Speech", "Survival", "Unarmed"];
		private var _VBLoader:Loader;
		private var uiSPCount:uint;
		private var uiPPCount:uint;
		public var loaded:uint = 0;
		private const TYPE_INTENSETRAINING:int = 8;
		private const TYPE_CANCEL:int = 9;
		
		private var startexit:Boolean = false;
		
		private var LearnSkillsButton:BSButtonHintData;
		private var LearnPerkButton:BSButtonHintData;
		private var CancelLearnSkillsButton:BSButtonHintData;
		private var skillschanged:Boolean = false;
		private var bskillsconfirmation:Boolean = false;
		private var SPCountBase:int = 0;
		public var _fF:int = int.MAX_VALUE;
		private var _fFinit:int = 0;
		private var _oldIndex:int = 0;
		
		private var perksOnly:Boolean = false;
		
		public var GridView_mc:PerkGrid;
		
		public var PerkInfo_mc:MovieClip;
		
		public var XPMeterHolder_mc:MovieClip;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		private var uiPerkCount:uint;
		
		private var ToggleTagSkillButton:BSButtonHintData;
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		private var SwitchButton:BSButtonHintData;
		private var PerkInfoButon:BSButtonHintData;
		private var IneligibleButton:BSButtonHintData;
		
		public var traitsMode:Boolean = false;
		public var traitsModeAllowClose:Boolean = true;
		
		public var tagSkillsMode:Boolean = false;
		public var tagSPtoAdd:int = 0;
		public var tagSkillsAllowRetag:Boolean = false;
		
		public var maxSkillLevel: int = 100;
		
		static public var bPlaySound:Boolean = true;
		public var bPlayPerkSound:Boolean = true;
		public var bPlayPerkSoundLoop:Boolean = true;
		
		private var rightPressed: Boolean = false;
		private var leftPressed: Boolean = false;
		
		public var BGSCodeObj:Object;
		
		public function LevelUpMenu()
		{
			LevelUpMenu._instance = this;
			this.ToggleTagSkillButton = new BSButtonHintData("$Choose", "Enter", "PSN_A", "Xenon_A", 1, this.toggleTagSkill);
			this.AcceptButton = new BSButtonHintData("$ACCEPT", "Enter", "PSN_A", "Xenon_A", 1, this.onAcceptPressed);
			this.LearnSkillsButton = new BSButtonHintData("$PRKF_LEARN_SKILLS", "Enter", "PSN_A", "Xenon_A", 1, this.onLearnSkillsPressed);
			this.LearnPerkButton = new BSButtonHintData("$PRKF_LEARN_PERK", "Enter", "PSN_A", "Xenon_A", 1, this.onLearnPerkButtonPressed);
			this.PerkInfoButon = new BSButtonHintData("$PRKF_PERK_INFORMATION", "R", "PSN_X", "Xenon_X", 1, this.onShowPerkRanksInfoPressed);
			this.CancelLearnSkillsButton = new BSButtonHintData("$CANCEL", "Tab", "PSN_B", "Xenon_B", 1, this.onCancelLearnSkillsPressed);
			this.CancelButton = new BSButtonHintData("$CLOSE", "Tab", "PSN_B", "Xenon_B", 1, this.onCancelPressed);
			this.SwitchButton = new BSButtonHintData("$SWITCH", "Ctrl", "PSN_L1", "Xenon_L1", 1, this.switchTabs);
			this.SwitchButton.SetSecondaryButtons("Alt", "PSN_R1", "Xenon_R1");
			this.SwitchButton.secondaryButtonCallback = this.switchTabs;
			this.IneligibleButton = new BSButtonHintData("$PRKF_SHOW_INELIGIBLE", "T", "PSN_Y", "Xenon_Y", 1, this.onIneligibleButtonPressed);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.GridView_mc.visible = false;
			this.SetButtons();
			this.PerkInfo_mc.visible = false;
			this.XPMeterHolder_mc.visible = false;
			VBHolder_mc.scaleX = 0.8;
			VBHolder_mc.scaleY = 0.8;
			//---my
			this._VBLoader = new Loader();
			addEventListener(BSScrollingList.LIST_ITEMS_CREATED, this.itemsCreated);
			addEventListener(BSScrollingList.ITEM_PRESS, this.onItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE, this.onSelectionChange);
			//addEventListener(KeyboardEvent.KEY_DOWN, this.onMenuKeyDown);
			//addEventListener(KeyboardEvent.KEY_UP, this.onMenuKeyUp);
			addEventListener(ArrowButton.MOUSE_UP, this.onArrowClick);
			addEventListener(ItemList.MOUSE_OVER, this.onListMouseOver);
			gear_mc.addEventListener(MouseEvent.CLICK, this.onGEARMCClick);
			//---
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.XPMeterHolder_mc.textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Description_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.info_textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
			this.__setProp_XPMeterHolder_mc_MenuObj_XPMeter_0();
			//---my
			
			this.__setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0();
			this.__setProp_bgholder_mc_MenuObj_bgholder_mc_0();
			this.__setProp_List_mc_MenuObj_List_mc_0();
			this.__setProp_PerkList_mc_MenuObj_PerkList_mc_0();
			this.__setProp_Intense_training_menu_mc_MenuObj_Intense_training_menu_mc_0();
			this.__setProp_LearnSkillsConfirmMenu_mc_MenuObj_LearnSkillsConfirmMenu_mc_0();
			this.__setProp_InfoWindow_mc();
			this.Options_mc.visible = false;
			//newlist1();
			//---
		
		}
		
		private function itemsCreated(e:Event):void
		{
			trace(e.target, "items created");
		}
		
		public static function get instance():LevelUpMenu
		{
			return _instance;
		}
		
		public function applycolor()
		{
			trace("colors applied 1");
			var _loc3_:ColorTransform = this.ButtonHintBar_mc.transform.colorTransform;
			for (var i:uint = 0; i < this.numChildren; i++)
			{
				this.getChildAt(i).transform.colorTransform = _loc3_;
			}
		}
		
		private function onListMouseOver(event:Event)
		{
			if (!AnyWindowOpened())
			{
				if ((event.target == this.List_mc) && !(stage.focus == List_mc))
				{
					stage.focus = this.List_mc;
					this.PerkList_mc.selectedIndex = -1;
				}
				else
				{
					if ((event.target == this.PerkList_mc) && !(stage.focus == this.PerkList_mc))
					{
						stage.focus = this.PerkList_mc;
						this.List_mc.selectedIndex = -1;
					}
					;
				}
				;
				SetButtons();
			}
		}
		
		private function PopulateButtonBar():void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			
			_loc1_.push(this.ToggleTagSkillButton);
			_loc1_.push(this.AcceptButton);
			_loc1_.push(this.LearnSkillsButton);
			
			_loc1_.push(this.LearnPerkButton);
			_loc1_.push(this.PerkInfoButon);
			
			_loc1_.push(this.IneligibleButton);
			_loc1_.push(this.SwitchButton);
			_loc1_.push(this.CancelLearnSkillsButton);
			_loc1_.push(this.CancelButton);
			//   _loc1_.push(this.NextPerkButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function onCodeObjCreate():*
		{
			//this.GridView_mc.codeObj = this.BGSCodeObj;
			//this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			CheckPlugins();
			root.f4se.plugins.PRKF.OpenMenu();
			var _loc1_:Object = new Object();
			this.BGSCodeObj.GetXPInfo(_loc1_);
			specials_mc.lvlc_tf.text = _loc1_.level;
			//GlobalFunc.SetText(this.XPMeterHolder_mc.textField, "$$LEVEL " + _loc1_.level, false);
			//this.XPMeterHolder_mc.Meter_mc.SetMeter(_loc1_.currXP, 0, _loc1_.maxXP);
		
			//this.GridView_mc.InvalidateGrid();
			//this.GridView_mc.addEventListener(PerkGrid.TEXTURES_LOADED, this.onGridTexturesLoaded);
			//---my
			//		root.f4se.SendExternalEvent("LevelUp::RequestSkills");
		}
		
		public function CheckPlugins():*
		{
			if (!root.f4se)
			{
				this.InfoWindow_mc.Open(null, "\n\nF4SE Status: FAIL\n\nF4SE is not running. Make sure that F4SE is installed and that you have launched the game with f4se_loader.exe.\n\n");
			}
		}
		
		public function onRequestSkills(param1:uint, param2:Array):*
		{
			atrace("skillsrecieved");
			
			this.SPCount = param1;
			
			this._SampleList = new Array();
			var i:int = 0;
			for each (var obj in param2)
			{
				this._SampleList.push({text: obj["__var__"]["__struct__"]["__data__"]["stext"], description: obj["__var__"]["__struct__"]["__data__"]["sdescription"], value: obj["__var__"]["__struct__"]["__data__"]["ivalue"], clipIndex: obj["__var__"]["__struct__"]["__data__"]["iclipIndex"], basevalue: obj["__var__"]["__struct__"]["__data__"]["ivalue"]});
				i++;
			}
			atrace("filling array finished");
			this.List_mc.entryList = this._SampleList;
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			this.List_mc.selectedIndex = 0;
			this.SetButtons();
		}
		
		public function addflag(afl:int)
		{
			_fF |= afl;
			this.PerkList_mc.filterer.itemFilter = _fF;
			this.PerkList_mc.InvalidateData();
			this.PerkList_mc.selectedIndex = this.PerkList_mc.GetEntryFromClipIndex(0);
		}
		
		public function remflag(afl:int)
		{
			_fF &= ~afl;
			this.PerkList_mc.filterer.itemFilter = _fF;
			this.PerkList_mc.InvalidateData();
			this.PerkList_mc.selectedIndex = this.PerkList_mc.GetEntryFromClipIndex(0);
		}
		
		public function checkFlag(afl:int):Boolean
		{
			//atrace(String(afl) + " " + String(_fF)+ " "+ String(afl & _fF));
			return (afl & _fF) == afl;
		}
		
		public function menuStart(perks_array:Array, skills_array:Array, aPPCount:int, aSPCount:int):*
		{
			//trace("\n\nmenuStart");
			this.tagSkillsMode = false;
			this.traitsMode = false;
			this.specials_mc.visible = true;
			this.Options_mc.visible = false;
			this.gear_mc.visible = true;
			this.PPCount = aPPCount;
			GlobalFunc.SetText(this.textField, "$PRKF_PP_AVAILABLE", true);
			GlobalFunc.SetText(this.info_textField, "", true);
			//trace("bp1");
			
			if (skills_array.length == 0 && loaded == 0)
			{
				this.List_mc.visible = false;
				this.bgholder_mc.width = 820;
				this.x = 180;
				this.LearnSkillsConfirmMenu_mc.x = 470 - 180;
				this.InfoWindow_mc.x = 270 - 180;
				this.ButtonHintBar_mc.x = 640 - 180;
				//this.Intense_training_menu_mc.x -= 180;
				
				this.textField1.visible = false;
				this.countField1.visible = false;
				//specials_mc.scaleX = 0.7;
				//specials_mc.scaleY = 0.7;
				perksOnly = true;
				specials_mc.x = 60 - 180;
				
			}
			//trace("bp2");
			//IT_array.push({
			//	text: "$Cancel",
			//	type: TYPE_CANCEL
			//});
			//this.Intense_training_menu_mc.stats_list.entryList = IT_array; //this._SampleList3;
			//this.Intense_training_menu_mc.stats_list.InvalidateData();
			
			atrace("filling array finished");
			var oldindex:int = this.PerkList_mc.selectedIndex;
			this.PerkList_mc.selectedIndex = -1;
			
			this.PerkList_mc.entryList = perks_array;
			this.PerkList_mc.filterer.itemFilter = _fF;
			this.PerkList_mc.InvalidateData();
			//trace("bp3");
			if (stage.focus != this.List_mc)
			{
				if (oldindex < 0)
				{
					this.PerkList_mc.selectedIndex = 0; //GetEntryFromClipIndex(0);
				}
				else
				{
					this.PerkList_mc.selectedIndex = oldindex;
				}
			}
			//trace("bp4");
			if (loaded == 0) stage.focus = this.PerkList_mc;
			loaded = 1;
			//trace("bp5");
			if (!skillschanged)
			{
				var oldindex1:int = this.List_mc.selectedIndex;
				this.List_mc.selectedIndex = -1;
				this.SPCount = aSPCount;
				this.SPCountBase = aSPCount;
				this.List_mc.entryList = skills_array;
				this.List_mc.InvalidateData();
				if (stage.focus != this.PerkList_mc)
				{
					if (oldindex1 < 0)
					{
						this.List_mc.selectedIndex = 0; //GetEntryFromClipIndex(0);
					}
					else
					{
						this.List_mc.selectedIndex = oldindex1;
					}
				}
			}
			//trace("bp6");
			var yesno:Array = new Array();
			yesno.push({text: "$YES"});
			yesno.push({text: "$NO"});
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.entryList = yesno;
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.InvalidateData();
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 0;
			
			var ok:Array = new Array();
			ok.push({text: "$OK"});
			this.InfoWindow_mc.confirmlist_mc.entryList = ok;
			this.InfoWindow_mc.confirmlist_mc.InvalidateData();
			this.InfoWindow_mc.confirmlist_mc.selectedIndex = 0;
			this.SetButtons();
			//trace("bp7");
		}
		
		public function tagSkillsModeStart(skills_array:Array, skillsNum:int, skillsPoints:int, allowRetag:Boolean):*
		{
			startexit = false;
			this.tagSkillsMode = true;
			this.tagSkillsAllowRetag = allowRetag;
			this.specials_mc.visible = false;
			this.Options_mc.visible = false;
			this.gear_mc.visible = false;
			this.SPCount = 0;
			this.PPCount = skillsNum;
			this.tagSPtoAdd = skillsPoints;
			this.tagSkillsAllowRetag = allowRetag;
			GlobalFunc.SetText(this.textField, "$PRKF_TAG_SKILLS_AVAILABLE", true);
			GlobalFunc.SetText(this.info_textField, "$PRKF_TAG_SKILLS_TEXT", true);
			this.PerkList_mc.visible = false;
			this.List_mc.x = 90;
			this.bgholder_mc.width = 820;
			this.x = 180;
			this.LearnSkillsConfirmMenu_mc.x = 470 - 180;
			this.InfoWindow_mc.x = 270 - 180;
			this.ButtonHintBar_mc.x = 640 - 180;
			//this.Intense_training_menu_mc.x -= 180;
			
			this.textField1.visible = false;
			this.countField1.visible = false;
			//specials_mc.scaleX = 0.7;
			//specials_mc.scaleY = 0.7;
			perksOnly = true;
			specials_mc.x = 60 - 180;
			
			this.List_mc.entryList = skills_array;
			this.List_mc.InvalidateData();
			this.List_mc.selectedIndex = 0; //GetEntryFromClipIndex(0);
			
			stage.focus = this.List_mc;
			loaded = 1;
			
			var yesno:Array = new Array();
			yesno.push({text: "$YES"});
			yesno.push({text: "$NO"});
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.entryList = yesno;
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.InvalidateData();
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 0;
			
			var ok:Array = new Array();
			ok.push({text: "$OK"});
			this.InfoWindow_mc.confirmlist_mc.entryList = ok;
			this.InfoWindow_mc.confirmlist_mc.InvalidateData();
			this.InfoWindow_mc.confirmlist_mc.selectedIndex = 0;
			
			this.SetButtons();
		}
		
		public function traitsModeStart(traits_array:Array, aTPCount:int, allowClose:Boolean):*
		{
			this.traitsMode = true;
			this.traitsModeAllowClose = allowClose;
			
			this.specials_mc.visible = false;
			this.Options_mc.visible = false;
			this.gear_mc.visible = false;
			
			this.SPCount = 0;
			this.PPCount = aTPCount;
			GlobalFunc.SetText(this.textField, "$PRKF_TP_AVAILABLE", true);
			
			this.List_mc.visible = false;
			this.bgholder_mc.width = 820;
			this.x = 180;
			this.LearnSkillsConfirmMenu_mc.x = 470 - 180;
			this.InfoWindow_mc.x = 270 - 180;
			this.ButtonHintBar_mc.x = 640 - 180;
			//this.Intense_training_menu_mc.x -= 180;
			
			this.textField1.visible = false;
			this.countField1.visible = false;
			//specials_mc.scaleX = 0.7;
			//specials_mc.scaleY = 0.7;
			perksOnly = true;
			specials_mc.x = 60 - 180;
			
			var oldindex:int = this.PerkList_mc.selectedIndex;
			this.PerkList_mc.selectedIndex = -1;
			
			this.PerkList_mc.entryList = traits_array;
			this.PerkList_mc.filterer.itemFilter = int.MAX_VALUE;
			this.PerkList_mc.InvalidateData();
			
			this.PerkList_mc.selectedIndex = 0; //GetEntryFromClipIndex(0);
			stage.focus = this.PerkList_mc;
			loaded = 1;
			
			var yesno:Array = new Array();
			yesno.push({text: "$YES"});
			yesno.push({text: "$NO"});
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.entryList = yesno;
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.InvalidateData();
			this.LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 0;
			
			var ok:Array = new Array();
			ok.push({text: "$OK"});
			this.InfoWindow_mc.confirmlist_mc.entryList = ok;
			this.InfoWindow_mc.confirmlist_mc.InvalidateData();
			this.InfoWindow_mc.confirmlist_mc.selectedIndex = 0;
			
			this.SetButtons();
			info_text: String = "";
			if (allowClose)
			{
				info_text = Translator("$PRKF_TP_TEXT_ALLOW_CLOSE");
			}
			else
			{
				info_text = Translator("$PRKF_TP_TEXT");
			}
			info_text = info_text.replace(/\$\$num/g, aTPCount);
			GlobalFunc.SetText(this.info_textField, info_text, true);
		}
		
		public function onCodeObjDestruction():*
		{
			trace("onCodeObjDestruction");
			root.f4se.plugins.PRKF.CloseMenu();
			this.BGSCodeObj = null;
		}
		
		private function onGridTexturesLoaded():*
		{
			
			trace("onGridTexturesLoaded");
		}
		
		public function get perkCount():uint
		{
			return this.uiPerkCount;
		}
		
		public function set perkCount(param1:uint):*
		{
			this.uiPerkCount = param1;
			this.GridView_mc.perkCount = param1;
		}
		
		public function get SPCount():uint
		{
			return this.uiSPCount;
		}
		
		public function set SPCount(param1:uint):*
		{
			
			GlobalFunc.SetText(this.countField1, String(param1), false);
			this.uiSPCount = param1;
			//this.AcceptButton.ButtonDisabled = param1 != 0 && PPCount == 0;
		}
		
		public function get PPCount():uint
		{
			return this.uiPPCount;
		}
		
		public function set PPCount(param1:uint):*
		{
			
			GlobalFunc.SetText(this.countField, String(param1), false);
			this.uiPPCount = param1;
			//this.AcceptButton.ButtonDisabled = param1 != 0 && SPCount == 0;
		}
		
		public function set ratio16x10(param1:Boolean):*
		{
		
		}
		
		public function set Specials(value:Array):void
		{
			_Specials = value;
			specials_mc.sc_tf.text = value[0];
			specials_mc.pc_tf.text = value[1];
			specials_mc.ec_tf.text = value[2];
			specials_mc.cc_tf.text = value[3];
			specials_mc.ic_tf.text = value[4];
			specials_mc.ac_tf.text = value[5];
			specials_mc.lc_tf.text = value[6];
		}
		
		public function set fFinit(value:int):void
		{
			_fFinit = value;
			if (_fFinit > 0)
			{
				addflag(_fFinit);
			}
			else
			{
				remflag(-1 * _fFinit);
			}
			this.Options_mc.filterCb.setcheck(checkFlag(_options.filterFlag_notelig));
		}
		
		private function onAcceptPressed():Boolean
		{
			if (traitsMode && !traitsModeAllowClose && PPCount > 0)
			{
				return;
			}
			if (tagSkillsMode)
			{
				if (PPCount > 0)
				{
					return;
				}
				else if (startexit)
				{
					startexit = false;
				}
				else
				{
					startexit = true;
					onConfirmTagSkillsPressed();
					return;
				}
			}
			//var temparray: Array = new Array();
			//for each(var obj in this.List_mc.entryList) {
			//	temparray.push(obj.value);
			//}
			//root.f4se.SendExternalEvent("LevelUp::ReturnSkills", temparray);
			try
			{
				root.f4se.AllowTextInput(false);
			}
			catch (e:Error)
			{
				trace("Failed to disable text input");
			}
			this.BGSCodeObj.CloseMenu();
		}
		
		private function onConfirmTagSkillsPressed():Boolean
		{
			
			this.LearnSkillsConfirmMenu_mc.confirmtype = LearnSkillsConfirmMenu.CONFIRM_TYPE_TAGSKILLS;
			this.LearnSkillsConfirmMenu_mc.Open(stage.focus, "$PRKF_TAG_SELECTED_SKILLS?");
			stage.focus = this.LearnSkillsConfirmMenu_mc.confirmlist_mc;
			this.PerkList_mc.disableInput = true;
			this.PerkList_mc.disableSelection = true;
			this.List_mc.disableInput = true;
			this.List_mc.disableSelection = true;
			SetButtons();
		}
		
		private function onLearnSkillsPressed():Boolean
		{
			
			this.LearnSkillsConfirmMenu_mc.confirmtype = LearnSkillsConfirmMenu.CONFIRM_TYPE_SKILL;
			this.LearnSkillsConfirmMenu_mc.Open(stage.focus, "$PRKF_LEARN_SKILLS?");
			stage.focus = this.LearnSkillsConfirmMenu_mc.confirmlist_mc;
			this.PerkList_mc.disableInput = true;
			this.PerkList_mc.disableSelection = true;
			this.List_mc.disableInput = true;
			this.List_mc.disableSelection = true;
			SetButtons();
		}
		
		private function onShowPerkRanksInfoPressed():Boolean
		{
			InfoWindow_mc.Open(stage.focus, this.PerkList_mc.selectedEntry.text + "<br><br>" + this.PerkList_mc.selectedEntry.ranksInfo);
			stage.focus = this.InfoWindow_mc.confirmlist_mc;
			this.PerkList_mc.disableInput = true;
			this.PerkList_mc.disableSelection = true;
			this.List_mc.disableInput = true;
			this.List_mc.disableSelection = true;
			SetButtons();
		}
		
		private function onLearnSkillsConfirm():Boolean
		{
			
			stage.focus = this.LearnSkillsConfirmMenu_mc.prevFocus;
			var learn:Boolean = (LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex == 0);
			this.LearnSkillsConfirmMenu_mc.Close()
			this.PerkList_mc.disableInput = false;
			this.PerkList_mc.disableSelection = false;
			this.List_mc.disableInput = false;
			this.List_mc.disableSelection = false;
			if (learn)
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuOK");
				var temparray:Array = new Array();
				for each (var obj in this.List_mc.entryList)
				{
					temparray.push({iformid: obj.formid, ivalue: obj.value - obj.basevalue});
				}
				try
				{
					skillschanged = false;
					root.f4se.plugins.PRKF.LearnSkills(temparray, SPCount - SPCountBase);
				}
				catch (e:Error)
				{
					trace("Failed to call root.f4se.plugins.PRKF.LearnSkills()")
				}
			}
			else
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuCancel");
			}
			//stage.focus = this.List_mc;
			SetButtons();
		}
		
		private function onCancelLearnSkillsPressed():Boolean
		{
			SPCount = SPCountBase;
			for each (var obj in this.List_mc.entryList)
			{
				obj.value = obj.basevalue;
				this.List_mc.UpdateList();
				skillschanged = false;
				SetButtons();
			}
		}
		
		private function onCancelPressed():Boolean
		{
			onAcceptPressed();
		}
		
		public function InvalidateGrid():*
		{
			//this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			//this.GridView_mc.InvalidateGrid();
		}
		
		public function SetButtons():*
		{
			if (tagSkillsMode)
			{
				this.ToggleTagSkillButton.ButtonEnabled = true;
				this.ToggleTagSkillButton.ButtonVisible = this.ToggleTagSkillButton.ButtonEnabled;
				this.AcceptButton.SetButtons("R", "PSN_X", "Xenon_X");
				this.AcceptButton.ButtonEnabled = PPCount == 0;
				this.AcceptButton.ButtonVisible = true;
				this.PerkInfoButon.ButtonEnabled = false;
				this.PerkInfoButon.ButtonVisible = this.PerkInfoButon.ButtonEnabled;
				this.IneligibleButton.ButtonEnabled = false;
				this.IneligibleButton.ButtonVisible = this.IneligibleButton.ButtonEnabled;
				this.SwitchButton.ButtonEnabled = false;
				this.SwitchButton.ButtonVisible = this.SwitchButton.ButtonEnabled;
				this.LearnPerkButton.ButtonEnabled = false;
				this.LearnPerkButton.ButtonVisible = this.LearnPerkButton.ButtonEnabled;
				this.LearnSkillsButton.ButtonEnabled = false;
				;
				this.LearnSkillsButton.ButtonVisible = this.LearnSkillsButton.ButtonEnabled;
				this.CancelLearnSkillsButton.ButtonEnabled = false;
				this.CancelLearnSkillsButton.ButtonVisible = this.CancelLearnSkillsButton.ButtonEnabled;
				this.CancelButton.ButtonEnabled = false;
				this.CancelButton.ButtonVisible = this.CancelButton.ButtonEnabled;
			}
			else
			{
				this.ToggleTagSkillButton.ButtonEnabled = false;
				this.ToggleTagSkillButton.ButtonVisible = this.ToggleTagSkillButton.ButtonEnabled;
				if ((PPCount == 0 && perksOnly) || (SPCountBase == 0 && PPCount == 0 && !perksOnly))
				{
					this.AcceptButton.ButtonDisabled = false;
					this.AcceptButton.ButtonVisible = true;
				}
				else
				{
					this.AcceptButton.ButtonDisabled = true;
					this.AcceptButton.ButtonVisible = false;
				}
				this.PerkInfoButon.ButtonEnabled = (stage.focus == this.PerkList_mc && this.PerkList_mc.selectedEntry.ranksInfo);
				this.PerkInfoButon.ButtonVisible = this.PerkInfoButon.ButtonEnabled;
				this.IneligibleButton.ButtonText = checkFlag(_options.filterFlag_notelig) ? "$PRKF_HIDE_INELIGIBLE_PERKS" : "$PRKF_SHOW_INELIGIBLE_PERKS";
				this.IneligibleButton.ButtonEnabled = !AnyWindowOpened() && !traitsMode && !tagSkillsMode;
				this.IneligibleButton.ButtonVisible = this.IneligibleButton.ButtonEnabled;
				this.SwitchButton.ButtonEnabled = (!perksOnly && !AnyWindowOpened());
				this.SwitchButton.ButtonVisible = this.SwitchButton.ButtonEnabled;
				this.LearnPerkButton.ButtonText = (traitsMode || tagSkillsMode) ? "$Choose" : "$PRKF_LEARN_PERK";
				this.LearnPerkButton.ButtonDisabled = (!(PPCount > 0 && this.PerkList_mc.numListItems > 0 && this.PerkList_mc.selectedIndex > -1 && this.PerkList_mc.selectedEntry.iselig)) && !tagSkillsMode;
				this.LearnPerkButton.ButtonVisible = ((stage.focus == this.PerkList_mc) && (PPCount != 0)) || tagSkillsMode;
				this.LearnSkillsButton.ButtonDisabled = !skillschanged;
				this.LearnSkillsButton.ButtonVisible = skillschanged && (stage.focus == this.List_mc);
				this.CancelLearnSkillsButton.ButtonEnabled = skillschanged && !AnyWindowOpened();
				this.CancelLearnSkillsButton.ButtonVisible = this.CancelLearnSkillsButton.ButtonEnabled;// && (stage.focus == this.List_mc);
				this.CancelButton.ButtonDisabled = !this.CancelLearnSkillsButton.ButtonDisabled && !AnyWindowOpened() || (traitsMode && !traitsModeAllowClose) || tagSkillsMode;
				this.CancelButton.ButtonVisible = !this.CancelButton.ButtonDisabled;
			}
		}
		
		function __setProp_XPMeterHolder_mc_MenuObj_XPMeter_0():*
		{
			try
			{
				this.XPMeterHolder_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.XPMeterHolder_mc.bracketCornerLength = 6;
			this.XPMeterHolder_mc.bracketLineWidth = 1.5;
			this.XPMeterHolder_mc.bracketPaddingX = 0;
			this.XPMeterHolder_mc.bracketPaddingY = 0;
			this.XPMeterHolder_mc.BracketStyle = "horizontal";
			this.XPMeterHolder_mc.bShowBrackets = true;
			this.XPMeterHolder_mc.bUseShadedBackground = true;
			this.XPMeterHolder_mc.ShadedBackgroundMethod = "Flash";
			this.XPMeterHolder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.XPMeterHolder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_bgholder_mc_MenuObj_bgholder_mc_0():*
		{
			try
			{
				this.bgholder_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.bgholder_mc.bracketCornerLength = 6;
			this.bgholder_mc.bracketLineWidth = 1.5;
			this.bgholder_mc.bracketPaddingX = 0;
			this.bgholder_mc.bracketPaddingY = 0;
			this.bgholder_mc.BracketStyle = "vertical";
			this.bgholder_mc.bShowBrackets = true;
			this.bgholder_mc.bUseShadedBackground = true;
			this.bgholder_mc.ShadedBackgroundMethod = "Flash";
			this.bgholder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.bgholder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_Intense_training_menu_mc_MenuObj_Intense_training_menu_mc_0():*
		{
			try
			{
				this.Intense_training_menu_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.Intense_training_menu_mc.bracketCornerLength = 6;
			this.Intense_training_menu_mc.bracketLineWidth = 1.5;
			this.Intense_training_menu_mc.bracketPaddingX = 0;
			this.Intense_training_menu_mc.bracketPaddingY = 0;
			this.Intense_training_menu_mc.BracketStyle = "vertical";
			this.Intense_training_menu_mc.bShowBrackets = true;
			this.Intense_training_menu_mc.bUseShadedBackground = true;
			this.Intense_training_menu_mc.ShadedBackgroundMethod = "Flash";
			this.Intense_training_menu_mc.ShadedBackgroundType = "normal";
			try
			{
				this.Intense_training_menu_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_LearnSkillsConfirmMenu_mc_MenuObj_LearnSkillsConfirmMenu_mc_0():*
		{
			try
			{
				this.LearnSkillsConfirmMenu_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.LearnSkillsConfirmMenu_mc.bracketCornerLength = 6;
			this.LearnSkillsConfirmMenu_mc.bracketLineWidth = 1.5;
			this.LearnSkillsConfirmMenu_mc.bracketPaddingX = 0;
			this.LearnSkillsConfirmMenu_mc.bracketPaddingY = 0;
			this.LearnSkillsConfirmMenu_mc.BracketStyle = "vertical";
			this.LearnSkillsConfirmMenu_mc.bShowBrackets = true;
			this.LearnSkillsConfirmMenu_mc.bUseShadedBackground = true;
			this.LearnSkillsConfirmMenu_mc.ShadedBackgroundMethod = "Flash";
			this.LearnSkillsConfirmMenu_mc.ShadedBackgroundType = "normal";
			try
			{
				this.LearnSkillsConfirmMenu_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_InfoWindow_mc():*
		{
			try
			{
				this.InfoWindow_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.InfoWindow_mc.bracketCornerLength = 6;
			this.InfoWindow_mc.bracketLineWidth = 1.5;
			this.InfoWindow_mc.bracketPaddingX = 0;
			this.InfoWindow_mc.bracketPaddingY = 0;
			this.InfoWindow_mc.BracketStyle = "vertical";
			this.InfoWindow_mc.bShowBrackets = true;
			this.InfoWindow_mc.bUseShadedBackground = true;
			this.InfoWindow_mc.ShadedBackgroundMethod = "Flash";
			this.InfoWindow_mc.ShadedBackgroundType = "normal";
			try
			{
				this.InfoWindow_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0():*
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 0.7;
			this.ButtonHintBar_mc.BackgroundColor = 3355443;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = true;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Flash";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_List_mc_MenuObj_List_mc_0():*
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.List_mc.listEntryClass = "Skills_ListEntry";
			this.List_mc.numListItems = 13;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 0;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		function __setProp_PerkList_mc_MenuObj_PerkList_mc_0():*
		{
			try
			{
				this.PerkList_mc["componentInspectorSetting"] = true;
			}
			catch (e:Error)
			{
			}
			this.PerkList_mc.listEntryClass = "Perks_ListEntry";
			this.PerkList_mc.numListItems = 13;
			this.PerkList_mc.restoreListIndex = false;
			this.PerkList_mc.textOption = "None";
			this.PerkList_mc.verticalSpacing = 0;
			try
			{
				this.PerkList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch (e:Error)
			{
				return;
			}
		}
		
		private function onSelectionChange(param1:Event):*
		{
			
			root.f4se.plugins.PRKF.PlaySound2("UIMenuPrevNext");
			//atrace("SELECTION CHANGED");
			/*if (param1.target == this.List_mc){
			   this.PerkList_mc.selectedIndex = -1;
			   stage.focus = this.List_mc;
			   } else {
			   this.List_mc.selectedIndex = -1;
			   stage.focus = this.PerkList_mc;
			   }*/
			var _loc2_:URLRequest = null;
			var _loc3_:LoaderContext = null;
			var textReqs:String = "";
			var textDesc:String;
			
			//atrace(param1.target);
			//atrace(param1.currentTarget);
			if (this.Intense_training_menu_mc.opened)
			{
				if (this.Intense_training_menu_mc.stats_list.selectedEntry && this.Intense_training_menu_mc.stats_list.selectedEntry.description)
				{
					GlobalFunc.SetText(this.Description_tf, this.Intense_training_menu_mc.stats_list.selectedEntry.description, false);
					textReqs = Translator("$PRKF_Requires") + ": ";
					if (this.Intense_training_menu_mc.stats_list.selectedEntry.isHighLevel)
					{
						textReqs += "<font color=\'#fa8e47\'>" + Translator("$PRKF_Level") + " " + this.Intense_training_menu_mc.stats_list.selectedEntry.reqlevel + "</font>" + this.Intense_training_menu_mc.stats_list.selectedEntry.reqs;
					}
					else
					{
						textReqs += Translator("$PRKF_Level") + " " + this.Intense_training_menu_mc.stats_list.selectedEntry.reqlevel + this.Intense_training_menu_mc.stats_list.selectedEntry.reqs;
					}
					textReqs = textReqs.replace(/\$PRKF_or/g, LevelUpMenu.Translator("$PRKF_or"));
					GlobalFunc.SetText(this.Reqs_tf, textReqs, true);
					if (this.Intense_training_menu_mc.stats_list.selectedEntry.SWFPath != "")
					{
						_loc2_ = new URLRequest(this.Intense_training_menu_mc.stats_list.selectedEntry.SWFPath);
					}
					else
					{
						_loc2_ = new URLRequest("Components/VaultBoys/Perks/PerkClip_" + (this.Intense_training_menu_mc.stats_list.selectedEntry.qname & 0xFFFFFF).toString(16) + ".swf");
					}
					_loc3_ = new LoaderContext(false, ApplicationDomain.currentDomain);
					this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onVBLoadComplete);
					this._VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onVBLoadIOError);
					this._VBLoader.load(_loc2_, _loc3_);
				}
				else
				{
					GlobalFunc.SetText(this.Description_tf, "", false);
					GlobalFunc.SetText(this.Reqs_tf, "", false);
					if (this.VBHolder_mc.numChildren > 0)
					{
						this.VBHolder_mc.removeChildAt(0);
					}
				}
			}
			else if (this.LearnSkillsConfirmMenu_mc.opened)
			{
				
			}
			else
			{
				if (this.List_mc.selectedEntry && this.List_mc.selectedEntry.description)
				{
					if (bPlayPerkSound)
					{
						root.f4se.plugins.PRKF.PlayPerkSoundByName(this.List_mc.selectedEntry.qname+"_sound");
						//root.f4se.plugins.PRKF.PlaySound2(this.List_mc.selectedEntry.qname+"_sound");
					}
					GlobalFunc.SetText(this.Description_tf, this.List_mc.selectedEntry.description, false);
					GlobalFunc.SetText(this.Reqs_tf, "", false);
					_loc2_ = new URLRequest("Components/VaultBoys/Skills/" + this.List_mc.selectedEntry.qname + ".swf");
					_loc3_ = new LoaderContext(false, ApplicationDomain.currentDomain);
					this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onVBLoadComplete);
					this._VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onVBLoadIOError);
					this._VBLoader.load(_loc2_, _loc3_);
				}
				else if (this.PerkList_mc.selectedEntry && this.PerkList_mc.selectedEntry.description)
				{
					if (bPlayPerkSound)
					{
						root.f4se.plugins.PRKF.PlayPerkSound(this.PerkList_mc.selectedEntry.formid);
					}
					if (this.PerkList_mc.selectedEntry.numranks != 1)
					{
						textDesc = Translator("$Rank:") + " " + int(this.PerkList_mc.selectedEntry.level) + "/" + this.PerkList_mc.selectedEntry.numranks + "\n" + this.PerkList_mc.selectedEntry.description;
					}
					else
					{
						textDesc = this.PerkList_mc.selectedEntry.description;
					}
					GlobalFunc.SetText(this.Description_tf, textDesc, false);
					if (!traitsMode)
					{
						textReqs = Translator("$PRKF_Requires") + ": ";
						if (this.PerkList_mc.selectedEntry.isHighLevel)
						{
							textReqs += "<font color=\'#fa8e47\'>" + Translator("$PRKF_Level") + " " + this.PerkList_mc.selectedEntry.reqlevel + "</font>" + this.PerkList_mc.selectedEntry.reqs;
						}
						else
						{
							textReqs += Translator("$PRKF_Level") + " " + this.PerkList_mc.selectedEntry.reqlevel + this.PerkList_mc.selectedEntry.reqs;
						}
						textReqs = textReqs.replace(/\$PRKF_or/g, LevelUpMenu.Translator("$PRKF_or"));
					}
					GlobalFunc.SetText(this.Reqs_tf, textReqs, true);
					if (this.PerkList_mc.selectedEntry.SWFPath != "")
					{
						_loc2_ = new URLRequest(this.PerkList_mc.selectedEntry.SWFPath);
					}
					else
					{
						_loc2_ = new URLRequest("Components/VaultBoys/Perks/PerkClip_" + (this.PerkList_mc.selectedEntry.qname & 0xFFFFFF).toString(16) + ".swf");
					}
					_loc3_ = new LoaderContext(false, ApplicationDomain.currentDomain);
					this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onVBLoadComplete);
					this._VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onVBLoadIOError);
					this._VBLoader.load(_loc2_, _loc3_);
				}
				else
				{
					GlobalFunc.SetText(this.Description_tf, "", false);
					GlobalFunc.SetText(this.Reqs_tf, "", false);
					if (this.VBHolder_mc.numChildren > 0)
					{
						this.VBHolder_mc.removeChildAt(0);
					}
				}
			}
			//atrace("UIMenuFocus");
			//this.BGSCodeObj.playSound("UIMenuFocus");
			SetButtons();
		}
		
		private function onVBLoadComplete(param1:Event):*
		{
			var _loc2_:DisplayObject = null;
			param1.target.removeEventListener(Event.COMPLETE, this.onVBLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onVBLoadIOError);
			if (this.VBHolder_mc.numChildren > 0)
			{
				param1.target.content.removeEventListener(Event.ENTER_FRAME, this.onPerkSelectionAnimUpdate);
				_loc2_ = this.VBHolder_mc.getChildAt(0);
				this.VBHolder_mc.removeChild(_loc2_);
			}
			this.VBHolder_mc.addChild(param1.target.content);
			if (bPlayPerkSound && bPlayPerkSoundLoop)
			{
				param1.target.content.addEventListener(Event.ENTER_FRAME, this.onPerkSelectionAnimUpdate);
			}
		}
		
		protected function onPerkSelectionAnimUpdate(param1:Event):*
		{
			if (param1.target.currentFrame == 1 && this._VBClipID != 0)
			{
				if (this.PerkList_mc.selectedEntry)
					root.f4se.plugins.PRKF.PlayPerkSound(this.PerkList_mc.selectedEntry.formid);
					else if (this.List_mc.selectedEntry)
					root.f4se.plugins.PRKF.PlayPerkSoundByName(this.List_mc.selectedEntry.qname+"_sound");
					//root.f4se.plugins.PRKF.PlaySound2(this.List_mc.selectedEntry.qname+"_sound");
			}
		}
		
		private function onVBLoadIOError(errorEvent:IOErrorEvent):*
		{
			errorEvent.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onVBLoadIOError);
			errorEvent.target.removeEventListener(Event.COMPLETE, this.onVBLoadComplete);
			var _loc2_:URLRequest = null;
			var _loc3_:LoaderContext = null;
			_loc2_ = new URLRequest("Components/VaultBoys/Perks/PerkClip_Default.swf");
			_loc3_ = new LoaderContext(false, ApplicationDomain.currentDomain);
			this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onVBLoadComplete);
			this._VBLoader.load(_loc2_, _loc3_);
		}
		
		private function onItemPress(param1:Event):*
		{
			
			switch (param1.target.name)
			{
			case "PerkList_mc": 
				if (PPCount > 0)
				{
					if ((param1.target.selectedEntry.type == TYPE_INTENSETRAINING) && (param1.target.selectedEntry.iselig))
					{
						this.Intense_training_menu_mc.Open()
					}
					else perkpressed(param1.target);
				}
				break;
			case "List_mc": 
				if (tagSkillsMode)
				{
					toggleTagSkill();
				}
				break;
			case "stats_list": 
				if (PPCount > 0)
				{
					if (param1.target.selectedEntry.type != TYPE_CANCEL) perkpressed(param1.target);
					this.Intense_training_menu_mc.Close();
				}
				break;
			case "confirmlist_mc": 
				if (InfoWindow_mc.opened)
				{
					this.onInfoWindowConfirm();
					break;
				}
				else
				{
					if (bskillsconfirmation)
					{
						bskillsconfirmation = false;
						break;
					}
					if (LearnSkillsConfirmMenu_mc.confirmtype == LearnSkillsConfirmMenu.CONFIRM_TYPE_PERK) this.onLearnPerkConfirm();
					else if (LearnSkillsConfirmMenu_mc.confirmtype == LearnSkillsConfirmMenu.CONFIRM_TYPE_TRAITS) this.onLearnTraitConfirm();
					else if (LearnSkillsConfirmMenu_mc.confirmtype == LearnSkillsConfirmMenu.CONFIRM_TYPE_SKILL) this.onLearnSkillsConfirm();
					else if (LearnSkillsConfirmMenu_mc.confirmtype == LearnSkillsConfirmMenu.CONFIRM_TYPE_TAGSKILLS) this.onTagSkillsConfirm();
					break;
				}
			default: 
				break;
			}
		}
		
		private function toggleTagSkill():*
		{
			//trace("tagSkillsAllowRetag", tagSkillsAllowRetag);
			val: int = 0;
			if (this.List_mc.selectedEntry.tagged)
			{
				if (this.List_mc.selectedEntry.alreadyTagged)
				{
					if (tagSkillsAllowRetag)
					{
						val = this.List_mc.selectedEntry.value - tagSPtoAdd;
						if (val < 00)
						{
							val = 0;
						}
						this.List_mc.selectedEntry.tagged = false;
						this.List_mc.selectedEntry.value = val;
						this.List_mc.selectedEntry.basevalue = val;
						PPCount += 1;
					}
				}
				else
				{
					this.List_mc.selectedEntry.tagged = false;
					this.List_mc.selectedEntry.value = this.List_mc.selectedEntry.unmodifiedValue;
					this.List_mc.selectedEntry.basevalue = this.List_mc.selectedEntry.value;
					PPCount += 1;
				}
			}
			else if (PPCount > 0)
			{
				this.List_mc.selectedEntry.tagged = true;
				val = this.List_mc.selectedEntry.value += tagSPtoAdd;
				if (val > maxSkillLevel)
				{
					val = maxSkillLevel;
				}
				this.List_mc.selectedEntry.value = val;
				this.List_mc.selectedEntry.basevalue = val;
				PPCount -= 1;
			}
			
			this.List_mc.UpdateList();
			SetButtons();
		}
		
		private function onLearnPerkPressed(ttarget:Object):Boolean
		{
			
			this.LearnSkillsConfirmMenu_mc.confirmtype = LearnSkillsConfirmMenu.CONFIRM_TYPE_PERK;
			this.LearnSkillsConfirmMenu_mc.Open(stage.focus, "$PRKF_LEARN_PERK?", ttarget);//PerkList_mc.SelectedEntry
			stage.focus = this.LearnSkillsConfirmMenu_mc.confirmlist_mc;
			this.PerkList_mc.disableInput = true;
			this.PerkList_mc.disableSelection = true;
			this.List_mc.disableInput = true;
			this.List_mc.disableSelection = true;
			SetButtons();
		}
		
		private function onLearnTraitPressed(ttarget:Object):Boolean
		{
			
			this.LearnSkillsConfirmMenu_mc.confirmtype = LearnSkillsConfirmMenu.CONFIRM_TYPE_TRAITS;
			this.LearnSkillsConfirmMenu_mc.Open(stage.focus, "$PRKF_CHOOSE_TRAIT?", ttarget);//PerkList_mc.SelectedEntry
			stage.focus = this.LearnSkillsConfirmMenu_mc.confirmlist_mc;
			this.PerkList_mc.disableInput = true;
			this.PerkList_mc.disableSelection = true;
			this.List_mc.disableInput = true;
			this.List_mc.disableSelection = true;
			SetButtons();
		}
		
		private function onLearnPerkButtonPressed():Boolean
		{
			onLearnPerkPressed(this.PerkList_mc.entryList[this.PerkList_mc.selectedIndex]);
		}
		
		private function onIneligibleButtonPressed()
		{
			if (checkFlag(_options.filterFlag_notelig))
			{
				remflag(_options.filterFlag_notelig);
			}
			else
			{
				addflag(_options.filterFlag_notelig);
			}
			this.Options_mc.filterCb.setcheck(checkFlag(_options.filterFlag_notelig));
			SetButtons();
		}
		
		private function switchTabs():*
		{
			if (!this.Intense_training_menu_mc.opened && !this.LearnSkillsConfirmMenu_mc.opened && !this.InfoWindow_mc.opened)
			{
				if ((stage.focus != this.PerkList_mc))
				{
					this.PerkList_mc.selectedIndex = _oldIndex;
					stage.focus = this.PerkList_mc;
					_oldIndex = this.List_mc.selectedIndex;
					this.List_mc.selectedIndex = -1;
					root.f4se.plugins.PRKF.PlaySound2("UIBarterHorizontalLeft");
				}
				else
				{
					this.List_mc.selectedIndex = _oldIndex;
					stage.focus = this.List_mc;
					_oldIndex = this.PerkList_mc.selectedIndex;
					this.PerkList_mc.selectedIndex = -1;
					root.f4se.plugins.PRKF.PlaySound2("UIBarterHorizontalRight");
				}
				SetButtons();
			}
		}
		
		private function onLearnPerkConfirm():Boolean
		{
			
			stage.focus = this.PerkList_mc;
			var fid:uint = uint(LearnSkillsConfirmMenu_mc.tttarget.formid);
			var qname:uint = uint(LearnSkillsConfirmMenu_mc.tttarget.qname);
			var learn:Boolean = (LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex == 0);
			
			this.LearnSkillsConfirmMenu_mc.Close();
			this.PerkList_mc.disableInput = false;
			this.PerkList_mc.disableSelection = false;
			this.List_mc.disableInput = false;
			this.List_mc.disableSelection = false;
			if (learn)
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuOK");
				try
				{
					root.f4se.plugins.PRKF.AddPerk(fid, qname);
				}
				catch (e:Error)
				{
					trace("Failed to call root.f4se.plugins.PRKF.AddPerk()")
				}
			}
			else
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuCancel");
			}
			SetButtons();
		}
		
		private function onTagSkillsConfirm():Boolean
		{
			
			stage.focus = this.List_mc;
			var exit:Boolean = (LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex == 0);
			
			this.LearnSkillsConfirmMenu_mc.Close();
			this.PerkList_mc.disableInput = false;
			this.PerkList_mc.disableSelection = false;
			this.List_mc.disableInput = false;
			this.List_mc.disableSelection = false;
			if (exit)
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuOK");
				for each (var obj in this.List_mc.entryList)
				{
					//trace("obj.tagged", obj.tagged, "obj.alreadyTagged", obj.alreadyTagged);
					if (obj.tagged) 
					{
						if (obj.alreadyTagged) 
						{
							
						}
						else 
						{
							try
							{
								root.f4se.plugins.PRKF.TagSkill(obj.formid, obj.value);
							}
							catch (e:Error)
							{
								trace("Failed to call root.f4se.plugins.PRKF.TagSkill()")
							}
							root.f4se.SendExternalEvent("PRKF::TagSkills::Tagged", obj.formid);
						}
					}
					else 
					{
						if (obj.alreadyTagged) 
						{
							try
							{
								root.f4se.plugins.PRKF.UnTagSkill(obj.formid, obj.value);
							}
							catch (e:Error)
							{
								trace("Failed to call root.f4se.plugins.PRKF.UnTagSkill()")
							}
							root.f4se.SendExternalEvent("PRKF::TagSkills::UnTagged", obj.formid);
						}
						else 
						{
							
						}
					}
				}
				root.f4se.SendExternalEvent("PRKF::TagSkills::Finish");
				onAcceptPressed();
			}
			else
			{
				startexit = false;
				root.f4se.plugins.PRKF.PlaySound2("UIMenuCancel");
				SetButtons();
			}
		}
		
		private function onLearnTraitConfirm():Boolean
		{
			
			stage.focus = this.PerkList_mc;
			var fid:uint = uint(LearnSkillsConfirmMenu_mc.tttarget.formid);
			var qname:uint = uint(LearnSkillsConfirmMenu_mc.tttarget.qname);
			var learn:Boolean = (LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex == 0);
			
			this.LearnSkillsConfirmMenu_mc.Close();
			this.PerkList_mc.disableInput = false;
			this.PerkList_mc.disableSelection = false;
			this.List_mc.disableInput = false;
			this.List_mc.disableSelection = false;
			if (learn)
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuOK");
				try
				{
					root.f4se.plugins.PRKF.AddTrait(fid, qname);
					PerkList_mc.entryList.splice(PerkList_mc.selectedIndex, 1);
					PerkList_mc.InvalidateData();
					PPCount -= 1;
				}
				catch (e:Error)
				{
					trace("Failed to call root.f4se.plugins.PRKF.AddTrait()")
				}
			}
			else
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuCancel");
			}
			SetButtons();
		}
		
		private function onInfoWindowConfirm()
		{
			root.f4se.plugins.PRKF.PlaySound2("UIMenuOK");
			this.InfoWindow_mc.Close();
			this.PerkList_mc.disableInput = false;
			this.PerkList_mc.disableSelection = false;
			this.List_mc.disableInput = false;
			this.List_mc.disableSelection = false;
			stage.focus = this.PerkList_mc;
			SetButtons();
		}
		
		private function perkpressed(ttarget:Object):*
		{
			if (traitsMode)
			{
				this.onLearnTraitPressed(ttarget.selectedEntry);
			}
			else if (ttarget.selectedEntry.iselig)
			{
				this.onLearnPerkPressed(ttarget.selectedEntry);
			}
		}
		
		public function onMenuKeyDown(param1:KeyboardEvent):*
		{
		/*if (param1.keyCode == Keyboard.ENTER){
		   if ((skillschanged) && !this.Intense_training_menu_mc.opened && !this.LearnSkillsConfirmMenu_mc.opened && (stage.focus == this.List_mc))
		   {
		   onLearnSkillsPressed();
		   bskillsconfirmation = true;
		   param1.stopPropagation();
		   }
		   else if (SPCountBase == 0 && PPCount == 0 && !this.Intense_training_menu_mc.opened && !this.LearnSkillsConfirmMenu_mc.opened) // || param1.keyCode == Keyboard.E))
		   {
		   this.onAcceptPressed();
		   param1.stopPropagation();
		   }
		   }
		   if (param1.keyCode == Keyboard.ESCAPE)
		   {
		   if (this.LearnSkillsConfirmMenu_mc.opened)
		   {
		   LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 1;
		   onLearnSkillsConfirm();
		   }
		   else if (skillschanged)
		   {
		   onCancelLearnSkillsPressed();
		   } else
		   {
		   this.onAcceptPressed();
		   }
		
		   }
		   if (stage.focus == this.List_mc) {
		   //trace("param1.keyCode", param1.keyCode);
		   if (param1.keyCode == Keyboard.A) {
		   this.ModSelectedValue(-1);
		   } else if (param1.keyCode == Keyboard.D) {
		   this.ModSelectedValue(1);
		   } else if (param1.keyCode == Keyboard.W) {
		   this.List_mc.moveSelectionUp();
		   } else if (param1.keyCode == Keyboard.S) {
		   this.List_mc.moveSelectionDown();
		   }
		   } else if (stage.focus == this.PerkList_mc) {
		   if (param1.keyCode == Keyboard.W) {
		   this.PerkList_mc.moveSelectionUp();
		   } else if (param1.keyCode == Keyboard.S) {
		   this.PerkList_mc.moveSelectionDown();
		   }
		   }	else if (stage.focus == this.Intense_training_menu_mc.stats_list) {
		   if (param1.keyCode == Keyboard.W) {
		   this.Intense_training_menu_mc.stats_list.moveSelectionUp();
		   } else if (param1.keyCode == Keyboard.S) {
		   this.Intense_training_menu_mc.stats_list.moveSelectionDown();
		   }
		   } else if (stage.focus == this.LearnSkillsConfirmMenu_mc.confirmlist_mc) {
		   if (param1.keyCode == Keyboard.W) {
		   this.LearnSkillsConfirmMenu_mc.confirmlist_mc.moveSelectionUp();
		   } else if (param1.keyCode == Keyboard.S) {
		   this.LearnSkillsConfirmMenu_mc.confirmlist_mc.moveSelectionDown();
		   }
		   }*/
		}
		
		public function onMenuKeyUp(param1:KeyboardEvent):*
		{
		
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean):Boolean
		{
			//trace("!!!!!!!!! PROCESSUSEREVENT ", param1, param2);
		}
		
		public function ProcessKeyEventEx(param1:int, param2:Boolean):Boolean
		{
			//trace("ProcessKeyEventEx ", param1, param2);
		}
		
		private function AnyWindowOpened():Boolean
		{
			return this.Intense_training_menu_mc.opened || this.LearnSkillsConfirmMenu_mc.opened || this.InfoWindow_mc.opened;
		}
		
		private function ModSelectedValueDelayed(val: int):*
		{
			trace("delayed call");
			if (leftPressed || rightPressed) 
			{
			this.ModSelectedValue(val);
			TweenLite.delayedCall(0.1,ModSelectedValueDelayed,[val]);
			}
		}
		
		public function ProcessUserEventEx(param1:String, param2:Boolean, param3:int, keyCode:int):Boolean
		{
			atrace("ProcessUserEventEx " + param1 + " keycode" + String(keyCode));
			//trace("traitsMode",traitsMode, "tagSkillsMode", tagSkillsMode, "controlName", param1, "isDown", param2, "deviceType", param3, "keyCode", keyCode);
			if (param2 == true)
			{
				rightPressed = false;
				leftPressed = false;
				if (!perksOnly && !traitsMode && !tagSkillsMode && (param1 == "NextPerk" || param1 == "PrevPerk"))
				{
					this.switchTabs();
				}
				else if (tagSkillsMode)
				{
					if (param1 == "Forward")
					{
						stage.focus.moveSelectionUp();
					}
					else if (param1 == "Back")
					{
						stage.focus.moveSelectionDown();
					}
				}
				//else if ((param1 == "YButton" || (param1 == "Unmapped" && (keyCode == 279 || keyCode == 84)) ) && !AnyWindowOpened()) 
				else if ((keyCode == 279 || keyCode == 84) && !AnyWindowOpened())
				{
					onIneligibleButtonPressed();
				}
				else if (stage.focus == this.List_mc)
				{
					if (param1 == "StrafeLeft" || param1 == "Left")
					{
						//this.ModSelectedValue(-1);
						//trace("left pressed");
						leftPressed = true;
						this.ModSelectedValue( -1);
						TweenLite.delayedCall(1,ModSelectedValueDelayed,[-1]);
					}
					else if (param1 == "StrafeRight" || param1 == "Right")
					{
						//trace("right pressed");
						rightPressed = true;
						this.ModSelectedValue(1);
						TweenLite.delayedCall(1,ModSelectedValueDelayed,[1]);
						//this.ModSelectedValue(1);
					}
					else if (param1 == "Forward")
					{
						this.List_mc.moveSelectionUp();
					}
					else if (param1 == "Back")
					{
						this.List_mc.moveSelectionDown();
					}
				}
				else if (stage.focus == this.PerkList_mc)
				{
					if (param1 == "Forward")
					{
						this.PerkList_mc.moveSelectionUp();
					}
					else if (param1 == "Back")
					{
						this.PerkList_mc.moveSelectionDown();
					}
					else if ((param1 == "XButton" || param1 == "ReadyWeapon" || keyCode == 278 || keyCode == 82) && stage.focus == this.PerkList_mc && this.PerkList_mc.selectedEntry.ranksInfo)
					{
						onShowPerkRanksInfoPressed();
					}
				}
				else if (stage.focus == this.Intense_training_menu_mc.stats_list)
				{
					if (param1 == "Forward")
					{
						this.Intense_training_menu_mc.stats_list.moveSelectionUp();
					}
					else if (param1 == "Back")
					{
						this.Intense_training_menu_mc.stats_list.moveSelectionDown();
					}
				}
				else if (stage.focus == this.LearnSkillsConfirmMenu_mc.confirmlist_mc)
				{
					if (param1 == "Forward")
					{
						this.LearnSkillsConfirmMenu_mc.confirmlist_mc.moveSelectionUp();
					}
					else if (param1 == "Back")
					{
						this.LearnSkillsConfirmMenu_mc.confirmlist_mc.moveSelectionDown();
					}
				}
				if (param1 == "Cancel" && !tagSkillsMode)
				{
					startexit = true;
				}
			}
			else
			{
				if (tagSkillsMode)
				{
					if (param1 == "XButton" || param1 == "ReadyWeapon" || keyCode == 278 || keyCode == 82)
					{
						if (!startexit)
						{
							onAcceptPressed();
						}
					}
					else if (param1 == "Cancel" && this.LearnSkillsConfirmMenu_mc.opened)
					{
						LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 1;
						onTagSkillsConfirm();
					}
				}
				else
				{
					if (param1 == "Activate" || param1 == "Accept")
					{
						if ((skillschanged) && !AnyWindowOpened() && (stage.focus == this.List_mc))
						{
							onLearnSkillsPressed();
							bskillsconfirmation = true;
						}
						else if (((PPCount == 0 && perksOnly) || (SPCountBase == 0 && PPCount == 0 && !perksOnly)) && !AnyWindowOpened())
						{
							this.onAcceptPressed();
						}
					}
					else if (param1 == "Cancel")
					{
						if (this.InfoWindow_mc.opened)
						{
							onInfoWindowConfirm();
						}
						else if (this.LearnSkillsConfirmMenu_mc.opened)
						{
							LearnSkillsConfirmMenu_mc.confirmlist_mc.selectedIndex = 1;
							onLearnSkillsConfirm();
						}
						else if (skillschanged)
						{
							onCancelLearnSkillsPressed();
						}
						else if (startexit)
						{
							startexit = false;
							this.onAcceptPressed();
						}
					}
				}
				if (stage.focus == this.List_mc)
				{
					if (param1 == "StrafeLeft" || param1 == "Left")
					{
						//this.ModSelectedValue(-1);
						//trace("left released");
						leftPressed = false;
					}
					else if (param1 == "StrafeRight" || param1 == "Right")
					{
						//trace("right released");
						rightPressed = false;
						//this.ModSelectedValue(1);
					}
				}
				
			}
			return false;
		}
		
		private function ModSelectedValue(param1:int):*
		{
			atrace("value " + String(this.List_mc.selectedEntry.value));
			atrace("basevalue " + String(this.List_mc.selectedEntry.basevalue));
			atrace("param1 " + String(param1));
			if (param1 < 0 && this.List_mc.selectedEntry.value > this.List_mc.selectedEntry.basevalue || param1 > 0 && this.uiSPCount > 0 && this.List_mc.selectedEntry.value < maxSkillLevel)
			{
				root.f4se.plugins.PRKF.PlaySound2("UIMenuQuantity");
				this.List_mc.selectedEntry.value += param1;
				this.SPCount -= param1
				this.List_mc.UpdateList();
				skillschanged = (SPCount != SPCountBase);
				SetButtons();
			}
		}
		
		private function onArrowClick(param1:Event):*
		{
			if (param1.target.name == "DecrementArrow")
			{
				this.ModSelectedValue(-1);
			}
			else
			{
				this.ModSelectedValue(1);
			}
		}
		
		private function ModListEntryValue(param1:int, param2:int, param3:Boolean):*
		{
		/*  if(param2 < 0 && this.uiCurrPoints > 0 && this.List_mc.entryList[param1].value > 1 || param2 > 0 && this.uiCurrPoints < this.uiMaxPoints && this.List_mc.entryList[param1].value < 10)
		   {
		   this.BGSCodeObj.modValue(param1,param2);
		   this.uiCurrPoints = this.uiCurrPoints + param2;
		   this.List_mc.UpdateList();
		   this.UpdateCounterAndButtons();
		   if(param3)
		   {
		   this.BGSCodeObj.playSound("UIMenuPrevNext");
		   }
		   }*/
		
		}
		
		private function onGEARMCClick(event:Event)
		{
			this.Options_mc.visible = !this.Options_mc.visible;
		}
		
		private function atrace(param1:String):*
		{
			if (!debugmode)
			{
				return
			}
			;
			atf.appendText(param1 + "\n");
			atf.scrollV = atf.maxScrollV;
		}
		
		static public function Translator(str:String):String
		{
			var translator:TextField = new TextField();
			translator.visible = false;
			if (str == "")
			{
				translator = null;
				return "";
			}
			if (str.charAt(0) != "$")
			{
				translator = null;
				return str;
			}
			GlobalFunc.SetText(translator, str, false);
			str = translator.text;
			translator = null;
			return str;
		}
	}
}