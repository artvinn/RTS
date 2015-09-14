package;

using Lambda;

import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Text;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;
import luxe.collision.shapes.Shape;

import entities.Unit;

import components.MoveToPoint;

import phoenix.Texture;
import phoenix.geometry.RectangleGeometry;

import Grid;
import Pathfinding;

typedef MoveEvent = {
    coords : Vector
}

class Main extends luxe.Game
{
	private var grass : Sprite;
	private var grassTexture : Texture;
	private var text : Text;

	private var selectionX : Float = 0;
	private var selectionY : Float = 0;
	private var selectionW : Float = 0;
	private var selectionH : Float = 0;
	private var leftMousePressed : Bool = false;
	
	private var units : Array<Unit> = new Array();

	private var grid : Grid;

	public var nodes : Array<Dynamic>;
	public var path : Pathfinding;

	override function config(config:luxe.AppConfig) {
		config.preload.textures.push( { id:'assets/grass.png' } );

		return config;
	}

	override function ready()
	{
		connect_input();
		grassTexture = Luxe.resources.texture('assets/grass.png');
		var mono = Luxe.resources.font('assets/fonts/font.fnt');
		
		var grass = new Unit({
			name: 'grass',
			texture: grassTexture,
			pos : new Vector(164, Luxe.screen.mid.y),
			size: new Vector(32, 32),
			centered: true
		});
		grass.add(new components.MoveByPath({name: 'move'}));
		grass.add(new components.MoveToPoint({name: 'rotator'}));
		units.push(grass);

        grid = new Grid(480, 480);
        grid.makeGrid();
        path = new Pathfinding(grid);
        nodes = path.findPath(grid.grid[0], grid.grid[5]);
        trace(nodes);
	}

	override function update(dt:Float)
	{	
		draw_selection();
	}

	private function draw_selection():Void
	{
		if (leftMousePressed)
		{
			Luxe.draw.box({
				immediate: true,
			    x : selectionX, 
			    y : selectionY,
			    w : selectionW, 
			    h : selectionH,
			    color : new Color( 0.4, 0.4, 0.4, 0.3 ),
			    depth : 2
			});

			// Polygon shape to check if selection overlaps sprites
			var polygon = Polygon.rectangle(selectionX, selectionY, selectionW, selectionH, false);

			for (unit in units)
			{
				if (!unit.selected && Collision.pointInPoly(unit.pos, polygon))
				{
					unit.selected = true;
				}
				else if (!unit.selected && !Collision.pointInPoly(unit.pos, polygon))
				{
					unit.selected = false;
				}
			}
		}
	}

	override function onmousedown(event:MouseEvent)
	{
		if (event.button == 1)
		{
			leftMousePressed = true;
		}

		// Selection
		selectionX = event.pos.x;
		selectionY = event.pos.y;

		for (unit in units)
		{
			if (event.button == 1)
			{
				if (!unit.selected && unit.point_inside(event.pos))
				{
					unit.selected = true;
				}
				else if (unit.selected && !unit.point_inside(event.pos))
				{
					unit.selected = false;
				}
			}
			else if (event.button == 3)
			{
				if (unit.selected)
				{	
					//unit.events.fire('move_to_point', {coords:event.pos});
					unit.events.fire('move', {nodes:nodes});
				}
			}
		}
	}
	
	override function onmouseup(event:MouseEvent)
	{

		if (event.button == 1)
		{
			leftMousePressed = false;
		}

		// Reset selection
		selectionX = 0;
		selectionY = 0;
		selectionW = 0;
		selectionH = 0;
	}
	
	override function onmousemove(event:MouseEvent)
	{
		// Set selection width and height
		if (leftMousePressed)
		{
			selectionW = event.pos.x - selectionX;
			selectionH = event.pos.y - selectionY;
		}
	}

	function connect_input() {
		Luxe.input.bind_key('left', Key.left);
		Luxe.input.bind_key('left', Key.key_a);

		Luxe.input.bind_key('right', Key.right);
		Luxe.input.bind_key('right', Key.key_d);
	}
}
