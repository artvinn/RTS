package entities;

import luxe.Sprite;
import luxe.Vector;
import luxe.Input;
import phoenix.Texture;


/**
 * ...
 * @author Zenext
 */
class Unit extends Sprite
{	
	public var moving : Bool = false;
	public var speed : Float = 100;
	public var selected : Bool = false;

	public function new(options) 
	{
		super(options);

		events.listen('select.unit', select_unit);
		events.listen('deselect.unit', deselect_unit);
	}

	function select_unit(data) {
		selected = true;
	}

	function deselect_unit(data) {
		selected = false;
	}

	override public function update(dt:Float) {
		if (selected) {
			size = new Vector(64, 64);
		} else {
			size = new Vector(48, 48);
		}
	}
}