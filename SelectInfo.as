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

// original by osmosis-wrench 2022
class SelectInfo extends MovieClip
{
	var option_id: String;

	var name: TextField;
	var level: TextField;
	var sex: TextField;
	var location: TextField;
	var time: TextField;
	var wanted: TextField;

	var empty: TextField;
	var foreground: MovieClip;

	private var baseW: Number;
	private var baseH: Number;

	public function get isDisabled() {
		return empty.text != "";
	}

	private function SelectInfo() {
		super();
		this.ClearData();
		
		// Stores the base width and height of the movieclip so we can reset the size after tweens etc later.
		baseW = foreground._width;
		baseH = foreground._height;

		_alpha = 25;
	}

	/* PUBLIC */

	public function ClearData()
	{
		option_id = "";
		empty.text = "EMPTY";

		name.text = "";
		level.text = "";
		sex.text = "";
		location.text = "";
		time.text = "";
		wanted.text = "";

		clearHighlight();
		_alpha = 25;
	}

	public function SetData(id: String, arg_name: String, lv: String, arg_sex: String, arg_loc: String, arg_time: String, arg_wanted: Boolean)
	{
		id = option_id;
		empty.text = "";

		name.text = arg_name;
		level.text = lv;
		sex.text = arg_sex
		location.text = arg_loc;
		time.text = arg_time;
		wanted.text = arg_wanted ? "WANTED" : "";

		_alpha = 70;
	}

	public function HandleHighlight(): Void
	{
		this._alpha = 100;
		foreground._width = baseW;
		foreground._height = baseH

		TweenLite.to(foreground, 0.5, {_width:baseW+2, _height:baseH+2});
	}
	
	public function clearHighlight(): Void
	{
		this._alpha = 80;
		TweenLite.to(foreground, 0.2, {_width:baseW, _height:baseH});
	}
	
	public function HandleSelection(): Void
	{
		TweenLite.to(foreground, 0.5, {_width:baseW+7, _height:this.baseH+7});
	}

	/* IMPL MOVIECLIP */

	public function onRollOver(): Void
	{
		if (isDisabled)
			return;

		_parent.SetCurrentSelection(this);
	}

	public function onMouseDown(): Void
	{
		if (isDisabled)
			return;

		if (Mouse.getTopMostEntity()._parent == this) {
			_root.main.DoAccept();
		}
	}

}
