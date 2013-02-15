package org.springextensions.actionscript.samples.organizer.application.events {
	
	import flash.events.Event;
	
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	
	public class ContactEvent extends Event {
		
		public static const OPEN:String = ApplicationEvents.OPEN_CONTACT;
		
		public static const ADD:String = ApplicationEvents.ADD_CONTACT;
		
		public static const SAVE_AND_CLOSE:String = "saveAndCloseContact";
		
		public static const SAVED:String = "contactSaved";
		
		public static const SELECT:String = "selectContact";
		
		public static const DELETE:String = ApplicationEvents.DELETE_CONTACT;
		
		public static const DELETED:String = "contactDeleted";
		
		private var _contact:Contact;
		
		public function ContactEvent(type:String, contact:Contact = null, bubbles:Boolean = true, cancelable:Boolean = true) {
			super(type, bubbles, cancelable);
			_contact = contact;
		}
		
		public function get contact():Contact {
			return _contact;
		}
		
		override public function clone():Event {
			return new ContactEvent(type, contact, bubbles, cancelable);
		}
	}
	
}