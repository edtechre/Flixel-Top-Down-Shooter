package com.edtechre.shooter
{
	public class PriorityQueue
	{
		private var _nodes:Array;
		
		public function PriorityQueue() 
		{
			clear();
		}
		
		public function enqueue(object:Object, time:Number):void {
			var node:Node = new Node(object, time);
			// Add to end of array
			_nodes.push(node);
			
			// Walk up the node in the min heap
			var child:uint = _nodes.length - 1;
			var parent:uint = child / 2;
			while (parent > 0) {
				if (node.time < _nodes[parent].time) {
					_nodes[child] = _nodes[parent];
					child = parent; 
					parent /= 2;
				} else {
					break;
				}
			}
			_nodes[child] = node;
		}
		
		public function dequeue(time:Number):Object {
			var node:Node = _nodes[1];
			if (!isEmpty() && node.time <= time) {
				// Place bottommost node as root and walk down
				_nodes[1] = _nodes[_nodes.length - 1];
				var temp:Node = _nodes[1];
				var parent:uint = 1;
				var child:uint = 2;
				while (child < _nodes.length) {
					// Find the smaller of the two children and compare
					if (child < _nodes.length - 1 && _nodes[child + 1].time < _nodes[child].time) {
						++child;
					}
					if (temp.time > _nodes[child].time) {
						_nodes[parent] = _nodes[child];
						parent = child;
						child *= 2;
					} else {
						break;
					}
				}
				_nodes[parent] = temp;
				// Remove from end
				_nodes.pop();
				return node.data;
			} else {
				return null;
			}
		}
		
		public function size():uint {
			return _nodes.length - 1;
		}
		
		public function isEmpty():Boolean {
			return size() <= 0;
		}
		
		public function clear():void {
			_nodes = new Array();
			// Add null event to the front of the array to make parent/child index calculations easier
			_nodes.push(new Node(null, 0));
		}
	}

}