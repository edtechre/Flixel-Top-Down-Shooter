package com.edtechre.shooter 
{	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import org.flixel.*;
	import flash.utils.Timer;
	
	public class PlayState extends FlxState
	{
		private static const INTERVAL:uint = 100;
		
		private var _player:Player;
		
		private var _bg1:SpaceBackground;
		private var _bg2:SpaceBackground;
		
		private var _timer:Timer;
		private var _time:uint = 0;
		private var _enemyQueue:PriorityQueue;
		private var _enemies:FlxGroup;
		
		private var _numLevels:uint = 1;
		private var _level:Level;
		private var _playerBullets:FlxGroup;
		private var _enemyBullets:FlxGroup;
		private var _bolts:FlxGroup;
		
		override public function create():void {
			// Load levels
			_enemyQueue = new PriorityQueue();
			nextLevel();
			
			// Create backgrounds
			_bg1 = new SpaceBackground(this, FlxG.width, FlxG.height, 4, 15, 0xff666666);
			_bg2 = new SpaceBackground(this, FlxG.width, FlxG.height, 8, 15, 0xffb3b3b3);
			
			// Create enemy group
			_enemyBullets = new FlxGroup();
			add(_enemyBullets);
			_enemies = new FlxGroup();
			add(_enemies);
			
			// Create player
			_bolts = new FlxGroup();
			add(_bolts);
			_playerBullets = new FlxGroup();
			add(_playerBullets);
			_player = new Player(FlxG.width / 2 - Player.WIDTH / 2, 0, _playerBullets, _bolts);
			_player.y = FlxG.height - _player.height;
			_player.addEventListener(Player.KILLED, onPlayerKilled); 
			add(_player);
			
			// Fade in
			FlxG.flash.start(0xff131c1b);
			
			// Enemy priority queue, test every half second
			_timer = new Timer(INTERVAL);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		public function onTimer(timer:TimerEvent):void {
			_time += INTERVAL;
			var enemyNode:XML = _enemyQueue.dequeue(_time) as XML;
			while (enemyNode != null) {
				// Add enemy object
				var _class:Class = flash.utils.getDefinitionByName("com.edtechre.shooter." + enemyNode.@type) as Class; 
				var color:uint = Game.BLUE;
				if (enemyNode.@red != undefined) {
					color = Game.RED;
				}
				var enemy:Enemy = new _class(enemyNode.@x, 0, color, _enemyBullets) as Enemy;
				enemy.y = -enemy.height;
				// Add kill event listener
				enemy.addEventListener(Enemy.KILLED, onEnemyKilled);
				_enemies.add(enemy);
				enemyNode = _enemyQueue.dequeue(_time) as XML;
			}
		}
		
		public function nextLevel():void {
			
			// Check for last level
			// if (FlxG.level != numLevels) {
				// Load level
				_level = new Level(++FlxG.level);
				// Populate enemyQueue with level objects
				_enemyQueue.clear();
				for (var i:uint = 0; i < _level.enemies.length(); i++) {
					_enemyQueue.enqueue(_level.enemies[i], _level.enemies[i].@time);
				}
			// Transition animation
			// } else {
				// Change to game end state
			//}
		}
		
		public function onEnemyKilled(event:Event):void {
			var enemy:Enemy = event.target as Enemy;
			if (enemy.culled) {
				trace("Culled");
			} else {
				trace("Killed");
			}
			// Check whether all enemies have been killed
			--_level.numEnemies;
			if (_level.numEnemies <= 0) {
				this.addBoss();
			}
		}
		
		public function addBoss():void {
			// Boss transition
			trace("Add boss");
			// Add boss object
		}
		
		public function onBossKilled(event:Event):void {
			// Move to next level
			nextLevel();
		}
		
		public function onPlayerKilled(event:Event):void {
			
			trace("Player killed");
		}
		
		override public function update():void
		{	
			super.update();
			// Scroll both star backgrounds
			_bg1.update();
			_bg2.update();
			// Player bullets to enemies
			FlxU.overlap(_playerBullets, _enemies, playerBulletToEnemy);
			// Enemy bullets to player
			
			// Player to enemy
			FlxU.overlap(_player, _enemies, playerToEnemy);
		}
		
		protected function playerBulletToEnemy(Object1:FlxObject, Object2:FlxObject):void {
			// Double the damage if bullet is opposite color of enemy
			var bullet:Bullet = Object1 as Bullet;
			var enemy:Enemy = Object2 as Enemy;
			if (bullet.color == enemy.color) {
				enemy.hurt(1);
			} else {
				enemy.hurt(2);
			}
			bullet.kill();
		}
		
		protected function playerToEnemyBullet(Object1:FlxObject, Object2:FlxObject):void {
			var player:Player = Object1 as Player;
			var bullet:Bullet = Object2 as Bullet;
			// If the same color, add to player's power bar
			if (player.color == bullet.color) {
			
			// Otherwise damage player
			} else {
				player.hurt(1);
			}
			
			bullet.kill();
		}
		
		protected function playerToEnemy(Object1:FlxObject, Object2:FlxObject):void {
			Object1.kill();
		}
	}
}