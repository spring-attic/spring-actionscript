package org.springextensions.actionscript.samples.organizer.application.events {
	
	import flash.events.Event;
	
	public class SearchEvent extends Event {
		
		public static const SEARCH:String = "search";
		
		public var query:String;
		
		public function SearchEvent(query:String, bubbles:Boolean = true, cancelable:Boolean = true) {
			super(SEARCH, bubbles, cancelable);
			this.query = query;
		}
	}
}