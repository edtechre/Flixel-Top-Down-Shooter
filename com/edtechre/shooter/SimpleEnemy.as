package com.edtechre.shooter
{
	import org.flixel.*;
	
	public class SimpleEnemy extends Enemy
	{	
		public function SimpleEnemy(X:int,Y:int,Color:uint,Bullets:FlxGroup) 
		{
			super(X, Y, 32, 32, Color, Bullets);
			velocity.y = 700;
		}
	}
}