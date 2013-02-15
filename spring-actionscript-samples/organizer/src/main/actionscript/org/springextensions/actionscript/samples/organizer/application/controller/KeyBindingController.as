package org.springextensions.actionscript.samples.organizer.application.controller {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
	import org.springextensions.actionscript.utils.ApplicationUtils;
	
	public class KeyBindingController extends EventDispatcher {
		
		public function KeyBindingController() {
			ApplicationUtils.application.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void {
			var eventType:String;
			
			switch (true) {
				case Keyboard.DELETE:
				case (event.ctrlKey && (event.keyCode == Keyboard.D)):
					eventType = ApplicationEvents.DELETE_CONTACT;
					break;
				case (event.ctrlKey && (event.keyCode == Keyboard.N)):
					eventType = ApplicationEvents.ADD_CONTACT;
					break;
				case (event.ctrlKey && (event.keyCode == Keyboard.O)):
					eventType = ApplicationEvents.OPEN_CONTACT;
					break;
			}
			
			if (eventType) {
				EventBus.dispatchEvent(new Event(eventType));
			}
		}
	}
}