package org.springextensions.actionscript.samples.organizer.application.controller {

	import flash.events.Event;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.core.event.IEventBusListener;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.OperationEvent;
	import org.springextensions.actionscript.samples.organizer.application.IAlertFactory;
	import org.springextensions.actionscript.samples.organizer.application.IContactWindowManager;
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
	import org.springextensions.actionscript.samples.organizer.application.events.ChangeContactsViewModeEvent;
	import org.springextensions.actionscript.samples.organizer.application.events.ContactEvent;
	import org.springextensions.actionscript.samples.organizer.application.events.ErrorEvent;
	import org.springextensions.actionscript.samples.organizer.application.events.SearchEvent;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;
	import org.springextensions.actionscript.samples.organizer.application.model.ContactsViewMode;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.domain.IContactRepository;
	import org.springextensions.actionscript.samples.organizer.presentation.ContactFormPM;
	import org.springextensions.actionscript.utils.ArrayCollectionUtils;

	/**
	 * Controller for Contact related use cases.
	 *
	 * @author Christophe Herreman
	 */
	public class ContactController implements IEventBusListener {

		private static var logger:ILogger = LoggerFactory.getClassLogger(ContactController);

		private var _appModel:ApplicationModel;
		private var _contactRepository:IContactRepository;
		private var _contactWindowManager:IContactWindowManager;
		private var _alertFactory:IAlertFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ContactController
		 *
		 * @param applicationModel the application model
		 * @param contactRepository the repository for the contacts
		 * @param contactWindowManager the window manager
		 * @param alertFactory the factory for creating alerts
		 */
		public function ContactController(applicationModel:ApplicationModel, contactRepository:IContactRepository,
				contactWindowManager:IContactWindowManager, alertFactory:IAlertFactory) {

			Assert.notNull(applicationModel, "The application model should not be null");
			Assert.notNull(contactRepository, "The contact repository should not be null");
			Assert.notNull(contactWindowManager, "The contact window manager should not be null");
			Assert.notNull(alertFactory, "The alert factory should not be null");

			_appModel = applicationModel;
			_contactRepository = contactRepository;
			_contactWindowManager = contactWindowManager;
			_alertFactory = alertFactory;

			EventBus.addListener(this);
		}

		// Event Handlers

		/**
		 * Handles an application event.
		 */
		public function onEvent(event:Event):void {
			logger.debug("Received event '{0}'", event.type);

			var contact:Contact;
			var text:String;
			var title:String;

			switch (event.type) {

				case ApplicationEvents.CANCEL_CHANGES_TO_CONTACT:
					contact = ContactEvent(event).contact;
					closeContact(contact);
					break;

				case ApplicationEvents.CHANGE_CONTACTS_VIEW_MODE:
					var mode:ContactsViewMode = ChangeContactsViewModeEvent(event).mode;
					_appModel.contactsViewMode = mode;
					break;

				case ApplicationEvents.CLOSE_CONTACT:
					contact = ContactEvent(event).contact;
					var pm:ContactFormPM = _appModel.getContactPresentationModel(contact);

					if (pm && pm.contactIsDirty) {
						text = "'" + contact.fullName + "' has been modified. Save changes?";
						title = "Save Contact";
						_alertFactory.createAlert(text, title, Alert.YES | Alert.NO | Alert.CANCEL, function(e:Event):void {
							// note: the event is typed to Event and not to CloseEvent or AlertEvent since we don't want to the controller
							// to know what alert implementation is used
							if (e["detail"] == Alert.YES) {
								saveAndCloseContact(contact);
							} else if (e["detail"] == Alert.NO) {
								closeContact(contact);
							}
						});
					} else {
						closeContact(contact);
					}

					break;

				// load contacts
				case ApplicationEvents.LOAD_ALL_CONTACTS:
					var operation:IOperation = _contactRepository.getContacts();
					operation.addCompleteListener(function(e:OperationEvent):void {
						logger.debug("Contacts loaded");
						_appModel.contacts.source = ArrayCollection(e.result).source;
						_appModel.contacts.refresh();
					});
					break;

				// search
				case SearchEvent.SEARCH:
					var query:String = SearchEvent(event).query;
					searchContacts(query);
					break;

				case ApplicationEvents.SELECT_CONTACT:
					_appModel.selectedContact = ContactEvent(event).contact;
					break;

				// contact add
				case ContactEvent.ADD:
					contact = _appModel.addNewContact();
					_contactWindowManager.openContact(contact);
					break;

				// contact open
				case ContactEvent.OPEN:
					contact = (ContactEvent(event).contact ? ContactEvent(event).contact : _appModel.selectedContact);

					if (!_appModel.isOpenContact(contact)) {
						_appModel.addOpenContact(contact);
					}

					_contactWindowManager.openContact(contact);
					break;

				case ContactEvent.SELECT:
					contact = ContactEvent(event).contact;
					_appModel.selectedContact = contact;

					break;

				// deletes a contact
				case ContactEvent.DELETE:
					contact = (event is ContactEvent ? ContactEvent(event).contact : _appModel.selectedContact);
					text = "Are you sure you want to delete the contact '" + contact.fullName + "'?";
					title = "Delete Contact";

					_alertFactory.createAlert(text, title, Alert.YES | Alert.NO, function(e:Event):void {
						if (e["detail"] == Alert.YES) {
							var operation:IOperation = _contactRepository.remove(contact);
							operation.addCompleteListener(function(e:OperationEvent):void {
								_appModel.deleteContact(contact);
							});
						}
					});

					break;

				case ContactEvent.SAVE_AND_CLOSE:
					contact = ContactEvent(event).contact;
					saveAndCloseContact(contact);
					break;
			}
		}

		private function searchContacts(searchString:String):void {
			var operation:IOperation = _contactRepository.getContactsByName(StringUtils.trim(searchString));
			operation.addCompleteListener(function(e:OperationEvent):void {
				_appModel.contacts.source = ArrayCollection(e.operation.result).source;
				_appModel.contacts.refresh();
			});
			operation.addErrorListener(function(e:OperationEvent):void {
				logger.error("Could not search contacts: '{0}'", e.error);
			});
		}

		/**
		 * Removes the given contact as a open contact from the application state.
		 */
		private function closeContact(contact:Contact):void {
			_contactWindowManager.closeContact(contact);
			_appModel.removeOpenContact(contact);
		}

		/**
		 * Saves the given contact and removes it as an open contact from the application state.
		 */
		private function saveAndCloseContact(contact:Contact):void {
			var operation:IOperation = _contactRepository.save(contact);

			// result handler
			operation.addCompleteListener(function(e:OperationEvent):void {
				var isNew:Boolean = (ArrayCollectionUtils.getItemsWithProperty(_appModel.contacts, "id", contact.id).length == 0);
				if (isNew) {
					_appModel.contacts.addItem(contact);
				}

				// remove the open contact
				closeContact(contact);
			});

			// error handler
			operation.addErrorListener(function(event:OperationEvent):void {
				EventBus.dispatchEvent(new ErrorEvent(String(event.operation.error)));
			});
		}
	}
}