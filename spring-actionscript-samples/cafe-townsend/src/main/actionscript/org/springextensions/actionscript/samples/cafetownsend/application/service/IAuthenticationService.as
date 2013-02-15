package org.springextensions.actionscript.samples.cafetownsend.application.service {

	import org.springextensions.actionscript.core.operation.IOperation;

	/**
	 * Service interface for logging in and out of the application.
	 *
	 * @author Christophe Herreman
	 */
	public interface IAuthenticationService {

		function login(username:String, password:String):IOperation;

		function logout():IOperation;

	}
}