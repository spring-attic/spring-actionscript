package org.springextensions.actionscript.samples.organizer.application.model {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
	import org.springextensions.actionscript.samples.organizer.application.events.ContactEvent;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.domain.ContactCollection;
	import org.springextensions.actionscript.samples.organizer.presentation.ContactFormPM;
	
	/** Dispatched when the selected contact has changed. */
	[Event(name="selectedContactChange", type="org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents")]
	
	/** Dispatched when the open contacts have changed (a contact was opened or closed). */
	[Event(name="openContactsChange", type="org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents")]
	
	[Event(name="editContact", type="org.springextensions.actionscript.samples.organizer.application.events.ContactEvent")]

	/**
	 * The application model holds the current state of the application.
	 *
	 * @author Christophe Herreman
	 */
	[Bindable]
	public class ApplicationModel extends EventDispatcher {
		
		/** The contacts currently loaded. */
		public var contacts:ContactCollection = new ContactCollection();
		
		public var contactsViewMode:ContactsViewMode = ContactsViewMode.LIST;
		
		private var _contactPresentationModels:Dictionary = new Dictionary();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new ApplicationModel.
		 */
		public function ApplicationModel() {
			super(this);
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// selectedContact
		// ----------------------------

		private var _selectedContact:Contact;
		
		/**
		 * The contact that is currently selected.
		 */
		[Bindable(event="selectedContactChange")]
		public function get selectedContact():Contact {
			return _selectedContact;
		}

		public function set selectedContact(value:Contact):void {
			if (value !== _selectedContact) {
				_selectedContact = value;
				dispatchEvent(new Event(ApplicationEvents.SELECTED_CONTACT_CHANGE));
			}
		}
		
		// ----------------------------
		// openContacts
		// ----------------------------
		
		private var _openContacts:ArrayCollection = new ArrayCollection();
		
		/**
		 * The open contacts.
		 */
		[Bindable(event="openContactsChange")]
		public function get openContacts():ArrayCollection {
			return _openContacts;
		}
		
		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------
		
		public function addNewContact():Contact {
			var contact:Contact = new Contact();
			addOpenContact(contact);
			return contact;
		}
		
		public function isOpenContact(contact:Contact):Boolean {
			if (!contact) {
				return false;
			}
			
			for each (var c:Contact in openContacts) {
				if (c.equals(contact)) {
					return true;
				}
			}
			return false;
		}
		
		public function addOpenContact(contact:Contact):void {
			_contactPresentationModels[contact] = new ContactFormPM(contact);
			_openContacts.addItem(contact);
			dispatchEvent(new Event(ApplicationEvents.OPEN_CONTACTS_CHANGE));
			dispatchEvent(new ContactEvent(ContactEvent.OPEN, contact));
		}
		
		public function removeOpenContact(contact:Contact):void {
			if (!contact) {
				return;
			}
			
			for (var i:int = 0; i<_openContacts.length; i++) {
				if (Contact(_openContacts[i]).equals(contact)) {
					_openContacts.removeItemAt(i);
					dispatchEvent(new Event(ApplicationEvents.OPEN_CONTACTS_CHANGE));
				}
			}
		}
		
		public function deleteContact(contact:Contact):void {
			contacts.deleteContact(contact);
		}
		
		public function getContactPresentationModel(contact:Contact):ContactFormPM {
			if (!contact) {
				return null;
			}
			
			for (var c:* in _contactPresentationModels) {
				if (c.equals(contact)) {
					return _contactPresentationModels[c];
				}
			}
			return null;
		}
	}
}