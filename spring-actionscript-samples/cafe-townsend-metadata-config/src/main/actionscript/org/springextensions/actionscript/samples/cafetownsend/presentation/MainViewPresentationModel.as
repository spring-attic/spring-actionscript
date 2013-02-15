package org.springextensions.actionscript.samples.cafetownsend.presentation {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

	/**
	 * Presentation model for the main view.
	 *
	 * @author Christophe Herreman
	 */
	[Component]
	public class MainViewPresentationModel extends EventDispatcher {

		// --------------------------------------------------------------------
		//
		// Private Static Constants
		//
		// --------------------------------------------------------------------

		private static const LOGIN_VIEW_INDEX:int = 0;
		private static const EMPLOYEE_LIST_VIEW_INDEX:int = 1;

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = LoggerFactory.getClassLogger(MainViewPresentationModel);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------
		
		public function MainViewPresentationModel() {
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// selectedViewIndex
		// ----------------------------

		private var m_selectedViewIndex:uint = 0;

		[Bindable(event="selectedViewIndexChange")]
		public function get selectedViewIndex():uint {
			return m_selectedViewIndex;
		}

		private function set selectedViewIndex(value:uint):void {
			if (value !== m_selectedViewIndex) {
				m_selectedViewIndex = value;
				dispatchEvent(new Event("selectedViewIndexChange"));
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		[EventHandler]
		public function loggedInHandler(event:Event):void {
			logger.debug("Received loggedIn event from EventBus");
			private::selectedViewIndex = EMPLOYEE_LIST_VIEW_INDEX;
		}

		[EventHandler]
		public function loggedOutHandler(event:Event):void {
			logger.debug("Received loggedOut event from EventBus");
			private::selectedViewIndex = LOGIN_VIEW_INDEX;
		}
	}
}