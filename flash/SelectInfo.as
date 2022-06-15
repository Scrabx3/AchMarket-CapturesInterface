import com.greensock.*;
import com.greensock.easing.*;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import mx.utils.Delegate;
import skse;
import Mouse;
// by osmosis-wrench 2022
class SelectInfo extends MovieClip
{
	var name: TextField;
	var level: TextField;
	var sex: TextField;
	var location: TextField;
	var time: TextField;
	var rarity: TextField;
	var wanted: TextField;

	var empty: TextField;
	var foreground: MovieClip;

	private var baseW: Number;
	private var baseH: Number;

	private function SelectInfo() {
		super();
		this.ClearData();
		
		// Stores the base width and height of the movieclip so we can reset the size after tweens etc later.
		baseW = foreground._width;
		baseH = foreground._height;

		this._alpha = 70;
		this.onRollOver = function ()
		{
			// When you the mouse over and option, set it as the current selection. 
			// This function calls back to HandleHighlight the current selection, and Clearhighlight the previous one.
			_parent.SetCurrentSelection(this);
			// _parent.Options[5].EnableOption();
		};
		
		this.onMouseDown = function ()
		{
			// This line is needed to allow flash to understand which of the icons you are clicking on, because they are all the same object. 
			// This is also a scaleform function, so doesn't work in the flash player.
			if (Mouse.getTopMostEntity()._parent == this) {
				_root.main.DoAccept();
			}
		};
	}

	public function ClearData()
	{
		empty.text = "EMPTY";

		name.text = "";
		level.text = "";
		sex.text = "";
		location.text = "";
		time.text = "";
		rarity.text = "";
		wanted.text = "";
	}

	public function SetData(n: String, lv: String, sx: String, loc: String, t: String, r: String, w: Boolean)
	{
		empty.text = "";

		name.text = n;
		level.text = lv;
		sex.text = sx
		location.text = loc;
		time.text = t;
		wanted.text = w ? "WANTED" : "";
	}

	public function IsDisabled(): Boolean
	{
		return empty.text != "";
	}

	public function HandleHighlight(): Void
	{
		this._alpha = 100;
		foreground._width = baseW;
		foreground._height = baseH
		
		// Tween to a slightly larger size to indicate selection.
		TweenLite.to(foreground, 0.5, {_width:baseW+2, _height:baseH+2});
	}
	
	public function ClearHighlight(): Void
	{
		this._alpha = 80;
		// Tween back to original size.
		TweenLite.to(foreground, 0.2, {_width:baseW, _height:baseH});
	}
	
	public function HandleSelection(): Void
	{
		TweenLite.to(foreground, 0.5, {_width:baseW+7, _height:this.baseH+7});
	}
	
	public function DisableOption(): Void
	{
		delete this.onRollOver;
		delete this.onMouseDown;
		ClearHighlight();
		this._alpha = 25;
	}
}
