package com.edtechre.shooter 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import org.flixel.*;
	
	public class Player extends FlxSprite implements IEventDispatcher
	{	
		public static const KILLED:String = "Killed";
		public static const WIDTH:uint = 32;
		public static const HEIGHT:uint = 48;
		
		private var _speed:Number = 180;
		private var _currBullet:int = 0;
		private var _bulletSpeed:int = -400;
		private var _bullets:FlxGroup;
		private var _parent:FlxState;
		private var _dispatcher:EventDispatcher;
		private var _bitmap:Bitmap;
		private var _bolts:FlxGroup;
		
		public function Player(X:int,Y:int,Bullets:FlxGroup,Bolts:FlxGroup) 
		{
			super(X, Y);
			health = 10;
			_dispatcher = new EventDispatcher(this);
			_bullets = Bullets;
			//loadGraphic(ImgPlayer, true, true, 32, 48);
			createGraphic(WIDTH, HEIGHT, 0xffffffff);
			color = Game.RED;
			_bitmap = new Bitmap(_framePixels);
			_bolts = Bolts;
		}
		
		override public function update():void
		{
			var rect:Rectangle = new Rectangle(x, y, width, height);
			_pixels.fillRect(rect, 0xFF0000);
			
			//MOVEMENT
			velocity.x = velocity.y = 0;
			acceleration.x = acceleration.y = 0;
			drag.x = drag.y = 0;
			if(FlxG.keys.LEFT) {
				velocity.x = -_speed;
			}
			else if(FlxG.keys.RIGHT) {
				velocity.x = _speed;
			}
			if (FlxG.keys.UP) {
				velocity.y = -_speed;
			} else if (FlxG.keys.DOWN) {
				velocity.y = _speed;
			}
			
			if (FlxG.keys.justPressed("S")) {
				if (color == Game.RED) {
					color = Game.BLUE;
				} else {
					color = Game.RED;
				}
			}
			
			if (FlxG.keys.D) {
				var bolt:Lightning = _bolts.add(new Lightning()) as Lightning;
				var origin:FlxPoint = new FlxPoint(x, 0);
				bolt.SetColor(color);
				bolt.SetOrigin(origin);
				var target:FlxPoint = new FlxPoint(x + width / 2, y + height / 2);
				bolt.SetTarget(target);
				bolt.strike(target.x, target.y);
			}
			_bolts.x = x;
			_bolts.y = y;
			
			if (FlxG.keys.justPressed("A")) {
				var bX:int = x + width / 2 - Bullet.WIDTH / 2;
				var bY:int = y - height / 2 + 16;
				var bullet:Bullet = new Bullet(bX, bY, 0, _bulletSpeed, color, true);
				_bullets.add(bullet);
			}
		
			//UPDATE POSITION AND ANIMATION
			super.update();
			
			// Keep in bounds
			if (x < 0) {
				x = 0;
			} else if (x + width > FlxG.width) {
				x = FlxG.width - width;
			}
			if (y < 0) {
				y = 0;
			} else if (y + height > FlxG.height) {
				y = FlxG.height - height;
			}
		}
		
		override public function kill():void 
		{
			// Fire event when player dies
			if (!dead) {
				dispatchEvent(new Event(Player.KILLED));
				dead = true;
			}
		}
		
		override public function hurt(Damage:Number):void {
			flicker(0.2);
			super.hurt(Damage);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean  = false, priority:int = 0, useWeakReference:Boolean  = false):void 
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean 
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean 
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean  = false):void 
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean 
		{
			return _dispatcher.willTrigger(type);
		}
	}
}