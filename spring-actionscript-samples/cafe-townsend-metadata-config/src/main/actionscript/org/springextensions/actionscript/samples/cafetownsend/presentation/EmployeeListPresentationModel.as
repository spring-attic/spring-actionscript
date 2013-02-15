package org.springextensions.actionscript.samples.cafetownsend.presentation {

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.cafetownsend.domain.Employee;
	import org.springextensions.actionscript.samples.cafetownsend.domain.service.IEmployeeService;

	/**
	 * Presentation model for the EmployeeList view.
	 *
	 * @author Christophe Herreman
	 */
	[Component]
	public class EmployeeListPresentationModel extends EventDispatcher {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _employeeService:IEmployeeService;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function EmployeeListPresentationModel(employeeService:IEmployeeService) {
			Assert.notNull(employeeService, "The employee service must not be null");
			_employeeService = employeeService;
			loadEmployees();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// employees
		// ----------------------------

		private var m_employees:ArrayCollection;

		[Bindable(event="employeesChange")]
		public function get employees():ArrayCollection {
			return m_employees;
		}

		public function set employees(value:ArrayCollection):void {
			if (value !== m_employees) {
				m_employees = value;
				dispatchEvent(new Event("employeesChange"));
			}
		}

		// ----------------------------
		// selectedEmployee
		// ----------------------------

		private var m_selectedEmployee:Employee;

		[Bindable(event="selectedEmployeeChange")]
		public function get selectedEmployee():Employee {
			return m_selectedEmployee;
		}

		public function set selectedEmployee(value:Employee):void {
			if (value !== m_selectedEmployee) {
				m_selectedEmployee = value;
				dispatchEvent(new Event("selectedEmployeeChange"));
			}
		}

		// ----------------------------
		// employeeDetailsPresentationModel
		// ----------------------------

		private var m_employeeDetailsPresentationModel:EmployeeDetailPresentationModel;

		[Bindable(event="employeeDetailsPresentationModelChange")]
		public function get employeeDetailsPresentationModel():EmployeeDetailPresentationModel {
			return m_employeeDetailsPresentationModel;
		}

		public function set employeeDetailsPresentationModel(value:EmployeeDetailPresentationModel):void {
			if (value !== m_employeeDetailsPresentationModel) {
				m_employeeDetailsPresentationModel = value;
				dispatchEvent(new Event("employeeDetailsPresentationModelChange"));
			}
		}

		// ----------------------------
		// editAllowed
		// ----------------------------

		[Bindable(event="selectedEmployeeChange")]
		[Bindable(event="deletingChange")]
		[Bindable(event="savingChange")]
		public function get editAllowed():Boolean {
			return (!deleting && !saving && (m_selectedEmployee != null));
		}

		// ----------------------------
		// deleteAllowed
		// ----------------------------

		[Bindable(event="selectedEmployeeChange")]
		[Bindable(event="deletingChange")]
		[Bindable(event="savingChange")]
		public function get deleteAllowed():Boolean {
			return (!deleting && !saving && (m_selectedEmployee != null));
		}

		// ----------------------------
		// deleting
		// ----------------------------

		private var m_deleting:Boolean;

		[Bindable(event="deletingChange")]
		private function get deleting():Boolean {
			return m_deleting;
		}

		private function set deleting(value:Boolean):void {
			if (value !== m_deleting) {
				m_deleting = value;
				dispatchEvent(new Event("deletingChange"));
			}
		}

		// ----------------------------
		// saving
		// ----------------------------

		private var m_saving:Boolean;

		[Bindable(event="savingChange")]
		private function get saving():Boolean {
			return m_saving;
		}

		private function set saving(value:Boolean):void {
			if (value !== m_saving) {
				m_saving = value;
				dispatchEvent(new Event("savingChange"));
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addEmployee():void {
			employeeDetailsPresentationModel = createDetailsPresentationModel();
		}

		public function deleteSelectedEmployee():void {
			deleting = true;

			var operation:IOperation = _employeeService.deleteEmployee(m_selectedEmployee);
			operation.addCompleteListener(deleteEmployee_completeHandler);
		}

		public function editSelectedEmployee():void {
			employeeDetailsPresentationModel = createDetailsPresentationModel(m_selectedEmployee);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function loadEmployees():void {
			var operation:IOperation = _employeeService.getEmployees();
			operation.addCompleteListener(loadEmployees_completeHandler);
			operation.addErrorListener(loadEmployees_errorHandler);
		}

		private function loadEmployees_completeHandler(event:OperationEvent):void {
			employees = event.result;
		}

		private function loadEmployees_errorHandler(event:OperationEvent):void {
			Alert.show("There was an error loading the list of employees.", "Application Error");
		}

		private function createDetailsPresentationModel(employee:Employee=null):EmployeeDetailPresentationModel {
			var result:EmployeeDetailPresentationModel = new EmployeeDetailPresentationModel(employee);
			result.addEventListener(EmployeeDetailPresentationModel.COMMIT, employeeDetailsPresentationModel_commitHandler);
			result.addEventListener(EmployeeDetailPresentationModel.CANCEL, employeeDetailsPresentationModel_cancelHandler);
			return result;
		}

		private function employeeDetailsPresentationModel_commitHandler(event:Event):void {
			var employee:Employee = employeeDetailsPresentationModel.employee;
			var operation:IOperation = _employeeService.saveEmployee(employee);
			operation.addCompleteListener(saveEmployee_completeHandler);

			saving = true;
			employeeDetailsPresentationModel = null;
		}

		private function employeeDetailsPresentationModel_cancelHandler(event:Event):void {
			employeeDetailsPresentationModel = null;
		}

		private function deleteEmployee_completeHandler(event:OperationEvent):void {
			deleting = false;
			selectedEmployee = null;
		}

		private function saveEmployee_completeHandler(event:OperationEvent):void {
			saving = false;
		}

	}
}