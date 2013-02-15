package org.springextensions.actionscript.samples.cafetownsend.infrastructure.service {

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.impl.MockOperation;
	import org.springextensions.actionscript.samples.cafetownsend.application.service.IAuthenticationService;

	/**
	 * In-memory implementation of the IAuthenticationService interface.
	 *
	 * @author Christophe Herreman
	 */
	public class InMemoryAuthenticationService implements IAuthenticationService {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InMemoryAuthenticationService() {
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IAuthenticationService
		//
		// --------------------------------------------------------------------

		public function login(username:String, password:String):IOperation {
			if ((username == "Flex") && (password == "Spring")) {
				return new MockOperation(true);
			}
			return new MockOperation(false);
		}

		public function logout():IOperation {
			return new MockOperation(true);
		}
	}
}