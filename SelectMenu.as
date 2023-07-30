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

	var _options:Array = new Array(3);
	var _optionFillIdx: Number = 0;

	var _selectedIdx:Number;

	public function SelectMenu() {
		super();
		FocusHandler.instance.setFocus(this, 0);
		bg = _root.bg;
		_options = [option0, option1, option2];
		_optionFillIdx = 0;
	}

	private function onLoad() {
		_global.gfxExtensions = true;

		bg._x = 0;
		bg._y = 0;
		bg._width = Stage.visibleRect.width;
		bg._height = Stage.visibleRect.height;

		this._x = Stage.visibleRect.width / 2;
		this._y = Stage.visibleRect.height / 2;

		TweenLite.from(_root, 0.6, {_alpha:0});
	}

	public function SetData(id: String, name:String, lv:String, sex:String, loc:String, time:String, wanted:String) {
		if (_optionFillIdx >= _options.length) {
			skse.Log("Cannot set data for more than " + _options.length + " options");
			return;
		}
		_options[_optionFillIdx++].SetData(id, name, lv, sex, loc, time, wanted == "1");
		if (_optionFillIdx == 1) {
			updateSelection(0);
		}
	}

	/* GFX */

	public function handleInput(details:InputDetails, pathToFocus:Array):Boolean {
		if (!GlobalFunc.IsKeyPressed(details))
			return false;

		switch (details.navEquivalent) {
		case NavigationCode.TAB:
			CancelSelection();
			break;
		case NavigationCode.ENTER:
			if (!_options[_selectedIdx].IsDisabled()) {
				AcceptSelection()
			}
			break;
		case NavigationCode.UP:
			{
				var newidx = _selectedIdx - 1;
				if (newidx < 0)	
					newidx = _options.length - 1;

				updateSelection(newidx)
			}
			break;
		case NavigationCode.DOWN:
			{
				var newidx = _selectedIdx + 1;
				if (newidx > _options.length - 1)	
					newidx = 0;

				updateSelection(newidx)
			}
			break;
		case NavigationCode.PAGE_DOWN:
			updateSelection(_options.length - 1);
			break;
		case NavigationCode.PAGE_UP:
			updateSelection(0);
			break;
		default:
			return false;
		}
		return true;
	}

	/* PRIVATE */

	private function AcceptSelection() {
		skse.SendModEvent("AchMarket_SELECT", _options[_selectedIdx].option_id);

		_options[_selectedIdx].HandleSelection();
		CloseMenu();
	}
	private function CancelSelection() {
		skse.SendModEvent("AchMarket_CANCEL");
		CloseMenu()
	}

	private function updateSelectionObj(newSelect) {
		for (var i = 0; i < _options.length; i++) {
			if (newSelect == _options[i]) {
				updateSelection(i);
				return;
			}
		}
		skse.Log("Invalid update request");
	}
	private function updateSelection(newIdx) {
		if (newIdx == _selectedIdx)
			return;

		_options[_selectedIdx].clearHighlight();
		_options[newIdx].highlight();
		_selectedIdx = newIdx;
	}

	private function CloseMenu() {
		TweenLite.to(this, 0.4, { _alpha:0, onComplete:_root.main.CloseMenuImpl});
		TweenLite.to(bg, 0.4, { _alpha:0 });
	}
	public function CloseMenuImpl() {
		skse.CloseMenu("CustomMenu");
	}

	private function isAllOptionsDisabled():Boolean {
		for (var i:Number = 0; i < _options.length; i++) {
			if (!_options[i].IsDisabled()) {
				return false;
			}
		}
		return true;
	}

}