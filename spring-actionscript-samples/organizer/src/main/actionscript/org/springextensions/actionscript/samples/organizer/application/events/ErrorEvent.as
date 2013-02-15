package org.springextensions.actionscript.samples.organizer.application.events
{
	import flash.events.Event;
	
	public class ErrorEvent extends Event
	{
		
		public static const ERROR:String = ApplicationEvents.ERROR;
		
		public function ErrorEvent(error:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(ERROR, bubbles, cancelable);
			_error = error;
		}
		
		private var _error:String;
		
		public function get error():String {
			return _error;
		}
		
		override public function clone():Event {
			return new ErrorEvent(error, bubbles, cancelable);
		}
	}
}