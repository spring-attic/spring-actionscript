package org.springextensions.actionscript.objects.testclasses {
	import org.springextensions.actionscript.objects.testinterfaces.ITestInterfaceWithInitMethod;

	public class ImplementsTestInterfaceWithInitMethod extends ImplementsTestInterfaceWithSimpleProperty implements ITestInterfaceWithInitMethod {

		public function ImplementsTestInterfaceWithInitMethod() {
		}

		public function initialize():void {
			initialized = true;
		}

		public var initialized:Boolean = false;

	}
}