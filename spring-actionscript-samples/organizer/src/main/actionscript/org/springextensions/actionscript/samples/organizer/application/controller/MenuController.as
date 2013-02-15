package org.springextensions.actionscript.samples.organizer.application.controller {
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
import org.springextensions.actionscript.samples.organizer.application.events.ChangeContactsViewModeEvent;
import org.springextensions.actionscript.samples.organizer.application.events.ContactEvent;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;
import org.springextensions.actionscript.samples.organizer.application.model.ContactsViewMode;
import org.springextensions.actionscript.samples.organizer.domain.Contact;

	/**
	 * Controller responsible for creating and managing the state of the native menu.
	 * 
	 * @author Christophe Herreman
	 */
	public class MenuController {
		
		private var _applicationModel:ApplicationModel;
		
		private var _menu:NativeMenu;
		
		// file
		private var _newContactMenuItem:NativeMenuItem;
		private var _openMenuItem:NativeMenuItem;
		private var _exitMenuItem:NativeMenuItem;
		
		// edit
		private var _deleteContactMenuItem:NativeMenuItem;
		
		// view
		private var _viewMenuItem:NativeMenuItem;
		private var _listViewMenuItem:NativeMenuItem;
		private var _tileViewMenuItem:NativeMenuItem;
		private var _viewContactItem:NativeMenuItem;
		
		/**
		 * Creates a new MenuController.
		 */
		public function MenuController(applicationModel:ApplicationModel) {
			Assert.notNull(applicationModel, "The application model must not be null");
			_applicationModel = applicationModel;
			_applicationModel.addEventListener(ApplicationEvents.SELECTED_CONTACT_CHANGE, applicationModel_selectedContactChangeHandler);
			_applicationModel.addEventListener(ApplicationEvents.OPEN_CONTACTS_CHANGE, applicationModel_openContactsChangeHandler);
		}
		
		/**
		 * Returns the native menu, created and managed by this controller.
		 */
		public function get menu():NativeMenu {
			if (!_menu) {
				createMenu();
			}
			return _menu;
		}
		
		/**
		 * Creates the native menu of the application.
		 */
		private function createMenu():void {
			_menu = new NativeMenu();
			_menu.addEventListener(Event.SELECT, menu_selectHandler);
			
			// file menu
			var fileMenu:NativeMenuItem = new NativeMenuItem("File");
			fileMenu.submenu = new NativeMenu();
			_newContactMenuItem = new NativeMenuItem("New");
			_newContactMenuItem.keyEquivalent = "n";
			fileMenu.submenu.addItem(_newContactMenuItem);
			fileMenu.submenu.addItem(new NativeMenuItem("", true));
			_openMenuItem = new NativeMenuItem("Open");
			_openMenuItem.enabled = false;
			fileMenu.submenu.addItem(_openMenuItem);
			fileMenu.submenu.addItem(new NativeMenuItem("", true));
			_exitMenuItem = new NativeMenuItem("Exit");
			fileMenu.submenu.addItem(_exitMenuItem);
			
			// edit menu
			var editMenu:NativeMenuItem = new NativeMenuItem("Edit");
			editMenu.submenu = new NativeMenu();
			_deleteContactMenuItem = new NativeMenuItem("Delete");
			_deleteContactMenuItem.enabled = false;
			editMenu.submenu.addItem(_deleteContactMenuItem);
			
			// view menu
			_viewMenuItem = new NativeMenuItem("View");
			_viewMenuItem.submenu = new NativeMenu();
			_listViewMenuItem = new NativeMenuItem("List View");
			_listViewMenuItem.checked = true;
			_viewMenuItem.submenu.addItem(_listViewMenuItem);
			_tileViewMenuItem = new NativeMenuItem("Tile View");
			_viewMenuItem.submenu.addItem(_tileViewMenuItem);
			_viewMenuItem.submenu.addItem(new NativeMenuItem("", true));
			_viewContactItem = new NativeMenuItem("Contact");
			_viewContactItem.enabled = false;
			_viewMenuItem.submenu.addItem(_viewContactItem);
			
			// help menu
			var helpMenu:NativeMenuItem = new NativeMenuItem("Help");
			helpMenu.submenu = new NativeMenu();
			helpMenu.submenu.addItem(new NativeMenuItem("About..."));
			
			_menu.addItem(fileMenu);
			_menu.addItem(editMenu);
			_menu.addItem(_viewMenuItem);
			_menu.addItem(helpMenu);
		}
		
		/**
		 * Handles the selection of a menu item.
		 */
		private function menu_selectHandler(event:Event):void {
			var item:NativeMenuItem = NativeMenuItem(event.target);
			
			switch (item) {
				case _newContactMenuItem:
					EventBus.dispatchEvent(new ContactEvent(ContactEvent.ADD));
					break;
				case _openMenuItem:
					EventBus.dispatchEvent(new ContactEvent(ContactEvent.OPEN));
					break;
				case _exitMenuItem:
					EventBus.dispatchEvent(new Event(ApplicationEvents.EXIT_APPLICATION));
					break;
				case _deleteContactMenuItem:
					EventBus.dispatchEvent(new Event(ApplicationEvents.DELETE_CONTACT));
					break;

				// view
				case _listViewMenuItem:
					EventBus.dispatchEvent(new ChangeContactsViewModeEvent(ContactsViewMode.LIST));
					break;
				case _tileViewMenuItem:
					EventBus.dispatchEvent(new ChangeContactsViewModeEvent(ContactsViewMode.TILES));
					break;
				default:
					if (item.name == "viewContactMenuItem") {
						var contact:Contact = Contact(item.data);
						EventBus.dispatchEvent(new ContactEvent(ContactEvent.OPEN, contact));
					}
			}
		}
		
		private function applicationModel_selectedContactChangeHandler(event:Event):void {
			_openMenuItem.enabled = (_applicationModel.selectedContact != null);
			_deleteContactMenuItem.enabled = (_applicationModel.selectedContact != null);
		}
		
		private function applicationModel_openContactsChangeHandler(event:Event):void {
			_viewContactItem.submenu = new NativeMenu();
			
			if (_applicationModel.openContacts.length == 0) {
				_viewContactItem.enabled = false;
			} else {
				_viewContactItem.enabled = true;
				for each (var contact:* in _applicationModel.openContacts) {
					var contactMenuItem:NativeMenuItem = new NativeMenuItem(Contact(contact).fullName);
					contactMenuItem.data = contact;
					contactMenuItem.name = "viewContactMenuItem";
					_viewContactItem.submenu.addItem(contactMenuItem);
				}
			}
		}
	}
}