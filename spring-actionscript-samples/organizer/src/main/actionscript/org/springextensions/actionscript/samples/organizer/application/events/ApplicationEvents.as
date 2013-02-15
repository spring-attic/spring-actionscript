package org.springextensions.actionscript.samples.organizer.application.events {
	
	public class ApplicationEvents {
		
		// --------------------------------------------------------------------
		//
		// Application Events
		//
		// --------------------------------------------------------------------
		
		/** general error event */
		public static const ERROR:String = "applicationError";
		
		public static const EXIT_APPLICATION:String = "exitApplication";
		
		public static const CHANGE_CONTACTS_VIEW_MODE:String = "changeContactsViewMode";
		
		// --------------------------------------------------------------------
		//
		// Contact Events
		//
		// --------------------------------------------------------------------
		
		public static const ADD_CONTACT:String = "addContact";
		
		public static const CANCEL_CHANGES_TO_CONTACT:String = "cancelChangesToContact";
		
		public static const CLOSE_CONTACT:String = "closeContact";
		
		public static const CLOSE_SELECTED_CONTACT:String = "closeSelectedContact";
		
		public static const DELETE_CONTACT:String = "deleteContact";
		
		public static const OPEN_CONTACT:String = "openContact";
		
		public static const LOAD_ALL_CONTACTS:String = "loadAllContacts";
		
		public static const OPEN_CONTACTS_CHANGE:String = "openContactsChange";
		
		public static const SAVE_SELECTED_CONTACT:String = "saveSelectedContact";
		
		public static const SEARCH_CONTACTS:String = "searchContacts";
		
		public static const SELECT_CONTACT:String = "selectContact";
		
		public static const SELECTED_CONTACT_CHANGE:String = "selectedContactChange";
		
		public function ApplicationEvents() {
		}
	}
}