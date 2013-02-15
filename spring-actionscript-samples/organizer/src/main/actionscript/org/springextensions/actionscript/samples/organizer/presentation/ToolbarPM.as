package org.springextensions.actionscript.samples.organizer.presentation {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.organizer.application.events.ApplicationEvents;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;

	/**
	 * Presentation Model for the application toolbar.
	 *
	 * @author Christophe Herreman
	 */
	public class ToolbarPM extends EventDispatcher {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ToolbarPM
		 *
		 * @param applicationModel
		 */
		public function ToolbarPM(applicationModel:ApplicationModel) {
			Assert.notNull(applicationModel, "The application model should not be null");
			this.applicationModel = applicationModel;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// deleteAllowed
		// ----------------------------

		[Bindable("selectedContactChange")]
		public function get deleteAllowed():Boolean {
			return (applicationModel && applicationModel.selectedContact);
		}

		// --------------------------------------------------------------------
		//
		// Private Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// applicationModel
		// ----------------------------

		private var _applicationModel:ApplicationModel;

		private function get applicationModel():ApplicationModel {
			return _applicationModel;
		}

		private function set applicationModel(value:ApplicationModel):void {
			if (value !== _applicationModel) {
				_applicationModel = value;
				if (_applicationModel) {
					_applicationModel.addEventListener(ApplicationEvents.SELECTED_CONTACT_CHANGE, function(event:Event):void {
						dispatchEvent(new Event("selectedContactChange"));
					});
				}
			}
		}
	}
}