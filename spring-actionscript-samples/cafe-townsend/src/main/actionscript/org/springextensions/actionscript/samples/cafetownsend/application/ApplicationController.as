package org.springextensions.actionscript.samples.cafetownsend.application {

	import flash.events.Event;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.event.EventBus;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.samples.cafetownsend.application.service.IAuthenticationService;

	/**
	 * Controller for global application actions.
	 *
	 * @author Christophe Herreman
	 */
	public class ApplicationController {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _authenticationService:IAuthenticationService;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ApplicationController(authenticationService:IAuthenticationService) {
			Assert.notNull("The authentication service should not be null");
			_authenticationService = authenticationService;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		[EventHandler]
		public function logout():void {
			var operation:IOperation = _authenticationService.logout();
			operation.addCompleteListener(logout_completeHandler);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function logout_completeHandler(event:Event):void {
			EventBus.dispatch(ApplicationEvents.LOGGED_OUT);
		}

	}
}