package org.springextensions.actionscript.objects.testclasses {

	import org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithSimpleProperty;

	public class ImplementsTestInterfaceWithSimpleProperty implements ITestInterfaceWithSimpleProperty{

		public function ImplementsTestInterfaceWithSimpleProperty() {
			super();
		}
		
		private var _testProperty:String;
		public function get testProperty():String {
			return _testProperty;
		}
		public function set testProperty(value:String):void{
			_testProperty = value;
		}

	}
}