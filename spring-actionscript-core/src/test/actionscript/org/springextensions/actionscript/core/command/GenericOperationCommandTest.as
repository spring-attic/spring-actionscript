package org.springextensions.actionscript.core.command {
	
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.core.operation.MockOperation;

	public class GenericOperationCommandTest extends TestCase {
		// please note that all test methods should start with 'test' and should be public

		public function GenericOperationCommandTest(methodName:String=null) {
			//TODO: implement function
			super(methodName);
		}

		public function testExecute():void {
			var completeHandler:Function = function(event:Event, result:Boolean):void {
				assertEquals(result, true);
			};
			var genCmd:GenericOperationCommand = new GenericOperationCommand(MockOperation,true);
			genCmd.addCompleteListener(addAsync(completeHandler, 1000, true), false, 0, true);
			genCmd.execute();
		}

		public function testGenericOperationCommand():void {
			var genCmd:GenericOperationCommand = new GenericOperationCommand(MockOperation,true);
			assertStrictlyEquals(MockOperation,genCmd.operationClass);
			assertEquals(1,genCmd.constructorArguments.length);
			assertTrue(genCmd.constructorArguments[0]);
		}
	}
}