package org.springextensions.actionscript.samples.cafetownsend.presentation {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.springextensions.actionscript.samples.cafetownsend.domain.Employee;

	/**
	 * Presentation model for the EmployeeDetail window.
	 *
	 * @author Christophe Herreman
	 */
	public class EmployeeDetailPresentationModel extends EventDispatcher {

		public static const COMMIT:String = "commit";

		public static const CANCEL:String = "cancel";

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _originalEmployee:Employee;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function EmployeeDetailPresentationModel(employee:Employee = null) {
			if (employee) {
				_originalEmployee = employee;
				private::employee = employee.clone();
			} else {
				private::employee = new Employee();
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// employee
		// ----------------------------

		private var m_employee:Employee;

		[Bindable(event="employeeChange")]
		public function get employee():Employee {
			return m_employee;
		}

		private function set employee(value:Employee):void {
			if (value !== m_employee) {
				m_employee = value;
				dispatchEvent(new Event("employeeChange"));
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function commitChanges():void {
			// copy the changes back into the original employee if we were editing one
			if (_originalEmployee) {
				_originalEmployee.copyFrom(m_employee);
			}
			dispatchEvent(new Event(COMMIT));
		}

		public function cancelChanges():void {
			dispatchEvent(new Event(CANCEL));
		}
	}
}