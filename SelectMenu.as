import com.greensock.*;
import com.greensock.easing.*;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import mx.utils.Delegate;
import skse;

class SelectMenu extends MovieClip {
	var bg:MovieClip;

	var option0:MovieClip;
	var option1:MovieClip;
	var option2:MovieClip;

	var options:Array = new Array(3);

	var CurrentSelection:MovieClip;
	var CurrentSelectionIdx:Number;

	public function SelectMenu() {
		super();
		FocusHandler.instance.setFocus(this,0);
		bg = _root.bg;
		options = [option0, option1, option2];
	}

	private function onLoad() {
		// Handle resizing the bg element for ultrawidescreen
		var stageObj = new Object();
		Stage.addListener(stageObj);
		stageObj.onResize = function() {
			_root.bg._width = Stage.width;
			_root.bg._height = Stage.height;
		};
		stageObj.onResize();
		Stage.addListener(stageObj);

		TweenLite.from(_root,0.6,{_alpha:0});
	}

	public function SetData(optionid:Number, n:String, lv:String, sx:String, loc:String, t:String, r:String, w:Boolean) {
		options[optionid].SetData(n,lv,sx,loc,t,r,w);
	}

	public function OpenMenu():Void {
		var len:Number = options.length;
		for (var i:Number = 0; i < len; i++) {
			if (options[i].IsDisabled()) {
				options[i].DisableOption();
			}
		}

		if (isalldisabled()) {
			return;
		}
		CurrentSelectionIdx = 0;
		while (options[CurrentSelectionIdx].IsDisabled()) {
			CurrentSelectionIdx++;
		}
		SetCurrentSelection(options[CurrentSelectionIdx]);
	}

	public function SetCurrentSelection(next:MovieClip) {
		CurrentSelection.ClearHighlight();// Clear old highlight tween.
		CurrentSelection = next;
		for (var x = 0; x < options.length; x++) {
			if (options[x] == CurrentSelection) {// Find index for current selection.
				CurrentSelectionIdx = x;
			}
		}
		CurrentSelection.HandleHighlight();// Start new highlight tween.
	}

	public function DoAccept() {
		// Event sending the chosen Victims name and FormID
		skse.SendModEvent("YKCaptures_Accept",CurrentSelection.name,CurrentSelectionIdx);
		CurrentSelection.HandleSelection();
		trace(CurrentSelectionIdx);
		DoExit();
	}

	public function DoCancel() {
		skse.SendModEvent("YKCaptures_Cancel");// Send ModEvent called "YamMenu_Cancel" to indicate the menu has been closed.
		DoExit();
	}

	private function DoExit() {
		TweenLite.to(this,0.4,{_alpha:0, onComplete:_root.main.DoClose});// When this tween completes, call DoClose();
		TweenLite.to(bg,0.4,{_alpha:0});
	}
	private function DoClose() {
		trace("exiting");
		skse.CloseMenu("CustomMenu");
	}

	public function handleInput(details:InputDetails, pathToFocus:Array):Void {
		//_root.test1.text = "value=" + details.value+ "navEquivalent=" + details.navEquivalent;
		if (GlobalFunc.IsKeyPressed(details)) {
			var last = options.length - 1;
			if (details.navEquivalent == NavigationCode.TAB) {
				DoCancel();
			} else if (details.navEquivalent == NavigationCode.ENTER && !CurrentSelection.IsDisabled()) {
				DoAccept();
			} else if (isalldisabled()) {
				return;
			} else if (details.navEquivalent == NavigationCode.UP) {
				CurrentSelectionIdx--;
				while (true) {
					if (CurrentSelectionIdx < 0) {
						CurrentSelectionIdx = last;
					}
					if (!options[CurrentSelectionIdx].IsDisabled()) {
						if (options[CurrentSelectionIdx] != CurrentSelection)
							SetCurrentSelection(options[CurrentSelectionIdx]);
						break;
					}
					CurrentSelectionIdx--;
				}
			} else if (details.navEquivalent == NavigationCode.DOWN) {
				CurrentSelectionIdx++;
				while (true) {
					if (CurrentSelectionIdx == options.length) {
						CurrentSelectionIdx = 0;
					}
					if (!options[CurrentSelectionIdx].IsDisabled()) {
						if (options[CurrentSelectionIdx] != CurrentSelection)
							SetCurrentSelection(options[CurrentSelectionIdx]);
						break;
					}
					CurrentSelectionIdx++;
				}
			}
		}
	}

	private function isalldisabled():Boolean {
		for (var i:Number = 0; i < options.length; i++) {
			if (!options[i].IsDisabled()) {
				return false;
			}
		}
		return true;
	}
}