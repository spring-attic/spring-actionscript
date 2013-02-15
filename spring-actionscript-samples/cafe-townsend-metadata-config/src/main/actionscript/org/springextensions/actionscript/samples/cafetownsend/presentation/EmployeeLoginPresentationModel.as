package org.springextensions.actionscript.samples.cafetownsend.presentation {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.controls.Alert;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.samples.cafetownsend.application.ApplicationEvents;
	import org.springextensions.actionscript.samples.cafetownsend.application.service.IAuthenticationService;

	/**
	 * Presentation model for the EmployeeLogin view.
	 *
	 * @author Christophe Herreman
	 */
	[RouteEvents(events="loggedIn")]
	[Event(name="loggedIn")]
	[Component]
	public class EmployeeLoginPresentationModel extends EventDispatcher {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = getClassLogger(EmployeeLoginPresentationModel);

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

		/**
		 * Creates a new EmployeeLoginPresentationModel
		 *
		 * @param authenticationService the service used to login the user
		 */
		public function EmployeeLoginPresentationModel(authenticationService:IAuthenticationService) {
			Assert.notNull(authenticationService, "The authentication service is required");

			_authenticationService = authenticationService;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// username
		// ----------------------------

		private var m_username:String = "";

		[Bindable(event="usernameChange")]
		public function get username():String {
			return m_username;
		}

		public function set username(value:String):void {
			if (value !== m_username) {
				m_username = value;
				dispatchEvent(new Event("usernameChange"));
			}
		}

		// ----------------------------
		// password
		// ----------------------------

		private var m_password:String = "";

		[Bindable(event="passwordChange")]
		public function get password():String {
			return m_password;
		}

		public function set password(value:String):void {
			if (value !== m_password) {
				m_password = value;
				dispatchEvent(new Event("passwordChange"));
			}
		}

		// ----------------------------
		// usernameEditAllowed
		// ----------------------------

		[Bindable(event="loggingInChange")]
		public function get usernameEditAllowed():Boolean {
			return !loggingIn;
		}

		// ----------------------------
		// passwordEditAllowed
		// ----------------------------

		[Bindable(event="loggingInChange")]
		public function get passwordEditAllowed():Boolean {
			return !loggingIn;
		}

		// ----------------------------
		// loginAllowed
		// ----------------------------

		[Bindable(event="loggingInChange")]
		[Bindable(event="usernameChange")]
		[Bindable(event="passwordChange")]
		public function get loginAllowed():Boolean {
			var usernameIsValid:Boolean = StringUtils.hasText(username);
			var passwordIsValid:Boolean = StringUtils.hasText(password);
			return (!loggingIn && usernameIsValid && passwordIsValid);
		}

		// ----------------------------
		// loggingIn
		// ----------------------------

		private var m_loggingIn:Boolean = false;

		private function get loggingIn():Boolean {
			return m_loggingIn;
		}

		private function set loggingIn(value:Boolean):void {
			if (value !== m_loggingIn) {
				m_loggingIn = value;
				dispatchEvent(new Event("loggingInChange"));
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function login():void {
			logger.info("Trying to log in.");

			loggingIn = true;

			var loginOperation:IOperation = _authenticationService.login(username, password);
			loginOperation.addCompleteListener(loginOperation_completeHandler);
			loginOperation.addErrorListener(loginOperation_errorHandler);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function loginOperation_completeHandler(event:OperationEvent):void {
			logger.info("Received result '{0}' from login method.", [event.result]);

			loggingIn = false;

			if (event.result) {
				dispatchEvent(new Event(ApplicationEvents.LOGGED_IN));
			} else {
				username = "";
				password = "";
				Alert.show("The given username and password are incorrect.", "Login Error");
			}
		}

		private function loginOperation_errorHandler(event:OperationEvent):void {
			loggingIn = false;
			Alert.show("There was an error when logging in", "Application Error");
		}
	}
}
