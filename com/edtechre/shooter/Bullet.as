package com.edtechre.shooter 
{
	import org.flixel.*;
	
	public class Bullet extends FlxSprite
	{
		public static const WIDTH:uint = 8;
		public static const HEIGHT:uint = 8;
		
		public var fromPlayer:Boolean;
		
		public function Bullet(X:int, Y:int, VelocityX:int, VelocityY:int, Color:uint, FromPlayer:Boolean=false) 
		{
			super(X, Y);
			fromPlayer = FromPlayer;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
			width = WIDTH;
			height = HEIGHT;
			color = Color;
			// Create square
			createGraphic(width, height, 0xff000000 + color);
		}
		
		override public function kill():void
		{
			if (dead) {
				return;
			}
			velocity.y = 0;
			dead = true;
			solid = false;
			super.kill();
		}
		
		override public function update():void
		{
			// Remove if off screen
			if (x < 0) {
				kill();
				finished = true;
			} else if (x + width > FlxG.width) {
				kill();
				finished = true;
			}
			if (y < 0) {
				kill();
				finished = true;
			} else if (y + height > FlxG.height) {
				kill();
				finished = true;
			}
			
			if (dead && finished) {
				exists = false;
			} else {
				super.update();
			}
		}
	}
}