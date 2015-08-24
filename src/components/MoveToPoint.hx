package components;

import luxe.Sprite;
import luxe.Vector;
import luxe.Input;
import entities.Unit;

class MoveToPoint extends luxe.Component
{
	public var rotate_speed : Float = 10;
    public var max_rotate_speed : Float = 60;

    var sprite : Unit;
    var coords : Vector;
    var coordsX : Vector;

    override function init() {
        sprite = cast entity;

        sprite.events.listen('move_to_point', move_to );
    }

    function move_to(data) {
    	sprite.moving = true;
    	coords = data.coords;
    }

    override function update( dt:Float ) {
        
        if (sprite.moving) {
        	if (sprite.point_inside(coords)) {
				sprite.moving = false;
        	}
        	var direction = coords.clone().subtract(sprite.pos).normalize();
			sprite.pos.add(direction.multiplyScalar(sprite.speed * dt));
        }

    }
}