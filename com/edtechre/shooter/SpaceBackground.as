package com.edtechre.shooter
{
	import flash.display.BitmapData;
	import org.flixel.*;
	
	public class SpaceBackground
	{
		
		protected var _density:int = 50;
		protected var _bg1:FlxSprite;
		protected var _bg2:FlxSprite;
		protected var _speed:Number;
		protected var _width:Number;
		protected var _height:Number;
		protected var _starColor:uint;
		protected var _state:FlxState;
		
		public function SpaceBackground(State:FlxState, Width:Number, Height:Number, Speed:Number, Density:Number=50, StarColor:uint=0xffffffff) 
		{
			_state = State;
			_speed = Speed;
			_width = Width;
			_height = Height;
			_starColor = StarColor;
			_density = Density;
			
			// Create sprites that hold bitmap data
			_bg1 = new FlxSprite(0, 0);
			_bg1.pixels = createBitmap();
			_bg2 = new FlxSprite(0, -_height);
			_bg2.pixels = createBitmap();
			_state.add(_bg1);
			_state.add(_bg2);
		}
		
		protected function createBitmap():BitmapData {
			var bitmapData:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
		
			for (var i:int = 0; i < _density; i++) {
				var xpos:Number =  Math.round(Math.random() * _width / 15) * 15;
				var ypos:Number = Math.round(Math.random() * _height / 15) * 15;
				// Draw color by setting bitmap data
				for (var j:int = 0; j <= 4; j++) {
					for (var k:int = 0; k <= 4; k++) {
						bitmapData.setPixel32(xpos + j, ypos + k, _starColor);
					}
				}
			}
			
			return bitmapData;
		}
		
		protected function updateBg(bg:FlxSprite):void {
			bg.y += _speed;
			if (bg.y > _height) {
				bg.y = -_height + bg.y - _height;
				bg.pixels.dispose();
				bg.pixels = createBitmap();
			}
		}
		
		public function update():void {
			updateBg(_bg1);
			updateBg(_bg2);
		}
	}
}