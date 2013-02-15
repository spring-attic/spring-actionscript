package org.springextensions.actionscript.samples.cafetownsend.application {

	import flash.events.Event;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.cafetownsend.application.service.IAuthenticationService;

	/**
	 * Controller for global application actions.
	 * @author Christophe Herreman
	 */
	public class ApplicationController implements IEventBusAware {

		private var _authenticationService:IAuthenticationService;

		private var _eventBus:IEventBus;

		public function ApplicationController(authenticationService:IAuthenticationService) {
			Assert.notNull("The authentication service should not be null");
			_authenticationService = authenticationService;
		}

		public function logout():void {
			var operation:IOperation = _authenticationService.logout();
			operation.addCompleteListener(logout_completeHandler);
		}

		private function logout_completeHandler(event:Event):void {
			eventBus.dispatch(ApplicationEvents.LOGGED_OUT);
		}

		public function get eventBus():IEventBus {
			return _eventBus;
		}

		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}

	}
}
