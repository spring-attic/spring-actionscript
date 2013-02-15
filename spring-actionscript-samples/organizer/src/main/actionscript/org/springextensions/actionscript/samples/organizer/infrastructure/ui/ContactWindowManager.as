package org.springextensions.actionscript.samples.organizer.infrastructure.ui
{
import flash.system.Capabilities;
import flash.utils.Dictionary;

import flash.utils.getQualifiedSuperclassName;

import mx.managers.PopUpManager;

import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.samples.organizer.application.IContactWindowManager;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.presentation.ContactWindow;
import org.springextensions.actionscript.stage.FlexStageProcessorRegistry;

public class ContactWindowManager implements IContactWindowManager {
		
		private static var logger:ILogger = LoggerFactory.getClassLogger(ContactWindowManager);
		
		private var _applicationModel:ApplicationModel;
		private var _windows:Dictionary = new Dictionary();
		
		/**
		 * Creates a new ContactWindowManager
		 */
		public function ContactWindowManager(applicationModel:ApplicationModel) {
			_applicationModel = applicationModel;
			//_applicationModel.addEventListener(ContactEvent.EDIT, editContactHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		public function openContact(contact:Contact):void {
			var window:ContactWindow = getContactWindowForContact(contact);
			
			// if we already have a window open for this contact, bring it to the front
			// else open a new window
			if (window) {
				window.orderToFront();
			} else {
				window = new ContactWindow();
				
				// explicitly register this window so its metadata can be processed
				// (for autowiring for instance)
				FlexStageProcessorRegistry.getInstance().registerWindow(window);

				window.presentationModel = _applicationModel.getContactPresentationModel(contact);
				window.open();
				
				// center the window
				//window.x = (Capabilities.screenResolutionX - window.width) / 2;
				//window.y = (Capabilities.screenResolutionY - window.height) / 2;

				_windows[contact] = window;
			}
			
		}
		
		public function closeContact(contact:Contact):void {
			var window:ContactWindow = getContactWindowForContact(contact);
			if (window) {
				window.close();
				FlexStageProcessorRegistry.getInstance().unregisterWindow(window);
				removeWindow(window);
			}
		}
		
		public function getContactWindowForContact(contact:Contact):ContactWindow {
			for (var c:* in _windows) {
				if (c.equals(contact)) {
					return _windows[c];
				}
			}
			return null;
		}
		
		private function removeWindow(window:ContactWindow):void {
			if (window) {
				for (var contact:* in _windows) {
					if (_windows[contact] == window) {
						delete _windows[contact];
						break;
					}
				}
			}
		}
		
		/*private function editContactHandler(event:ContactEvent):void {
			openContact(event.contact);
		}*/
	}
}