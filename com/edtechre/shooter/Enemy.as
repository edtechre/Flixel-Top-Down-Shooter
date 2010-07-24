package com.edtechre.shooter
{
	import org.flixel.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Enemy extends FlxSprite implements IEventDispatcher
	{		
		public static const KILLED:String = "Killed";
		
		public var culled:Boolean = false;
		public var colorState:uint;
		private var _dispatcher:EventDispatcher;
		private var _emitter:FlxEmitter;
		private var _bullets:FlxGroup;
		
		public function Enemy(X:int,Y:int,Width:uint,Height:uint,Color:uint,Bullets:FlxGroup,ImgClass:Class=null) 
		{
			super(X, Y);
			color = Color;
			_bullets = Bullets;
			_dispatcher = new EventDispatcher(this);
			_emitter = new FlxEmitter();
			_emitter.delay = 2;
			_emitter.setXSpeed(-150,150);
			_emitter.setYSpeed(-200,200);
			_emitter.gravity = 0;
			FlxG.state.add(_emitter);
			if (ImgClass != null) {
				loadGraphic(ImgClass, true, true, Width, Height);
				color = Color;
			} else {
				// Place holder graphic
				createGraphic(Width, Height, 0xff000000 + Color);
			}
		}
		
		override public function update():void
		{
			super.update();
			// Remove sprite when it goes offscreen
			if (y > FlxG.height) {
				culled = true;
				kill();
			}
		}
		
		override public function kill():void 
		{
			// Send kill event to any listeners
			dispatchEvent(new Event(Enemy.KILLED));
			if (!culled) {
				var ImgClass:Class = null;
				if (color == Game.BLUE) {
					ImgClass = Game.BlueParticle;
				} else {
					ImgClass = Game.RedParticle;
				}
				_emitter.createSprites(ImgClass, 100, 10, true, 0.5);
				_emitter.at(this);
				_emitter.start(true, 0, 20);
			}
			super.kill();
		}
		
		override public function hurt(Damage:Number):void
		{
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