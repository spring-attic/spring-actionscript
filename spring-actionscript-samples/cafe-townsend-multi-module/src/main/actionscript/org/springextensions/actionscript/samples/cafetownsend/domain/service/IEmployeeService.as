package org.springextensions.actionscript.samples.cafetownsend.domain.service {

	import org.as3commons.async.operation.IOperation;
	import org.springextensions.actionscript.samples.cafetownsend.domain.Employee;

	/**
	 * Defines a service for working with Employee objects.
	 *
	 * @author Christophe Herreman
	 */
	public interface IEmployeeService {

		/**
		 * Returns all employees.
		 *
		 * @return
		 */
		function getEmployees():IOperation;

		/**
		 * Saves the given employee.
		 *
		 * @param employee
		 * @return
		 */
		function saveEmployee(employee:Employee):IOperation;

		/**
		 * Deletes the given employee.
		 *
		 * @param employee
		 * @return
		 */
		function deleteEmployee(employee:Employee):IOperation;

	}
}