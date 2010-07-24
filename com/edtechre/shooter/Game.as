package com.edtechre.shooter
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	
	public class Game extends FlxGame
	{			
		// State constants
		public static const BLUE:uint = 0x0000ff;
		public static const RED:uint = 0xff0000;
		
		// Levels file
		public static const LEVELS_FILE:String = "data/Levels.xml";
		
		// Needed for reflection.  Classes need to be made available at compile time
		private var _enemyClasses:Array = [SimpleEnemy, BounceEnemy];
		
		[Embed(source = "data/particle_blue.png")] public static var BlueParticle:Class;
		[Embed(source = "data/particle_red.png")] public static var RedParticle:Class;
		
		public function Game() 
		{
			FlxG.width = 640;
			FlxG.height = 480;
			super(FlxG.width, FlxG.height, PlayState, 1);
		}
	}
}