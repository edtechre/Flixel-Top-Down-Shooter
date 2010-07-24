package com.edtechre.shooter
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.xml.*;
	import flash.utils.ByteArray;
	
	public class Level
	{	
		public var enemies:XMLList;
		public var boss:Enemy;
		public var numEnemies:int;
		
		public static var xml:XML = null;
		
		[Embed(source="data/Levels.xml",mimeType="application/octet-stream")] protected const EmbeddedXML:Class;
		
		public function Level(n:int) 
		{
			// Create XML object from embedded XML data
			if (xml == null) {
				var ba:ByteArray = (new EmbeddedXML()) as ByteArray;
				var s:String = ba.readUTFBytes(ba.length);
				// IMPORTANT, remove BOM character to fix parsing
				s = s.replace(String.fromCharCode(65279), "");
				xml = new XML(s);
				xml.ignoreWhitespace = true;
			}	
			// Get nth level from XML file
			enemies = xml.level[n - 1].enemies.children();
			numEnemies = enemies.length();
		}
	}
}