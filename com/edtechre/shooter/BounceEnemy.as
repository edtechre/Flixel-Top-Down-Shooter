package com.edtechre.shooter 
{
	import org.flixel.*;
	
	public class BounceEnemy extends Enemy
	{
		public function BounceEnemy(X:int,Y:int,Color:uint,Bullets:FlxGroup) 
		{
			super(X, Y, 32, 32, Color, Bullets);
			health = 3;
			velocity.y = 200;
			velocity.x = 300;
			var dir:int = Math.round(Math.random());
			if (dir == 1) {
				velocity.x *= -1;
			}
		}
		
		override public function update():void {
			super.update();
			
			if (x < 0) {
				x = 0;
				velocity.x *= -1;
			} else if (x + width > FlxG.width) {
				x = FlxG.width - width;
				velocity.x *= -1;
			}
			
			if (y < 0) {
				y = 0;
				velocity.y *= -1;
			} else if (y + height > FlxG.height) {
				y = FlxG.height - height;
				velocity.y *= -1;
			}
		}
	}
}