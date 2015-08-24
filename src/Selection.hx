package;

import luxe.Sprite;
import luxe.Vector;
import luxe.Input;
import phoenix.Texture;

var selectionX : Float;
var selectionY : Float;
var selectionW : Float;
var selectionH : Float;
var mousePressed : Bool = false;
var mouseMoving : Bool;

class Selection extends luxe.Game
{	

	public function ready() 
	{
		
	}

	override function update(dt:Float)
	{
		if (mousePressed) {
			Luxe.draw.box({
				immediate: true,
			    x : selectionX, 
			    y : selectionY,
			    w : selectionW, 
			    h : selectionH,
			    color : new Color( 0.4, 0.4, 0.4, 0.3 ),
			    depth : 2
			});

			var polygon = Polygon.rectangle(selectionX, selectionY, selectionW, selectionH, false);

			for (unit in Main.units) {
				if (!unit.selected && Collision.pointInPoly(unit.pos, polygon)) {
					unit.selected = true;
				} else if (!unit.selected && !Collision.pointInPoly(unit.pos, polygon)) {
					unit.selected = false;
				}
			}
		}
	}

	override function onmousedown(event:MouseEvent) {
		mousePressed = true;
		selectionX = event.pos.x;
		selectionY = event.pos.y;

		for (unit in Main.units) {
			if (event.button == 1) {
				if (!unit.selected && unit.point_inside(event.pos)) {
					unit.selected = true;
				} else if (unit.selected && !unit.point_inside(event.pos)) {
					unit.selected = false;
				}
			} else if (event.button == 3) {
				if (unit.selected) {
					unit.events.fire('move_to_point', {coords:event.pos});
				}
			}
		}
	}
	
	override function onmouseup(event:MouseEvent) {
		mousePressed = false;

		selectionX = 0;
		selectionY = 0;
		selectionW = 0;
		selectionH = 0;
	}
	
	override function onmousemove(event:MouseEvent) {

		if (mousePressed) {
			selectionW = event.pos.x - selectionX;
			selectionH = event.pos.y - selectionY;
		}
	} 
}