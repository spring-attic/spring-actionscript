package org.springextensions.actionscript.samples.cafetownsend.infrastructure.service {

	import mx.collections.ArrayCollection;

	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.MockOperation;
	import org.springextensions.actionscript.samples.cafetownsend.domain.Employee;
	import org.springextensions.actionscript.samples.cafetownsend.domain.service.IEmployeeService;

	/**
	 * In-memory implementation of the IEmployeeService interface.
	 *
	 * @author Christophe Herreman
	 */
	public class InMemoryEmployeeService implements IEmployeeService {

		private var _employeeIndex:uint = 1;
		private var _employees:ArrayCollection;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InMemoryEmployeeService() {
			initEmployees();
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IEmployeeService
		//
		// --------------------------------------------------------------------

		public function getEmployees():IOperation {
			return new MockOperation(_employees);
		}

		public function saveEmployee(employee:Employee):IOperation {
			if (employee.id == -1) {
				employee.id = _employeeIndex++;
				_employees.addItem(employee);
			}
			return new MockOperation(employee);
		}

		public function deleteEmployee(employee:Employee):IOperation {
			var numEmployees:uint = _employees.length;

			for (var i:uint = 0; i<numEmployees; i++) {
				if (employee == _employees[i]) {
					_employees.removeItemAt(i);
					break;
				}
			}

			return new MockOperation(true);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function initEmployees():void {
			_employees = new ArrayCollection();
			_employees.addItem(new Employee(_employeeIndex++, "Sue", "Hove", "shove@cafetownsend.com", new Date(2006, 7, 1)));
			_employees.addItem(new Employee(_employeeIndex++, "Matt", "Boles", "mboles@cafetownsend.com", new Date(2007, 3, 13)));
			_employees.addItem(new Employee(_employeeIndex++, "Mike", "Kollen", "mkollen@cafetownsend.com", new Date(2006, 11, 19)));
			_employees.addItem(new Employee(_employeeIndex++, "Jennifer", "Jaegel", "jjaegel@cafetownsend.com", new Date(2003, 1, 27)));
		}
	}
}