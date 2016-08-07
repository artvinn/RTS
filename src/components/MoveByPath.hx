package components;

import luxe.Sprite;
import luxe.Vector;
import luxe.Input;
import entities.Unit;
import Grid;

class MoveByPath extends luxe.Component
{

    public var rotate_speed : Float = 10;
    public var max_rotate_speed : Float = 60;

    var sprite : Unit;
    var coords : Vector;
    var coordsX : Vector;

    override function init() {
        sprite = cast entity;

        sprite.events.listen('move', move_to );
    }

    function move_to(data) {
        sprite.pos = new Vector(data.nodes[0].x * 48 + sprite.size.x / 2, data.nodes[0].y * 48 + sprite.size.y / 2);
    }

    override function update( dt:Float ) {

    }
}