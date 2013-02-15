package org.springextensions.actionscript.samples.organizer.presentation {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.as3commons.lang.StringUtils;
	import org.as3commons.lang.builder.EqualsBuilder;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
	import org.springextensions.actionscript.samples.organizer.application.events.ContactEvent;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	
	/**
	 *
	 */
	public class ContactFormPM extends EventDispatcher {
		
		private var _originalContact:Contact;
		private var _closing:Boolean = false;
		private var _cancelled:Boolean = false;
		
		/**
		 * Creates a new ContactForm
		 */
		public function ContactFormPM(contact:Contact = null) {
			if (contact) {
				_contact = contact.clone();
				_originalContact = contact;
				_isNew = false;
			} else {
				_contact = new Contact();
				_isNew = true;
			}
		}
		
		private var _isNew:Boolean;
		
		public function get isNew():Boolean {
			return _isNew;
		}
		
		private var _contact:Contact;
		
		[Bindable]
		public function get contact():Contact {
			return _contact;
		}
		
		public function set contact(value:Contact):void {
			if (value !== _contact) {
				_contact = value;
			}
		}
		
		[Bindable(event="contactUpdate")]
		public function get commitAllowed():Boolean {
			return (contactIsDirty);
		}
		
		public function get contactIsDirty():Boolean {
			if (!_contact) {
				return false;
			}
			
			// a new contact is always dirty
			if (isNew) {
				return true;
			}
			
			return (!new EqualsBuilder()
					.append(_originalContact.firstName, _contact.firstName)
					.append(_originalContact.lastName, _contact.lastName)
					.append(_originalContact.email, _contact.email)
					.append(_originalContact.phone, _contact.phone)
					.append(_originalContact.address, _contact.address)
					.append(_originalContact.city, _contact.city)
					.append(_originalContact.state, _contact.state)
					.append(_originalContact.zip, _contact.zip)
					.append(_originalContact.dob, _contact.dob)
					.equals);
		}
		
		[Bindable(event="contactUpdate")]
		public function get title():String {
			var result:String = "Contact Editor";
			
			result += " - ";
			
			if (contactIsDirty) {
				result += "*";
			}
			
			if (contact.firstName == "" && contact.lastName == "") {
				result += "(untitled)";
			} else {
				result += contact.fullName;
			}
			
			return result;
		}
		
		public function get closing():Boolean {
			return _closing;
		}
		
		public function get cancelled():Boolean {
			return _cancelled;
		}
		
		public function updateContact(firstName:String, lastName:String, email:String, phone:String, address:String, city:String, state:String, zip:String):void {
			contact.firstName = StringUtils.trim(firstName);
			contact.lastName = StringUtils.trim(lastName);
			contact.email = StringUtils.trim(email);
			contact.phone = StringUtils.trim(phone);
			contact.address = StringUtils.trim(address);
			contact.city = StringUtils.trim(city);
			contact.state = StringUtils.trim(state);
			contact.zip = StringUtils.trim(zip);
			dispatchEvent(new Event("contactUpdate"));
		}
		
		/**
		 * Accepts and merges the changes to the modified contact.
		 */
		public function commitChanges():void {
			var contactToSave:Contact = contact;
			
			if (!isNew) {
				contactToSave = _originalContact;
				_originalContact.firstName = contact.firstName;
				_originalContact.lastName = contact.lastName;
				_originalContact.email = contact.email;
				_originalContact.phone = contact.phone;
				_originalContact.address = contact.address;
				_originalContact.city = contact.city;
				_originalContact.state = contact.state;
				_originalContact.zip = contact.zip;
			}
			
			EventBus.dispatchEvent(new ContactEvent(ContactEvent.SAVE_AND_CLOSE, contactToSave));
		}
		
		public function close():void {
			_closing = true;
			EventBus.dispatchEvent(new ContactEvent(ApplicationEvents.CLOSE_CONTACT, contact));
		}
		
		public function cancelChanges():void {
			_cancelled = true;
			EventBus.dispatchEvent(new ContactEvent(ApplicationEvents.CANCEL_CHANGES_TO_CONTACT, contact));
		}
		
		private function contact_idSetHandler(value:int):void {
			dispatchEvent(new Event("contactUpdated"));
		}
	}
}