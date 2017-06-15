package {
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

	public class LevelUpMenu extends IMenu {
	
	private var debugmode: Boolean = false;
		private static var _instance:LevelUpMenu;
		public var bgholder_mc: def_BG_Holder;
		public var List_mc: BSScrollingList;
		public var PerkList_mc: BSScrollingList;
		public var spec_tf: TextField;
		private var _SampleList: Array;
		private var _SampleList1: Array;
		public var freepoints_holder_mc: freepoints_holder;
		public var VBHolder_mc: MovieClip;
		public var Description_tf: TextField;
		public var Reqs_tf: TextField;
		public var atf: TextField;
		private const SkillsClipNameMap:Array = ["Barter","Energy Weapons","Explosives","Guns","LockPick","Medicine","Melee Weapons","Repair","Science","Sneak","Speech","Survival","Unarmed"];
		private var _VBLoader:Loader;
		private var uiSPCount: uint;
		private var uiPPCount: uint;
		public var filterCb: def_controls_cb;

		public var GridView_mc: PerkGrid;

		public var PerkInfo_mc: MovieClip;

		public var XPMeterHolder_mc: MovieClip;

		public var ButtonHintBar_mc: BSButtonHintBar;

		private var uiPerkCount: uint;

		private var errorDisapearTimer: Timer;

		private var bConfirming: Boolean;

		private var _WasCancelPressRegistered: Boolean;

		private var AcceptButton: BSButtonHintData;

		private var CancelButton: BSButtonHintData;

		private var PrevPerkButton: BSButtonHintData;

		private var NextPerkButton: BSButtonHintData;

		private const INFO_Y_BOUND: Number = 460;

		private const INFO_UPPER_Y: Number = 35;

		private const INFO_LOWER_Y: Number = 617.75;

		private var _SelectionDesc: String;

		private var _ViewingRankOffset: int;

		private var _ViewingRanks: Boolean;

		public var BGSCodeObj: Object;

		public function LevelUpMenu() {
			LevelUpMenu._instance = this;
			this.AcceptButton = new BSButtonHintData("$ACCEPT", "Enter", "PSN_A", "Xenon_A", 1, this.onAcceptPressed);
			this.CancelButton = new BSButtonHintData("$CLOSE", "Tab", "PSN_B", "Xenon_B", 1, this.onCancelPressed);
			this.PrevPerkButton = new BSButtonHintData("$PREV PERK", "Ctrl", "PSN_L1", "Xenon_L1", 1, this.onPrevPerk);
			this.NextPerkButton = new BSButtonHintData("$NEXT PERK", "Alt", "PSN_R1", "Xenon_R1", 1, this.onNextPerk);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.GridView_mc.visible = false;
			this.GridView_mc.PerksHolder_mc.visible = false;
			this.GridView_mc.Header_mc.visible = false;

			this.SetButtons();
			this.PerkInfo_mc.visible = false;
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.bConfirming = false;
			this._WasCancelPressRegistered = false;
			this._ViewingRankOffset = 0;
			this._ViewingRanks = false;
			this.GridView_mc.addEventListener(PerkGrid.SELECTION_CHANGE, this.onGridSelectionChange);
			this.GridView_mc.addEventListener(PerkGrid.ZOOMING, this.onGridZoom);
			this.GridView_mc.addEventListener(PerkAnimHolder.CLICK, this.onGridItemPress);
			//---my
			this._VBLoader = new Loader();
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onMenuKeyDown);
			addEventListener(ArrowButton.MOUSE_UP,this.onArrowClick);
			addEventListener(ItemList.MOUSE_OVER, this.onListMouseOver);
			filterCb.addEventListener(MouseEvent.CLICK, this.onCbClick);
			//---
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.XPMeterHolder_mc.textField, TextFieldEx.TEXTAUTOSZ_SHRINK);
			this.__setProp_XPMeterHolder_mc_MenuObj_XPMeter_0();
			//---my
			this.__setProp_freepoints_holder_mc_MenuObj_freepoints_holder_mc_0();
			this.__setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0();
			this.__setProp_bgholder_mc_MenuObj_bgholder_mc_0();
			this.__setProp_List_mc_MenuObj_List_mc_0();
			this.__setProp_PerkList_mc_MenuObj_PerkList_mc_0();
			 newlist1();
			//---
			
		}
		
      public static function get instance() : LevelUpMenu
      {
         return _instance;
      }
	  
		private function onListMouseOver(event:Event){
			//if (!this.QuantityMenu_mc.opened){
				if ((event.target == this.List_mc) && !(stage.focus == List_mc)){
					stage.focus = this.List_mc;
					this.PerkList_mc.selectedIndex = -1;
				} else {
					if ((event.target == this.PerkList_mc) && !(stage.focus == this.PerkList_mc)){
						stage.focus = this.PerkList_mc;
						this.List_mc.selectedIndex = -1;
					};
				};
			//};
		}
		
		private function onCbClick(event:Event){
			filterCb.togglecheck();
			this.PerkList_mc.filterer.itemFilter = filterCb.bChecked ? 3:1;
			this.PerkList_mc.InvalidateData();
		//	this.PerkList_mc.UpdateList();
			this.PerkList_mc.selectedIndex = this.PerkList_mc.GetEntryFromClipIndex(0);
		}

		private function PopulateButtonBar(): void {
			var _loc1_: Vector.<BSButtonHintData>= new Vector.<BSButtonHintData>();
			  _loc1_.push(this.AcceptButton);
			//_loc1_.push(this.CancelButton);
			//  _loc1_.push(this.PrevPerkButton);
			//   _loc1_.push(this.NextPerkButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}

		public function onCodeObjCreate(): * {
			this.GridView_mc.codeObj = this.BGSCodeObj;
			this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			var _loc1_: Object = new Object();
			this.BGSCodeObj.GetXPInfo(_loc1_);
			GlobalFunc.SetText(this.XPMeterHolder_mc.textField, "$$LEVEL " + _loc1_.level, false);
			this.XPMeterHolder_mc.Meter_mc.SetMeter(_loc1_.currXP, 0, _loc1_.maxXP);
			//this.GridView_mc.InvalidateGrid();
			//this.GridView_mc.addEventListener(PerkGrid.TEXTURES_LOADED, this.onGridTexturesLoaded);
			//---my
	//		root.f4se.SendExternalEvent("LevelUp::RequestSkills");
		//	newlist();
		//	this.List_mc.entryList = this._SampleList;
		//	this.List_mc.InvalidateData();
		//	stage.focus = this.List_mc;
		//	this.List_mc.selectedIndex = 0;
			//---
		}
		
		public function onRequestSkills(param1: uint,param2: Array): * {
			atrace("skillsrecieved");
			//GlobalFunc.SetText(this.freepoints_holder_mc.countField1, String(param1), false);
			this.SPCount = param1;
			
		this._SampleList = new Array();
		var i: int = 0;
		for each(var obj in param2){
			this._SampleList.push({
				text: obj["__var__"]["__struct__"]["__data__"]["stext"],
				description: obj["__var__"]["__struct__"]["__data__"]["sdescription"],
				value: obj["__var__"]["__struct__"]["__data__"]["ivalue"],
				clipIndex: obj["__var__"]["__struct__"]["__data__"]["iclipIndex"],
				basevalue: obj["__var__"]["__struct__"]["__data__"]["ivalue"]
			});
		i++;
		}
		atrace("filling array finished");
			this.List_mc.entryList = this._SampleList;
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			this.List_mc.selectedIndex = 0;
			this.SetButtons();
		}

		public function qqStart(param1: Array,param2: int, param3: int, param4: Array, param5: String): * {
		//public function qqStart(param1: Array): * {
			atrace("skillsrecieved");
			trace("param2 "+ param2+ "   param3: "+param3);
			trace("param5 "+ param5);
			this.spec_tf.text = param5;
			this.SPCount = param2;
			this.PPCount = param3;
			//GlobalFunc.SetText(this.freepoints_holder_mc.countField1, String(param1), false);
			//this.SPCount = param1;
			if (param1.length == 0){
				this.List_mc.visible = false;
				this.bgholder_mc.width = 820;
				this.x += 180;
				this.ButtonHintBar_mc.x -= 180;
				this.freepoints_holder_mc.x -= 360;
				this.freepoints_holder_mc.textField1.visible = false;
				this.freepoints_holder_mc.countField1.visible = false;
				this.freepoints_holder_mc.textField.y = 8;
				this.freepoints_holder_mc.countField.y = 8;
			}
		this._SampleList = param1;
		this._SampleList1 = param4;
		
		atrace("filling array finished");
			this.List_mc.entryList = this._SampleList;
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			this.List_mc.selectedIndex = -1;
			this.PerkList_mc.entryList = this._SampleList1;
			this.PerkList_mc.InvalidateData();
			this.PerkList_mc.selectedIndex = 0;

			this.SetButtons();
			    var _loc3_:ColorTransform = this.XPMeterHolder_mc.transform.colorTransform;									//////////!!!!!!!!!!!!!!!!!!!!! CHECK THIS
																															//////////!!!!!!!!!!!!!!!!!!!!! CHECK THIS
         this.freepoints_holder_mc.transform.colorTransform = _loc3_;														//////////!!!!!!!!!!!!!!!!!!!!! CHECK THIS
		}
		public function onCodeObjDestruction(): * {
			this.GridView_mc.codeObj = null;
			this.BGSCodeObj = null;
		}

		private function onGridTexturesLoaded(): * {
			this.GridView_mc.removeEventListener(PerkGrid.TEXTURES_LOADED, this.onGridTexturesLoaded);
			this.GridView_mc.platform = uiPlatform;
			this.GridView_mc.visible = true;
			//   stage.focus = this.GridView_mc;
			this.BGSCodeObj.onGridAddedToStage();
			this.SetButtons();
		}

		public function get perkCount(): uint {
			return this.uiPerkCount;
		}

		public function set perkCount(param1: uint): * {
			this.uiPerkCount = param1;
			this.GridView_mc.perkCount = param1;
		}
		
		public function get SPCount(): uint {
			return this.uiSPCount;
		}

		public function set SPCount(param1: uint): * {
		GlobalFunc.SetText(this.freepoints_holder_mc.countField1, String(param1), false);
			this.uiSPCount = param1;
				this.AcceptButton.ButtonDisabled = param1!=0 && PPCount ==0;
		}
		
		public function get PPCount(): uint {
			return this.uiPPCount;
		}

		public function set PPCount(param1: uint): * {
		GlobalFunc.SetText(this.freepoints_holder_mc.countField, String(param1), false);
			this.uiPPCount = param1;
				this.AcceptButton.ButtonDisabled = param1!=0 && SPCount ==0;
		}

		public function set ratio16x10(param1: Boolean): * {
			this.GridView_mc.ratio16x10 = param1;
		}

		public function ProcessUserEvent(param1: String, param2: Boolean): Boolean {
			/*var _loc4_: Object = null;
			var _loc3_: Boolean = this.GridView_mc.ProcessUserEvent(param1, param2);
			if (!_loc3_) {
				if (!param2) {
					if (param1 == "Cancel") {
						if (this._WasCancelPressRegistered) {
							_loc3_ = this.onCancelPressed();
						}
						this._WasCancelPressRegistered = false;
					} else if (param1 == "Accept" || param1 == "Activate") {
						_loc4_ = this.GridView_mc.selectedPerkEntry;
						if (_loc4_ != null) {
							if (!this.bConfirming) {
								this.TryToAcquirePerk(_loc4_);
								_loc3_ = this.bConfirming;
							} else {
								_loc3_ = this.onAcceptPressed();
							}
						}
					} else if (param1 == "PrevPerk" && this.PrevPerkButton.ButtonVisible && !this.PrevPerkButton.ButtonDisabled) {
						this.onPrevPerk();
					} else if (param1 == "NextPerk" && this.NextPerkButton.ButtonVisible && !this.NextPerkButton.ButtonDisabled) {
						this.onNextPerk();
					}
				} else if (param1 == "Cancel") {
					this._WasCancelPressRegistered = true;
				}
			}
			return _loc3_;*/
			return false;
		}

		protected function onGridItemPress(param1: Event): * {
			var _loc2_: Object = this.GridView_mc.selectedPerkEntry;
			if (_loc2_ != null && param1.target == this.GridView_mc.selectedPerkClip && !this.GridView_mc.isDragging) {
				this.TryToAcquirePerk(_loc2_);
			}
		}

		private function TryToAcquirePerk(param1: Object): * {
			if (param1 != null) {
				if (!param1.available && this.uiPerkCount > 0) {
					if (param1.displayRank != param1.displayMaxRank) {
						this.ShowErrorText("$PerksLowReqs");
					}
					this.BGSCodeObj.PlaySound("UIMenuCancel");
				} else if (!this.bConfirming) {
					if (this.uiPerkCount > 0) {
						this.StartConfirmation();
						this.BGSCodeObj.PlaySound("UIMenuOK");
					}
				} else if (uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE) {
					this.OnSelectPerk();
				}
			}
		}

		private function onAcceptPressed(): Boolean {
			var temparray: Array = new Array();
			for each (var obj in this.List_mc.entryList) {
				temparray.push(obj.value);
			}
			root.f4se.SendExternalEvent("LevelUp::ReturnSkills", temparray);
			this.BGSCodeObj.CloseMenu();
			
		}

		private function onCancelPressed(): Boolean {
				this.BGSCodeObj.CloseMenu();
		}

		protected function OnSelectPerk(): * {
			var _loc1_: Object = this.GridView_mc.selectedPerkEntry;
			if (_loc1_.available && this.uiPerkCount > 0) {
				this.BGSCodeObj.SelectPerk(_loc1_.clipName, _loc1_.rank);
				this.BGSCodeObj.PlaySound("UIMenuOK");
				this.EndConfirmation();
			}
		}

		public function InvalidateGrid(): * {
			this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			this.GridView_mc.InvalidateGrid();
		}

		private function onGridSelectionChange(): * {
			if (this.GridView_mc.visible) {
				if (this.GridView_mc.selectedPerkEntry != null) {
					if (this.GridView_mc.selectedPerkEntry.owned == true) {
						this.BGSCodeObj.PlayPerkSound(this.GridView_mc.selectedPerkEntry.clipName);
					} else {
						this.BGSCodeObj.StopPerkSound();
					}
					this.BGSCodeObj.PlaySound("UIMenuFocus");
					this._SelectionDesc = this.GridView_mc.selectedPerkEntry.description;
					if (this.GridView_mc.selectedPerkEntry.rank == this.GridView_mc.selectedPerkEntry.maxRank) {
						this._ViewingRankOffset = 0;
					} else if (this.GridView_mc.selectedPerkEntry.rank == 0 || this.uiPerkCount != 0) {
						this._ViewingRankOffset = 1;
					} else {
						this._ViewingRankOffset = 0;
					}
					this._ViewingRanks = false;
				} else {
					this._SelectionDesc = "";
					this._ViewingRankOffset = 0;
					this._ViewingRanks = false;
					this.BGSCodeObj.StopPerkSound();
				}
			}
			this.UpdateSelectionText();
			this.SetButtons();
		}

		private function UpdateSelectionText(): * {
			var _loc2_: Array = null;
			var _loc3_: Number = NaN;
			var _loc4_: Number = NaN;
			var _loc5_: Number = NaN;
			var _loc6_: TextLineMetrics = null;
			var _loc7_: Number = NaN;
			var _loc8_: Number = NaN;
			var _loc9_: uint = 0;
			var _loc10_: MovieClip = null;
			var _loc1_: Object = this.GridView_mc.selectedPerkEntry;
			if (_loc1_ != null) {
				GlobalFunc.SetText(this.PerkInfo_mc.PerkName_tf, this.GridView_mc.selectedPerkEntry.text.toUpperCase(), false);
				_loc2_ = this._SelectionDesc.split("\n");
				if (_loc2_.length >= 2) {
					if (this.GridView_mc.selectedPerkEntry.displayRank != this.GridView_mc.selectedPerkEntry.displayMaxRank || this._ViewingRanks) {
						GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf, _loc2_[0], true);
					} else {
						GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf, " ", true);
					}
					GlobalFunc.SetText(this.PerkInfo_mc.DescriptionText_tf, _loc2_[1], true);
				} else if (_loc2_.length == 1) {
					GlobalFunc.SetText(this.PerkInfo_mc.DescriptionText_tf, _loc2_[0], true);
					GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf, " ", true);
				}
				while (this.PerkInfo_mc.StarHolder_mc.numChildren > 0) {
					this.PerkInfo_mc.StarHolder_mc.removeChildAt(0);
				}
				if (_loc1_.displayMaxRank != null && _loc1_.displayMaxRank > 1) {
					_loc9_ = 0;
					while (_loc9_ < _loc1_.displayMaxRank) {
						_loc10_ = new PerkRankStar();
						this.PerkInfo_mc.StarHolder_mc.addChild(_loc10_);
						_loc10_.x = 22.5 * _loc9_;
						_loc10_.scaleX = 0.5;
						_loc10_.scaleY = _loc10_.scaleX;
						_loc9_++;
					}
					this.PerkInfo_mc.StarHolder_mc.x = this.PerkInfo_mc.Background_mc.x + (this.PerkInfo_mc.Background_mc.width - this.PerkInfo_mc.StarHolder_mc.width) / 2;
					this.RefreshStarStates(_loc1_.displayRank, _loc1_.displayMaxRank, _loc1_.available == true);
				}
				_loc3_ = 4;
				_loc4_ = 43;
				_loc5_ = 35;
				this.PerkInfo_mc.StarHolder_mc.y = this.PerkInfo_mc.DescriptionText_tf.y + this.PerkInfo_mc.DescriptionText_tf.textHeight + _loc3_;
				this.PerkInfo_mc.Reqs_tf.y = this.PerkInfo_mc.StarHolder_mc.y + _loc4_;
				this.PerkInfo_mc.Confirm_tf.y = this.PerkInfo_mc.StarHolder_mc.y + _loc5_;
				_loc6_ = this.PerkInfo_mc.DescriptionText_tf.getLineMetrics(0);
				_loc7_ = 100;
				_loc8_ = 30;
				this.PerkInfo_mc.Background_mc.x = this.PerkInfo_mc.DescriptionText_tf.x + _loc6_.x - _loc7_ / 2;
				this.PerkInfo_mc.Background_mc.width = _loc6_.width + _loc7_;
				this.PerkInfo_mc.Background_mc.height = this.PerkInfo_mc.Reqs_tf.y - this.PerkInfo_mc.PerkName_tf.y + _loc8_;
				this.SetInfoClipLocation();
				this.PerkInfo_mc.visible = true;
			} else {
				this.PerkInfo_mc.visible = false;
				this.ClearErrorText();
			}
		}

		private function RefreshStarStates(param1: uint, param2: uint, param3: Boolean): * {
			var _loc5_: MovieClip = null;
			var _loc6_: Boolean = false;
			var _loc7_: * = false;
			var _loc4_: uint = 0;
			while (_loc4_ < param2) {
				_loc5_ = this.PerkInfo_mc.StarHolder_mc.getChildAt(_loc4_) as MovieClip;
				_loc6_ = param3 && param1 == _loc4_ && this.uiPerkCount > 0;
				_loc7_ = _loc4_ < param1;
				if (_loc6_) {
					_loc5_.gotoAndStop("Available");
				} else if (_loc7_) {
					_loc5_.gotoAndStop("Full");
				} else {
					_loc5_.gotoAndStop("Empty");
				}
				_loc4_++;
			}
		}

		private function onGridZoom(): * {
			this.SetInfoClipLocation();
		}

		private function SetInfoClipLocation(): * {
			if (uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.GridView_mc.selectedPerkEntry != null && this.GridView_mc.selectedPerkEntry.y != undefined && this.GridView_mc.y + this.GridView_mc.selectedPerkEntry.y * this.GridView_mc.gridScale > this.INFO_Y_BOUND) {
				this.PerkInfo_mc.y = this.INFO_UPPER_Y;
			} else {
				this.PerkInfo_mc.y = this.INFO_LOWER_Y - this.PerkInfo_mc.height;
			}
		}

		private function SetButtons(): * {
		/*	var _loc1_: Object = this.GridView_mc.selectedPerkEntry;
			if (this.bConfirming) {
				this.AcceptButton.ButtonText = "$ACCEPT";
				this.AcceptButton.ButtonDisabled = false;
				this.AcceptButton.ButtonVisible = true;
			} else if (this.uiPerkCount > 0) {
				this.AcceptButton.ButtonDisabled = _loc1_ == null || _loc1_.available == false || this._ViewingRanks && this._ViewingRankOffset != 1;
				this.AcceptButton.ButtonText = "$$Choose (" + this.uiPerkCount.toString() + ")";
				this.AcceptButton.ButtonVisible = true;
			} else {
				this.AcceptButton.ButtonVisible = false;
			}
			this.PrevPerkButton.ButtonDisabled = _loc1_ == null || _loc1_.displayMaxRank <= 1 || _loc1_.rank + this._ViewingRankOffset - 1 == 0;
			this.NextPerkButton.ButtonDisabled = _loc1_ == null || _loc1_.displayMaxRank <= 1 || _loc1_.rank + this._ViewingRankOffset + 1 > _loc1_.maxRank || _loc1_.displayRank + this._ViewingRankOffset + 1 > _loc1_.displayMaxRank;*/
		}

		private function onPrevPerk(): * {
			this._ViewingRankOffset--;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
		}

		private function onNextPerk(): * {
			this._ViewingRankOffset++;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
		}

		private function nextPrevPerk_Helper(): * {
			this._SelectionDesc = this.BGSCodeObj.GetPerkInfoByRank(this.GridView_mc.selectedPerkEntry.clipName, this.GridView_mc.selectedPerkEntry.rank + this._ViewingRankOffset - 1);
			this.UpdateSelectionText();
			this.RefreshStarStates(this.GridView_mc.selectedPerkEntry.displayRank + this._ViewingRankOffset, this.GridView_mc.selectedPerkEntry.displayMaxRank, false);
			this.SetButtons();
			this.BGSCodeObj.PlaySound("UIMenuPrevNext");
		}

		protected function StartConfirmation(): * {
			this.GridView_mc.disableInput = true;
			GlobalFunc.SetText(this.PerkInfo_mc.Confirm_tf, "$ConfirmPerkSelect", false);
			this.PerkInfo_mc.Confirm_tf.visible = true;
			this.PerkInfo_mc.Reqs_tf.visible = false;
			this.bConfirming = true;
			this.SetButtons();
		}

		protected function EndConfirmation(): * {
			this.GridView_mc.disableInput = false;
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.PerkInfo_mc.Reqs_tf.visible = true;
			this.bConfirming = false;
			this.SetButtons();
		}

		protected function ShowErrorText(param1: String): * {
			GlobalFunc.SetText(this.PerkInfo_mc.Confirm_tf, param1, false);
			this.PerkInfo_mc.Confirm_tf.visible = true;
			this.PerkInfo_mc.Reqs_tf.visible = false;
			if (this.errorDisapearTimer == null) {
				this.errorDisapearTimer = new Timer(2000, 1);
				this.errorDisapearTimer.addEventListener(TimerEvent.TIMER, this.onTimerClearErrorText);
				this.errorDisapearTimer.start();
			}
		}

		protected function ClearErrorText(): * {
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.PerkInfo_mc.Reqs_tf.visible = true;
		}

		protected function onTimerClearErrorText(param1: TimerEvent): * {
			if (this.PerkInfo_mc.Confirm_tf.visible && !this.PerkInfo_mc.Reqs_tf.visible) {
				this.ClearErrorText();
			}
			this.errorDisapearTimer.removeEventListener(TimerEvent.TIMER, this.onTimerClearErrorText);
			this.errorDisapearTimer = null;
		}

		function __setProp_XPMeterHolder_mc_MenuObj_XPMeter_0(): * {
			try {
				this.XPMeterHolder_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.XPMeterHolder_mc.bracketCornerLength = 6;
			this.XPMeterHolder_mc.bracketLineWidth = 1.5;
			this.XPMeterHolder_mc.bracketPaddingX = 0;
			this.XPMeterHolder_mc.bracketPaddingY = 0;
			this.XPMeterHolder_mc.BracketStyle = "horizontal";
			this.XPMeterHolder_mc.bShowBrackets = true;
			this.XPMeterHolder_mc.bUseShadedBackground = true;
			this.XPMeterHolder_mc.ShadedBackgroundMethod = "Flash";
			this.XPMeterHolder_mc.ShadedBackgroundType = "normal";
			try {
				this.XPMeterHolder_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}
		function __setProp_freepoints_holder_mc_MenuObj_freepoints_holder_mc_0(): * {
			try {
				this.freepoints_holder_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.freepoints_holder_mc.bracketCornerLength = 6;
			this.freepoints_holder_mc.bracketLineWidth = 1.5;
			this.freepoints_holder_mc.bracketPaddingX = 0;
			this.freepoints_holder_mc.bracketPaddingY = 0;
			this.freepoints_holder_mc.BracketStyle = "horizontal";
			this.freepoints_holder_mc.bShowBrackets = true;
			this.freepoints_holder_mc.bUseShadedBackground = true;
			this.freepoints_holder_mc.ShadedBackgroundMethod = "Flash";
			this.freepoints_holder_mc.ShadedBackgroundType = "normal";
			try {
				this.freepoints_holder_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}

		function __setProp_bgholder_mc_MenuObj_bgholder_mc_0(): * {
			try {
				this.bgholder_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.bgholder_mc.bracketCornerLength = 6;
			this.bgholder_mc.bracketLineWidth = 1.5;
			this.bgholder_mc.bracketPaddingX = 0;
			this.bgholder_mc.bracketPaddingY = 0;
			this.bgholder_mc.BracketStyle = "vertical";
			this.bgholder_mc.bShowBrackets = true;
			this.bgholder_mc.bUseShadedBackground = true;
			this.bgholder_mc.ShadedBackgroundMethod = "Flash";
			this.bgholder_mc.ShadedBackgroundType = "normal";
			try {
				this.bgholder_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}

		function __setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0(): * {
			try {
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
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
			try {
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}
		function __setProp_List_mc_MenuObj_List_mc_0(): * {
			try {
				this.List_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.List_mc.listEntryClass = "Skills_ListEntry";
			this.List_mc.numListItems = 13;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 0;
			try {
				this.List_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}
		function __setProp_PerkList_mc_MenuObj_PerkList_mc_0(): * {		
			try {
				this.PerkList_mc["componentInspectorSetting"] = true;
			} catch (e: Error) {}
			this.PerkList_mc.listEntryClass = "Perks_ListEntry";
			this.PerkList_mc.numListItems = 13;
			this.PerkList_mc.restoreListIndex = false;
			this.PerkList_mc.textOption = "None";
			this.PerkList_mc.verticalSpacing = 0;
			try {
				this.PerkList_mc["componentInspectorSetting"] = false;
				return;
			} catch (e: Error) {
				return;
			}
		}
		
      private function onSelectionChange(param1:Event) : *
      {
	/*if (param1.target == this.List_mc){
	this.PerkList_mc.selectedIndex = -1;	
	stage.focus = this.List_mc;
	} else {
	this.List_mc.selectedIndex = -1;
	stage.focus = this.PerkList_mc;
	}*/
         var _loc2_:URLRequest = null;
         var _loc3_:LoaderContext = null;
         if(this.List_mc.selectedEntry && this.List_mc.selectedEntry.description)
         {
            GlobalFunc.SetText(this.Description_tf,this.List_mc.selectedEntry.description,false);
			GlobalFunc.SetText(this.Reqs_tf,"",false);
            //_loc2_ = new URLRequest("Components/VaultBoys/Skills/" + this.SkillsClipNameMap[this.List_mc.selectedIndex] + ".swf");
			_loc2_ = new URLRequest("Components/VaultBoys/Skills/" + this.List_mc.selectedEntry.qname + ".swf");
            _loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
            this._VBLoader.load(_loc2_,_loc3_);
         } else if (this.PerkList_mc.selectedEntry && this.PerkList_mc.selectedEntry.description)
		 {
			GlobalFunc.SetText(this.Description_tf,this.PerkList_mc.selectedEntry.description,false);
			GlobalFunc.SetText(this.Reqs_tf,this.PerkList_mc.selectedEntry.reqs,true);
			_loc2_ = new URLRequest("Components/VaultBoys/Perks/PerkClip_" + (this.PerkList_mc.selectedEntry.qname & 0xFFFFFF).toString(16) + ".swf");
            _loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
			this._VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadIOError);
            this._VBLoader.load(_loc2_,_loc3_);
         } else {
            GlobalFunc.SetText(this.Description_tf,"",false);
			GlobalFunc.SetText(this.Reqs_tf,"",false);
            if(this.VBHolder_mc.numChildren > 0)
            {
               this.VBHolder_mc.removeChildAt(0);
            }
         }
         this.BGSCodeObj.playSound("UIMenuFocus");
      }
	  
      private function onVBLoadComplete(param1:Event) : *
      {
         var _loc2_:DisplayObject = null;
         param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
         if(this.VBHolder_mc.numChildren > 0)
         {
            _loc2_ = this.VBHolder_mc.getChildAt(0);
            this.VBHolder_mc.removeChild(_loc2_);
         }
         this.VBHolder_mc.addChild(param1.target.content);
      }
	  
      private function onVBLoadIOError(errorEvent:IOErrorEvent) : *
      {
         errorEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadIOError);
		 errorEvent.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
         var _loc2_:URLRequest = null;
         var _loc3_:LoaderContext = null;
		_loc2_ = new URLRequest("Components/VaultBoys/Perks/PerkClip_Default.swf");
        _loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
        this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
        this._VBLoader.load(_loc2_,_loc3_);
      }
	  
      private function onItemPress(param1:Event) : *
      {

      }
	  
      public function onMenuKeyDown(param1:KeyboardEvent) : *
      {
		if(SPCount == 0 && PPCount == 0 && (param1.keyCode == Keyboard.ENTER))// || param1.keyCode == Keyboard.E))
            {
               this.onAcceptPressed();
			   param1.stopPropagation();
            }
	  
         if(this.List_mc.selectedIndex != -1)
         {
            if(param1.keyCode == Keyboard.A)
            {
               this.ModSelectedValue(-1);
            }
            else if(param1.keyCode == Keyboard.D)
            {
               this.ModSelectedValue(1);
            }
            else if(param1.keyCode == Keyboard.W)
            {
               this.List_mc.moveSelectionUp();
            }
            else if(param1.keyCode == Keyboard.S)
            {
               this.List_mc.moveSelectionDown();
            }
         }
      }
	  
      private function ModSelectedValue(param1:int) : *
      {
	  atrace("value "+String(this.List_mc.selectedEntry.value));
	  atrace("basevalue "+String(this.List_mc.selectedEntry.basevalue));
	  atrace("param1 "+String(param1));
		if (param1<0 && this.List_mc.selectedEntry.value>this.List_mc.selectedEntry.basevalue || param1 > 0 && this.uiSPCount > 0 && this.List_mc.selectedEntry.value<100)
			{
				this.List_mc.selectedEntry.value +=param1;
				this.SPCount-=param1
				this.List_mc.UpdateList();
			}
      }
	  
      private function onArrowClick(param1:Event) : *
      {
         if(param1.target.name == "DecrementArrow")
         {
            this.ModSelectedValue(-1);
         }
         else
         {
            this.ModSelectedValue(1);
         }
      }
	  
  
      private function ModListEntryValue(param1:int, param2:int, param3:Boolean) : *
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
	  
	  
		private function newlist(): * {
			this._SampleList = new Array();
			this._SampleList.push({
				text: "Barter",
				description: "Proficiency at trading and haggling. Also used to negotiate better quest rewards or occasionally as a bribe-like alternative to Speech.",
				value: 5,
				clipIndex: 0
			});
			this._SampleList.push({
				text: "Crafting",
				description: "Proficiency at repairing items and crafting items and ammunition.",
				value: 5,
				clipIndex: 1
			});
			this._SampleList.push({
				text: "Energy Weapons",
				description: "Proficiency at using energy-based weapons.",
				value: 5,
				clipIndex: 2
			});
			this._SampleList.push({
				text: "Explosives",
				description: "Proficiency at using explosive weaponry, disarming mines, and crafting explosives.",
				value: 5,
				clipIndex: 3
			});
			this._SampleList.push({
				text: "Guns",
				description: "Proficiency at using weapons that fire standard ammunition.",
				value: 5,
				clipIndex: 4
			});
			this._SampleList.push({
				text: "Lockpick",
				description: "Proficiency at picking locks.",
				value: 5,
				clipIndex: 5
			});
			this._SampleList.push({
				text: "Medicine",
				description: "Proficiency at using medical tools, drugs, and for crafting Doctor's Bags.",
				value: 5,
				clipIndex: 6
			});
			this._SampleList.push({
				text: "Melee Weapons",
				description: "Proficiency at using melee weapons.",
				value: 5,
				clipIndex: 7
			});
			this._SampleList.push({
				text: "Science",
				description: "Proficiency at hacking terminals, recycling energy ammunition at workbenches, crafting chems, and many dialog checks.",
				value: 5,
				clipIndex: 8
			});
			this._SampleList.push({
				text: "Sneak",
				description: "Proficiency at remaining undetected and stealing.",
				value: 5,
				clipIndex: 9
			});
			this._SampleList.push({
				text: "Speech",
				description: "Proficiency at persuading others. Also used to negotiate for better quest rewards and to talk your way out of combat, convincing people to give up vital information and succeeding in multiple speech checks.",
				value: 5,
				clipIndex: 10
			});
			this._SampleList.push({
				text: "Survival",
				description: "Proficiency at cooking, making poisons, and crafting \"natural\" equipment and consumables. Also yields increased benefits from food.",
				value: 5,
				clipIndex: 11
			});
			this._SampleList.push({
				text: "Unarmed",
				description: "Proficiency at unarmed fighting.",
				value: 5,
				clipIndex: 12
			});
		}
		
		private function newlist1(): * {
			this._SampleList1 = new Array();
			this._SampleList1.push({
				text: "Barter",
				description: "Proficiency at trading and haggling. Also used to negotiate better quest rewards or occasionally as a bribe-like alternative to Speech.",
				value: 5,
				clipIndex: 0
			});
			this._SampleList1.push({
				text: "Crafting",
				description: "Proficiency at repairing items and crafting items and ammunition.",
				value: 5,
				clipIndex: 1
			});
		}
		
	  private function atrace(param1: String):*{
	  if (!debugmode) {return};
	  atf.appendText(param1+"\n");
	  atf.scrollV=atf.maxScrollV;
	  }
	}
}