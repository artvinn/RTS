package;

import phoenix.geometry.LineGeometry;
import luxe.Vector;
import luxe.Color;
import luxe.Text;

typedef Point = {x: Int, y: Int};

class Node {
	public var x:Int;
	public var y:Int;
	public var walkable:Bool = true;
	public var parentNode:Node;
	public var G:Float = 0;
	public var H:Float;
	public var F:Float;
	public var starter:Bool;

	public function new(p: Point) {
		this.x = p.x;
		this.y = p.y;
	}

	public function isInArray(arr:Array<Node>):Bool
	{	
        var checkX:Bool = false;
		for (i in arr)
		{
            if(i.x == this.x && i.y == this.y) {
            	checkX = true;
            	break;
        	}
		}
        return checkX;
	}

	public function equals(p: Node):Bool
	{
		return (this.x == p.x && this.y == p.y);
	}
}

class Grid
{
	public var grid : Array<Node>;
	private var width : Int;
	private var height : Int;
	private var tileWidth : Int = 48;
	private var tileHeight : Int = 48;

	public function new(w:Int, h:Int)
	{
		width = Std.int(w / tileWidth);
		height = Std.int(h / tileHeight);
		grid = new Array();
	}

	public function makeGrid()
	{
		for (i in 0...width)
		{
			for (j in 0...height)
			{	
				grid.push(new Node({x: i, y: j}));
			}
		}
		grid[1].walkable = false;
		grid[11].walkable = false;
		grid[21].walkable = false;
		grid[4].walkable = false;
		drawGrid();
	}

	public function getNeighbors(pos: Point):Array<Node>
	{	
		var x = pos.x;
		var y = pos.y;

		var neighbors = [];

		if (y + 1 <= height - 1)
		{
			neighbors.push(getNode({x: x,  y: y + 1}));
		}

		if (x + 1 <= width - 1)
		{
			neighbors.push(getNode({x: x + 1,  y: y}));
		}

		if (y - 1 >= 0)
		{
			neighbors.push(getNode({x: x,  y: y - 1}));
		}

		if (x - 1 >= 0)
		{
			neighbors.push(getNode({x: x - 1,  y: y}));
		}

		return neighbors;
	}

	public function getNode(p: Point):Node
	{
		var x = p.x;
		var y = p.y;
		var node:Node = null;
		for (i in grid)
		{
			if (i.x == x && i.y == y)
				node = i;
		}
		return node;
	}

	public function drawGrid()
	{
		for (x in 0...width)
		{
			Luxe.draw.line({
			    p0 : new Vector(tileWidth * x, 0),
			    p1 : new Vector(tileWidth * x, Luxe.screen.h),
			    color : new Color( 0.5, 0.2, 0.2, 1 )
			});
		}

		for (y in 0...height)
		{
			Luxe.draw.line({
			    p0 : new Vector(0, tileHeight * y),
			    p1 : new Vector(Luxe.screen.w, tileHeight * y),
			    color : new Color( 0.5, 0.2, 0.2, 1 )
			});
		}

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var text = new Text({
		            pos : new Vector(x * tileWidth + 20, y * tileHeight + 20),
		            point_size : 14,
		            depth : 1,
		            align : TextAlign.center,
		            text : x + ', ' + y ,
		            color : new Color( 0.6, 0.6, 0.2 )
		        });
			}
		}
	}
}