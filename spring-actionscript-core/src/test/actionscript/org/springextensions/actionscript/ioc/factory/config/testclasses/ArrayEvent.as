package org.springextensions.actionscript.ioc.factory.config.testclasses {

	import flash.events.Event;

	public class ArrayEvent extends Event {

		public static const REVERSE:String = "reverseArray";

		public var array:Array;

		public function ArrayEvent(type:String, array:Array) {
			super(type);
			this.array = array;
		}

		override public function clone():Event {
			return new ArrayEvent(type, array);
		}
	}
}