package org.springextensions.actionscript.samples.cafetownsend.application.service {
	import org.as3commons.async.operation.IOperation;



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