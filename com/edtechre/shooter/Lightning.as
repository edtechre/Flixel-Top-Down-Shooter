package com.edtechre.shooter
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import org.flixel.*;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	
	public class Lightning extends FlxSprite
	{
		private var radius:Number = 1;
		private var visibleDuration:Number = .25;
		private var visibleTimer:Number;
		private var targetX:int;
		private var targetY:int;
		private var originX:int;
		private var originY:int;
		private var glowColor:uint;
		
		public function Lightning():void
		{
			super();
			solid = false;
			this.kill();
		}
		
		public function SetOrigin(origin:FlxPoint):void {
			originX = origin.x;
			originY = origin.y;
		}
		
		public function SetTarget(target:FlxPoint):void {
			targetX = target.x;
			targetY = target.y;
		}
		
		public function SetColor(glowColor:uint):void {
			this.glowColor = glowColor;
		}
		
		override public function update():void
		{
			visibleTimer -= FlxG.elapsed;
			
			if (visibleTimer <= 0)
				this.kill();
			super.update();
		}
		
		override public function render():void
		{
			var canvas:Shape = new Shape();
			var scrollX:int = FlxG.scroll.x;
			var scrollY:int = FlxG.scroll.y;
			if (Math.random() < .8)
			{
				var boltOrigin:FlxPoint = new FlxPoint(originX, originY)
				var dx:int = boltOrigin.x - (targetX+scrollX);
				var dy:int = boltOrigin.y - (targetY+scrollY);
				var dist:int = int(Math.sqrt (dx * dx + dy * dy));
				var radians:Number = Math.atan2 (dy, dx);
				var theAngle:Number = radians * 180 / Math.PI;
				//canvas.graphics.clear();
				canvas.graphics.lineStyle(2, 0xffffff);
				canvas.graphics.moveTo (boltOrigin.x, boltOrigin.y);
		
				var traveled:Number = 0;
				var linethickness:Number = 3;
				var alpha:Number = 0;
				var timer:Number = 20;
				while (traveled < dist - 10)
				{
						var speed:Number = Math.random()*2 + 30;
						var tmpAngle:Number = theAngle * Math.PI / 180;
						var bx:int = traveled * Math.cos (tmpAngle);
						var by:int = traveled * Math.sin (tmpAngle);
						traveled += speed;
						var theX:Number = (boltOrigin.x - bx) + Math.random () * 25 - 13;
						var theY:Number = (boltOrigin.y - by) + Math.random () * 25 - 13;
						
						canvas.graphics.lineStyle (linethickness, 0xFFFFFF, 1);
						canvas.graphics.lineTo (theX, theY);
						linethickness -= 1;
						alpha += .25;
				}
				canvas.graphics.lineTo (targetX+scrollX, targetY+scrollY);
				canvas.graphics.endFill();
				var glow:GlowFilter = new GlowFilter;
				glow.color = glowColor;
				glow.strength = 6;
				glow.blurX = 24;
				glow.blurY = 24;
				canvas.filters = [glow];
				FlxG.buffer.draw(canvas,null,null,"screen");	
			}
		
		}
		
		public function strike(X:int, Y:int):void
		{
			this.x = X;
			this.y = Y;
			this.exists = true;
			this.dead = false;
			visibleTimer = visibleDuration;
		}
	}
}