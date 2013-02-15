package org.springextensions.actionscript.samples.organizer.application.controller {

	import mx.core.WindowedApplication;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.organizer.application.IAlertFactory;
	import org.springextensions.actionscript.samples.organizer.application.events.ErrorEvent;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;
	import org.springextensions.actionscript.samples.organizer.application.model.ContactsViewMode;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * The application controller handles application events.
	 *
	 * @author Christophe Herreman
	 */
	public class ApplicationController {

		private var _applicationModel:ApplicationModel;
		private var _alertFactory:IAlertFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ApplicationController
		 *
		 * @param applicationModel the application model
		 * @param alertFactory the factory used to create alerts
		 */
		public function ApplicationController(applicationModel:ApplicationModel, alertFactory:IAlertFactory) {
			Assert.notNull(applicationModel, "The application model should not be null");
			Assert.notNull(alertFactory, "The alert factory should not be null");

			_applicationModel = applicationModel;
			_alertFactory = alertFactory;
		}

		// --------------------------------------------------------------------
		//
		// Event Handlers
		//
		// --------------------------------------------------------------------

		[EventHandler]
		public function applicationError(event:ErrorEvent):void {
			var text:String = "An application error occurred: '" + ErrorEvent(event).error + "'";
			var title:String = "Application Error";
			_alertFactory.createAlert(text, title);
		}

		[EventHandler]
		public function exitApplication():void {
			var application:* = ApplicationUtils.application;

			if (application is WindowedApplication) {
				WindowedApplication(application).close();
			}
		}

		[EventHandler]
		public function changeContactsViewMode(mode:ContactsViewMode):void {
			_applicationModel.contactsViewMode = mode;
		}

	}
}